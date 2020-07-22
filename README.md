# PowerShellGetCompat

[![PowerShell Gallery - PowerShellGetCompat](https://img.shields.io/badge/PowerShell%20Gallery-PowerShellGet-blue.svg)](https://www.powershellgallery.com/packages/PowerShellGetCompat)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-3.0-blue.svg)](https://github.com/PowerShell/PowerShellGetCompat)


Introduction
============
PowerShellGetCompat is a compatibility module that allows use of PowerShellGet 2.x (and below) cmdlet syntax with PowerShellGet 3.0 (and newer) functionality by making a best effort mapping between the cmdlet interfaces of both versions of the module.'

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional
questions or comments.

Documentation
=============

Documentation for PowerShellGetCompat has not yet been published, please
[Click here](https://docs.microsoft.com/powershell/module/PowerShellGet/?view=powershell-7)
to reference the documentation for previous versions of PowerShellGet.

Requirements
============

- Windows PowerShell 3.0 or newer.
- PowerShell Core.


Get PowerShellGetCompat Module
========================

Please refer to our [documentation](https://www.powershellgallery.com/packages/PowerShellGetCompat/) for the up-to-date version on how to get the PowerShellGetCompat Module.


Get PowerShellGet Source
========================

#### Steps
* Obtain the source
    - Download the latest source code from the release page (https://github.com/PowerShell/PowerShellGetCompat/releases) OR
    - Clone the repository (needs git)
    ```powershell
    git clone https://github.com/PowerShell/PowerShellGetCompat
    ```
* Navigate to the source directory
```powershell
cd path/to/PowerShellGetCompat
```

* Import the module
```powershell
Import-Module src/PowerShellGetCompat
```
