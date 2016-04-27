function AddDriversToImage($winImagePath, $driversPath)
{
    Write-Output ('Adding drivers from "{0}" to image "{1}"' -f $driversPath, $winImagePath)
    Add-WindowsDriver -Path $winImagePath -Driver $driversPath -ForceUnsigned -Recurse
    #& Dism.exe /image:${winImagePath} /Add-Driver /driver:${driversPath} /ForceUnsigned /recurse
    #if ($LASTEXITCODE) { throw "Dism failed to add drivers from: $driversPath" }
}
function Add-VirtIODrivers($vhdDriveLetter = "C:", $image = "D:", $driversBasePath = "E:")
{
    # For VirtIO ISO with drivers version lower than 1.8.x
    if ($image.ImageVersion.Major -eq 6 -and $image.ImageVersion.Minor -eq 0) {
        $virtioVer = "VISTA"
    } elseif ($image.ImageVersion.Major -eq 6 -and $image.ImageVersion.Minor -eq 1) {
        $virtioVer = "WIN7"
    } elseif (($image.ImageVersion.Major -eq 6 -and $image.ImageVersion.Minor -ge 2) `
        -or $image.ImageVersion.Major -gt 6) {
        $virtioVer = "WIN8"
    } else {
        throw "Unsupported Windows version for VirtIO drivers: {0}" `
            -f $image.ImageVersion
    }
    $virtioDir = "{0}\{1}\{2}" -f $driversBasePath, $virtioVer, $image.ImageArchitecture
    if (Test-Path $virtioDir) {
        AddDriversToImage $vhdDriveLetter $virtioDir
        return
    }
    $image
    # For VirtIO ISO with drivers version higher than 1.8.x
    if ($image.ImageVersion.Major -eq 6 -and $image.ImageVersion.Minor -eq 0) {
        $virtioVer = "2k8"
    } elseif ($image.ImageVersion.Major -eq 6 -and $image.ImageVersion.Minor -eq 1) {
        if ($image.ImageInstallationType -eq "Server") {
            $virtioVer = "2k8r2"
        } else {
            $virtioVer = "w7"
        }
    } elseif ($image.ImageVersion.Major -eq 6 -and $image.ImageVersion.Minor -eq 2) {
        if ($image.ImageInstallationType -eq "Server") {
            $virtioVer = "2k12"
        } else {
            $virtioVer = "w8"
        }
    } elseif (($image.ImageVersion.Major -eq 6 -and $image.ImageVersion.Minor -ge 3) `
        -or $image.ImageVersion.Major -gt 6) {
        if ($image.ImageInstallationType -eq "Server") {
            $virtioVer = "2k12R2"
        } else {
            $virtioVer = "w8.1"
        }
    } else {
        throw "Unsupported Windows version for VirtIO drivers: {0}" `
            -f $image.ImageVersion
    }
    $driversBasePath = "E:"
    $drivers = @("Balloon", "NetKVM", "viorng", "vioscsi", "vioserial", "viostor")
    foreach ($driver in $drivers) {
        $virtioDir = "{0}\{1}\{2}\{3}" -f $driversBasePath, $driver, $virtioVer, $image.ImageArchitecture
        if (Test-Path $virtioDir) {
            AddDriversToImage $vhdDriveLetter $virtioDir
        }
    }
}