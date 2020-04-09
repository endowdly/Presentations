# Find commands
Get-Command about_*     # gcm
Get-Command -Verb Add   
Get-Alias ps            # gal
Get-Alias -Definition Get-Process

Get-Help ps
ps | Get-Member         # gm

Update-Help # Run as admin

# As you already figured, comments start with #

# Simple hello world example:
echo Hello world!

# echo is an alias for Write-Output and it is implicit
'Hello World!'

# Most cmdlets and functions follow the Verb-Noun naming convention

# Each command starts on a new line, or after a semicolon:
'This is the first line'; 'This is the second line'

# Declaring a variable looks like this:
$aString = "Some string"
$aNumber = 5 -as [double]
$aDouble = 5.0
$anEmptyList = @()
$aList = 1, 2, 3, 4, 5
$aString = $aList -join '--' # yes, -split exists also
$aHashtable = @{ name1 = 'val1'; name2 = 'val2' }

# Or using a Cmdlet...

Set-Variable aNumber 42 

# Builtin variables:
# There are some useful builtin variables, like
"Booleans: $True and $False"
"Empty value: $Null"
"Last program's return value: $?"
"Exit code of last run Windows-based program: $LastExitCode"
"Script's PID: $PID"
"Full path of current script directory: $PSScriptRoot"
'Full path of current script: ' + $MyInvocation.MyCommand.Path
"Full path of current directory: $Pwd"
# Double-quoted strings interpolate variables. Single-quoted strings do not.
'Bound arguments in a function, script or code block: $PSBoundParameters'
'Unbound arguments: $Args'
# More builtins: `help about_Automatic_Variables`

# Inline another file (dot operator)
. .\otherScriptName.ps1

# Execute another file without bringing it into scope
& .\otherScriptName.ps1

# Control Flow
# We have the usual if structure:
if ($Age -is [string]) {
    'But.. $Age cannot be a string!' # Implicit returns
}
elseif ($Age -lt 12 -and $Age -gt 0) {
    'Child (Less than 12. Greater than 0)'
}
else {
    'Adult'
}

# Switch statements are more powerful compared to most languages
$val = "20"

switch ($val) {
  { $_ -eq 42 }           { "The answer equals 42"; break }
  '20'                    { "Exactly 20"; break }
  { $_ -like 's*' }       { "Case insensitive"; break }
  { $_ -clike 's*'}       { "clike, ceq, cne for case sensitive"; break }
  { $_ -notmatch '^.*$'}  { "Regex matching. cnotmatch, cnotlike, ..."; break }
  { 'x' -contains 'x'}    { "FALSE! -contains is for lists!"; break }
  default                 { "Others" }
}

# The classic for
for ($i = 1; $i -le 10; $i++) {
  "Loop number $i"
}

# Or
1..10 | % { "Loop number $_" } # % is an alias for Foreach-Object

# PowerShell also offers
foreach ($var in 'val1','val2','val3') { echo $var } # echo is an alias for Write-Output, called implicitly
# while () {}
# do {} while ()
# do {} until ()

# Exception handling
try {} catch {} finally {}
try {} catch [System.NullReferenceException] {
    $_.Exception
}


### Providers
# List files and directories in the current directory
ls # or `dir`
cd ~ # goto home

Get-Alias ls # -> Get-ChildItem
# Uh!? These cmdlets have generic names because unlike other scripting
# languages, PowerShell does not only operate in the current directory.
cd HKCU: # go to the HKEY_CURRENT_USER registry hive

# Get all providers in your session
Get-PSProvider


### Pipeline
# Cmdlets have parameters that control their execution:
Get-ChildItem -Filter *.txt -Name # Get just the name of all txt files
# Only need to type as much of a parameter name until it is no longer ambiguous
ls -fi *.txt -n # -f is not possible because -Force also exists
# Use `Get-Help Get-ChildItem -Full` for a complete overview

