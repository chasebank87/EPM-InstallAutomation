#region set mainVariables and mainFunctions

    . 'C:\InstallAutomation\Variables\mainVariables.ps1'
    . 'C:\InstallAutomation\Functions\mainfunctions.ps1'

#endregion

#region install assembly

    Add-Type -AssemblyName PresentationFramework

#endregion

#region installer important info notice

    [System.Windows.MessageBox]::Show('Thank you for using the EPM silent installer/configuration utility. Please note the following requirments and limitations before continuing:
    
    Requirments:
    1. IIS, Netframework 3.5 must be installed as that feature has not beed added to the utility yet.
    2. You must be a local Administrator.
    3. UAC must be disabled.
    4. 7-zip must be installed. The utility will install for you but if you opt out of that feature the script will error out.
    
    Limitations:
    1. This utility should not be used on an environment that has already been configured.
    2. Oracle DB is currently not supported.
    3. 100% Customization is not currently supported. Only common settings can be configured (ex. database name, host, port, smtp, more..)
    4. SOA Products like Tax Management and Financial Close Manager are not supported.
    
    Click ok to continue..')

#endregion

#region look for current programs and hyperion

    $installedSoftware = Get-Software
    $7zipStatus = New-Object PSObject
    $7zipStatus | Add-Member -MemberType NoteProperty -Name Name -Value "7-Zip"
    $firefoxStatus = New-Object PSObject
    $firefoxStatus | Add-Member -MemberType NoteProperty -Name Name -Value "Firefox"
    $notepadStatus = New-Object PSObject
    $notepadStatus | Add-Member -MemberType NoteProperty -Name Name -Value "Notepad++"
    $epmStatus = New-Object PSObject
    $epmStatus | Add-Member -MemberType NoteProperty -Name Name -Value "Oracle EPM"
    foreach($i in $installedSoftware) {
        
        #look for 7zip
        if($i.DisplayName -like "*7-Zip*") {
            $7zipStatus | Add-Member -MemberType NoteProperty -Name Installed -Value $true
        }

        #look for firefox
        if($i.DisplayName -like "*Firefox*") {
            $firefoxStatus | Add-Member -MemberType NoteProperty -Name Installed -Value $true
        }

        #look for notepad++
        if($i.DisplayName -like "*Notepad++*") {
            $notepadStatus | Add-Member -MemberType NoteProperty -Name Installed -Value $true
        }

         #look for epm
        if($i.DisplayName -like "*Oracle EPM*") {
            $epmStatus | Add-Member -MemberType NoteProperty -Name Installed -Value $true
        }
    }

#endregion

#region prompt user

    $softwareStatus = @($7zipStatus,$firefoxStatus,$notepadStatus)
    foreach($j in $softwareStatus){
        if($j.installed -eq $true) {
            Write-Host "$($j.name) is already installed. Skipping.." -ForegroundColor Green
        }

        else {
            Write-Host "$($j.name) is not installed." -ForegroundColor Yellow
            while($break -eq $null){
                switch(Read-Host "Would you like me to install $($j.name) for you? Y or N"){
                    "Y" {
                        ""
                        $installFile = $j.name + 'Installer.exe'
                        Write-Host "Installing $($j.name).." -ForegroundColor Cyan
                        Start-Process -FilePath "$($installerPath)\Third Party\$($installFile)" -Wait
                        $break = 'break'
                    }
                    "N" {
                        ""
                        Write-Host "Skipping $($j.name).." -ForegroundColor Yellow
                        $break = 'break'
                    }
                    Default {
                        ""
                        Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                    }
                }
            }
        }
        Clear-Variable break
    }

    Clear-Variable break

    if($epmStatus.installed -eq $true){
        Write-Host "$($epmStatus.name) is already installed. Skipping.." -ForegroundColor Green
        while($break -eq $null){
            switch(Read-Host "EPM is already installed. Would you like to configure EPM? Y or N"){
                "Y" {
                    ""
                    Write-Host "Starting $($epmStatus.name).. configuration procedure" -ForegroundColor Cyan
                    Invoke-Expression -Command "$($installerPath)/Powershell/configure.ps1"
                    $break = 'break'
                }
                "N" {
                    ""
                    Write-Host "Skipping $($epmStatus.name) configuration.." -ForegroundColor Yellow
                    $break = 'break'
                }
                Default {
                    ""
                    Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                }
            }
        }
        Clear-Variable break
    }
    else {
        Write-Host "$($epmStatus.name) is not installed." -ForegroundColor Yellow
        while($break -eq $null){
            switch(Read-Host "Would you like me to install $($epmStatus.name) for you? Y or N"){
                "Y" {
                    ""
                    Write-Host "Starting $($epmStatus.name) installation procedure.." -ForegroundColor Cyan
                    Invoke-Expression -Command "$($installerPath)/Powershell/install.ps1"
                    $break = 'break'
                }
                "N" {
                    ""
                    Write-Host "Skipping $($epmStatus.name) installation.." -ForegroundColor Yellow
                    $break = 'break'
                }
                Default {
                    ""
                    Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                }
            }
        }
        }

#endregion

#region cleanup variables

    Clear-Variable 7zipStatus,firefoxStatus,notepadStatus,epmStatus,break

#endregion
