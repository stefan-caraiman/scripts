function AddDriversToImage($winImagePath, $driversPath)
{
    Write-Output ('Adding drivers from "{0}" to image "{1}"' -f $driversPath, $winImagePath)
    pnputil.exe -i -a $driversPath\*.inf
    #& Dism.exe /image:${winImagePath} /Add-Driver /driver:${driversPath} /ForceUnsigned /recurse
    #if ($LASTEXITCODE) { throw "Dism failed to add drivers from: $driversPath" }
}
function Add-VirtIODrivers($vhdDriveLetter = "C:", $image = "D:", $driversBasePath = "E:")
{
    $virtioVer = "w8.1"
    $driversBasePath = "E:"
    $i = $ENV:PROCESSOR_ARCHITECTURE
    $drivers = @("Balloon", "NetKVM", "viorng", "vioscsi", "vioserial", "viostor")
    foreach ($driver in $drivers) {
        $virtioDir = "{0}\{1}\{2}\{3}" -f $driversBasePath, $driver, $virtioVer, $i
        if (Test-Path $virtioDir) {
            AddDriversToImage $vhdDriveLetter $virtioDir
        }
    }
}
Add-VirtIODrivers
