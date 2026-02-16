<#
.SYNOPSIS
    Gets OpenXML file list
.DESCRIPTION
    Gets the list of files in an OpenXML document.
.LINK
    https://learn.microsoft.com/en-us/dotnet/api/system.io.packaging.package.getparts?wt.mc_id=MVP_321542
#>  
[OutputType([string[]])]
param()

@($this.GetParts()).Uri -as [string[]]