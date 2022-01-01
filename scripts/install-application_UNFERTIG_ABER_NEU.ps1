param(
    [Parameter(Mandatory=$true)]  [string]   $solutionDir,
    [Parameter(Mandatory=$true)]  [string]   $projectName,
    [Parameter(Mandatory=$true)]  [string]   $mfappxRelative,
    [Parameter(Mandatory=$false)] [string]   $appdefRelative   = "appdef.xml.user",
    [Parameter(Mandatory=$false)] [string]   $configRelative   = "..\config\connections.json.user",
    [Parameter(Mandatory=$false)] [string[]] $InstallGroups    = @()
)

# initializing current directory
$currentDir = Get-Location

# Startup messages
Write-Output "  Checking startup parameters..."
Write-Output "    currentDir:      $currentDir"
Write-Output "    solutionDir:     $solutionDir"
Write-Output "    projectName:     $projectName"
Write-Output "    mfappxRelative:  $mfappxRelative"
Write-Output "    appdefRelative:  $appdefRelative"
Write-Output "    configRelative:  $configRelative"
Write-Output "    InstallGroups:   $InstallGroups"

# Append the current path so we have the full location (required in some situations).
$mfappxFullPath = Join-Path $currentDir $mfappxRelative
$appdefFullPath = Join-Path $currentDir $appdefRelative
$configFullPath = Join-Path $currentDir $configRelative

# Normalize the parth
$mfappxFullPath = [system.io.Path]::GetFullPath( $mfappxFullPath )
$appdefFullPath = [system.io.Path]::GetFullPath( $appdefFullPath )
$configFullPath = [system.io.Path]::GetFullPath( $configFullPath )

# Calculated paths
Write-Output "  Calculated full paths..."
Write-Output "    mfappxFullPath:  $mfappxFullPath"
Write-Output "    appdefFullPath:  $appdefFullPath"
Write-Output "    configFullPath:  $configFullPath"

# initializing data from appdef.xml
$appGuid        = "<unknown>"
$appName        = "<unknown>"
$appDesc        = "<unknown>"
$appPublisher   = "<unknown>"
$appVersion     = "<unknown>"
$appCopyright   = "<unknown>"
$appMFVersion   = "<unknown>"
$appMultiServer = "<unknown>"

# next step
Write-Output "  Extracting values from appdef.xml.user file..."
try {

    # Load appdef.xml into XML object
    $xml = New-Object XML
    $xml.PreserveWhitespace = $true
    $xml.Load($appdefFullPath)

    # Select element "version"
    $element = $xml.SelectSingleNode("//guid")
    if ($element) {
        $appGuid = $element.'#text'
    }

    # Select element "version"
    $element = $xml.SelectSingleNode("//name")
    if ($element) {
        $appName = $element.'#text'
    }

    # Select element "version"
    $element = $xml.SelectSingleNode("//description")
    if ($element) {
        $appDesc = $element.'#text'
    }

    # Select element "version"
    $element = $xml.SelectSingleNode("//publisher")
    if ($element) {
        $appPublisher = $element.'#text'
    }

    # Select element "version"
    $element = $xml.SelectSingleNode("//version")
    if ($element) {
        $appVersion = $element.'#text'
    }

    # Select element "version"
    $element = $xml.SelectSingleNode("//copyright")
    if ($element) {
        $appCopyright = $element.'#text'
    }

    # Select element "version"
    $element = $xml.SelectSingleNode("//required-mfiles-version")
    if ($element) {
        $appMFVersion = $element.'#text'
    }

    # Select element "version"
    $element = $xml.SelectSingleNode("//multi-server-compatible")
    if ($element) {
        $appMultiServer = $element.'#text'
    }
}    
catch {
    Write-Output "  ... failed: $_!"
}

# Output of the data read from appdef.xml
Write-Output "    guid:                     $appGuid"
Write-Output "    name:                     $appName"
Write-Output "    description:              $appDesc"
Write-Output "    publisher:                $appPublisher"
Write-Output "    version:                  $appVersion"
Write-Output "    copyright:                $appCopyright"
Write-Output "    required-mfiles-version:  $appMFVersion"
Write-Output "    multi-server-compatible:  $appMultiServer"

# Load M-Files API.
$null = [System.Reflection.Assembly]::LoadWithPartialName("Interop.MFilesAPI")

