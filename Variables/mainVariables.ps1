#region variables

    $7zip = "C:\Program Files\7-Zip\7z.exe"
    $timestamp = Get-Date -Format MM-dd-yyyy-h:m:ss
    $computername = (Get-WmiObject Win32_ComputerSystem).name
    $domain = (Get-WmiObject Win32_ComputerSystem).Domain
    $fqdn = $computername + '.' + $domain
    $downloads = @('https://www.dropbox.com/s/5ej05tpjw9ichzf/V37446-01.zip?dl=1','https://www.dropbox.com/s/xwjfw05q0xym9op/V74056-01.zip?dl=1','https://www.dropbox.com/s/l427dufp9qw61t0/V37380-01_1of2.zip?dl=1','https://www.dropbox.com/s/riy7jd6t4mlfi7u/V76569-01.zip?dl=1','https://www.dropbox.com/s/x53bpo7ldkoa6vh/V76567-01.zip?dl=1','https://www.dropbox.com/s/f5eqa4didqz56oh/V74050-01.zip?dl=1','https://www.dropbox.com/s/8p584d2ol4eas6l/V74044-01.zip?dl=1','https://www.dropbox.com/s/2dftueghujf50dg/V74037-01.zip?dl=1','https://www.dropbox.com/s/a4rqipidk3maf6a/V74031-01.zip?dl=1','https://www.dropbox.com/s/2kfotb5ovbpc2df/V74025-01.zip?dl=1','https://www.dropbox.com/s/5q41p4lz84sq5ph/V74019-01.zip?dl=1','https://www.dropbox.com/s/1djehovxmox6pza/V74016-01.zip?dl=1','https://www.dropbox.com/s/46qrz9x2gq8ictb/V74011-01.zip?dl=1','https://www.dropbox.com/s/stk1pbfpdq45tw2/V37380-01_2of2.zip?dl=1','https://www.dropbox.com/s/kr58y7vr5nfnuvp/V74108-01.zip?dl=1')
    $downloadHashs = @('D91D48640C1461879AA017E1B9BD24DD68F34CABA36D508BDC228680327F1D13','81428ED4B106ABA4E475244FE46D0568ADA85A112CCF7D2FAA2EA85724240779','0894407241F8F5E98C4E7FAA752D3FF51522BAC1CF9646F60D5F96F2AAA4B0C4','C48D7E4E71F8C2EB0A67A497A0CD6FBDD98F44902D022F9AFF81E7B12EB79381','9D98B1D666727CB915AAE9B5DF4E6AECF0EEEA88DE9A2D5DB2E615F048AD2380','59F11B27A382218A7AD9095F0927DC829E529B92071602693E93F35A4C11BA93','A11C1F64933BBEBA13FFC98C956CD7999868F837E136A31DE09E1B54B830CC55','6F122FF4D3508B094BB4C4F348F1A9B147415C3FBC99038098D7313C7EC4EFB7','FCAEFC2CDBB421382A14B3398F47E5BEF5A122CC43B9D70681911249B17CBA70','783A47240B322CB77529FA3B5220ADEBBBFA8BBEE0D7E8E231BD0699A940AFE5','97B67973DE863442A989F995E1E4ADC2AE202F6EDD3F44941C7AE6FE78DAA45B','8FDDC0039E3E6EBADD0D5E89AC523CC4F50A959A7F1BDC927F7FC9D2D95924DE','26528C31EED1B0F89CFCB7B6EC856E83D734B0125422D38702EE1BF34367415B','BDC10C2E72C162450D0CA47F477E3BF3B36A5E2C3C0D5A7B7043BA3908440ABD','DA286090345B18897B3081F937540A5BA13D021F77E15687B3C2B90F096DF6FE')
    $choco = {Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))}
    $osVersion = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
    $ps2008 = "$($installerPath)\PS5\Install-WMF5.1.ps1"
    $ps2012 = "$($installerPath)\PS5\Win8.1AndW2K12R2-KB3191564-x64.msu"
    $wusa = "$env:systemroot\SysWOW64\wusa.exe"
    $tempVerbose = "$($installerPath)\Temp\Verbose"

#endregion


