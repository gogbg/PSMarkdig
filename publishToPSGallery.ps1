[cmdletbinding()]
param
(
    [Parameter(Mandatory)]
    [securestring]$NuGetApiKey
)

$moduleName = Get-Item -Path $PSScriptRoot | Select-Object -ExpandProperty BaseName
$moduleOutFolder = Join-Path -Path $PSScriptRoot -ChildPath 'out' -AdditionalChildPath $moduleName
$moduleSrcFolder = Join-Path -Path $PSScriptRoot -ChildPath 'src' -AdditionalChildPath '*'
$testsPath = Join-Path -Path $PSScriptRoot -ChildPath 'tests'
if (test-path -Path $moduleOutFolder)
{
    Remove-Item -Path $moduleOutFolder -Recurse -Force
}
$null = New-Item -Path $moduleOutFolder -ItemType Directory -Force

#Invoke Tests
Invoke-Pester -Script $testsPath

#Publish Module
Copy-Item -Path $moduleSrcFolder -Recurse -Destination $moduleOutFolder
Publish-Module -Path $moduleOutFolder -Repository psgallery -NuGetApiKey ($NuGetApiKey | ConvertFrom-SecureString -AsPlainText) -Force