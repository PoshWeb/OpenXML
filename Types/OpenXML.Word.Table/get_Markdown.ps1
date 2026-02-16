<#
.SYNOPSIS
    Gets Word Tables as Markdown
.DESCRIPTION
    Gets a Word Table in Markdown
#>

$isFirst = $true
@(foreach ($row in $this.tr) {    
    '|' + (@(        
        foreach ($column in $row.tc) {
            $column.InnerText -replace '(?>\r\n|\n)', '<br/>'
            $columnNumber++
        }
        
    ) -join '|') + '|'

    if ($isFirst) {
        $isFirst = $false
        "|" + ("-|" * ($row.tc.Count))
    }
}) -join [Environment]::NewLine