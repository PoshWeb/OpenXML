$formulaCells = [Ordered]@{}
foreach ($worksheetRow in $this.content.worksheet.sheetdata.row) {
    foreach ($worksheetColumn in $worksheetRow.c) {
        if ($worksheetColumn.f) {
            $formulaCells[$worksheetColumn.r] = $worksheetColumn.f
        }        
    }
}
$formulaCells