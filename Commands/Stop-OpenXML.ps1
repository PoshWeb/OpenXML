function Stop-OpenXML {
    <#
    .SYNOPSIS
        Stops an OpenXML Server
    .DESCRIPTION
        Stops a server running from an OpenXML.
    .NOTES
        This will stop any jobs with HTTP listeners and OpenXML
    #>
    param(
    # The input object.
    # Any input without an HttpListener and OpenXML property will be ignored.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject,

    # If set, will pass thru the input.
    [switch]
    $PassThru
    )

    process {
        # If the input is lacking a listener or OpenXML, return
        if (-not $InputObject.HttpListener -or -not $InputObject.OpenXML) {
            # (pass thru the input if we asked)
            if ($PassThru) {
                return $InputObject
            }
            return 
        }        

        # Stop the listener
        $InputObject.HttpListener.Stop()
        # and attempt to stop the job (ideally so that it reports as stopped, not completed)
        if ($InputObject.StopJob -is [Management.Automation.PSMethod]) {
            $InputObject.StopJob()
        }
        if ($PassThru) {
            return $InputObject
        }        
    }
}