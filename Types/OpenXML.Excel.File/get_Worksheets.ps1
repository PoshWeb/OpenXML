$worksheetNames = @($this.Parts['/docProps/app.xml'].Content.Properties.TitlesOfParts.vector.lpstr)

$worksheetsInOrder = @($this.Parts[$this.Parts.keys -match '/sheet\d+'] | 
    Sort-Object { $_.Uri -replace '\D' -as [int]} |
    Select-Object)

$worksheetObject = [Ordered]@{
    PSTypeName = 'OpenXML.Excel.Worksheets'
}
$worksheetCounter = 0
foreach ($worksheet in $worksheetsInOrder) {
    $worksheetName = $worksheetNames[$worksheetCounter]
    if (-not $worksheetName) {
        $worksheetName = "Sheet$($worksheetCounter + 1)"
    }
    $worksheetObject[$worksheetName] = [PSCustomObject][Ordered]@{
        PSTypeName = 'OpenXML.Excel.Worksheet'
        FilePath = $this.FilePath
        Uri = $worksheet.Uri
        WorksheetName = $worksheetName
        Content = $worksheet.Content
        ContentType = $worksheet.ContentType
    }
    $worksheetCounter++
}
[PSCustomObject]$worksheetObject