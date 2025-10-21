@{

# Script module or binary module file associated with this manifest.
RootModule = 'OpenXML.psm1'

# Version number of this module.
ModuleVersion = '0.1'

# Supported PSEditions
# CompatiblePSEditions = @()
Description = 'Automate OpenXML. Excel, Word, and PowerPoint automation in PowerShell.'

# ID used to uniquely identify this module
GUID = 'ce1bf009-73ae-4293-b57f-a19aaaa793b7'

# Author of this module
Author = 'James Brundage'

# Company or vendor of this module
CompanyName = 'Start-Automating'

# Copyright statement for this module
Copyright = '2025 Start-Automating'

TypesToProcess = @('OpenXML.types.ps1xml')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-OpenXML', 'Set-OpenXML', 'Import-OpenXML', 'Export-OpenXML', 'Start-OpenXML', 'Stop-OpenXML'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'OpenXML', 'Close-OpenXML', 'Open-OpenXML', 'Restore-OpenXML', 'Save-OpenXML'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Word','Excel','PowerPoint','OpenXML','OfficeOpenXML','OOXML')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/PowerShellWeb/OpenXML/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/PowerShellWeb/OpenXML'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = @'
## OpenXML 0.1

* Initial Build of OpenXML Module (#1)
* Commands:
  * `Get-OpenXML` (#2)
  * `Import-OpenXML` (#14)
  * `Export-OpenXML` (#15)
  * `Close-OpenXML` (#16)  
  * `Copy-OpenXML` (#18)
  * `Set-OpenXML` (#19)
  * `Start-OpenXML` (#28)
  * `Stop-OpenXML` (#29)
* Initial Extended Types
  * `OpenXML`
    * `OpenXML.get_Parts` (#17)
    * `OpenXML.get_Created` (#23)
    * `OpenXML.get_Modified` (#24)
  * `OpenXML.File`
    * `OpenXML.File.get_DocumentProperty` (#13)
    * `OpenXML.File` default display (#7)
  * `OpenXML.Excel.File`
    * `OpenXML.Excel.File.get_Worksheets` (#5)    
    * `OpenXML.Excel.File.get_SharedString` (#25)
  * `OpenXML.Excel.Worksheet`
    * `OpenXML.Excel.Worksheet.get_Cell` (#6)
    * `OpenXML.Excel.Worksheet.get_Formula` (#26)
  * `OpenXML.PowerPoint.File`
    * `OpenXML.PowerPoint.File.get_Slides` (#8)
    * `OpenXML.PowerPoint.File.get_Text` (#9)
  * `OpenXML.PowerPoint.Slide`
    * `OpenXML.PowerPoint.get_Text` (#10)
  * `OpenXML.Word.File`
    * `OpenXML.Word.File.get_Text` (#11)  
* Sample Documents (#3)
* Initial Tests (#27)
* Build workflow
  * Building types with [EZOut](https://github.com/StartAutomating/EZOut) (#4)
  * Building GitHub Workflow with [PSDevOps](https://github.com/StartAutomating/PSDevOps) (#12)
* Core Documentation
  * README (#1)
  * CODE_OF_CONDUCT (#20)
  * CONTRIBUTING (#21)
  * SECURITY (#22)
'@

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

