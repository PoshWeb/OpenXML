function Set-OpenXML
{
    <#
    .SYNOPSIS
        Sets OpenXML content
    .DESCRIPTION
        Sets content in an OpenXML file.
    .EXAMPLE
        Get-OpenXML ./Examples/Sample.docx |
            Set-OpenXML -Uri '/index.html' -Content ([xml]"<h1>Hello World</h1>") -ContentType text/html |
            Set-OpenXML -Uri '/404.html' -Content ([xml]"<h1>File Not Found</h1>") -ContentType text/html |
            Export-OpenXML ./Examples/Sample2.docx
    #>
    param(
    # The uri to set
    [Parameter(Mandatory,ParameterSetName='Uri',ValueFromPipelineByPropertyName)]
    [Alias('Url')]
    [uri]
    $Uri,

    # The content type.  By default, `text/plain`
    [Parameter(ValueFromPipelineByPropertyName)]    
    [string]
    $ContentType = 'text/plain',

    # The content to set.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject]
    $Content,

    # The input object.  
    # This must be a package, and it must be writeable.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject
    )

    process {
        # If there is no input, there is nothing to do
        if (-not $InputObject) { return }
        # If the input is not a package, pass it thru.
        if ($InputObject -isnot [IO.Packaging.Package]) {
            return $InputObject
        }

        # Get or create the part
        $part = 
            if ($InputObject.PartExists($uri)) {
                $InputObject.GetPart($uri)
            } else {
                $InputObject.CreatePart($uri, $ContentType)
            }

        if (-not $?) { return }

        # Get the stream
        $partStream = $part.GetStream()
        # If the content was xml or could be,
        if ($content -is [xml] -or ($contentXml = $content -as [xml])) {            
            if ($contentXml) { $content = $contentXml }              
            $buffer = $OutputEncoding.GetBytes($content.OuterXml)
            # write it to the package.
            $partStream.Write($buffer, 0, $buffer.Length)
        } elseif ($content -is [string]) {
            # Put strings in as a byte array.
            $buffer = $OutputEncoding.GetBytes($content)
            $partStream.Write($buffer, 0, $buffer.Length)
        } elseif ($contentBytes = $content -as [byte[]]) {
            # Bytes are obviously a byte array
            $partStream.Write($contentBytes, 0, $contentBytes.Length)
        } 
        elseif ($ContentType -match '[/\+]json') {
            # Explicitly typed json can be converted to json
            $buffer = $OutputEncoding.GetBytes((ConvertTo-Json -InputObject $content -Depth 10))
            $partStream.Write($buffer, 0, $buffer.Length)
        }
        else {
            # and everything else is stringified
            $buffer = $OutputEncoding.GetBytes("$content")
            $partStream.Write($buffer, 0, $buffer.Length)
        }

        # Close the part stream
        $partStream.Close()

        # and invalidate the parts cache on the object
        $inputObject.PSObject.Properties.Remove('.Parts')
        # then pass it thru so we can keep piping.
        $inputObject
    }
}