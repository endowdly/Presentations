#Requires -Version 3.0

param (

    # Specifies a path to one location to watch.
    [Parameter(Position = 0)]
    [Alias('Folder', 'Directory')]
    [ValidateScript({ Resolve-Path $_ | Test-Path -PathType Container })]
    [string]
    $Path = $pwd,

    # Filters the paths to only include a specified file or types. Wildcards accepted.
    [string]
    $Filter = '*',

    # Halts watching.
    [Alias('Halt')]
    [switch]
    $Stop, 

    # A file path containing wildcard path names to ignore or do not watch. Default: ./.ignore
    [ValidateScript({ Resolve-Path $_ | Test-Path })]
    [string]
    $IgnorePath = (Join-Path $pwd .ignore),

    # Silently run. No output to the console.
    [Alias('Zzz', 'Shh')]
    [switch]
    $Silent,
    
    # Log to destination
    [switch]
    $Log,

    # Log file destination
    [string]
    $LogPath = (Join-Path $pwd fileWatcher.log)
    
)


function NewFileSystemWatcher {
    [System.IO.FileSystemWatcher]::new()
}

filter SetDirectory {
    $_.Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    $_ 
}

filter SetFilter {
    $_.Filter = $Filter
    $_
}

filter SetOptions {
    $_.IncludeSubdirectories = $false
    $_.NotifyFilter = [IO.NotifyFilters] 'LastWrite, FileName, DirectoryName, CreationTime'
    $_.EnableRaisingEvents = $true
    $_
}

function Get-Watcher {
    NewFileSystemWatcher |
        SetDirectory |
        SetFilter |
        SetOptions 
}

function GetFileDiff ($ref, $diff) {
    $refFiles = Get-ChildItem $ref
    $diffFiles = Get-ChildItem $diff

    Compare-Object $refFiles $diffFiles |
        Where-Object SideIndicator -eq '<=' |
        Select-Object -ExpandProperty InputObject 
}

filter CopyFileDiff ($s) {
    Copy-Item $_ $s -Recurse
}


# We want to backup our work and log extra changes.
if ($PSBoundParameters.ContainsKey('OriginPath')) {

    # Path exists, copy everything over.
    if (Test-Path $OriginPath) {
        GetFileDiff $Path $OriginPath | CopyFileDiff $OriginPath
    }
    else {
        New-Item $OriginPath -ItemType Directory
        Copy-Item $Path $OriginPath -Recurse 
    } 

}

$Msg = @{
    Log     = $Log.IsPresent
    Silent  = $Silent.IsPresent
    LogPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($LogPath)
    Exclude = Get-Content $IgnorePath
} 

$CreateAction = {
        
    if (-not $Event.MessageData.Silent) {
        Write-Host "$( $EventArgs.Name ) was $( $EventArgs.ChangeType ) at $( $Event.TimeGenerated )" -ForegroundColor Green
    }

    if ($Event.MessageData.Log) {
        '[ {0:o} ] [+] {1}' -f $Event.TimeGenerated, $EventArgs.FullPath >> $Event.MessageData.LogPath
    }
} 
$ChangeAction = {
    $parent = Split-Path $EventArgs.FullPath 
    $filter = (Get-ChildItem $parent* -Exclude $Event.MessageData.Exclude).FullName
    if ($EventArgs.FullPath -in $filter) { 

        if (-not $Event.MessageData.Silent) {
            Write-Host "$( $EventArgs.Name ) was $( $EventArgs.ChangeType ) at $( $Event.TimeGenerated )" -ForegroundColor Cyan
        }

        if ($Event.MessageData.Log) {
            '[ {0:o} ] [*] {1}' -f $Event.TimeGenerated, $EventArgs.FullPath >> $Event.MessageData.LogPath
        }

        if ($null -ne (Get-Variable $EventArgs.FullPath -Scope Script)) { 
            $change = New-Object System.Text.StringBuilder

            Compare-Object (Get-Variable $EventArgs.FullPath -Scope Script -ValueOnly) (Get-Content $EventArgs.FullPath) |
                    ForEach-Object {
                        $content = $_.InputObject
                        $line = 
                            switch ($_.SideIndicator) {
                                '=>' { "  [+] $content" }
                                '<=' { "  [-] $content" }
                            }
                        
                        [void] $change.AppendLine($line)
                    } 

                $change.ToString() >> $Event.MessageData.LogPath 
        }

        Set-Variable $EventArgs.FullPath (Get-Content $EventArgs.FullPath) -Scope Script -Visibility Private -Force
    }
} 
$RemoveAction = {
        
    if (-not $Event.MessageData.Silent) {
        Write-Host "$( $EventArgs.Name ) was $( $EventArgs.ChangeType ) at $( $Event.TimeGenerated )" -ForegroundColor Red
    }

    if ($Event.MessageData.Log) {
        '[ {0:o} ] [-] {1}' -f $Event.TimeGenerated, $EventArgs.FullPath >> $Event.MessageData.LogPath
    }
} 
$RenameAction = {
    $parent = Split-Path $EventArgs.FullPath 
    $filter = (Get-ChildItem $parent* -Exclude $Event.MessageData.Exclude).FullName
    if ($EventArgs.FullPath -in $filter) { 
        
        if (-not $Event.MessageData.Silent) {
            Write-Host "$( $EventArgs.OldName ) was $( $EventArgs.ChangeType ) at $( $Event.TimeGenerated ) to $( $EventArgs.Name )" -ForegroundColor Magenta
        }

        if ($Event.MessageData.Log) {
            '[ {0:o} ] {1} -> {2}' -f $Event.TimeGenerated, $EventArgs.OldName, $EventArgs.Name >> $Event.MessageData.LogPath
        }
    }
} 

$DirName = (Get-Item $Path).BaseName
$Watcher = Watcher

if ($Stop) {
    $Watcher.Dispose()
    Get-EventSubscriber $DirName* | Unregister-Event
}
else {
    Register-ObjectEvent $Watcher Created -SourceIdentifier ${DirName}:Created -Action $CreateAction -MessageData $Msg
    Register-ObjectEvent $Watcher Changed -SourceIdentifier ${DirName}:Changed -Action $ChangeAction -MessageData $Msg
    Register-ObjectEvent $Watcher Deleted -SourceIdentifier ${DirName}:Deleted -Action $RemoveAction -MessageData $Msg
    Register-ObjectEvent $Watcher Renamed -SourceIdentifier ${DirName}:Renamed -Action $RenameAction -MessageData $Msg
}