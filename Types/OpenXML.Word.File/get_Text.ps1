@($this.Parts['/word/document.xml'].Content | 
    Select-Xml -XPath '//w:t|//w:p' -Namespace @{w='http://schemas.openxmlformats.org/wordprocessingml/2006/main'} |
    Foreach-Object {
        if ($_.Node.LocalName -eq 't') {
            $_.Node.InnerText  
        } else {
            [Environment]::NewLine
        }
        
    }) -join ''