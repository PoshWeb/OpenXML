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
