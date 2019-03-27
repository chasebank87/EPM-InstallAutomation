#region variables

    $7zip = "C:\Program Files\7-Zip\7z.exe"
    $timestamp = Get-Date -Format MM-dd-yyyy-h:m:ss
    $computername = (Get-WmiObject Win32_ComputerSystem).name
    if($nodomain.IsPresent -eq $true){
    $fqdn = $computername
    } else {
    $domain = (Get-WmiObject Win32_ComputerSystem).Domain
    $fqdn = $computername + '.' + $domain
    }
    $downloads = @('https://www.dropbox.com/s/5ej05tpjw9ichzf/V37446-01.zip?dl=1','https://www.dropbox.com/s/xwjfw05q0xym9op/V74056-01.zip?dl=1','https://www.dropbox.com/s/l427dufp9qw61t0/V37380-01_1of2.zip?dl=1','https://www.dropbox.com/s/riy7jd6t4mlfi7u/V76569-01.zip?dl=1','https://www.dropbox.com/s/x53bpo7ldkoa6vh/V76567-01.zip?dl=1','https://www.dropbox.com/s/f5eqa4didqz56oh/V74050-01.zip?dl=1','https://www.dropbox.com/s/8p584d2ol4eas6l/V74044-01.zip?dl=1','https://www.dropbox.com/s/2dftueghujf50dg/V74037-01.zip?dl=1','https://www.dropbox.com/s/a4rqipidk3maf6a/V74031-01.zip?dl=1','https://www.dropbox.com/s/2kfotb5ovbpc2df/V74025-01.zip?dl=1','https://www.dropbox.com/s/5q41p4lz84sq5ph/V74019-01.zip?dl=1','https://www.dropbox.com/s/1djehovxmox6pza/V74016-01.zip?dl=1','https://www.dropbox.com/s/46qrz9x2gq8ictb/V74011-01.zip?dl=1','https://www.dropbox.com/s/stk1pbfpdq45tw2/V37380-01_2of2.zip?dl=1','https://www.dropbox.com/s/kr58y7vr5nfnuvp/V74108-01.zip?dl=1')
    $downloadHashs = @('D91D48640C1461879AA017E1B9BD24DD68F34CABA36D508BDC228680327F1D13','81428ED4B106ABA4E475244FE46D0568ADA85A112CCF7D2FAA2EA85724240779','0894407241F8F5E98C4E7FAA752D3FF51522BAC1CF9646F60D5F96F2AAA4B0C4','C48D7E4E71F8C2EB0A67A497A0CD6FBDD98F44902D022F9AFF81E7B12EB79381','9D98B1D666727CB915AAE9B5DF4E6AECF0EEEA88DE9A2D5DB2E615F048AD2380','59F11B27A382218A7AD9095F0927DC829E529B92071602693E93F35A4C11BA93','A11C1F64933BBEBA13FFC98C956CD7999868F837E136A31DE09E1B54B830CC55','6F122FF4D3508B094BB4C4F348F1A9B147415C3FBC99038098D7313C7EC4EFB7','FCAEFC2CDBB421382A14B3398F47E5BEF5A122CC43B9D70681911249B17CBA70','783A47240B322CB77529FA3B5220ADEBBBFA8BBEE0D7E8E231BD0699A940AFE5','97B67973DE863442A989F995E1E4ADC2AE202F6EDD3F44941C7AE6FE78DAA45B','8FDDC0039E3E6EBADD0D5E89AC523CC4F50A959A7F1BDC927F7FC9D2D95924DE','26528C31EED1B0F89CFCB7B6EC856E83D734B0125422D38702EE1BF34367415B','BDC10C2E72C162450D0CA47F477E3BF3B36A5E2C3C0D5A7B7043BA3908440ABD','DA286090345B18897B3081F937540A5BA13D021F77E15687B3C2B90F096DF6FE')
    $downloads900 = @('https://www.dropbox.com/s/xy5n29ywpa8b9v8/V975624-01.zip?dl=1','https://www.dropbox.com/s/e6anp88bakph29b/V975630-01.zip?dl=1','https://www.dropbox.com/s/ofh20ufgrhwnxjw/V975632-01.zip?dl=1','https://www.dropbox.com/s/qng5pb081r1gnzp/V975645-01.zip?dl=1','https://www.dropbox.com/s/4judcucayqsd2bz/V975647-01.zip?dl=1','https://www.dropbox.com/s/tvld1gmy47mslaq/V980741-01.zip?dl=1','https://www.dropbox.com/s/jw61cfcoz6ybx63/V975616-01.zip?dl=1','https://www.dropbox.com/s/csua5pb1wx1frfe/V74050-01.zip?dl=1','https://www.dropbox.com/s/xgn6k5u165ta7er/V74019-01.zip?dl=1')
    $downloadHashs900 = @('59F11B27A382218A7AD9095F0927DC829E529B92071602693E93F35A4C11BA93','97B67973DE863442A989F995E1E4ADC2AE202F6EDD3F44941C7AE6FE78DAA45B','307BB14B5493BAFF96121D9693D7A72F31EFC45E335DC970EC639B8D3AA613AA','EA46ED0BDF9FA5B162B9B936350EA02E5CD38DC279ABD4024FA5AE7BA4323247','492EEDF30908C70306EF6A1C713AE5F60468559070C3FA36BD40EA64EF928D16','820281CD337BD4352972DB1AEA0235A44C7B4D91699908D04E30F80EC0A7254F','1187F0C654F7575BC4EF59CD80BB5CC594749EDACC36820F48D7D508223C2215','E95DB0CA7FA8B7DD5351B71083CBE260E676D784A07E29F6B4258FD3EA950500','61D7054917DC7E04B7238E38C77049025DE6B636138167541CE47D8DBC007182')
    $choco = {Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))}
    $osVersion = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
    $ps2008 = "$($installerPath)\PS5\Win7AndW2K8R2-KB3191566-x64"
    $ps2012 = "$($installerPath)\PS5\Win8.1AndW2K12R2-KB3191564-x64.msu"
    $wusa = "$env:systemroot\SysWOW64\wusa.exe"
    $tempVerbose = "$($installerPath)\Temp\Verbose"
    $installFiles = @('foundation','essbase','raf','planning','disclosure','hfm','fdm','profit','fcm','tax','strategic','header','footer')
    $installFiles900 = @('foundation','essbase','fr','planning','disclosure','hfm','fdm','profit','fcm','tax','strategic','header','footer')

#endregion