# auth types as integer value for install-application.user
# 1 [MFilesAPI.MFAuthType]::MFAuthTypeLoggedOnWindowsUser
# 2 [MFilesAPI.MFAuthType]::MFAuthTypeSpecificWindowsUser
# 3 [MFilesAPI.MFAuthType]::MFAuthTypeSpecificMFilesUser

# protocolSequence as string:
# 1 ncacn_ip_tcp - TCP/IP
# 2 grpc         - gRPC
# 3 grpc-local   - local gRPC
# 4 ncacn_spx    - SPX
# 5 ncalrpc      - Local Procedure Call (LPC)
# 6 ncacn_http   - HTTPS

# Target vault
$vaultName = "Default Dev"

# Connection details 
$authType = [MFilesAPI.MFAuthType]::MFAuthTypeLoggedOnWindowsUser
$userName = ""
$password = ""
$domain = ""
$spn = ""
$protocolSequence = "ncacn_ip_tcp"
$networkAddress = "localhost"
$endpoint = 2266
$encryptedConnection = $false
$localComputerName = ""

# Default to reporting an error if the script fails.
$ErrorActionPreference = 'Stop'
$StatusSummary = [System.Collections.ArrayList]@()
$maxLengthOldVersion = 0
$maxLengthNewVersion = 0

# If we are using install-application.user.json then parse the vault connections.
$doesInstallApplicationUserFileExist = $false
$vaultConnections = @()
try {
    Write-Output "  Parsing user config file (if available)..."
    $jsonInput = Get-Content -Path $configFullPath | ConvertFrom-Json
    if($InstallGroups.Count -eq 0) {
        Write-Output "    No install groups given, proceeding with default."
        $InstallGroups += "default"
    }
    ForEach($jsonConnection in $jsonInput.VaultConnections) {
        $doesInstallApplicationUserFileExist = $true

        # check if host name is given
        $onHost = ""
        if ($jsonConnection.networkAddress) {
            $onHost = " on $($jsonConnection.networkAddress)";
        }
    
        ForEach($ig in $InstallGroups) {
            # if no groups, include to default
            if(-not $jsonConnection.installGroups) {
                if($InstallGroups -contains "default") {
                    $vaultConnections += $jsonConnection
                    Write-Output "    Will deploy to '$($jsonConnection.vaultName)'$($onHost), as the declaration has no groups defined (included in default)."
                }
                break; # The connection has no groups, no further looping is needed
            }
            if($jsonConnection.InstallGroups -contains $ig) {
                $vaultConnections += $jsonConnection
                Write-Output "    Will deploy to '$($jsonConnection.vaultName)'$($onHost), as the declaration has group $($ig) defined."
                break;
            }
        }
    }
    if ($jsonInput.VaultConnection) {
        # Copy to $jsonConnection
        $jsonConnection = $jsonInput.VaultConnection;
        $doesInstallApplicationUserFileExist = $true

        # check if host name is given
        $onHost = ""
        if ($jsonConnection.networkAddress) {
            $onHost = " on $($jsonConnection.networkAddress)";
        }
    
        ForEach($ig in $InstallGroups) {
            # if no groups, include to default
            if(-not $jsonConnection.installGroups) {
                if($InstallGroups -contains "default") {
                    $vaultConnections += $jsonConnection
                    Write-Output "    Will deploy to '$($jsonConnection.vaultName)'$($onHost), as the declaration has no groups defined (included in default)."
                }
                break; # The connection has no groups, no further looping is needed
            }
            if($jsonConnection.InstallGroups -contains $ig) {
                $vaultConnections += $jsonConnection
                Write-Output "    Will deploy to '$($jsonConnection.vaultName)'$($onHost), as the declaration has group $($ig) defined."
                break;
            }
        }
    }
}
catch [System.IO.FileNotFoundException], [System.Management.Automation.ItemNotFoundException]
{
    # This is fine; the user is probably not using this approach for deployment.
    Write-Output "    connections.json.user file not found; using data from install-application.ps1."
}
catch {
    # Write the exception out and throw so that we stop execution.
    Write-Error -Exception $error[0].Exception
    throw;
}
finally
{
    $error.clear();
}
# If we are not using an external JSON file
# then use the connection/authentication information defined at the top of the file.
if(-not $doesInstallApplicationUserFileExist) {
    $vaultConnections += [PSCustomObject]@{
        vaultName = $vaultName
        authType = $authType
        userName = $userName
        password = $password
        domain = $domain
        spn = $spn
        protocolSequence = $protocolSequence
        networkAddress = $networkAddress
        endpoint = $endpoint
        encryptedConnection = $encryptedConnection
        localComputerName = $localComputerName
        deploy = true
        subPackage = "Metadata.Sample"
    }
}
                                 
