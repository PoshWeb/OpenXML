<#
.SYNOPSIS
    Gets Table Header
.DESCRIPTION
    Gets Table Row that are header rows.
#>
foreach ($row in $this.tr) {
    if (-not $row.trPr.psobject.properties) { continue }
    if (-not $row.trPr.psobject.properties['tblHeader']) { continue }

    if ($row.pstypenames -ne 'OpenXML.Word.TableRow') {
        $row.pstypenames.insert(0, 'OpenXML.Word.TableRow')
    }
    if ($row.pstypenames -ne 'OpenXML.Word.TableHeader') {        
        $row.pstypenames.insert(0, 'OpenXML.Word.TableHeader')        
    }
    if (-not $row.FilePath) {
        $row.psobject.properties.add(
            [psnoteproperty]::new("FilePath", $this.FilePath), $false
        )
    }
    if (-not $row.OpenXML) {
        $row.psobject.properties.add(
            [psnoteproperty]::new("OpenXML", $this.OpenXML), $false
        )
    }
    if (-not $row.Table) {
        $row.psobject.properties.add(
            [psnoteproperty]::new("Table", $this), $false
        )
    }

    $row    
}