function Import-OpenXML {
    <#
    .SYNOPSIS
        Imports OpenXML
    .DESCRIPTION
        Imports OpenXML packages in PowerShell.
    .EXAMPLE
        $excelFile = Import-OpenXML ./a.xlsx
    .LINK
        Get-OpenXML
    #>
    [Alias('Restore-OpenXML','Open-OpenXML')]
    param(
    # The path to the file
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $FilePath
    )

    process {
        Get-OpenXML @PSBoundParameters
    }
}
