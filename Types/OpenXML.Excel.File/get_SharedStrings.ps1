<#
.SYNOPSIS
    Gets an Excel File's Shared Strings
.DESCRIPTION
    Gets an Excel File's Shared Strings.

    In Excel, any cell with text in it really contains an index of it's shared string.
.EXAMPLE
    Get-OpenXML ./Examples/HelloWorld.xlsx | Select -Expand SharedString
#>
,@($this.Parts.'/xl/sharedStrings.xml'.Content.sst.si.t)