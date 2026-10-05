# Usage : .\deploy.ps1            -> prend le binome-site-v*.html le plus récent
#         .\deploy.ps1 fichier.html -> prend ce fichier précis
param([string]$Source)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
if (-not $Source) {
  $f = Get-ChildItem -Filter *.html | Where-Object Name -ne "index.html" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if (-not $f) { throw "Aucun fichier HTML à déployer dans $PSScriptRoot" }
  $Source = $f.FullName
}
Copy-Item $Source index.html -Force
git add -A
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) { Write-Host "Rien de nouveau à déployer."; exit 0 }
git commit -m "Mise à jour du site ($(Get-Date -Format 'yyyy-MM-dd HH:mm')) depuis $(Split-Path $Source -Leaf)"
git push
Write-Host "Poussé. En ligne d'ici 1 à 2 minutes."
