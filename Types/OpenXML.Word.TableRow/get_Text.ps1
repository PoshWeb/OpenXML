<#
.SYNOPSIS
    Gets table row text
.DESCRIPTION
    Gets an array containing the text from a table row.
#>
return ,@(foreach ($column in $this.tc) {
    $column.InnerText
})