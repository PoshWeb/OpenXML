

$ThisModule = Import-Module ./ -PassThru


$intro = @'

OpenXML is the standard used for Office documents.

You can think of it as a .zip in a trenchcoat.

Every part of an Excel, PowerPoint, or Word document is saved into an archive.

You can prove this to yourself by renaming any .docx file to .zip.

I sometimes call this the "zip epiphany", because it helps you understand how much technology is really a "zip in a trenchcoat".

(hint: it's _much_ more than just OpenXML files)

This module is here to help you automate, inspect, and understand OpenXML files.
'@



"# $($ThisModule.Name)"

"## $($ThisModule.Description)"

@"
<div align='center'>    
    <a href='https://www.powershellgallery.com/packages/OpenXML/' >
    <img src='https://img.shields.io/powershellgallery/dt/OpenXML' />
    </a>
</div>
"@

$intro

"### Installing and Importing"

@"
You can install $($ThisModule.Name) from the PowerShell gallery

~~~PowerShell
Install-Module $($ThisModule.Name) -Scope CurrentUser -Force
~~~

Once installed, you can simply ``Import-Module``
~~~PowerShell
Import-Module $($ThisModule.Name)
~~~

"@


"### Commands"

$thisModulesFunctions =  $ThisModule.ExportedFunctions.Keys  | Sort-Object Name
foreach ($command in $thisModulesFunctions) {
    "* $($command)"
}

"### Demos"

$quickDemos = {

    # Get text from a word document
Get-OpenXML ./Examples/HelloWorld.docx | 
    Select-Object -ExpandProperty Text

}, {
    
# Get modification times
Get-OpenXML ./Examples/HelloWorld.docx |
    Select-Object -Property Created, Modified

}, {
# Get PowerPoint slides
Get-OpenXML ./Examples/ASlideDeck.pptx |
    Select-Object -ExpandProperty Slides
},{

# Get text from PowerPoint
Get-OpenXML ./Examples/ASlideDeck.pptx |
    Select-Object -ExpandProperty Text

}, {

# Get worksheets from Excel

Get-OpenXML ./Examples/Sample.xlsx |
    Select-Object -ExpandProperty Worksheets
    
},{

# Get cells from Excel

Get-OpenXML ./Examples/Sample.xlsx |
    Select-Object -ExpandProperty Worksheets |
    Select-Object -ExpandProperty Cell
    
},{

# Get formulas from Excel

Get-OpenXML ./Examples/Sum.xlsx |
    Select-Object -ExpandProperty Worksheets |
    Select-Object -ExpandProperty Formula    
}


foreach ($demo in $quickDemos) {
    "~~~PowerShell"
    "$demo"
    "~~~"
}

"### Roadmap"

$roadmap = @'
While OpenXML has been around since 2006, this module is considerably younger.

It has a large amount of room to grow.

The primary goal for the forseeable future is to increase coverage of office features.  If you would like to help, please consider [contributing](CONTRIBUTING.md).
'@

$roadmap

"### Security"

@'
OpenXML presents some unique security challenges.

This module makes OpenXML documents easier to read and write, which can be useful to both red and blue teams.  Please see the [security guide](SECURITY.md) for more information.
'@