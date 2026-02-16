<#
.SYNOPSIS
    Gets word table columns
.DESCRIPTION
    Gets columns in a word table
#>
foreach ($column in $this.tr) {
    if (-not $column.trPr.psobject.properties) { continue }
    if ($column.trPr.psobject.properties['tblHeader']) { continue }

    if ($column.pstypenames -ne 'OpenXML.Word.TableColumn') {
        $column.pstypenames.insert(0, 'OpenXML.Word.TableColumn')
    }
    if (-not $column.FilePath) {
        $column.psobject.properties.add(
            [psnoteproperty]::new("FilePath", $this.FilePath), $false
        )
    }
    if (-not $column.OpenXML) {
        $column.psobject.properties.add(
            [psnoteproperty]::new("OpenXML", $this.OpenXML), $false
        )
    }
    if (-not $column.Table) {
        $column.psobject.properties.add(
            [psnoteproperty]::new("Table", $this.Table), $false
        )
    }

    if (-not $column.Row) {
        $column.psobject.properties.add(
            [psnoteproperty]::new("Row", $this), $false
        )
    }

    $column    
}