function Get-OpenXML
{
    <#
    .SYNOPSIS
        Gets Open Office XML files (Excel, PowerPoint, and Word)
    .DESCRIPTION
        Gets Open Office XML files (Excel, PowerPoint, and Word) as a structured object.

        The object contains the file path, parts, and relationships of the OpenXML document.
        
        This cmdlet can be used to read the contents of .docx, .pptx, .xps, .xlsx files
        (or any files that are readable with [`IO.Packaging.Package`](https://learn.microsoft.com/en-us/dotnet/api/system.io.packaging.package?wt.mc_id=MVP_321542))
    .EXAMPLE
        # Get an OpenXML document
        Get-OpenXML -FilePath './Sample.docx'
    #>
    [CmdletBinding()]
    [Alias('OpenXML')]
    param(
    # The path to the OpenXML file to read
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Alias('Fullname')]
    [string]
    $FilePath
    )

    begin {
        # First lets declare a little helper function to get the content of a part
        filter getPartContent {
            $part = $_            
            $partStream = $part.GetStream()
            if (-not $partStream) { return }
            switch ($part.ContentType) {
                # If the content type looks like XML, read it as XML
                { $part.ContentType -match '[\./\+]xml' } {
                    $streamReader = [IO.StreamReader]::new($partStream)                        
                    $streamReader.ReadToEnd() -as [xml]
                    $streamReader.Close()
                }
                # If the part looks like JSON, read it as JSON
                { $part.Uri -match '\.json$'} {
                    $streamReader = [IO.StreamReader]::new($partStream)
                    $jsonContent = $streamReader.ReadToEnd()
                    $streamReader.Close()
                    $jsonContent | ConvertFrom-Json
                }                
                # Otherwise, read it as a memory stream and return the byte array
                default {
                    $outputStream = [IO.MemoryStream]::new()
                    $partStream.CopyTo($outputStream)
                    $outputStream.Seek(0, 'Begin')
                    $outputStream.ToArray()
                }                
            }
            
            $partStream.Close()
            $partStream.Dispose()
        }
    }
    
    process {
        # Try to resolve the file path
        $resolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($FilePath)
        # If we could not resolve the path, exit
        if (-not $resolvedPath ) { return }
        
        foreach ($filePath in $resolvedPath) {
            # Get the file info and read the file as a byte stream.            
            $fileInfo = $FilePath -as [IO.FileInfo]
            # By reading the file with Get-Content -AsByteStream, we avoid locking the file
            # (or the file being locked by another process)
            $packageBytes = Get-Content -Path $FilePath -AsByteStream -Raw

            # If there were no bytes, return
            if (-not $packageBytes) { return }

            # Create a memory stream from the byte array
            $memoryStream = [IO.MemoryStream]::new($packageBytes)
            # and open the package from the memory stream
            $filePackage = [IO.Packaging.Package]::Open($memoryStream, "Open", "Read")
            # If that did not work, return.
            if (-not $filePackage) { return }
            
            # Get the package relationships.
            # (these are important for key corner cases in OpenXML files)
            $packageRelationships = $filePackage.GetRelationships()
            $packageContent = [Ordered]@{}
            $packageParts = @($filePackage.GetParts())
            
            # Now we will read each part in the package, and store it in an `[Ordered]` dictionary
            # Since this _might_ take a while (if you used a lot of PowerPoint images) we want to show a progress bar.

            # Prepare the progress bar
            $partCount = 0
            $partTotal = $packageParts.Length
            $partProgress = [Ordered]@{Id=Get-Random;Activity='Reading Parts'}
                        
            # Then read each part
            foreach ($part in $packageParts) {
                $partCount++
                # update the progress bar
                Write-Progress @partProgress -Status "Reading part $($part.Uri) ($partCount of $partTotal)" -PercentComplete (
                    [math]::Round(($partCount * 100/ $partTotal))
                )
                # and store the part in the dictionary
                $packageContent["$($part.Uri)"] = 
                    [PSCustomObject]@{
                        PSTypeName = 'OpenXML.Part'
                        Uri = $part.Uri
                        ContentType = $part.ContentType
                        # (we'll use our helper function to get the content)
                        Content = $part | getPartContent 
                        FilePath = "$resolvedPath"
                    }
            }
            # Now that we've read all parts, we can close the package
            $filePackage.Close()
            # and the memory stream, too.
            $memoryStream.Close()
            
            # and finally, complete the progress bar.
            Write-Progress @partProgress -Status "Completed reading $partCount parts" -Completed
                
            # Now we can create the final object.
            $OpenXMLObject = [PSCustomObject]@{
                # It is a generic OpenXML file by default
                PSTypeName = 'OpenXML.File'
                # with a `.FilePath`, so we can re-read and update it.
                FilePath = $resolvedPath
                # all of the `.Parts` have been read.
                Parts = $packageContent
                # and the package relationships are included, too.
                Relationships = $packageRelationships
            }
                        
            # Now we can get more specific about what type of OpenXML file this is.
            # By looking for certain key parts, we can determine if this is a PowerPoint, Excel, or Word file.
            # For example, if the package contains a part with `/ppt/` in the URI,
            if ($packageContent.Keys -match '/ppt/') {
                # it is an `OpenXML.PowerPoint.File`
                $openXmlObject.pstypenames.insert(0, 'OpenXML.PowerPoint.File')
            }
            
            # If the package contains a part with `/xl/` in the URI,
            if ($packageContent.Keys -match '/xl/') {
                # it is an `OpenXML.Excel.File`
                $openXmlObject.pstypenames.insert(0, 'OpenXML.Excel.File')
            }
            
            # If the package contains a part with `/word/` in the URI, it is a Word file.
            if ($packageContent.Keys -match '/word/') {
                # it is an `OpenXML.Word.File`
                $openXmlObject.pstypenames.insert(0, 'OpenXML.Word.File')
            }
            

            # Now we output our openXML object
            $OpenXMLObject
        }                
    }    
}
