$arguments = "--install `"${env:ProgramFiles}\AnyDesk`" --silent --remove-first --create-shortcuts"
function Download-Anydesk
{
    try{
        $tmpfile = ""
        $tmpfile = [System.IO.Path]::GetTempFileName()
        $url = "https://download.anydesk.com/AnyDesk.exe"
        Invoke-WebRequest -Uri $url -SkipCertificateCheck -OutFile $tmpfile
        Unblock-File -Path $tmpfile -ErrorAction Stop
        $exefile = Join-Path -Path (Split-Path -Path $tmpfile -Parent) -ChildPath 'AnyDesk.exe'
        if (Test-Path $exefile) {
            Remove-Item $exefile
        }
        $tmpfile | Rename-Item -NewName 'AnyDesk.exe' -Force -ErrorAction Stop
    }
    catch{
        Throw "Something went wrong $($_.Exception.Message)"
    }
return $exefile
}

$Filename = Download-Anydesk
Start-Process -FilePath $Filename -ArgumentList $arguments -Wait
