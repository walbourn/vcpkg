# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

<#
.SYNOPSIS
    Updates the directx-dxc vcpkg port to a new release from microsoft/DirectXShaderCompiler.

.DESCRIPTION
    Downloads release assets, computes SHA512 hashes, and updates portfile.cmake and vcpkg.json.

.PARAMETER NewTag
    The GitHub release tag (e.g., v1.9.2602.24).

.PARAMETER NewVersion
    The version date string from asset filenames (e.g., 2026_05_27).

.PARAMETER WinAssetUrl
    The browser_download_url for the Windows zip asset.

.PARAMETER LinuxAssetUrl
    The browser_download_url for the Linux tar.gz asset.

.PARAMETER PortDir
    Path to the port directory. Defaults to ports/directx-dxc relative to repo root.
#>

param(
    [Parameter(Mandatory)][string]$NewTag,
    [Parameter(Mandatory)][string]$NewVersion,
    [Parameter(Mandatory)][string]$WinAssetUrl,
    [Parameter(Mandatory)][string]$LinuxAssetUrl,
    [string]$PortDir
)

$ErrorActionPreference = 'Stop'

if (-not $PortDir) {
    $repoRoot = git rev-parse --show-toplevel
    $PortDir = Join-Path $repoRoot 'ports/directx-dxc'
}

$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) "dxc-update-$([System.Guid]::NewGuid().ToString('N').Substring(0,8))"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

try {
    # Download assets
    Write-Host "Downloading Windows asset..."
    $winFile = Join-Path $tempDir 'win_asset.zip'
    Invoke-WebRequest -Uri $WinAssetUrl -OutFile $winFile -UseBasicParsing

    Write-Host "Downloading Linux asset..."
    $linuxFile = Join-Path $tempDir 'linux_asset.tar.gz'
    Invoke-WebRequest -Uri $LinuxAssetUrl -OutFile $linuxFile -UseBasicParsing

    Write-Host "Downloading LICENSE.TXT..."
    $licenseUrl = "https://raw.githubusercontent.com/microsoft/DirectXShaderCompiler/${NewTag}/LICENSE.TXT"
    $licenseFile = Join-Path $tempDir 'LICENSE.TXT'
    Invoke-WebRequest -Uri $licenseUrl -OutFile $licenseFile -UseBasicParsing

    # Compute SHA512 hashes
    $winSha = (Get-FileHash -Path $winFile -Algorithm SHA512).Hash.ToLower()
    $linuxSha = (Get-FileHash -Path $linuxFile -Algorithm SHA512).Hash.ToLower()
    $licenseSha = (Get-FileHash -Path $licenseFile -Algorithm SHA512).Hash.ToLower()

    Write-Host "Windows SHA512:  $winSha"
    Write-Host "Linux SHA512:    $linuxSha"
    Write-Host "License SHA512:  $licenseSha"

    # Update portfile.cmake
    $portfile = Join-Path $PortDir 'portfile.cmake'
    $content = Get-Content -Path $portfile -Raw

    # Replace TAG
    $content = $content -replace 'set\(DIRECTX_DXC_TAG [^\)]+\)', "set(DIRECTX_DXC_TAG $NewTag)"

    # Replace VERSION
    $content = $content -replace 'set\(DIRECTX_DXC_VERSION [^\)]+\)', "set(DIRECTX_DXC_VERSION $NewVersion)"

    # Replace SHA512 hashes in order: Linux, Windows, LICENSE
    $shaPattern = '(?<=SHA512\s+)[0-9a-fA-F]{128}'
    $hashes = @($linuxSha, $winSha, $licenseSha)
    $index = 0
    $content = [regex]::Replace($content, $shaPattern, {
        param($match)
        $result = $hashes[$script:index]
        $script:index++
        return $result
    })

    if ($index -ne 3) {
        throw "Expected 3 SHA512 entries in portfile, found $index"
    }

    Set-Content -Path $portfile -Value $content -NoNewline

    # Update vcpkg.json
    $versionDate = $NewVersion -replace '_', '-'
    $vcpkgJson = Join-Path $PortDir 'vcpkg.json'
    $jsonContent = Get-Content -Path $vcpkgJson -Raw
    $jsonContent = $jsonContent -replace '"version-date":\s*"[^"]+"', "`"version-date`": `"$versionDate`""
    Set-Content -Path $vcpkgJson -Value $jsonContent -NoNewline

    Write-Host "Updated port to $NewTag ($versionDate)"
}
finally {
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}
