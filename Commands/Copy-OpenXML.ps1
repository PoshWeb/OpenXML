function Copy-OpenXML 
{
    <#
    .SYNOPSIS
        Copies OpenXML
    .DESCRIPTION
        Copies content from one OpenXML file to another
    #>
    param(
    # The destination path
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Destination')]
    [string]
    $DestinationPath,

    # The input object
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject,

    # If set, will update existing packages.
    [switch]
    $Force
    )

    process {
        # If the input was not a package
        if ($inputObject -isnot [IO.Packaging.Package]) {
            $loadedPackage = # see if it is a file we can load
                if ($InputObject -is [IO.FileInfo]) {
                    Get-OpenXML $InputObject.FullName
                } elseif ($inputFile = Get-Item -ErrorAction Ignore -Path "$InputObject") {
                    Get-OpenXML $inputFile
                }

            # If it was not, return.
            if ($loadedPackage -isnot [IO.Packaging.Package]) { return }
            $InputObject = $loadedPackage
        }
        
        # Get the absolute path of the destination, without creating the file,
        $unresolvedDestination = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DestinationPath)

        # then see if the file exists.
        $fileExists = Test-Path $unresolvedDestination
        # If it does and we are not using the -Force
        if ($fileExists -and -not $force) {
            # write an error
            Write-Error "$unresolvedDestionation already exists, use -Force to update" -Category ResourceExists
            return
        }
        # If it did not exist, create it with New-Item -Force
        elseif (-not $fileExists) 
        {
            # this will create intermediate paths.
            $newFile = New-Item -ItemType File -Path $unresolvedDestination -Force
            if (-not $newFile) { return }
        }

        # Try to open or create our package for read and write.
        $destinationPackage = [IO.Packaging.Package]::Open($unresolvedDestination, 'OpenOrCreate', 'ReadWrite')
        
        # If we could not, we are done.
        if (-not $destinationPackage) { return }

        # Get the input parts and relationships
        $inputPackageParts = $InputObject.GetParts()
        $inputPackageRelationships = $InputObject.GetRelationships()

        # For each part in the input
        foreach ($inputPart in $inputPackageParts) {
            # Create or open a part in the destination            
            $destinationPart = 
                if (-not $destinationPackage.PartExists($inputPart.Uri)) {
                    $destinationPackage.CreatePart($inputPart.Uri, $inputPart.ContentType)
                } else {
                    $destinationPackage.GetPart($inputPart.Uri)
                }

            # and copy the streams.
            $inputStream = $inputPart.GetStream()
            $destinationStream = $destinationPart.GetStream()
            $inputStream.CopyTo($destinationStream)
            $inputStream.Close()
            $destinationStream.Close()
        }

        # Then, create any relationships that do not exist.
        foreach ($inputRelationship in $inputPackageRelationships) {
            if ($inputRelationship) {                
                if (-not $destinationPackage.RelationshipExists($inputRelationship.id)) {
                    $null = $destinationPackage.CreateRelationship(
                        $inputRelationship.targetUri, 
                        $inputRelationship.targetMode, 
                        $inputRelationship.relationshipType,
                        $inputRelationship.id
                    )
                }
            }
        }
        
        # We can now close our package, writing the file.
        $destinationPackage.Close()

        # We want to open it right back up again as we output the updated file.
        Get-OpenXML -FilePath $unresolvedDestination
    }
}