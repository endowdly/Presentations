#Requires -Version 3.0

<#
.Synopsis
  Tools to convert an outline or a presentation using Reveal.js and node.
.Description
  Using node, asciidoctor.js and reveal.js, produce a nice html5 based slide deck.
  It can take a presentation file (adoc) and convert it to an final html file.

  Asciidoctor.js & reveal.js JavaScript libraries handle adoc -> html.
.Example
  PS> ./convert.ps1 -Path presentation.adoc
  Processes presentation.adoc with asciidoctor.js and reveal.js to a html5 slide deck name.
.Example
  PS> ./convert.ps1 -Path presentation.adoc -Destination slide.html
  Processes presentation.adoc to slide.html.
.Notes
  string -> unit
  string -> string -> unit 
#>

[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'PresentationToHtml')]
param (
    # Specifies a path to one input file.
    [Parameter(Mandatory, HelpMessage = 'Path to one input file.',
               Position = 0,
               ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('Input')]
    [ValidateScript({ Test-Path $_ })]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path,

    # Specifies a path to a destination file.
    [Parameter(Position = 1, ValueFromPipelineByPropertyName)]
    [Alias('Output')]
    [string]
    $Destination = ([System.IO.FileInfo]::new($Path)).BaseName + '.html')

begin {
    $modulesPath = Join-Path $PSScriptRoot node_modules
    $asciidoctorJSPath = Join-Path $modulesPath asciidoctor.js
    $revealJSPath = Join-Path $modulesPath asciidoctor-reveal.js
    $converter = Join-Path $PSScriptRoot converter.js

    if (-not (Get-Command node)) {
        Write-Error "Node not found! Ensure node.exe is in your path." -Category ObjectNotFound
        
        exit 1
    } 

    if (-not (Test-Path $converter)) {
        Write-Error "Converter not found. Ensure converter.js is in this directory." -Category ObjectNotFound

        exit 1
    }

    if (-not (Test-Path $asciidoctorJSPath) -or -not (Test-Path $revealJSPath)) {
        Write-Error "Libraries not found! Try running 'npm clean-install' in $PSScriptRoot" -Category ObjectNotFound

        exit 1
    }

    $fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    $fullDestination = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)
}

end {
    Push-Location $PSScriptRoot

    if ($PSCmdlet.ShouldProcess($Path, "Processing to $Destination")) {
        node $converter $fullPath $fullDestination
    }

    Pop-Location
}
