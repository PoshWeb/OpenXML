<#
.SYNOPSIS
    Gets word file styles
.DESCRIPTION
    Gets the `/word/styles.xml` within a Word File. 
#>
[OutputType([xml])]
param()

if ($null -ne $this.'#style') { return $this.'#style'}

if (-not $this.PartExists) { return }
if (-not $this.PartExists('/word/styles.xml')) { return }

$documentPart = $this.GetPart('/word/styles.xml')

$docStream = $documentPart.GetStream()

$streamReader = [IO.StreamReader]::new($docStream)

$stylesXml = $streamReader.ReadToEnd() -as [xml]

$streamReader.Close()
$streamReader.Dispose()

$docStream.Close()
$docStream.Dispose()

if ($stylesXml) {
    $stylesXml.pstypenames.insert(0,'OpenXML.Word.Style')
    $stylesXml.psobject.properties.add(
        [psnoteproperty]::new('FilePath', $this.FilePath), $false
    )
    $stylesXml.psobject.properties.add(
        [psnoteproperty]::new('OpenXML', $this), $false
    )
    $stylesXml.psobject.properties.add(
        [psnoteproperty]::new('Part', $documentPart), $false
    )
    $this.psobject.properties.add(
        [psnoteproperty]::new('#style', $stylesXml), $false
    )    
    return $this.'#styles'
}

