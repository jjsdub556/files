# Define the computer object name
$ComputerName = "COMPUTER_OBJECT_NAME"

# Define the LDAP path for the domain
$LDAPPath = "LDAP://DC=yourdomain,DC=com" # Replace with your domain's LDAP path

# Create a DirectorySearcher object
$Searcher = New-Object System.DirectoryServices.DirectorySearcher
$Searcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry($LDAPPath)
$Searcher.Filter = "(&(objectClass=computer)(sAMAccountName=$ComputerName`$))" # Note: Computer name should end with $

# Specify properties to load
$Searcher.PropertiesToLoad.Add("ms-Mcs-AdmPwd") | Out-Null

# Perform the search
try {
    $Result = $Searcher.FindOne()

    if ($Result -and $Result.Properties["ms-Mcs-AdmPwd"]) {
        $LAPSPassword = $Result.Properties["ms-Mcs-AdmPwd"][0]
        Write-Host "The LAPS password for $ComputerName is: $LAPSPassword" -ForegroundColor Green
    } else {
        Write-Host "LAPS password not found or access denied for $ComputerName." -ForegroundColor Yellow
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
