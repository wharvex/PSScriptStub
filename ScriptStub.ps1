# Function to create a ps1 file containing a function definition with the
# given name, and a line that calls that function, wrapped in a check to see
# if the script is being run directly or dot-sourced.

function New-ScriptStub {
    param (
        [string]$FunctionName
    )

    $ScriptBlock = @"
function $FunctionName {
    param (
        [string]`$name
    )
    Write-Host "Hello, `"`$name`"!"
}

# For debugging in VS Code.
# Install the PowerShell extension and set "powershell.debugging.executeMode": "Call" in settings.json.
if (`$MyInvocation.InvocationName -ne ".") {
    $FunctionName "World"
}
"@

    $FolderName = "PS$FunctionName"
    $FolderPath = Join-Path -Path (Get-Location) -ChildPath $FolderName
    if (-not (Test-Path -Path $FolderPath)) {
        New-Item -Path $FolderPath -ItemType Directory | Out-Null
    }
    $FilePath = Join-Path -Path $FolderPath -ChildPath "$FunctionName.ps1"

    Set-Content -Path $FilePath -Value $ScriptBlock
    Write-Host "Script stub created at: $FilePath"
}

# For debugging in VS Code.
If ($MyInvocation.InvocationName -ne ".") {
    New-ScriptStub -FunctionName "Greet"
}
