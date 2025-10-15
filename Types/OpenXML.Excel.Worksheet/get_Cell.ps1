$excelCells = [Ordered]@{

}
$sharedStrings = $this.OpenXML.Parts['/xl/sharedStrings.xml'].Content
foreach ($worksheetRow in $this.content.worksheet.sheetdata.row) {
    foreach ($worksheetColumn in $worksheetRow.c) {
        
        $excelCells[$worksheetColumn.r] = 
            if ($worksheetColumn.t -eq 's') {
                $this.OpenXML.SharedStrings[$worksheetColumn.v -as [int]]
            } else {
                $worksheetColumn.v   
            }
    }
}
$excelCells