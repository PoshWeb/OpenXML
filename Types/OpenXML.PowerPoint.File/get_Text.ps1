$this.Slides.Content | 
    Select-Xml -XPath '//a:t' -Namespace @{a='http://schemas.openxmlformats.org/drawingml/2006/main'} |
    Foreach-Object {
        if ($_.Node.LocalName -eq 't') {
            $_.Node.InnerText  
        } else {
            [Environment]::NewLine
        }        
    }