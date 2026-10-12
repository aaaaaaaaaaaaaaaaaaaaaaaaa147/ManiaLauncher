$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
if (-not (Get-Command py -ErrorAction SilentlyContinue)) {
  throw "Instale Python 3.12 ou 3.13 para Windows (incluindo o launcher py)."
}
py -3 -m venv .venv
$py = Join-Path $PSScriptRoot ".venv\Scripts\python.exe"
& $py -m pip install --upgrade pip
& $py -m pip install -r requirements.txt
& $py -m pip install "pyinstaller>=6,<7"
& $py -m unittest discover -s tests -v
if ($LASTEXITCODE -ne 0) { throw "Os testes falharam. A compilação foi interrompida." }
& $py -m PyInstaller --noconfirm --clean --windowed --onefile --name ManiaLauncher `
  --collect-all minecraft_launcher_lib --hidden-import tkinter --hidden-import requests main.py
if ($LASTEXITCODE -ne 0) { throw "Falha ao gerar executável." }
Write-Host "Executável pronto: dist\ManiaLauncher.exe"
Write-Host "O .exe é um launcher, e baixará os arquivos do Minecraft após configurar a conta."

$innoPaths = @(
  "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
  "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
)
$inno = $innoPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($inno) {
  & $inno ManiaLauncher.iss
  if ($LASTEXITCODE -ne 0) { throw "Falha ao gerar instalador Inno Setup." }
  Write-Host "Instalador pronto: dist\ManiaLauncher_Setup_0.2.0.exe"
} else {
  Write-Host "Inno Setup 6 não instalado: o executável portátil foi gerado, mas não o Setup.exe."
  Write-Host "Para criar o instalador, instale o Inno Setup 6 e execute ISCC.exe ManiaLauncher.iss"
}
