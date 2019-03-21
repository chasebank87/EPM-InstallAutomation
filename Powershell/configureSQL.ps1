#region set mainVariables and mainFunctions

    . "$($installerPath)\Variables\mainVariables"
    . "$($installerPath)\Functions\mainfunctions.ps1"

#endregion

#region create session to sql server
    
    #confirm the server collation is correct
    $serverCollation = Invoke-Sqlcmd -ConnectionString "Server=$($dbServer);User Id=$($sqlAdmin);Password=$($sqlAdminPassword);" -Query "SELECT CONVERT (varchar, SERVERPROPERTY('collation'))"
    if($serverCollation.Column1 -eq 'SQL_Latin1_General_CP1_CI_AS'){
        Write-Host "SQL Server collation is set correctly. Continuing.." -ForegroundColor Green
    } else {
        Write-Host "SQL Server collation is set incorrectly. Please correct this and rerun this script." -ForegroundColor Red
        Read-Host "Click enter to exit"
        Exit
    }

    #confirm the sqlAdmin provides is a sysadmin
    $sqlSysAdminUsers = Invoke-Sqlcmd -ConnectionString "Server=$($dbServer);User Id=$($sqlAdmin);Password=$($sqlAdminPassword);" -Query "
    SELECT   name,type_desc,is_disabled
    FROM     master.sys.server_principals
    WHERE    IS_SRVROLEMEMBER ('sysadmin',name) = 1
    ORDER BY name "
    if("$($sqlAdmin)" -in $sqlSysAdminUsers.name){
        Write-Host "$($sqlAdmin) is a sysadmin. Continuing.." -ForegroundColor Cyan
    } else {
        Write-Host "$($sqlAdmin) is not a member of the sysadmin role. Please correct and rerun this script" -ForegroundColor Red
        Read-Host "Click enter to exit"
        #Exit
    }
        
#region announce start

        Write-Host '

 ______   ______   ______   ______   ______  __   __   __   ______                
/\  ___\ /\  == \ /\  ___\ /\  __ \ /\__  _\/\ \ /\ "-.\ \ /\  ___\               
\ \ \____\ \  __< \ \  __\ \ \  __ \\/_/\ \/\ \ \\ \ \-.  \\ \ \__ \              
 \ \_____\\ \_\ \_\\ \_____\\ \_\ \_\  \ \_\ \ \_\\ \_\\"\_\\ \_____\             
  \/_____/ \/_/ /_/ \/_____/ \/_/\/_/   \/_/  \/_/ \/_/ \/_/ \/_____/             
                                                                                  
 _____    ______   ______  ______   ______   ______   ______   ______   ______    
/\  __-. /\  __ \ /\__  _\/\  __ \ /\  == \ /\  __ \ /\  ___\ /\  ___\ /\  ___\   
\ \ \/\ \\ \  __ \\/_/\ \/\ \  __ \\ \  __< \ \  __ \\ \___  \\ \  __\ \ \___  \  
 \ \____- \ \_\ \_\  \ \_\ \ \_\ \_\\ \_____\\ \_\ \_\\/\_____\\ \_____\\/\_____\ 
  \/____/  \/_/\/_/   \/_/  \/_/\/_/ \/_____/ \/_/\/_/ \/_____/ \/_____/ \/_____/ 
                                                                                  

                                                                                  ' -ForegroundColor Magenta
#endregion

    #create DB array
    $databases = @($epmaDB,$calcDB,$disclosureDB,$essbaseDB,$fdmDB,$foundationDB,$hfmDB,$profitDB,$rafDB)

    #look for databases
    foreach($d in $databases){
        if($d -ne $null){
            $dbExistence = Invoke-Sqlcmd -ConnectionString "Server=$($dbServer);User Id=$($sqlAdmin);Password=$($sqlAdminPassword);" -Query "
            select * from sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');"
            if($dbExistence.name -contains "$d"){
                Write-Host "$d already exists. Skipping.." -ForegroundColor Yellow
            } elseif($dbExistence.name -notcontains "$d"){
                Write-Host "$d does not exist. Creating Now.." -ForegroundColor Cyan
                $create = "CREATE DATABASE $($d);"
                $modify = " USE $($d)
                            EXEC sp_changedbowner '$($dbUser)'
                            go
                            ALTER DATABASE $($d)
                            SET READ_COMMITTED_SNAPSHOT ON
                            GO
                            ALTER DATABASE $($d)
                            SET ALLOW_SNAPSHOT_ISOLATION ON
                            GO"
                #create
                try {
                    Invoke-Sqlcmd -ConnectionString "Server=$($dbServer);User Id=$($sqlAdmin);Password=$($sqlAdminPassword);" -Query "$($create)"
                } catch {
                    $_ | Out-File "$($installerPath)\Logs\create$($d).Error.log"
                    Get-Content "$($installerPath)\Logs\create$($d).Error.log" | Write-Host -ForegroundColor Red
                    Read-Host "Click enter to exit"
                    Exit
                }
                #modify
                 try {
                    Invoke-Sqlcmd -ConnectionString "Server=$($dbServer);User Id=$($sqlAdmin);Password=$($sqlAdminPassword);" -Query "$($modify)"
                } catch {
                    $_ | Out-File "$($installerPath)\Logs\modify$($d).Error.log"
                    Get-Content "$($installerPath)\Logs\modify$($d).Error.log" | Write-Host -ForegroundColor Red
                    Read-Host "Click enter to exit"
                    Exit
                }
            }
        }
    }

#endregion



