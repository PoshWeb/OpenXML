if (-not $this.Parts) { return }
$docProps = $this.Parts[$this.Parts.Keys -match '/docProps/']
$docProps