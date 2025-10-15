<#
.SYNOPSIS
    Gets cells from Excel
.DESCRIPTION
    Gets individual cells in an Excel worksheet.
.EXAMPLE
    Get-OpenXML ./Examples/Sum.xlsx |
        Select-Object -ExpandProperty Worksheets |
        Select-Object -ExpandProperty Cell
#>
param()
$excelCells = [Ordered]@{}
# Get each row from our sheet data
foreach ($worksheetRow in $this.content.worksheet.sheetdata.row) {
    # and get each column from each row
    foreach ($worksheetColumn in $worksheetRow.c) {
        # The `r` attribute contains the cell coordinate
        $excelCells[$worksheetColumn.r] =
            # Excel cells are always numbers.
            # If the cell contains a string, it is actually stored as an index in "sharedStrings"
            if ($worksheetColumn.t -eq 's') {
                # which makes indexing awfully easy (and has the side-effect of reducing the total file size for worksheets with similar text)
                $this.OpenXML.SharedStrings[$worksheetColumn.v]
            } else {
                # Otherwise, the value should be `v`.
                $worksheetColumn.v   
            }
    }
}

# Return our cells as dictionary
return $excelCells