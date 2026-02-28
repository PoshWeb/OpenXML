<#
.SYNOPSIS
    Gets Code Markdown
.DESCRIPTION
    Gets Word Code blocks as Markdown
#>
param()
@(foreach ($run in $this.r) {
    $runText = $run.t
    if ($runText -isnot [string]) {
        $runText = $run.t.InnerText
    }
    '```' + 
        [Environment]::NewLine + 
            $runText + 
        [Environment]::NewLine +
    '```'
}) -join '' -replace '`{6}'