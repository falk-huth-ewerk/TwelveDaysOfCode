param( [string] $solutionDir, [string] $solutionName )

# initializing variables
$currentDir = Get-Location

# startup messages
Write-Output "Updating version number"
Write-Output "  Checking startup parameters..."
Write-Output "    currentDir:    $currentDir"
Write-Output "    solutionDir:   $solutionDir"
Write-Output "    solutionName:  $solutionName"

# Get full path of base directory
$solutionDir = [system.io.Path]::GetFullPath($solutionDir)
Write-Output "  Initializing with directory $solutionDir as base for files..."

# Get the new version - replacing the time if it is 0:01 -> x.x.x.001 -> x.x.x.1 | x.x.x.012 -> x.x.x.12
$newversion  = (Get-Date).ToUniversalTime().toString("yy.M.d.Hmm").Replace(".0", ".").Replace(".0", ".")
$currentYear = (Get-Date).ToUniversalTime().toString("yyyy")
Write-Output "    Calculated new version numer: $newversion"
Write-Output "    Calculated current year:      $currentYear"

# Writing version into ..\config\version.txt.user
$Filename = [system.io.Path]::GetFullPath("$($solutionDir)config\version.txt.user")
Write-Output "    Writing version to $Filename"
Out-File -FilePath $Filename -InputObject $newversion

# Replace version in all occurences of AssemblyInfo.cs
Write-Output "  Changing version in AssemblyInfo.cs.template files in the project..."
Get-ChildItem -Path $solutionDir -Filter AssemblyInfo.cs.template -Recurse -ErrorAction SilentlyContinue -Force | 
    ForEach-Object {

        # Log the current target filename
        $targetFileUser = $_.FullName.Replace(".template", "")
        $targetFileOrig = $_.FullName
        Write-Output "    Replacing version from $targetFileOrig"
        Write-Output "    Target file $targetFileUser"

        try
        {
            # Replacing the values in Assembly and AssemblyFile
            (Get-Content -Path $targetFileOrig) -Replace '(?<=Assembly(?:File)?Version\(")[^"]*(?="\))', $newVersion | Set-Content -Path $targetFileUser
            (Get-Content -Path $targetFileUser) -Replace '%YEAR_PLACEHOLDER%', $currentYear | Set-Content -Path $targetFileUser
        }   
        catch {
            Write-Output "    ... failed: $_!"
        }
    }

#Settings object will instruct how the xml elements are written to the file
$settings = New-Object System.Xml.XmlWriterSettings
$settings.Indent = $true

#NewLineChars will affect all newlines
$settings.NewLineChars ="`r`n"

#Set an optional encoding, UTF-8 is the most used (without BOM)
$settings.Encoding = New-Object System.Text.UTF8Encoding( $false )

# Replace version in all occurences of appdef.xml.user
Write-Output "  Changing version in all appdef.xml.user and moduleDef.xml.user files in the solution..."
Get-ChildItem -Path $solutionDir -Include appdef.xml, moduleDef.xml -Recurse -ErrorAction SilentlyContinue -Force | 
    ForEach-Object {

        # Log the current target filename
        $targetFileOrig = $_.FullName
        $targetFileUser = "$($targetFileOrig).user"
        Write-Output "    Replacing version in $targetFileUser after copying it from appdef.xml / moduleDef.xml"

        try {

            # New XML object for appdef.xml
            $xml = New-Object XML
            $xml.PreserveWhitespace = $true
            $xml.Load($targetFileOrig)

            # Select Version -element from appdef.xml XML object
            $element = $xml.SelectSingleNode("//version")
            $element.'#text' = [string]$newVersion

            # Select Copyright -element from appdef.xml XML object
            $element = $xml.SelectSingleNode("//copyright")
            $currentCopyright = $element.'#text'
            $newCopyright = $currentCopyright.Replace("%YEAR_PLACEHOLDER%", $currentYear)
            $element.'#text' = [string]$newCopyright

            # Save XML -file
            $xml.Save($targetFileUser)
        }    
        catch {
            Write-Output "    ... failed: $_!"
        }
    }

# Finished message
Write-Output "  Replacement completed"
Write-Output "Updating version number successfully completed"