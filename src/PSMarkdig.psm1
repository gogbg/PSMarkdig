function Get-MdDocument
{
  [cmdletBinding()]
  [OutputType([Markdig.Syntax.MarkdownDocument])]
  param
  (
    [Parameter(Mandatory)]
    [System.IO.FileInfo]$FilePath,

    [Parameter()]
    [string[]]$Extension
  )

  process
  {
    $fileContent = Get-Content -Path $FilePath -Raw
    $pipeline = [Markdig.MarkdownPipelineBuilder]::new()
    if ($PSBoundParameters.ContainsKey('Extension'))
    {
      $pipeline = [Markdig.MarkDownExtensions]::Configure($pipeline,($Extension -join '+'))
    }
    $result = [Markdig.Parsers.MarkdownParser]::Parse($fileContent,$pipeline.Build())
    $PSCmdlet.WriteObject($result,$false)
  }
}

function Get-MdElement
{
  [cmdletBinding()]
  param
  (
    [Parameter(Mandatory)]
    [Markdig.Syntax.MarkdownObject]$Document,

    [Parameter(Mandatory)]
    [string]$TypeName
  )

  process
  {
    #Check Type
    $type = $TypeName -as [Type]
    if (-not $type)
    {
      throw "Type: '$TypeName' not found"
    }

    $mdExtensionsType = [Markdig.Syntax.MarkdownObjectExtensions]
    $methodDescendants = [Markdig.Syntax.MarkdownObjectExtensions].GetMethod('Descendants',1,[Markdig.Syntax.MarkdownObject])
    $method = $methodDescendants.MakeGenericMethod($Type)
    $method.Invoke($mdExtensionsType,@(,$Document)) | ForEach-Object {$PSCmdlet.WriteObject($_,$false)} | Write-Output -NoEnumerate
  }
}

function Convert-MdToString {
  [cmdletBinding()]
  [OutputType([string])]
  param (
    [Parameter(Mandatory, ValueFromPipeline)]
    [Markdig.Syntax.MarkdownObject[]]$InputObject
  )

  begin {
    $stringWriter = [System.IO.StringWriter]::new()
    $renderer = [Markdig.Renderers.Normalize.NormalizeRenderer]::new($stringWriter)
  }

  process {
    foreach ($io in $InputObject) {
      $null = $renderer.Render($io)
    }
  }

  end {
    $stringWriter.ToString()
  }
}