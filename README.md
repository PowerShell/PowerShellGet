# CompatPowerShellGet

[![PowerShell Gallery - PowerShellGet](https://img.shields.io/badge/PowerShell%20Gallery-PowerShellGet-blue.svg)](https://www.powershellgallery.com/packages/PowerShellGet)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://github.com/PowerShell/PowerShellGet)


Introduction
============
PowerShellGet v3 is a compatibility module that allows use of PowerShellGet 2.x (and below) cmdlet syntax with Microsoft.PowerShell.PSResourceGet functionality by making a best effort mapping between the cmdlet interfaces of both versions of the module.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional
questions or comments.

Documentation
=============

Documentation for PowerShellGet v3 has not yet been published, please
[Click here](https://docs.microsoft.com/powershell/module/PowerShellGet/?view=powershell-7)
to reference the documentation for previous versions of PowerShellGet.

Requirements
============

- Windows PowerShell 5.1 or newer.
- PowerShell Core.


Get PowerShellGet Module
========================

Please refer to our [documentation](https://www.powershellgallery.com/packages/PowerShellGet/) for the up-to-date version on how to get the PowerShellGet Module.


Get PowerShellGet Source
========================

#### Steps
* Obtain the source
    - Download the latest source code from the release page (https://github.com/PowerShell/PowerShellGet/releases) OR
    - Clone the repository (needs git)
    ```powershell
    git clone https://github.com/PowerShell/PowerShellGet
    ```
* Navigate to the source directory
```powershell
cd path/to/PowerShellGet
```

* Import the module
```powershell
Import-Module src/PowerShellGet -Force
```
