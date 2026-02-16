<#
.SYNOPSIS
    Gets tables in a document
.DESCRIPTION
    Gets any table elements within a Word document.
#>
$doc = $this
if ($doc -isnot [xml]) { return }
foreach ($wordTable in 
    $doc | 
        Select-Xml -XPath '//w:tbl' -Namespace @{w='http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
) {
    $table = $wordTable.Node
    if ($table.pstypenames[0] -ne 'OpenXML.Word.Table') {
        $table.pstypenames.insert(0, 'OpenXML.Word.Table')
    }
    if (-not $table.FilePath) {
        $table.psobject.properties.add(
            [psnoteproperty]::new("FilePath", $this.FilePath), $false
        )        
    }
    if (-not $table.OpenXML) {
        $table.psobject.properties.add(
            [psnoteproperty]::new("OpenXML", $this.OpenXML), $false
        )
    }
    $table    
}
    




