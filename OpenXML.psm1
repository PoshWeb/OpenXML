$CommandsPath = Join-Path $PSScriptRoot 'Commands'
foreach ($file in Get-ChildItem -Path $CommandsPath -Filter '*-*.ps1') {
    if ($file.Name -like '*.*.ps1') {
        continue
    }
    . $file.FullName
}
