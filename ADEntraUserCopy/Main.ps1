# Ensure the PresentationFramework assembly is loaded
Add-Type -AssemblyName PresentationFramework

# Load the XAML file
$xamlFile = Join-Path $PSScriptRoot "MainWindow.xaml"
try {
    $xaml = [System.IO.File]::ReadAllText($xamlFile)
}
catch {
    Write-Error "Failed to read XAML file: $_"
    exit
}

# Parse the XAML
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xaml))
try {
    $window = [System.Windows.Markup.XamlReader]::Load($reader)
}
catch {
    Write-Error "Failed to parse XAML: $_"
    exit
}
finally {
    $reader.Dispose()
}

# Find controls for event handling (optional, add as needed)
$loginButton = $window.FindName("LoginButton")
$searchButton = $window.FindName("SearchButton")
$validateButton = $window.FindName("ValidateButton")
$deleteGroupsButton = $window.FindName("DeleteGroupsButton")
$copyGroupsButton = $window.FindName("CopyGroupsButton")
$clearOutputButton = $window.FindName("ClearOutputButton")
$referenceUserTextBox = $window.FindName("ReferenceUserTextBox")
$targetUserTextBox = $window.FindName("TargetUserTextBox")
$signatureComboBox = $window.FindName("SignatureComboBox")
$smartphoneComboBox = $window.FindName("SmartphoneComboBox")
$ms365LicenseComboBox = $window.FindName("MS365LicenseComboBox")
$additionalLicensesListBox = $window.FindName("AdditionalLicensesListBox")
$groupsListBox = $window.FindName("GroupsListBox")
$outputTextBox = $window.FindName("OutputTextBox")

# Example: Add a click event for the Login button
if ($loginButton) {
    $loginButton.Add_Click({
        $outputTextBox.Text = "Login button clicked!"
        Disconnect-Graph
        Connect-MgGraph
    })
}

# Example: Add a click event for the Clear button
if ($clearOutputButton) {
    $clearOutputButton.Add_Click({
        $outputTextBox.Text = ""
    })
}

# Handle the File > Exit menu item
$fileExitMenu = $window.FindName("FileExitMenu") # Note: MenuItem names are not explicitly set in XAML, so you may need to adjust
    $fileExitMenu.Add_Click({
        $window.Close()
    })

# Show the window
$window.ShowDialog() | Out-Null