<#
.SYNOPSIS
    Gets the document in a word file
.DESCRIPTION
    Gets the `/word/document.xml` within a Word File. 
#>
[OutputType([xml])]
param()

if ($null -ne $this.'#document') { return $this.'#document'}

if (-not $this.PartExists) { return }
if (-not $this.PartExists('/word/document.xml')) { return }

$documentPart = $this.GetPart('/word/document.xml')

$docStream = $documentPart.GetStream()

$streamReader = [IO.StreamReader]::new($docStream)

$documentXml = $streamReader.ReadToEnd() -as [xml]

$streamReader.Close()
$streamReader.Dispose()

$docStream.Close()
$docStream.Dispose()

if ($documentXml) {
    $documentXml.pstypenames.insert(0,'OpenXML.Word.Document')
    $documentXml.psobject.properties.add(
        [psnoteproperty]::new('FilePath', $this.FilePath), $false
    )
    $documentXml.psobject.properties.add(
        [psnoteproperty]::new('OpenXML', $this), $false
    )
    $documentXml.psobject.properties.add(
        [psnoteproperty]::new('Part', $documentPart), $false
    )
    $this.psobject.properties.add(
        [psnoteproperty]::new('#document', $documentXml), $false
    )    
    return $this.'#document'
}

