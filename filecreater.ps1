## open powershell for local user and run below command
## Install-Module -Name ImportExcel -Scope CurrentUser

# Ensure the ImportExcel module is available
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Write-Host "ImportExcel module is not installed. Please run 'Install-Module -Name ImportExcel -Scope CurrentUser' to install it."
    exit
}

# Import the module
Import-Module ImportExcel

# Define the path to the Excel file (in the same directory as the script)
$excelPath = Join-Path -Path (Get-Location) -ChildPath "data.xlsx" # Replace 'data.xlsx' with your desired file name

# Check if the file exists
if (-not (Test-Path -Path $excelPath)) {
    # Create a new Excel file with headers if it doesn't exist
    @(
        [PSCustomObject]@{ 'File Name' = ''; 'File Content' = '' }
    ) | Export-Excel -Path $excelPath -WorksheetName 'Sheet1' -AutoSize

    Write-Host "Excel file created with headers. Please enter your data and save the file."

    # Open the Excel file for editing
    Start-Process -FilePath $excelPath
    exit
}

# Read the Excel file into a variable
$data = Import-Excel -Path $excelPath

# Loop through each row in the Excel file
foreach ($row in $data) {
    # Retrieve the file name and content from the respective columns
    $fileName = $row."File Name"
    $fileContent = $row."File Content"

    # Check if both file name and content are not empty
    if (![string]::IsNullOrWhiteSpace($fileName) -and (![string]::IsNullOrWhiteSpace($fileContent))) {
        # Create the file and write the content
        Set-Content -Path $fileName -Value $fileContent
        Write-Host "File '$fileName' created with specified content."
    } else {
        # Stop processing if a row has empty fields
        Write-Host "Empty row encountered, stopping further processing."
        break
    }
}
