[CmdletBinding(PositionalBinding=$false)]
param(
    [bool] $CreatePackages,
    [bool] $RunTests = $true,
    [string] $PullRequestNumber
)

$msbuild="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"
if (-not (test-path $msbuild)) {
    $msbuild="$env:ProgramFiles (x86)\MSBuild\15.0\Bin\MSBuild.exe"
}
$os = "win32"
if ($PSVersionTable.Platform -eq "Unix") {
    $os = "Unix"
}

if ($os -eq "win32" -and -not (test-path $msbuild)) {
    # Install-Module VSSetup -Scope CurrentUser -Force
    $vspath = (Get-VSSetupInstance -All -Prerelease | Select-VSSetupInstance).InstallationPath
    $msbuild="$vspath\MSBuild\15.0\Bin\MSBuild.exe"
} else {
    $msbuild = "msbuild"
    if ($IsMacOS) { 
        # $PSVersionTable.OS.BeginsWith("Darwin")
        $env:FrameworkPathOverride="/Library/Frameworks/Mono.framework/Versions/Current/lib/mono/4.5"
    }
    # dotnet add package Microsoft.TargetingPack.NETFramework.v4.6.2  --version 1.0.1 --source https://dotnet.myget.org/F/dotnet-core/api/v3/index.json
}

Write-Host "Run Parameters:" -ForegroundColor Cyan
Write-Host "  CreatePackages: $CreatePackages"
Write-Host "  RunTests: $RunTests"
Write-Host "  dotnet --version:" (dotnet --version)

$packageOutputFolder = "$PSScriptRoot\.nupkgs"
$projectsToBuild =
    'MiniProfiler.Shared',
    'MiniProfiler',
    'MiniProfiler.EF6',
    'MiniProfiler.EntityFrameworkCore',
    'MiniProfiler.Mvc5',
    'MiniProfiler.AspNetCore',
    'MiniProfiler.AspNetCore.Mvc',
    'MiniProfiler.Providers.MongoDB',
    'MiniProfiler.Providers.MySql',
    'MiniProfiler.Providers.Redis',
    'MiniProfiler.Providers.Sqlite',
    'MiniProfiler.Providers.SqlServer',
    'MiniProfiler.Providers.SqlServerCe'

$testsToRun =
    'MiniProfiler.Tests',
    'MiniProfiler.Tests.AspNet'

if ($PullRequestNumber) {
    Write-Host "Building for a pull request (#$PullRequestNumber), skipping packaging." -ForegroundColor Yellow
    $CreatePackages = $false
}

Write-Host "Building solution..." -ForegroundColor "Magenta"
dotnet build ".\MiniProfiler.sln" /p:CI=true
Write-Host "Done building." -ForegroundColor "Green"

$RunTests = false  #TODO if exists "./tests/MiniProfiler.Tests"
if ($RunTests) {
    foreach ($project in $testsToRun) {
        Write-Host "Running tests: $project (all frameworks)" -ForegroundColor "Magenta"
        Push-Location "./tests/$project"

        dotnet xunit
        if ($LastExitCode -ne 0) { 
            Write-Host "Error with tests, aborting build." -Foreground "Red"
            Pop-Location
            Exit 1
        }

        Write-Host "Tests passed!" -ForegroundColor "Green"
	    Pop-Location
    }
}

if ($CreatePackages) {
    mkdir -Force $packageOutputFolder | Out-Null
    Write-Host "Clearing existing $packageOutputFolder..." -NoNewline
    Get-ChildItem $packageOutputFolder | Remove-Item
    Write-Host "done." -ForegroundColor "Green"

    Write-Host "Building all packages" -ForegroundColor "Green"

    foreach ($project in $projectsToBuild) {
        Write-Host "Packing $project (dotnet pack)..." -ForegroundColor "Magenta"
        dotnet pack ".\src\$project\$project.csproj" -c Release /p:PackageOutputPath=$packageOutputFolder /p:NoPackageAnalysis=true /p:CI=true
        Write-Host ""
    }
}

Write-Host "Done."