$slidesInOrder = @($this.Parts[$this.Parts.keys -match '/slide\d+\.xml$'] | 
    Sort-Object { $_.Uri -replace '\D' -as [int]} |
    Select-Object)


foreach ($slide in $slidesInOrder) {
    [PSCustomObject][Ordered]@{
        PSTypeName = 'OpenXML.PowerPoint.Slide'
        FilePath = $this.FilePath
        Uri = $slide.Uri
        SlideNumber = $slide.Uri -replace '\D' -as [int]    
        Content = $slide.Content
        ContentType = $slide.ContentType
    }    
}


