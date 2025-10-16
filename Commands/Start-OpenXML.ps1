function Start-OpenXML {
    <#
    .SYNOPSIS
        Starts an OpenXML Server
    .DESCRIPTION
        Starts a read only server, using one or more OpenXML files as the storage.
    .NOTES
        If a URI in the package is requested, that URI will be returned.

        If a path does not have an extension, it will search for an .index.html.

        If the file was not found, a 404 code will be returned.
        
        If the OpenXML archive contains a `/404.html`, the content in this file will be returned with the 404

        If another method than GET or HEAD is used, a 405 code will be returned.

        If the OpenXML archive contains a `/405.html`, then content in this file will be returned with the 405.

        ### Security Implications

        By default, this only serves content locally.
        
        If this serves content to any other machine, the script will need to be running as administrator, and all of the content within the file will be exposed.

        If the file contained PII, this could be problematic.

        If you see this command running in an administrative process, please contact your network infrastructure and security teams
    .EXAMPLE
        $openXmlServer = Get-OpenXML ./Examples/Blank.docx |
            Set-OpenXML -Uri '/index.html' -ContentType text/html -Content "
               <h1>Hello World</h1>
            " |
            Start-OpenXML

        Start-Process $openXmlServer.Name
    .EXAMPLE
        $openXmlServer = Get-OpenXML ./Examples/Blank.docx |
            Set-OpenXML -Uri '/index.html' -ContentType text/html -Content "
            <html>
                <head>
                    <title>Hello World</title>
                    <link rel='stylesheet' href='/css/style.css' /> 
                </head>
                <body>
                    <h1>Hello World</h1>                    
                </body>
            </html>
            " |
            Set-OpenXML -Uri '/css/style.css' -ContentType text/css -Content "
            body { background-color: #000000; color: #4488ff }
            " |            
            Set-OpenXML -Uri '/404.html' -ContentType text/html -Content "
            <html>
                <head>
                    <title>Hello World</title>
                    <link rel='stylesheet' href='/css/style.css' /> 
                </head>
                <body>
                    <h1>File Not Found</h1>                    
                </body>
            </html>
            " |
            Start-OpenXML

        Start-Process $openXmlServer.Name
    .EXAMPLE
        $openXmlUpdate = Get-OpenXML ./Examples/Blank.docx |
            Set-OpenXML -Uri '/index.html' -ContentType text/html -Content "<h1>Hello World</h1>" |
            Export-OpenXML ./Examples/Server.docx -Force
        
        $openXmlServer  = Start-OpenXML -FilePath $openXmlUpdate.FilePath

        Start-Process $openXmlServer.Name
    #>
    param(
    # The path to an OpenXML file, or a glob that matches multiple OpenXML files.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]    
    [string]
    $FilePath,

    # The Root
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $RootUrl = "http://127.0.0.1:$(Get-Random -Minimum 4200 -Maximum 42000)/",

    # The input object.  This can be provided to avoid loading a file from disk.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject
    )

    begin {
        if ($PSVersionTable.PSVersion -lt '7.0') {
            Write-Error "This feature requires thread jobs, which are part of PowerShell Core"
            return
        }
    }
    process {
        # Get our OpenXML
        $openXml = 
            if ($inputObject -is [IO.Packaging.Package]) {
                $inputObject
            } else {
                Get-OpenXML -FilePath $FilePath
            }

        # and return if we could not
        if (-not $openXml) { return }

        # Create a listener
        $httpListener = [Net.HttpListener]::new()
        $httpListener.Prefixes.Add($RootUrl)
        $httpListener.Start()


        # Create an IO object to populate the background runspace
        $IO = [Ordered]@{
            HttpListener = $httpListener
            OpenXML = $openXml
        }

        # Because this function exposes a server, we want to fire some events.
        # First is an approve event: `Approve-Start-OpenXML`
        # By using Register-EngineEvent, this can be handled
        $beforeEvent = 
            New-Event -SourceIdentifier "Approve-Start-OpenXML" -MessageData $IO -Sender $MyInvocation.MyCommand -EventArguments $IO

        # We will just wait almost no time, so that the handler can run.
        Start-Sleep -Milliseconds 0

        # To reject the event, the handler can put one of three values in the `$event.MessageData`

        if ($beforeEvent.MessageData.Rejected -or 
            $beforeEvent.MessageData.Reject -or 
            $beforeEvent.MessageData.No) {
        }

        # Start a thread job
        $startedJob = Start-ThreadJob -ScriptBlock {
            param([Collections.IDictionary]$IO)
            
            # unpack our IO into local variables
            foreach ($variableName in $IO.Keys) {
                $ExecutionContext.SessionState.PSVariable.Set($variableName, $IO[$variableName])
            }

            # declare a little filter to serve a part

            filter servePart {
                $uriPart = $_
                $packagePart = $package.GetPart($uriPart)
                $response.ContentType = $packagePart.ContentType
                $partStream = $packagePart.GetStream()
                $partStream.CopyTo($response.OutputStream)
                $partStream.Close()
                $response.Close()
            }

            # and start listening            
            :nextRequest while ($httpListener.IsListening) {
                $getContextAsync = $httpListener.GetContextAsync()
                # wait in short increments to minimize CPU impact and stay snappy
                while (-not $getContextAsync.Wait(7)) {

                }
                # Get our listener context
                $context = $getContextAsync.Result                
                # and break that into a result and response
                $request, $response = $context.Request, $context.Response

                # If they asked for an inappropriate method
                if ($request.HttpMethod -notin 'GET', 'HEAD') {
                    # use the appropriate status code
                    $response.StatusCode = 405
                    foreach ($package in $openXml) {
                        # and serve any /405.html we find.
                        if ($package.PartExists("/405.html")) {
                            "/405.html" | servePart
                            continue nextRequest
                        }
                    }
                    # close out
                    $response.close()
                    # and continue to the next request
                    continue nextRequest
                }

                # Get the local path
                $localPath = $request.Url.LocalPath
                # if it lacks an extension, look for an index.
                $uriPart = if ($localPath -notmatch '\..+?$') {
                    ($localPath -replace '/$') + '/index.html' 
                } else {
                    $localPath
                }

                # If we find the part
                foreach ($package in $openXml) {
                    if ($package.PartExists($uriPart)) {
                        # serve it and continue
                        $uriPart | servePart
                        continue nextRequest
                    }
                }
                # If we did not find a part, set the appropriate status code
                $response.StatusCode = 404 
                foreach ($package in $openXml) {
                    # look for a 404 to serve
                    if ($package.PartExists("/404.html")) {
                        "/404.html" | servePart
                        continue nextRequest
                    }
                }
                # and close the respons
                $response.Close()
            }
        } -ArgumentList $IO -Name $RootUrl -ThrottleLimit 100 |
            Add-Member NoteProperty IO $IO -Force -PassThru | 
            Add-Member NoteProperty HttpListener $httpListener -Force -PassThru |
            Add-Member NoteProperty OpenXML $openXml -Force -PassThru

        $null = New-Event -SourceIdentifier Start-OpenXML -Sender $MyInvocation.MyCommand -EventArguments $startedJob -MessageData $IO

        $startedJob

    }
}