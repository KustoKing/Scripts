# Code to trust all certificates
add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[System.Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
$arguments = "--install `"${env:ProgramFiles}\AnyDesk`" --silent --remove-first --create-shortcuts"
function Download-Anydesk
{
    try{
        $tmpfile = ""
        $tmpfile = [System.IO.Path]::GetTempFileName()
        $url = "https://download.anydesk.com/AnyDesk.exe"
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($url, $tmpfile)
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
