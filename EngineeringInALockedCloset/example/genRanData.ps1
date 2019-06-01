param (
    [Switch] $ShowProgress,

    [int] $Rows
)

$BaseDate = Get-Date 1/1/2019
$Year = New-TimeSpan -Days 365
$SecondsInYear = $Year.TotalSeconds
$File = 'testData.csv' 

function GenData ($nLoops) {
    $data = New-Object System.Collections.ArrayList
    
    filter Loop {
        if ($ShowProgress) {
            Write-Progress -Activity 'Generating Data' -PercentComplete (($_/$nLoops) * 100)
        }

        $secondOffset = Get-Random $SecondsInYear
        $d = $BaseDate.AddSeconds(-$secondOffset)
        $t = if ((Get-Random 5) -lt 4) { 'RX' } else { 'TX' }
        $v = (Get-Random 10e3) / 100
        $datum = [PSCustomObject]@{
            Date = $d
            Type = $t
            Freq = $v 
        }

        [void] $data.Add($datum) 
    }

    1..$nLoops | Loop

    # Default encoding is UTF-16, which means data will be twice as long if not specified
    $data | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8 
}

$Start = Get-Date

GenData $Rows

$End = Get-Date
$Diff = ($End - $Start).TotalSeconds

"Processing took $Diff seconds" 

# invoke with ./genRanData x where x is an integer