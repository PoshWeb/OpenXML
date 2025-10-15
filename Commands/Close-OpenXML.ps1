function Close-OpenXML {
    <#
    .SYNOPSIS
        Closes OpenXML files
    .DESCRIPTION
        Closes OpenXML files and streams
    #>
    param(
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject
    )

    process {
        if (-not $InputObject) { return }
        if ($InputObject -isnot [IO.Packaging.Package]) { return  }
        if ($InputObject.MemoryStream) { 
            try {
                $InputObject.MemoryStream.Close()
            } catch {
                $PSCmdlet.WriteError($_)
            }            
        }

        try {
            $InputObject.Close()
        } catch {
            $PSCmdlet.WriteError($_)
        }        
    }

}
