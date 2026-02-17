$runs = @($this.r)        
$headingLevel = 1
if ($this.pPr.pStyle -match '\d') {
    $headingLevel = $matches.0 -as [int]
}
    
('#' * ($headingLevel)) + 
    ' ' + 
    $(@(foreach ($run in $runs) {
    
        $runText = $run.t
        if ($runText -isnot [string]) {
            $runText = $run.t.InnerText
        }

        if (-not $run.rPr.psobject.properties) {
            $runText
        }
        elseif ($run.rPr.psobject.properties['b'] -and
            $run.rPr.psobject.properties['i']
        ) {
            "***$runText***"
        }
        elseif (                
            $run.rPr.psobject.properties['b']
        ) {
            "**$runText**"
        }
        elseif (                
            $run.rPr.psobject.properties['i']
        ) {
            "*$runText*"
        } else  {
            $runText  
        } 
        
    }
) -join '' -replace '(?<=\w)(?>\*{6}|\*{4})(?=\w)')