# Results of the previous cmdlet can be passed to the next as input.
# `$_` is the current object in the pipeline object.
ls | Where-Object { $_.Name -match 'c' } | Export-CSV export.txt
ls | ? { $_.Name -match 'c' } | ConvertTo-HTML | Out-File export.html

# If you get confused in the pipeline use `Get-Member` for an overview
# of the available methods and properties of the pipelined objects:
ls | Get-Member
Get-Date | gm

# ` is the line continuation character. Or end the line with a |
Get-Process | Sort-Object ID -Descending | Select-Object -First 10 Name,ID,VM `
    | Stop-Process -WhatIf

Get-EventLog Application -After (Get-Date).AddHours(-2) | Format-List

# Use % as a shorthand for ForEach-Object
(a,b,c) | ForEach-Object `
    -Begin { "Starting"; $counter = 0 } `
    -Process { "Processing $_"; $counter++ } `
    -End { "Finishing: $counter" }

# Get-Process as a table with three columns
# The third column is the value of the VM property in MB and 2 decimal places
# Computed columns can be written more verbose as:
# `@{name='lbl';expression={$_}`
ps | Format-Table ID,Name,@{n='VM(MB)';e={'{0:n2}' -f ($_.VM / 1MB)}} -autoSize


### Functions
# The [string] attribute is optional.
function foo([string]$name) {
    echo "Hey $name, have a function"
}

# Calling your function
foo "Say my name"

# Functions with named parameters, parameter attributes, parsable documentation
<#
.SYNOPSIS
Setup a new website
.DESCRIPTION
Creates everything your new website needs for much win
.PARAMETER siteName
The name for the new website
.EXAMPLE
New-Website -Name FancySite -Po 5000
New-Website SiteWithDefaultPort
New-Website siteName 2000 # ERROR! Port argument could not be validated
('name1','name2') | New-Website -Verbose
#>
function New-Website() {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [Alias('name')]
        [string]$siteName,
        [ValidateSet(3000,5000,8000)]
        [int]$port = 3000
    )
    BEGIN { Write-Verbose 'Creating new website(s)' }
    PROCESS { echo "name: $siteName, port: $port" }
    END { Write-Verbose 'Website(s) created' }
}


### It's all .NET
# A PS string is in fact a .NET System.String
# All .NET methods and properties are thus available
'string'.ToUpper().Replace('G', 'ggg')
# Or more powershellish
'string'.ToUpper() -replace 'G', 'ggg'

# Unsure how that .NET method is called again?
'string' | gm

# Syntax for calling static .NET methods


# Note that .NET functions MUST be called with parentheses
# while PS functions CANNOT be called with parentheses.
# If you do call a cmdlet/PS function with parentheses,
# it is the same as passing a single parameter list
$writer = New-Object System.IO.StreamWriter($path, $true)
$writer.Write([Environment]::NewLine)
$writer.Dispose()

### IO
# Reading a value from input:
$Name = Read-Host "What's your name?"
echo "Hello, $Name!"
[int]$Age = Read-Host "What's your age?"

# Test-Path, Split-Path, Join-Path, Resolve-Path
# Get-Content filename # returns a string[]
# Set-Content, Add-Content, Clear-Content
Get-Command ConvertTo-*,ConvertFrom-*


### Useful stuff
# Refresh your PATH
$env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + 
    ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Find Python in path
$env:PATH.Split(";") | Where-Object { $_ -like "*python*"}

# Change working directory without having to remember previous path
Push-Location c:\temp # change working directory to c:\temp
Pop-Location # change back to previous working directory
# Aliases are: pushd and popd

# Unblock a directory after download
Get-ChildItem -Recurse | Unblock-File

# Open Windows Explorer in working directory
ii .

# Any key to exit
$host.UI.RawUI.ReadKey()
return

# Create a shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($link)
$Shortcut.TargetPath = $file
$Shortcut.WorkingDirectory = Split-Path $file
$Shortcut.Save()