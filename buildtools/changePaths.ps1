param (
    [Parameter(Mandatory=$true)][string]$makefile
)

(Get-Content $makefile) | ForEach-Object {
    $_ -replace "/", "\"
} | Set-Content makefileChangePaths.txt