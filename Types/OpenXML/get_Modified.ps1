<#
.SYNOPSIS
    Gets OpenXML modified time
.DESCRIPTION
    Gets the time an OpenXML file was modified, according to core document metadata.
.EXAMPLE
    Get-OpenXML ./Examples/Blank.docx | Select-Object -ExpandProperty Modified
#>
$this.Parts.'/docProps/core.xml'.content.coreProperties.modified.innerText -as [DateTime]