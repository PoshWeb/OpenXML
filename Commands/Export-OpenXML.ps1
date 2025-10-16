function Export-OpenXML {
    <#
    .SYNOPSIS
        Exports OpenXML
    .DESCRIPTION
        Exports loaded OpenXML to a file.    
    #>
    [Alias('Save-OpenXML')]
    param(
    # The file path to save the turtle graphics pattern.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Path')]
    [string]
    $FilePath,

    # The input object.  
    # This must be a package loaded with this module.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject,

    # If set, will force the export even if a file already exists.
    [switch]
    $Force
    )

    process {
        # If there is no input return
        if (-not $InputObject) { return }
        # If the input is not a package, pass it thru
        if ($InputObject -isnot [IO.Packaging.Package]) { 
            return $InputObject
        }
        
        Copy-OpenXML -DestinationPath $FilePath -InputObject $inputObject -force:$Force
    }
}

