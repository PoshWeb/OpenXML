<#
.SYNOPSIS
    Gets text with a table
.DESCRIPTION
    Gets text within a table as an array of arrays.
.EXAMPLE
    # Gets the first row and column from the first table in a document
    $doc.Table[0].Text[0][0] 
#>
,@(foreach ($row in $this.tr) {
    ,@(foreach ($column in $row.tc) {
        $column.InnerText
    })
})