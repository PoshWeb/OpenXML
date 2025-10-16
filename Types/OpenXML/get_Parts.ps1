if ($this.'.Parts') {
    return $this.'.Parts'
}


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
            break
        }
        # If the part looks like JSON, read it as JSON
        { $part.Uri -match '\.json$'} {
            $streamReader = [IO.StreamReader]::new($partStream)
            $jsonContent = $streamReader.ReadToEnd()
            $streamReader.Close()
            $jsonContent | ConvertFrom-Json
            break
        }
        { $part.ContentType -match 'text/.+?$'} {
            $streamReader = [IO.StreamReader]::new($partStream)
            $textContent = $streamReader.ReadToEnd()
            $streamReader.Close()
            $textContent
            break
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

$packageParts = @($this.GetParts())
$packageContent = [Ordered]@{}

# Now we will read each part in the package, and store it in an `[Ordered]` dictionary
# Since this _might_ take a while (if you used a lot of PowerPoint images) we want to show a progress bar.

# Prepare the progress bar
$partCount = 0
$partTotal = $packageParts.Length
$partProgress = [Ordered]@{Id=Get-Random;Activity='Reading Parts'}
            
# Then read each part
@(foreach ($part in $packageParts) {
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
})
<## Now that we've read all parts, we can close the package
$filePackage.Close()
# and the memory stream, too.
$memoryStream.Close()#>

# and finally, complete the progress bar.
Write-Progress @partProgress -Status "Completed reading $partCount parts" -Completed
$this | Add-Member NoteProperty '.Parts' -Force $packageContent

return $this.'.Parts'
