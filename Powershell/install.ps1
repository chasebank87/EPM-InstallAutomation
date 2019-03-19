﻿#region set mainVariables and mainFunctions

    . "$($installerPath)\Variables\mainVariables"
    . "$($installerPath)\Functions\mainfunctions.ps1"

#endregion

#region look for zip files and unzip
    if(!$superSilentInstall -or $superSilentInstall -eq $false){
        if($break){Clear-Variable break}
        while($break -ne 'break'){
            Write-Host "Looking for installation files"
            $expectedInstallationFiles = @('V37380-01_1of2.zip','V37380-01_2of2.zip','V37446-01.zip','V74011-01.zip','V74016-01.zip','V74019-01.zip','V74025-01.zip','V74031-01.zip','V74037-01.zip','V74044-01.zip','V74050-01.zip','V74056-01.zip','V74108-01.zip','V76567-01.zip','V76569-01.zip')
            $installationFileAvailability = @()
            $installationFailures = 0
            $installationFiles = Get-ChildItem -Path "$($installerPath)\EPM"
            foreach($i in $expectedInstallationFiles){
                if($i -in $installationFiles.name) {
                    $newObject = New-Object -TypeName PSObject
                    $newObject | Add-Member -type NoteProperty -name Name -Value $i
                    $newObject | Add-Member -type NoteProperty -name Available -Value $true
                    $installationFileAvailability += $newObject
                }
                else {
                    $newObject = New-Object -TypeName PSObject
                    $newObject | Add-Member -type NoteProperty -name Name -Value $i
                    $newObject | Add-Member -type NoteProperty -name Available -Value $false 
                    $installationFileAvailability += $newObject           
                }
            }

            foreach($i in $installationFileAvailability){
                Write-Host "Looking for $($i.name)" -ForegroundColor Cyan
                Sleep -Seconds 1.5
                if($i.available -eq $true){
                    Write-Host "OK" -ForegroundColor Green
                }
                else {
                    $installationFailures++
                    Write-Host "NOT FOUND" -ForegroundColor Red
                    While($break -eq $null){
                        Switch($downloadFile = Read-Host "Would you like me to download $($i.name) for you? Y or N"){
                            "Y" {
                                ""
                                Write-Host "Downloading $($i.name).." -ForegroundColor Cyan
                                $fileToDownload = $downloads | Where-Object -FilterScript { $_ -like "*$($i.name)*" }
                                $ProgressPreference = 'SilentlyContinue'
                                #wget $fileToDownload -OutFile "$($installerPath)\EPM\$($i.name)" -Verbose
                                (New-Object System.Net.WebClient).DownloadFile($fileToDownload, "$($installerPath)\EPM\$($i.name)")
                                $ProgressPreference = 'Continue'
                                $downloadedFileHash = Get-FileHash -Path "$($installerPath)\EPM\$($i.name)"
                                if($downloadedFileHash.hash -notin $downloadHashs){
                                    Write-Host "Downloaded file hash not found. Terminating." -ForegroundColor Red
                                    Read-Host "Cleck enter to exit.."
                                    Exit
                                }
                                else{
                                    Write-Host "Downloaded file hash matches hash array. Continuing.." -ForegroundColor Green
                                    $installationFailures--
                                }
                                $break = 'break'
                            }
                            "N" {
                                Write-Host "Skipping $($i.name).." -ForegroundColor Yellow
                                $break = 'break'
                            }
                            Default {
                                Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                            }
                        }
                    }
                }
                if($break){Clear-Variable break}
            }
            if($break){Clear-Variable break}
            Write-Host ""
            Write-Host ""
            if($installatioNFailures -gt 0){
                Write-Host "Please download the missing files and place them in the EPM folder." -ForegroundColor Yellow
                Read-Host "Click Enter when the missing files have been placed in the EPM folder."
            }
            elseif($installationFailures -eq 0) {
                Write-Host "All install files are available. Continuing to Install." -ForegroundColor Green
                $break = 'break'
            }
        }

        $testUnzipDest = Test-Path "$($installerPath)\EPM\Unzipped\"
        if($testUnzipDest -eq $true){
            Remove-Item -Path "$($installerPath)\EPM\Unzipped\" -Recurse -Force
        }
 
        try{
                Write-Host "Unzipping Install Files.  This may take a few minutes." -ForegroundColor Cyan
                $7zipProcess = Start-Process -FilePath """$($7zip)""" -ArgumentList "x ""$($installerPath)\EPM\*.zip"" -y -o""$($installerPath)\EPM\Unzipped\""" -WindowStyle Hidden -passthru
            }
        Catch {
                $_ | Out-File "$($installerPath)\Logs\Unzip.Error.log" -Append
            }

        if($7zipProcess) {
            While((get-process -id $7zipProcess.id -ErrorAction SilentlyContinue) -ne $null){
                $unzippedFiles = Get-ChildItem -Path "$($installerPath)\EPM\Unzipped\" -Recurse -ErrorAction SilentlyContinue
                $unzippedFilesSize = "{0:N2}" -f ((Get-ChildItem "$($installerPath)\EPM\Unzipped\" -Recurse  -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
                $unzippedFilesSizeCompPercent = 100 /  19733.84 * [int]$unzippedFilesSize
                $unzippedFilesSizeCompPercent = [math]::floor($unzippedFilesSizeCompPercent)
                $unzipCompPercent = ((100 / 29880 * $unzippedFiles.count) + $unzippedFilesSizeCompPercent) / 2
                $unzipCompPercent = [math]::floor($unzipCompPercent) 
                Write-Host "Unzipping.. $($unzipCompPercent)% Completed." -ForegroundColor Cyan
                Sleep -Seconds 15
            }
         }
     } elseif($superSilentInstall -and $superSilentInstall -eq $true) {
        Write-Host "Looking for installation files"
        $expectedInstallationFiles = @('V37380-01_1of2.zip','V37380-01_2of2.zip','V37446-01.zip','V74011-01.zip','V74016-01.zip','V74019-01.zip','V74025-01.zip','V74031-01.zip','V74037-01.zip','V74044-01.zip','V74050-01.zip','V74056-01.zip','V74108-01.zip','V76567-01.zip','V76569-01.zip')
        $installationFileAvailability = @()
        $installationFailures = 0
        $installationFiles = Get-ChildItem -Path "$($installerPath)\EPM"
        foreach($i in $expectedInstallationFiles){
            if($i -in $installationFiles.name) {
                $newObject = New-Object -TypeName PSObject
                $newObject | Add-Member -type NoteProperty -name Name -Value $i
                $newObject | Add-Member -type NoteProperty -name Available -Value $true
                $installationFileAvailability += $newObject
            }
            else {
                $newObject = New-Object -TypeName PSObject
                $newObject | Add-Member -type NoteProperty -name Name -Value $i
                $newObject | Add-Member -type NoteProperty -name Available -Value $false 
                $installationFileAvailability += $newObject           
            }
        }
        foreach($i in $installationFileAvailability){
            Write-Host "Looking for $($i.name)" -ForegroundColor Cyan
            Sleep -Seconds 1.5
            if($i.available -eq $true){
                Write-Host "OK" -ForegroundColor Green
            }
            else {
                $installationFailures++
                Write-Host "NOT FOUND" -ForegroundColor Red
                Write-Host "Downloading $($i.name).." -ForegroundColor Cyan
                $fileToDownload = $downloads | Where-Object -FilterScript { $_ -like "*$($i.name)*" }
                $ProgressPreference = 'SilentlyContinue'
                #wget $fileToDownload -OutFile "$($installerPath)\EPM\$($i.name)" -Verbose
                (New-Object System.Net.WebClient).DownloadFile($fileToDownload, "$($installerPath)\EPM\$($i.name)")
                $ProgressPreference = 'Continue'
                $downloadedFileHash = Get-FileHash -Path "$($installerPath)\EPM\$($i.name)"
                if($downloadedFileHash.hash -notin $downloadHashs){
                    Write-Host "Downloaded file hash not found. Terminating." -ForegroundColor Red
                    Read-Host "Cleck enter to exit.."
                    Exit
                }
                else{
                    Write-Host "Downloaded file hash matches hash array. Continuing.." -ForegroundColor Green
                    $installationFailures--
                }
            }

            if($break){Clear-Variable break}
            Write-Host ""
            Write-Host ""
            if($installatioNFailures -gt 0){
                Write-Host "Please download the missing files and place them in the EPM folder." -ForegroundColor Yellow
                Read-Host "Click Enter when the missing files have been placed in the EPM folder."
            }
            elseif($installationFailures -eq 0) {
                #Write-Host "All install files are available. Continuing to Install." -ForegroundColor Green
                $break = 'break'
            }
        }

        $testUnzipDest = Test-Path "$($installerPath)\EPM\Unzipped\"
        if($testUnzipDest -eq $true){
            Remove-Item -Path "$($installerPath)\EPM\Unzipped\" -Recurse -Force
        }
 
        try{
                Write-Host "Unzipping Install Files.  This may take a few minutes." -ForegroundColor Cyan
                $7zipProcess = Start-Process -FilePath """$($7zip)""" -ArgumentList "x ""$($installerPath)\EPM\*.zip"" -y -o""$($installerPath)\EPM\Unzipped\""" -WindowStyle Hidden -passthru
            }
        Catch {
                $_ | Out-File "$($installerPath)\Logs\Unzip.Error.log" -Append
            }

        if($7zipProcess) {
            While((get-process -id $7zipProcess.id -ErrorAction SilentlyContinue) -ne $null){
                $unzippedFiles = Get-ChildItem -Path "$($installerPath)\EPM\Unzipped\" -Recurse -ErrorAction SilentlyContinue
                $unzippedFilesSize = "{0:N2}" -f ((Get-ChildItem "$($installerPath)\EPM\Unzipped\" -Recurse  -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
                $unzippedFilesSizeCompPercent = 100 /  19733.84 * [int]$unzippedFilesSize
                $unzippedFilesSizeCompPercent = [math]::floor($unzippedFilesSizeCompPercent)
                $unzipCompPercent = ((100 / 29880 * $unzippedFiles.count) + $unzippedFilesSizeCompPercent) / 2
                $unzipCompPercent = [math]::floor($unzipCompPercent) 
                Write-Host "Unzipping.. $($unzipCompPercent)% Completed." -ForegroundColor Cyan
                Sleep -Seconds 15
            }
         }
    }
#endregion

#region start epm install

    if(!$superSilentInstall -or $superSilentInstall -eq $false){
        if($break){Clear-Variable break}
        while($break -ne 'break'){
            $epmInstallPath = Read-Host "Please type the path where you want to install EPM. Example: C:\Oracle\Middleware"
            if(($epmInstallPath.Length - 1) -eq '\'){
               $epmInstallPath =  $epmInstallPath.TrimEnd()
            }
            $testEPMInstallPath = Test-Path -Path $epmInstallPath.Substring(0,3)
            $testEPMInstallPathChildren = Get-ChildItem $epmInstallPath -ErrorAction SilentlyContinue
            if($testEPMInstallPath -eq $false) {
                Write-Host "Invalid Path. Try again." -ForegroundColor Red
            }
            else{
                Write-Host "Valid Path. Continuing." -ForegroundColor Green
                $break = 'break'
            }
            if($testEPMInstallPathChildren.count -gt 0 ) {
                Write-Host "Path contains files. Cannot Continue." -ForegroundColor Red
                Read-Host "Press enter to exit."
                Exit
            } 
            else {
                Write-Host "Path is ready to be used. Continuing." -ForegroundColor Green
                $break = 'break'
            }
        }

        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install Foundation?"
        #Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding Foundation to Install List" -ForegroundColor Green
                    Write-Host ""
					$inputFoundation = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\foundation" -Raw
					$inputFoundation = $ExecutionContext.InvokeCommand.ExpandString($inputFoundation)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping Foundation Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputFoundation = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install Essbase?"
        #Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding Essbase to Install List" -ForegroundColor Green
                    Write-Host ""
					$inputEssbase = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\essbase" -Raw
					$inputEssbase = $ExecutionContext.InvokeCommand.ExpandString($inputEssbase)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping Essbase Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputEssbase = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install Reporting"
        Write-Host "and Analysis Framework?"
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding Reporting anto Install List" -ForegroundColor Green
                    Write-Host ""
					$inputRAF = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\raf" -Raw
					$inputRAF = $ExecutionContext.InvokeCommand.ExpandString($inputRAF)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping Reporting Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputRAF = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install Planning?"
        #Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding Planning to Install List" -ForegroundColor Green
                    Write-Host ""
                    $inputPlanning = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\planning" -Raw
					$inputPlanning = $ExecutionContext.InvokeCommand.ExpandString($inputPlanning)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping Planning Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputPlanning = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install Disclosure?"
        #Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding Disclosure to Install List" -ForegroundColor Green
                    Write-Host ""
					$inputDisclosure = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\disclosure" -Raw
					$inputDisclosure = $ExecutionContext.InvokeCommand.ExpandString($inputDisclosure)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping Disclosure Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputDisclosure = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install HFM?"
        #Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding HFM to Install List" -ForegroundColor Green
                    Write-Host ""
					$inputHFM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\hfm" -Raw
					$inputHFM = $ExecutionContext.InvokeCommand.ExpandString($inputHFM)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping HFM Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputHFM = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install FDM?"
        #Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding FDM to Install List" -ForegroundColor Green
                    Write-Host ""
					$inputFDM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\fdm" -Raw
					$inputFDM = $ExecutionContext.InvokeCommand.ExpandString($inputFDM)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping FDM Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputFDM = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install Profit?"
        #Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding Profit to Install List" -ForegroundColor Green
                    Write-Host ""
					$inputProfit = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\profit" -Raw
					$inputProfit = $ExecutionContext.InvokeCommand.ExpandString($inputProfit)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping Profit Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputProfit = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install Financial Close"
        Write-Host "Management?"
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding Financial Close to Install List" -ForegroundColor Green
                    Write-Host ""
					$inputFCC = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\fcm" -Raw
					$inputFCC = $ExecutionContext.InvokeCommand.ExpandString($inputFCC)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping Financial Close Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputFCC = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install Tax Management?"
        #Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding Tax Management to Install List" -ForegroundColor Green
                    Write-Host ""
					$inputTax = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\tax" -Raw
					$inputTax = $ExecutionContext.InvokeCommand.ExpandString($inputTax)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping Tax Management Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputTax = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}

    
        #getting products to install
        Write-Host "============= EPM Modules =============="
        Write-Host "Would you like to install Strategic Finance?"
        #Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "========================================"
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Adding Strategic Finance to Install List" -ForegroundColor Green
                    Write-Host ""
					$inputHSF = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\hsf" -Raw
					$inputHSF = $ExecutionContext.InvokeCommand.ExpandString($inputHSF)
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Skipping Strategic Finance Install" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputHSF = ''
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
        if($break){Clear-Variable break}
    } elseif($superSilentInstall -and $superSilentInstall -eq $true){
        if($standalone -eq $true){
		Write-Host "Starting Standalone Install" -ForegroundColor cyan
            if($installFoundation -eq $true -and $remoteDeployment -ne $true){
                Write-Host "Adding Foundation to Install List" -ForegroundColor Green
                $inputFoundation = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\foundation" -Raw
			    $inputFoundation = $ExecutionContext.InvokeCommand.ExpandString($inputFoundation)
            } elseif($installFoundation -eq $true -and $remoteDeployment -eq $true) {
			    Write-Host "Adding Foundation Remote Deployment to Install List" -ForegroundColor Green
			    $inputFoundation = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\foundationRemoteDeployment" -Raw
			    $inputFoundation = $ExecutionContext.InvokeCommand.ExpandString($inputFoundation)
		    }
            if($installEssbase -eq $true){
                Write-Host "Adding Essbase to Install List" -ForegroundColor Green
			    $inputEssbase = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\essbase" -Raw
			    $inputEssbase = $ExecutionContext.InvokeCommand.ExpandString($inputEssbase)
            }
            if($installRAF -eq $true){
                Write-Host "Adding Reporting to Install List" -ForegroundColor Green
			    $inputRAF = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\raf" -Raw
			    $inputRAF = $ExecutionContext.InvokeCommand.ExpandString($inputRAF)
            }
            if($installPlanning -eq $true){
                Write-Host "Adding Planning to Install List" -ForegroundColor Green
			    $inputPlanning = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\planning" -Raw
			    $inputPlanning = $ExecutionContext.InvokeCommand.ExpandString($inputPlanning)
            }
            if($installDisclosure -eq $true){
                Write-Host "Adding Disclosure to Install List" -ForegroundColor Green
			    $inputDisclosure = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\disclosure" -Raw
			    $inputDisclosure = $ExecutionContext.InvokeCommand.ExpandString($inputDisclosure)
            }
            if($installHFM -eq $true){
                Write-Host "Adding HFM to Install List" -ForegroundColor Green
			    $inputHFM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\hfm" -Raw
			    $inputHFM = $ExecutionContext.InvokeCommand.ExpandString($inputHFM)
            }
            if($installFDM -eq $true){
                Write-Host "Adding FDM to Install List" -ForegroundColor Green
			    $inputFDM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\fdm" -Raw
			    $inputFDM = $ExecutionContext.InvokeCommand.ExpandString($inputFDM)
            }
            if($installProfit -eq $true){
                Write-Host "Adding Profit to Install List" -ForegroundColor Green
			    $inputProfit = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\profit" -Raw
			    $inputProfit = $ExecutionContext.InvokeCommand.ExpandString($inputProfit)
            }
            if($installFCM -eq $true){
                Write-Host "Adding Financial Close to Install List" -ForegroundColor Green
			    $inputFCC = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\fcm" -Raw
			    $inputFCC = $ExecutionContext.InvokeCommand.ExpandString($inputFCC)
            }
            if($installTax -eq $true){
                Write-Host "Adding Tax Management to Install List" -ForegroundColor Green
			    $inputTax = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\tax" -Raw
			    $inputTax = $ExecutionContext.InvokeCommand.ExpandString($inputTax)
            }
            if($installStrategic -eq $true){
                Write-Host "Adding Strategic Finance to Install List" -ForegroundColor Green
			    $inputHSF = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\hsf" -Raw
			    $inputHSF = $ExecutionContext.InvokeCommand.ExpandString($inputHSF)
            }
            if($epmPath){
                $epmInstallPath = $epmPath
            }

        } else {
            if($remoteDeployment -ne $true){
	    	Write-Host "Starting Distributed Central Install" -ForegroundColor cyan
                if($installFoundation -eq $true -and $remoteDeployment -ne $true){
                    Write-Host "Adding Foundation to Install List" -ForegroundColor Green
                    $inputFoundation = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\foundation" -Raw
			        $inputFoundation = $ExecutionContext.InvokeCommand.ExpandString($inputFoundation)
                } elseif($installFoundation -eq $true -and $remoteDeployment -eq $true) {
			        Write-Host "Adding Foundation Remote Deployment to Install List" -ForegroundColor Green
			        $inputFoundation = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\foundation" -Raw
			        $inputFoundation = $ExecutionContext.InvokeCommand.ExpandString($inputFoundation)
		        }
                if($installEssbase -eq $true -and $distributedEssbase -eq $true){
                    Write-Host "Adding Essbase Distributed to Install List" -ForegroundColor Green
			        $inputEssbase = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\essbase" -Raw
			        $inputEssbase = $ExecutionContext.InvokeCommand.ExpandString($inputEssbase)
                } elseif($installEssbase -eq $true -and $distributedEssbase -ne $true){
                    Write-Host "Adding Essbase Standalone to Install List" -ForegroundColor Green
			        $inputEssbase = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\essbase" -Raw
			        $inputEssbase = $ExecutionContext.InvokeCommand.ExpandString($inputEssbase)
                }
                if($installRAF -eq $true){
                    Write-Host "Adding Reporting anto Install List" -ForegroundColor Green
			        $inputRAF = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\raf" -Raw
			        $inputRAF = $ExecutionContext.InvokeCommand.ExpandString($inputRAF)
                }
                if($installPlanning -eq $true -and $distributedPlanning -eq $true){
                    Write-Host "Adding Planning Distributed to Install List" -ForegroundColor Green
			        $inputPlanning = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\planning" -Raw
			        $inputPlanning = $ExecutionContext.InvokeCommand.ExpandString($inputPlanning)
                } elseif($installPlanning -eq $true -and $distributedPlanning -ne $true){
                    Write-Host "Adding Planning Standalone to Install List" -ForegroundColor Green
			        $inputPlanning = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\planning" -Raw
			        $inputPlanning = $ExecutionContext.InvokeCommand.ExpandString($inputPlanning)
                }
                if($installDisclosure -eq $true){
                    Write-Host "Adding Disclosure to Install List" -ForegroundColor Green
			        $inputDisclosure = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\disclosure" -Raw
			        $inputDisclosure = $ExecutionContext.InvokeCommand.ExpandString($inputDisclosure)
                }
                if($installHFM -eq $true -and $distributedHFM -eq $true){
                    Write-Host "Adding HFM Distributed to Install List" -ForegroundColor Green
			        $inputHFM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\hfm" -Raw
			        $inputHFM = $ExecutionContext.InvokeCommand.ExpandString($inputHFM)
                } elseif($installHFM -eq $true -and $distributedHFM -ne $true){
                    Write-Host "Adding HFM Standalone to Install List" -ForegroundColor Green
			        $inputHFM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\hfm" -Raw
			        $inputHFM = $ExecutionContext.InvokeCommand.ExpandString($inputHFM)
                }
                if($installFDM -eq $true -and $distributedFDM -eq $true){
                    Write-Host "Adding FDM Distributed to Install List" -ForegroundColor Green
			        $inputFDM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\fdm" -Raw
			        $inputFDM = $ExecutionContext.InvokeCommand.ExpandString($inputFDM)
                } elseif($installFDM -eq $true -and $distributedFDM -ne $true){
                    Write-Host "Adding FDM Standalone to Install List" -ForegroundColor Green
			        $inputFDM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\fdm" -Raw
			        $inputFDM = $ExecutionContext.InvokeCommand.ExpandString($inputFDM)                    
                }
                if($installProfit -eq $true){
                    Write-Host "Adding Profit to Install List" -ForegroundColor Green
			        $inputProfit = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\profit" -Raw
			        $inputProfit = $ExecutionContext.InvokeCommand.ExpandString($inputProfit)
                }
                if($installFCM -eq $true){
                    Write-Host "Adding Financial Close to Install List" -ForegroundColor Green
			        $inputFCC = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\fcm" -Raw
			        $inputFCC = $ExecutionContext.InvokeCommand.ExpandString($inputFCC)
                }
                if($installTax -eq $true){
                    Write-Host "Adding Tax Management to Install List" -ForegroundColor Green
			        $inputTax = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\tax" -Raw
			        $inputTax = $ExecutionContext.InvokeCommand.ExpandString($inputTax)
                }
                if($installStrategic -eq $true){
                    Write-Host "Adding Strategic Finance to Install List" -ForegroundColor Green
			        $inputHSF = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\hsf" -Raw
			        $inputHSF = $ExecutionContext.InvokeCommand.ExpandString($inputHSF)
                }
                if($epmPath){
                    $epmInstallPath = $epmPath
                }
            } else {
	    	Write-Host "Starting Distributed Remote Install" -ForegroundColor cyan
                if($installFoundation -eq $true -and $remoteDeployment -ne $true){
                    Write-Host "Adding Foundation to Install List" -ForegroundColor Green
                    $inputFoundation = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Central\foundation" -Raw
			        $inputFoundation = $ExecutionContext.InvokeCommand.ExpandString($inputFoundation)
                } elseif($installFoundation -eq $true -and $remoteDeployment -eq $true) {
			        Write-Host "Adding Foundation Remote Deployment to Install List" -ForegroundColor Green
			        $inputFoundation = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\foundation" -Raw
			        $inputFoundation = $ExecutionContext.InvokeCommand.ExpandString($inputFoundation)
		        }
                if($installEssbase -eq $true){
                    Write-Host "Adding Essbase to Install List" -ForegroundColor Green
			        $inputEssbase = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\essbase" -Raw
			        $inputEssbase = $ExecutionContext.InvokeCommand.ExpandString($inputEssbase)
                }
                if($installRAF -eq $true){
                    Write-Host "Adding Reporting anto Install List" -ForegroundColor Green
			        $inputRAF = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\raf" -Raw
			        $inputRAF = $ExecutionContext.InvokeCommand.ExpandString($inputRAF)
                }
                if($installPlanning -eq $true){
                    Write-Host "Adding Planning to Install List" -ForegroundColor Green
			        $inputPlanning = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\planning" -Raw
			        $inputPlanning = $ExecutionContext.InvokeCommand.ExpandString($inputPlanning)
                }
                if($installDisclosure -eq $true){
                    Write-Host "Adding Disclosure to Install List" -ForegroundColor Green
			        $inputDisclosure = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\disclosure" -Raw
			        $inputDisclosure = $ExecutionContext.InvokeCommand.ExpandString($inputDisclosure)
                }
                if($installHFM -eq $true){
                    Write-Host "Adding HFM to Install List" -ForegroundColor Green
			        $inputHFM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\hfm" -Raw
			        $inputHFM = $ExecutionContext.InvokeCommand.ExpandString($inputHFM)
                }
                if($installFDM -eq $true){
                    Write-Host "Adding FDM to Install List" -ForegroundColor Green
			        $inputFDM = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\fdm" -Raw
			        $inputFDM = $ExecutionContext.InvokeCommand.ExpandString($inputFDM)
                }
                if($installProfit -eq $true){
                    Write-Host "Adding Profit to Install List" -ForegroundColor Green
			        $inputProfit = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\profit" -Raw
			        $inputProfit = $ExecutionContext.InvokeCommand.ExpandString($inputProfit)
                }
                if($installFCM -eq $true){
                    Write-Host "Adding Financial Close to Install List" -ForegroundColor Green
			        $inputFCC = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\fcm" -Raw
			        $inputFCC = $ExecutionContext.InvokeCommand.ExpandString($inputFCC)
                }
                if($installTax -eq $true){
                    Write-Host "Adding Tax Management to Install List" -ForegroundColor Green
			        $inputTax = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\tax" -Raw
			        $inputTax = $ExecutionContext.InvokeCommand.ExpandString($inputTax)
                }
                if($installStrategic -eq $true){
                    Write-Host "Adding Strategic Finance to Install List" -ForegroundColor Green
			        $inputHSF = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Distributed\Remote\hsf" -Raw
			        $inputHSF = $ExecutionContext.InvokeCommand.ExpandString($inputHSF)
                }
                if($epmPath){
                    $epmInstallPath = $epmPath
                }
            }
        }

    }
	
	$inputHeader = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\header" -Raw
    $inputHeader = $ExecutionContext.InvokeCommand.ExpandString($inputHeader)
	$inputFooter = Get-Content -Path "$($installerPath)\Variables\Property Files\Install\Standalone\footer" -Raw
    $inputFooter = $ExecutionContext.InvokeCommand.ExpandString($inputFooter)
	
	
	if($remoteDeployment -eq $true){
		$data = "$($inputHeader)
		$($inputFoundation)
		$($inputessbase)
		$($inputraf)
		$($inputFCC)
		$($inputTax)
		$($inputHSF)
		$($inputplanning)
		$($inputdisclosure)
		$($inputhfm)
		$($inputfdm)
		$($inputprofit)
		$($inputFooter)"
	} else {
		$data = "$($inputHeader)
		$($inputFoundation)
		$($inputessbase)
		$($inputraf)
		$($inputFCC)
		$($inputTax)
		$($inputHSF)
		$($inputplanning)
		$($inputdisclosure)
		$($inputhfm)
		$($inputfdm)
		$($inputprofit)
		$($inputFooter)" 
	}
    
    $data | Out-File "$($installerPath)\Temp\silentInstall" -Encoding utf8
    $silentInstallFile = Get-Content "$($installerPath)\Temp\silentInstall"
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines("$($installerPath)\Temp\silentInstall", $silentInstallFile, $Utf8NoBomEncoding)

    try {
    Write-Host "Installing EPM. This may take 10 - 20 Minutes." -ForegroundColor Cyan
    $epmInstallProcess = Start-Process -FilePath "$($installerPath)\EPM\Unzipped\installTool.cmd" -ArgumentList "-silent $($installerPath)\Temp\silentInstall" -Verb RunAs -Wait
    }
    catch {
        $_ | Out-File "$($installerPath)\Logs\installTool.Error.log" -Append
        Get-Content "$($installerPath)\Logs\installTool.Error.log" | Write-Host -ForegroundColor Red
        Read-Host "Click enter to exit"
        Exit
    }

#endregion

#region configuration
      
      if(!$superSilentConfig -or $superSilentConfig -eq $false){
          if($break){Clear-Variable break}
              Write-Host "EPM is now installed." -ForegroundColor Green
                while($break -eq $null){
                    switch(Read-Host "Would you like to configure EPM now? Y or N"){
                        "Y" {
                            ""
                            Write-Host "Starting $($epmStatus.name) configuration procedure" -ForegroundColor Cyan
                            Invoke-Expression -Command "$($installerPath)/Powershell/configure.ps1"
                            $break = 'break'
                            }
                        "N" {
                            ""
                            Write-Host "Skipping $($epmStatus.name) configuration.." -ForegroundColor Yellow
                            Exit
                            }
                        Default {
                            ""
                            Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                            }
                        }
                    }
            if($break){Clear-Variable break}
        } elseif($superSilentConfig -and $superSilentConfig -eq $true){
            Write-Host "Starting $($epmStatus.name).. configuration procedure" -ForegroundColor Cyan
            Invoke-Expression -Command "$($installerPath)/Powershell/configure.ps1"
        }

#endregion
