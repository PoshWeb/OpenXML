Push-Location $PSScriptRoot
describe OpenXML {
    it 'Is a zip in a trenchcoat' {        
        $blankDocument = Get-OpenXML -FilePath ./Examples/Blank.docx
        $blankDocument.Parts.Count | Should -BeGreaterThan 1
    }

    it 'Can access metadata' {
        $blankDocument = Get-OpenXML -FilePath ./Examples/Blank.docx
        $blankDocument.Created | Should -BeLessThan ([DateTime]::Now)
        $blankDocument.Modified | Should -BeLessThan ([DateTime]::Now)
    }


    context Excel {
        it 'Can Get Cells' {
            $helloExcel = OpenXML ./Examples/HelloWorld.xlsx
            $helloExcel.Text -replace '^[\n\r]' | Should -Be 'Hello World'
        }        
    }
    context PowerPoint {
        it 'Can Get Text' {
            $helloPowerPoint = OpenXML ./Examples/HelloWorld.pptx
            $helloPowerPoint.Text -replace '^[\n\r]' | Should -Be 'Hello World'
        }
        it 'Can Get Slides' {
            $aSlideDeck = OpenXML ./Examples/ASlideDeck.pptx
            $aSlideDeck.Slides.Count | Should -BeGreaterThan 1
            $aSlideDeck.Slides.SlideNumber | Should -BeGreaterOrEqual 1 
        }
    }

    context Word {
        it 'Can Get Text' {
            $helloWorld = Get-OpenXML -FilePath ./Examples/HelloWorld.docx
            $helloWorld.Text -replace '^[\n\r]+' | Should -Be 'Hello World'
        }
    }

    
}

Pop-Location