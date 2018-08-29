param (
    [Parameter(Mandatory=$true)][string]$scriptfile
)

if (Test-Path $scriptfile) {
    (Get-Content $scriptfile) | ForEach-Object {
        ($_ -replace "``", "\``") -replace "\\``", "\\\``"
    } | Set-Content escapeSymbols.al
} else {
    Write-Output "Could not find file $($scriptfile)."
}