# Initialize loop
Write-Output ""
Write-Output "  ----------------------------------------------------------------------------"
Write-Output "  -----     BEGIN OF M-FILES API CALLS                                   -----"
Write-Output "  ----------------------------------------------------------------------------"
Write-Output ""
$firstEntry = $true
$countConnections = 0
$counter = 0

if ($vaultConnections) {
    $countConnections = $vaultConnections.Count
}
                                 
# use every connection configured
ForEach($vc in $vaultConnections) {
    # will be set for each case afterwards - only to be sure
    $StatusShortName = "[SHOULD NOT TO BE SEEN]"
    # but old version is not available in all cases
    $oldVersion = "unknown" 
    # leave out version if something went wrong
    $newVersion = "went wrong"
    if ($firstEntry) {
        $firstEntry = $false
    } else {
    }
    # old version for all connections if just connecting and checking version is configured as ok
    if ($vc.justConnectIsOk) {
        try {
            # Connect to M-Files Server.
            $onHost = ""
            if ($vc.networkAddress) {
              $onHost = " on $($vc.networkAddress)";
            }
            Write-Output "  ----------------------------------------------------------------------------"
            Write-Output "  Installing to '$($vc.vaultName)'$($onHost)..."
            Write-Output "  ----------------------------------------------------------------------------"
            $StatusCurrentLine = "'$($vc.vaultName)'$($onHost): "
            $server = new-object MFilesAPI.MFilesServerApplicationClass
            $tzi = new-object MFilesAPI.TimeZoneInformationClass
            $tzi.LoadWithCurrentTimeZone()
            $null = $server.ConnectAdministrativeEx( $tzi, $vc.authType, $vc.userName, $vc.password, $vc.domain, $vc.spn, $vc.protocolSequence, $vc.networkAddress, $vc.endpoint, $vc.encryptedConnection, $vc.localComputerName )
            # Get the target vault.
            $vaultOnServer = $server.GetOnlineVaults().GetVaultByName( $vc.vaultName )
            # Login to vault.
            $vault = $vaultOnServer.LogIn()
            # Checking installed application.
            try {
                Write-Output "    Application $($appGuid)"
                $customApp = $vault.CustomApplicationManagementOperations.GetCustomApplication( $appGuid );
                Write-Output "    Old version $($customApp.Version)"
                $oldVersion = "$($customApp.Version)"
            } catch {
                Write-Output "    Not installed yet"
                $oldVersion = "No previous"
            }                     
            # Install application.
            Write-Output "    New version $($appVersion)"
        } catch {
            Write-Output "    Not installed yet"
            $oldVersion = "No previous"
        }   
        # Installing only if marked for deploy
        if ($vc.deploy) {
            try {
                Write-Output "    Installing $($mfappxFullPath)..."
                $vault.CustomApplicationManagementOperations.InstallCustomApplication( $mfappxFullPath )
                # Restart vault.
                Write-Output "    Restarting vault..."
                $server.VaultManagementOperations.TakeVaultOffline( $vaultOnServer.GUID, $true )
                $server.VaultManagementOperations.BringVaultOnline( $vaultOnServer.GUID )
                # Short sleep to prevent SQL errors on logging in.
                Start-Sleep -Milliseconds 500
                # Login to vault again.
                $vault = $vaultOnServer.LogIn()
                $customApp = $vault.CustomApplicationManagementOperations.GetCustomApplication( $appGuid );
                if ($customApp) {
                    $appType = "Unspecified" # "MFCustomApplicationTypeUnspecified"
                    if ($customApp.ApplicationType -eq 1) {
                        $appType = "Client" # "MFCustomApplicationTypeClient"
                    }
                    if ($customApp.ApplicationType -eq 2) {
                        $appType = "Server" # "MFCustomApplicationTypeServer"
                    }
                    Write-Output "    Properties of the installed CustomApplication:"
                    Write-Output "      ApplicationType:        $($appType)"
                    Write-Output "      ChecksumHash:           $($customApp.ChecksumHash)"
                    Write-Output "      Description:            $($customApp.Description)"
                    Write-Output "      Enabled:                $($customApp.Enabled)"
                    Write-Output "      ID:                     $($customApp.ID)"
                    Write-Output "      MasterApplication:      $($customApp.MasterApplication)"
                    Write-Output "      MultiServerCompatible:  $($customApp.MultiServerCompatible)"
                    Write-Output "      Name:                   $($customApp.Name)"
                    Write-Output "      Optional:               $($customApp.Optional)"
                    Write-Output "      Publisher:              $($customApp.Publisher)"
                    Write-Output "      RequireSystemAccess:    $($customApp.RequireSystemAccess)"
                    Write-Output "      Version:                $($customApp.Version)"
            
                    $appsTotal = 0
                    $appsChild = 0
                    $vault.CustomApplicationManagementOperations.GetCustomApplications() | 
                        ForEach-Object {
                            $appsTotal++
                            if ("{$($_.MasterApplication)}" -eq $customApp.ID) {
                                $appsChild++
                                $appType = "Unspecified" # "MFCustomApplicationTypeUnspecified"
                                if ($_.ApplicationType -eq 1) {
                                    $appType = "Client" # "MFCustomApplicationTypeClient"
                                }
                                if ($_.ApplicationType -eq 2) {
                                    $appType = "Server" # "MFCustomApplicationTypeServer"
                                }
                                Write-Output "    Sub-Application installed:"
                                Write-Output "      ApplicationType:        $($appType)"
                                Write-Output "      ChecksumHash:           $($_.ChecksumHash)"
                                Write-Output "      Description:            $($_.Description)"
                                Write-Output "      Enabled:                $($_.Enabled)"
                                Write-Output "      ID:                     $($_.ID)"
                                Write-Output "      MasterApplication:      $($_.MasterApplication)"
                                Write-Output "      MultiServerCompatible:  $($_.MultiServerCompatible)"
                                Write-Output "      Name:                   $($_.Name)"
                                Write-Output "      Optional:               $($_.Optional)"
                                Write-Output "      Publisher:              $($_.Publisher)"
                                Write-Output "      RequireSystemAccess:    $($_.RequireSystemAccess)"
                                Write-Output "      Version:                $($_.Version)"
                            }
                        }
                
                    Write-Output "    Number of child applications: $appsChild of $appsTotal total."
                    $StatusShortName = "[>> OK]"
                    $newVersion = $appVersion
                }
                else {
                    Write-Output "      ERROR: Installed application could not be loaded."
                    Write-Output "    Done."
                    $StatusShortName = "[ERROR]"
                    $newVersion = "reload failed"
                }
                Write-Output "  ----------------------------------------------------------------------------"
                Write-Output "  Completed installation to '$($vc.vaultName)'$($onHost)."
                Write-Output "  ----------------------------------------------------------------------------"
                Write-Output ""
            } catch {
                # Already exists
                if($_.Exception -Match "0x80040031") {
                    Write-Output "    WARNING: This application version already exists on the vault, installation skipped"
                    Write-Output ""
                    $StatusShortName = "[EXIST]"
                    $newVersion = "is existing"
                } else {
                    if($_.Exception -Match "0x8004091E") {
                        Write-Output "    WARNING: A newer version of this application is already installed on the vault, installation skipped"
                        Write-Output ""
                        $StatusCurrentLine += "[NEWER]"
                        $newVersion = "already newer"
                    } else {
                        throw
                    }
                }
            }
        } else {
            Write-Output "  SKIPPING INSTALLATION to '$($vc.vaultName)'$($onHost)."
            Write-Output ""
            $StatusShortName = "[-SKIP]"
            $newVersion = "skip (config)""
        }
    } catch {
        Write-Output "  ERROR installing to '$($vc.vaultName)'$($onHost)."
        Write-Output ""
        $StatusShortName = "[FAULT]"
        $newVersion = "unknown error""
    }

    $i = 1
    $maxLengthVersion = 14
    While (($newVersion.Length -lt $maxLengthVersion) -And ($i -lt 20)) {
        $i++
        $newVersion = " $($newVersion)"
    }

    $i = 1
    While (($oldVersion.Length -lt $maxLengthVersion) -And ($i -lt 20)) {
        $i++
        $oldVersion = " $($oldVersion)"
    }
    $StatusLine = "$($StatusShortName) install/update from [$($oldVersion)] to [$($appVersion)] on vault '$($vc.vaultName)'$($onHost)"
    $StatusSummary.Add($StatusLine)
}
Write-Output "  ----------------------------------------------------------------------------"
Write-Output "  -----     END OF M-FILES API CALLS                                     -----"
Write-Output "  ----------------------------------------------------------------------------"
Write-Output ""

ForEach($line in $StatusSummary) {
    Write-Output "  - $($line)"
}

Write-Output ""