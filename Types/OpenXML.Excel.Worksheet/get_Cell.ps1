$excelCells = [Ordered]@{

}
foreach ($worksheetRow in $this.content.worksheet.sheetdata.row) {
    foreach ($worksheetColumn in $worksheetRow.c) {
        $excelCells[$worksheetColumn.r] = $worksheetColumn.v
    }
}
$excelCells