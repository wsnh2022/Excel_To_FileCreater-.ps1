# Excel_To_FileCreater-.ps1

# Excel to Files Generator

This PowerShell script automates the process of creating multiple files based on data stored in an Excel spreadsheet. It leverages the ImportExcel module to read from an Excel file and generate corresponding files with specified content.

## Features

- Automatic creation of an Excel template if not present
- Reads data from an Excel file with "File Name" and "File Content" columns
- Generates files based on the Excel data
- Error handling for missing modules and empty data rows

## Prerequisites

- Windows operating system
- PowerShell 5.1 or later
- ImportExcel module

## Installation

1. Clone this repository or download the script file.

2. Install the required ImportExcel module:

   ```powershell
   Install-Module -Name ImportExcel -Scope CurrentUser
   ```

## Usage

1. Ensure your Excel file (`data.xlsx` by default) is in the same directory as the script, with the following structure:

   | File Name | File Content |
   |-----------|--------------|
   | example.txt | This is the content of example.txt |
   | ...         | ...                                |

2. Run the script:

   ```powershell
   .\ExcelToFilesGenerator.ps1
   ```

3. If `data.xlsx` doesn't exist, the script will create it and open it for you to input data.

4. The script will process each row in the Excel file, creating files with the specified names and content.

## Configuration

You can modify the following variables in the script to customize its behavior:

- `$excelPath`: Change the name or path of the Excel file if needed.

## Error Handling

- The script will halt execution if it encounters a row with empty fields.
- If the ImportExcel module is not installed, the script will provide instructions and exit.

## Contributing

Contributions to improve the script are welcome. Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the creators of the [ImportExcel](https://github.com/dfinke/ImportExcel) module.
