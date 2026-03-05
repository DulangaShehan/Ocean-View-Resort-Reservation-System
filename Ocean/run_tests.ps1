# Automated Test Runner Script for Ocean View Hotel Management System

$projectRoot = $PSScriptRoot
$srcDir = Join-Path $projectRoot "src\main\java"
$testDir = Join-Path $projectRoot "src\test\java"
$binDir = Join-Path $projectRoot "build\test-classes"
$libDir = Join-Path $projectRoot "src\main\webapp\WEB-INF\lib"

# Create build directory if not exists
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "  OCEAN VIEW HOTEL - TEST AUTOMATION SCRIPT      " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# Find all Java source files (excluding Controllers to avoid servlet dependency)
$sourceFiles = Get-ChildItem -Path $srcDir -Filter *.java -Recurse | Where-Object { $_.FullName -notmatch "Controller" } | ForEach-Object { "`"$($_.FullName)`"" }
$testFiles = Get-ChildItem -Path $testDir -Filter *.java -Recurse | ForEach-Object { "`"$($_.FullName)`"" }

# Find mysql-connector (if any) in the lib folder
$libFiles = Get-ChildItem -Path $libDir -Filter *.jar -Recurse | ForEach-Object { $_.FullName }
$classpath = ".;$binDir"
if ($libFiles) {
    $classpath += ";" + ($libFiles -join ";")
}

Write-Host "1. Compiling Source and Test files..." -ForegroundColor Yellow
$compileCmd = "javac -d `"$binDir`" -cp `"$classpath`" " + ($sourceFiles -join " ") + " " + ($testFiles -join " ")
Invoke-Expression $compileCmd

if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAILURE] Compilation failed. Please check for syntax errors." -ForegroundColor Red
    exit 1
}

Write-Host "[SUCCESS] Compilation completed." -ForegroundColor Green

Write-Host "`n2. Running Automated Test Suite..." -ForegroundColor Yellow
$runCmd = "java -cp `"$classpath;$binDir`" Daos.TestRunner"
Invoke-Expression $runCmd

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n[SUCCESS] All tests passed." -ForegroundColor Green
} else {
    Write-Host "`n[FAILURE] One or more tests failed." -ForegroundColor Red
}

Write-Host "=================================================" -ForegroundColor Cyan
