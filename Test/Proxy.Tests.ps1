# These test the v2 proxy functions for PowerShellGetV3
Describe "Proxies exist" {
    BeforeAll {
        $skipTest = $false
        # check to be sure that PowerShellGet is loaded and the version is 3.0.0 or better
        $PSGetModule = Get-Module PowerShellGet
        if ( ! $PSGetModule ) {
            Write-Warning -message "PowerShellGet module not imported"
            $skipTest = $true
        }
        if ( $PSGetModule.Version -lt "3.0.0" ) {
            Write-Warning -message "PowerShellGet module is not correct version"
            $skipTest = $true
        }
        # be sure that this module is loaded
        $proxyModuleName = "CompatPowerShellGet"
        $unloadModule = $false
        if ( ! (Get-Module $proxyModuleName) ) {
            $unloadModule = $true
            Import-Module "$PSScriptRoot/../src/${proxyModuleName}.psd1"
            if ( ! (Get-Module $proxyModuleName) ) {
                # ok - couldn't load the module - skip the tests
                $skipTest = $true
            }
        }

        $expectedProxies = @(
            "Find-Command"
            "Find-DscResource"
            "Find-Module"
            "Find-RoleCapability"
            "Find-Script"
            "Get-InstalledModule"
            "Get-InstalledScript"
            "Get-PSRepository"
            "Install-Module"
            "Install-Script"
            "Publish-Module"
            "Publish-Script"
            "Register-PSRepository"
            "Save-Module"
            "Save-Script"
            "Set-PSRepository"
            "Uninstall-Module"
            "Uninstall-Script"
            "Unregister-PSRepository"
            "Update-Module"
            "Update-Script"
            ) | Sort-Object

        $proxyTestCases = @(

            @{ Name = "Find-Command";            ProxyTo = "Find-PSResource" }
            @{ Name = "Find-DscResource";        ProxyTo = "Find-PSResource" }
            @{ Name = "Find-Module";             ProxyTo = "Find-PSResource" }
            @{ Name = "Find-RoleCapability";     ProxyTo = "Find-PSResource" }
            @{ Name = "Find-Script";             ProxyTo = "Find-PSResource" }
            @{ Name = "Get-InstalledModule";     ProxyTo = "Get-PSResource" }
            @{ Name = "Get-InstalledScript";     ProxyTo = "Get-PSResource" }
            @{ Name = "Get-PSRepository";        ProxyTo = "Get-PSResourceRepository" }
            @{ Name = "Install-Module";          ProxyTo = "Install-PSResource" }
            @{ Name = "Install-Script";          ProxyTo = "Install-PSResource" }
            @{ Name = "Publish-Module";          ProxyTo = "Publish-PSResource" }
            @{ Name = "Publish-Script";          ProxyTo = "Publish-PSResource" }
            @{ Name = "Register-PSRepository";   ProxyTo = "Register-PSResourceRepository" }
            @{ Name = "Save-Module";             ProxyTo = "Save-PSResource" }
            @{ Name = "Save-Script";             ProxyTo = "Save-PSResource" }
            @{ Name = "Set-PSRepository";        ProxyTo = "Set-PSResourceRepository" }
            @{ Name = "Uninstall-Module";        ProxyTo = "Uninstall-PSResource" }
            @{ Name = "Uninstall-Script";        ProxyTo = "Uninstall-PSResource" }
            @{ Name = "Unregister-PSRepository"; ProxyTo = "Unregister-PSResourceRepository" }
            @{ Name = "Update-Module";           ProxyTo = "Update-PSResource" }
            @{ Name = "Update-Script";           ProxyTo = "Update-PSResource" }

            )
        $proxyParameterTestCases = @(
            @{ Name = 'Find-Command';            Parameters = 'AllowPrerelease','AllVersions','Debug','ErrorAction','ErrorVariable','Filter','InformationAction','InformationVariable','MaximumVersion','MinimumVersion','ModuleName','Name','OutBuffer','OutVariable','PipelineVariable','Proxy','ProxyCredential','Repository','RequiredVersion','Tag','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Find-DscResource';        Parameters = 'AllowPrerelease','AllVersions','Debug','ErrorAction','ErrorVariable','Filter','InformationAction','InformationVariable','MaximumVersion','MinimumVersion','ModuleName','Name','OutBuffer','OutVariable','PipelineVariable','Proxy','ProxyCredential','Repository','RequiredVersion','Tag','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Find-Module';             Parameters = 'AllowPrerelease','AllVersions','Command','Credential','Debug','DscResource','ErrorAction','ErrorVariable','Filter','IncludeDependencies','Includes','InformationAction','InformationVariable','MaximumVersion','MinimumVersion','Name','OutBuffer','OutVariable','PipelineVariable','Proxy','ProxyCredential','Repository','RequiredVersion','RoleCapability','Tag','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Find-RoleCapability';     Parameters = 'AllowPrerelease','AllVersions','Debug','ErrorAction','ErrorVariable','Filter','InformationAction','InformationVariable','MaximumVersion','MinimumVersion','ModuleName','Name','OutBuffer','OutVariable','PipelineVariable','Proxy','ProxyCredential','Repository','RequiredVersion','Tag','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Find-Script';             Parameters = 'AllowPrerelease','AllVersions','Command','Credential','Debug','ErrorAction','ErrorVariable','Filter','IncludeDependencies','Includes','InformationAction','InformationVariable','MaximumVersion','MinimumVersion','Name','OutBuffer','OutVariable','PipelineVariable','Proxy','ProxyCredential','Repository','RequiredVersion','Tag','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Get-InstalledModule';     Parameters = 'AllowPrerelease','AllVersions','Debug','ErrorAction','ErrorVariable','InformationAction','InformationVariable','MaximumVersion','MinimumVersion','Name','OutBuffer','OutVariable','PipelineVariable','RequiredVersion','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Get-InstalledScript';     Parameters = 'AllowPrerelease','Debug','ErrorAction','ErrorVariable','InformationAction','InformationVariable','MaximumVersion','MinimumVersion','Name','OutBuffer','OutVariable','PipelineVariable','RequiredVersion','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Get-PSRepository';        Parameters = 'Debug','ErrorAction','ErrorVariable','InformationAction','InformationVariable','Name','OutBuffer','OutVariable','PipelineVariable','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Install-Module';          Parameters = 'AcceptLicense','AllowClobber','AllowPrerelease','Confirm','Credential','Debug','ErrorAction','ErrorVariable','Force','InformationAction','InformationVariable','InputObject','MaximumVersion','MinimumVersion','Name','OutBuffer','OutVariable','PassThru','PipelineVariable','Proxy','ProxyCredential','Repository','RequiredVersion','Scope','SkipPublisherCheck','Verbose','WarningAction','WarningVariable','WhatIf' }
            @{ Name = 'Install-Script';          Parameters = 'AcceptLicense','AllowPrerelease','Confirm','Credential','Debug','ErrorAction','ErrorVariable','Force','InformationAction','InformationVariable','InputObject','MaximumVersion','MinimumVersion','Name','NoPathUpdate','OutBuffer','OutVariable','PassThru','PipelineVariable','Proxy','ProxyCredential','Repository','RequiredVersion','Scope','Verbose','WarningAction','WarningVariable','WhatIf' }
            @{ Name = 'Publish-Module';          Parameters = 'AllowPrerelease','Confirm','Credential','Debug','ErrorAction','ErrorVariable','Exclude','Force','FormatVersion','IconUri','InformationAction','InformationVariable','LicenseUri','Name','NuGetApiKey','OutBuffer','OutVariable','Path','PipelineVariable','ProjectUri','ReleaseNotes','Repository','RequiredVersion','SkipAutomaticTags','Tags','Verbose','WarningAction','WarningVariable','WhatIf' }
            @{ Name = 'Publish-Script';          Parameters = 'Confirm','Credential','Debug','ErrorAction','ErrorVariable','Force','InformationAction','InformationVariable','LiteralPath','NuGetApiKey','OutBuffer','OutVariable','Path','PipelineVariable','Repository','Verbose','WarningAction','WarningVariable','WhatIf' }
            @{ Name = 'Register-PSRepository';   Parameters = 'Credential','Debug','Default','ErrorAction','ErrorVariable','InformationAction','InformationVariable','InstallationPolicy','Name','OutBuffer','OutVariable','PackageManagementProvider','PipelineVariable','Proxy','ProxyCredential','PublishLocation','ScriptPublishLocation','ScriptSourceLocation','SourceLocation','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Save-Module';             Parameters = 'AcceptLicense','AllowPrerelease','Confirm','Credential','Debug','ErrorAction','ErrorVariable','Force','InformationAction','InformationVariable','InputObject','LiteralPath','MaximumVersion','MinimumVersion','Name','OutBuffer','OutVariable','Path','PipelineVariable','Proxy','ProxyCredential','Repository','RequiredVersion','Verbose','WarningAction','WarningVariable','WhatIf' }
            @{ Name = 'Save-Script';             Parameters = 'AcceptLicense','AllowPrerelease','Confirm','Credential','Debug','ErrorAction','ErrorVariable','Force','InformationAction','InformationVariable','InputObject','LiteralPath','MaximumVersion','MinimumVersion','Name','OutBuffer','OutVariable','Path','PipelineVariable','Proxy','ProxyCredential','Repository','RequiredVersion','Verbose','WarningAction','WarningVariable','WhatIf' }
            @{ Name = 'Set-PSRepository';        Parameters = 'Credential','Debug','ErrorAction','ErrorVariable','InformationAction','InformationVariable','InstallationPolicy','Name','OutBuffer','OutVariable','PackageManagementProvider','PipelineVariable','Proxy','ProxyCredential','PublishLocation','ScriptPublishLocation','ScriptSourceLocation','SourceLocation','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Uninstall-Module';        Parameters = 'AllowPrerelease','AllVersions','Confirm','Debug','ErrorAction','ErrorVariable','Force','InformationAction','InformationVariable','InputObject','MaximumVersion','MinimumVersion','Name','OutBuffer','OutVariable','PipelineVariable','RequiredVersion','Verbose','WarningAction','WarningVariable','WhatIf' }
            @{ Name = 'Uninstall-Script';        Parameters = 'AllowPrerelease','Confirm','Debug','ErrorAction','ErrorVariable','Force','InformationAction','InformationVariable','InputObject','MaximumVersion','MinimumVersion','Name','OutBuffer','OutVariable','PipelineVariable','RequiredVersion','Verbose','WarningAction','WarningVariable','WhatIf' }
            @{ Name = 'Unregister-PSRepository'; Parameters = 'Debug','ErrorAction','ErrorVariable','InformationAction','InformationVariable','Name','OutBuffer','OutVariable','PipelineVariable','Verbose','WarningAction','WarningVariable' }
            @{ Name = 'Update-Module';           Parameters = 'AcceptLicense','AllowPrerelease','Confirm','Credential','Debug','ErrorAction','ErrorVariable','Force','InformationAction','InformationVariable','MaximumVersion','Name','OutBuffer','OutVariable','PassThru','PipelineVariable','Proxy','ProxyCredential','RequiredVersion','Scope','Verbose','WarningAction','WarningVariable','WhatIf' }
            @{ Name = 'Update-Script';           Parameters = 'AcceptLicense','AllowPrerelease','Confirm','Credential','Debug','ErrorAction','ErrorVariable','Force','InformationAction','InformationVariable','MaximumVersion','Name','OutBuffer','OutVariable','PassThru','PipelineVariable','Proxy','ProxyCredential','RequiredVersion','Verbose','WarningAction','WarningVariable','WhatIf' }
            )
    }
    It "Should contain the '<name>' proxy" -skip:$skipTest -testcase $proxyTestCases {
        param ( $name, $proxyto )
        Get-Command -ErrorAction ignore -module $proxyModuleName -Name $name | Should -Not -BeNullOrEmpty
    }

    It "The '<name>' proxy is delivered and proxies <proxyto>" -testcase $proxyTestCases -skip:$skipTest {
        param ($name, $proxyto)
        $tokens = $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput((Get-Content function:"$name"), [ref]$tokens, [ref]$errors)
        # hunt for the proxied command
        $query =  { $args[0] -is [System.Management.Automation.Language.invokememberexpressionast] -and
            ($args[0].Expression -match "ExecutionContext.InvokeCommand") -and
            ($args[0].Arguments[0].Extent -match $proxyto)
            }
        $result = $ast.findall($query, $true)
        $result | Should -Not -BeNullOrEmpty
    }

    It "The proxy function for '<name>' has the correct parameters" -TestCases $proxyParameterTestCases -skip:$skipTest {
        param ( $name, $parameters )
        $commandInfo = get-command $name
        $observedParameters = $commandInfo.Parameters.Keys | Foreach-Object {"$_"} | Sort-Object
        $observedParameters | Should -Be $parameters
    }
}
