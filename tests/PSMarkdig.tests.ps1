$moduleName = $MyInvocation.MyCommand.Name -replace '.tests.ps1$'
$modulePath = Split-Path -Path $PSScriptRoot | Join-Path -ChildPath 'src' -AdditionalChildPath $moduleName
Import-Module -Name $modulePath -Force

InModuleScope $moduleName {
    describe 'Get-MhDocument' {
      $testResourcesFolder = Join-Path -Path $PSScriptRoot -ChildPath 'testResources'
        it "Get document" {
            $file = Join-Path -Path $testResourcesFolder -ChildPath 'doc1.md'
            $testResult = Get-MhDocument -FilePath $file -ErrorAction Stop
            $testResult.GetType().FullName | should -be 'Markdig.Syntax.MarkdownDocument'
        }

        it "Get document using -Extensions=Yaml" {
          $file = Join-Path -Path $testResourcesFolder -ChildPath 'doc1.md'
          $testResult = Get-MhDocument -FilePath $file -Extension Yaml -ErrorAction Stop
          $testResult.GetType().FullName | should -be 'Markdig.Syntax.MarkdownDocument'
      }
    }

    describe 'Get-MhDocument' {
      $testResourcesFolder = Join-Path -Path $PSScriptRoot -ChildPath 'testResources'
      it "Get Elements when Type=Markdig.Syntax.HeadingBlock" {
          $file = Join-Path -Path $testResourcesFolder -ChildPath 'doc1.md'
          $mdDocument = Get-MhDocument -FilePath $file -ErrorAction Stop
          $testResult = Get-MhElement -Document $mdDocument -Type 'Markdig.Syntax.HeadingBlock'
      }

      it "Get Elements when Type=Markdig.Syntax.Inlines.LinkInline" {
        $file = Join-Path -Path $testResourcesFolder -ChildPath 'doc1.md'
        $mdDocument = Get-MhDocument -FilePath $file -ErrorAction Stop
        $testResult = Get-MhElement -Document $mdDocument -Type 'Markdig.Syntax.Inlines.LinkInline'
      }

      it "Get Elements when Type=Markdig.Extensions.Yaml.YamlFrontMatterBlock" {
        $file = Join-Path -Path $testResourcesFolder -ChildPath 'doc1.md'
        $mdDocument = Get-MhDocument -FilePath $file -Extension Yaml -ErrorAction Stop
        $testResult = Get-MhElement -Document $mdDocument -Type 'Markdig.Extensions.Yaml.YamlFrontMatterBlock'
      }
    }
}