# Function to create a ps1 file containing a function definition with the
# given name, and a line that calls that function, wrapped in a check to see
# if the script is being run directly or dot-sourced.

function New-ScriptStub {
    param (
        [string]$FunctionName
    )

    if (-not $FunctionName) {
        $approvedVerbs = Get-Verb | Select-Object -ExpandProperty Verb
        do {
            $verb = Read-Host "Enter a verb (e.g., Get, Set, New)"
            if ($approvedVerbs -contains $verb) {
                break
            }
            else {
                Write-Host "The verb '$verb' is not an approved PowerShell verb. Please try again."
            }
        } while ($true)

        $noun = Read-Host "Enter a noun (e.g., Item, User, File)"
        $FunctionName = "$verb-$noun"
    }

    $ScriptBlock = @"
function $FunctionName {
    param (
        [string]`$name
    )
    Write-Host "Hello, `$name!"
}

# For debugging in VS Code.
# Install the PowerShell extension and set "powershell.debugging.executeMode": "Call" in settings.json.
if (`$MyInvocation.InvocationName -ne ".") {
    $FunctionName "World"
}
"@

    $FunctionNameNoHyphens = $FunctionName -replace '-', ''

    $FolderName = "PS$FunctionNameNoHyphens"
    $FolderPath = Join-Path -Path (Get-Location) -ChildPath $FolderName
    if (-not (Test-Path -Path $FolderPath)) {
        New-Item -Path $FolderPath -ItemType Directory | Out-Null
    }
    $FilePath = Join-Path -Path $FolderPath -ChildPath "$FunctionNameNoHyphens.ps1"

    if (Test-Path -Path $FilePath) {
        Write-Host "File '$FilePath' already exists. Skipping creation."
    } else {
        Set-Content -Path $FilePath -Value $ScriptBlock
    }
    Write-Host "Script stub created at: $FilePath"
}

# For debugging in VS Code.
If ($MyInvocation.InvocationName -ne ".") {
    New-ScriptStub
}
