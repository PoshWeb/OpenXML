<#
.SYNOPSIS
    Gets OpenXML creation time
.DESCRIPTION
    Gets the time an OpenXML file was created, according to core document metadata.
.EXAMPLE
    Get-OpenXML ./Examples/Blank.docx | Select-Object -ExpandProperty Created
#>
param()
$this.Parts.'/docProps/core.xml'.content.coreProperties.created.innerText -as [DateTime]