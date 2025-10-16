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
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string]
    $FilePath
    )

    begin {
        
        filter openXMLFromFile {
            $filePath = $_
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
            $filePackage = [IO.Packaging.Package]::Open($memoryStream, "Open", "ReadWrite")
            # If that did not work, return.
            if (-not $filePackage) { return }
            
            $filePackage.pstypenames.insert(0,'OpenXML')
            $filePackage.pstypenames.insert(0,'OpenXML.File')
            $openXMLObject = $filePackage | 
                Add-Member NoteProperty FilePath $filePath -Force -PassThru |
                Add-Member NoteProperty MemoryStream $memoryStream -Force -PassThru

            $packageParts = $filePackage.GetParts()
                                                   
            # Now we can get more specific about what type of OpenXML file this is.
            # By looking for certain key parts, we can determine if this is a PowerPoint, Excel, or Word file.
            # For example, if the package contains a part with `/ppt/` in the URI,
            if ($packageParts.Uri -match '^/ppt/') {
                # it is an `OpenXML.PowerPoint.File`
                $openXmlObject.pstypenames.insert(0, 'OpenXML.PowerPoint.File')
            }
            
            # If the package contains a part with `/xl/` in the URI,
            if ($packageParts.Uri -match '^/xl/') {
                # it is an `OpenXML.Excel.File`
                $openXmlObject.pstypenames.insert(0, 'OpenXML.Excel.File')
            }
            
            # If the package contains a part with `/word/` in the URI, it is a Word file.
            if ($packageParts.Uri -match '^/word/') {
                # it is an `OpenXML.Word.File`
                $openXmlObject.pstypenames.insert(0, 'OpenXML.Word.File')
            }

            # If the package contains a part with `/Documents/` in the URI,
            if ($packageParts.Uri -match '^Documents/') {
                # it is an `OpenXML.XPS.File`
                $openXmlObject.pstypenames.insert(0, 'OpenXML.XPS.File')
            }

            # Now we output our openXML object
            $OpenXMLObject
        }
    }
    
    process {
        if ($filePath) {
            # Try to resolve the file path
            $resolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($FilePath)
            # If we could not resolve the path, exit
            if (-not $resolvedPath ) { return }

            $resolvedPath | openXMLFromFile                        
        } else {
            $memoryStream = [IO.MemoryStream]::new()
            $EmptyPackage = [io.packaging.package]::Open($memoryStream ,'Create')
            $EmptyPackage | Add-Member NoteProperty -Name MemoryStream -Value $memoryStream -Force
            $EmptyPackage.pstypenames.insert(0, 'OpenXML')
            $EmptyPackage            
        }                        
    }    
}
