# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

$ProgressPreference = "SilentlyContinue"
$modPath = "$psscriptroot/../PSGetTestUtils.psm1"
Import-Module $modPath -Force -Verbose
Write-Verbose -Verbose -Message "PowerShellGet version currently loaded: $($(Get-Module powershellget).Version)"

Describe 'Test CompatPowerShellGet: Uninstall-PSResource' -tags 'CI' {
    BeforeAll{
        $PSGalleryName = Get-PSGalleryName
        $testModuleName = "testmodule99"
        $testModuleName2 = "test_module"
        $testScriptName = "test_script"
        Get-NewPSResourceRepositoryFile
        Set-PSResourceRepository PSGallery -Trusted
        Uninstall-PSResource -Name $testModuleName -Version "*" -ErrorAction SilentlyContinue
        Uninstall-PSResource -Name $testScriptName -Version "*" -ErrorAction SilentlyContinue
    }

    BeforeEach {
        Install-PSResource $testModuleName -Repository $PSGalleryName -WarningAction SilentlyContinue
        Install-PSResource $testModuleName2 -Repository $PSGalleryName -SkipDependencyCheck -WarningAction SilentlyContinue
        Install-PSResource $testScriptName -Repository $PSGalleryName -WarningAction SilentlyContinue
    }

    AfterEach {
        Uninstall-PSResource -Name $testModuleName -Version "*" -ErrorAction SilentlyContinue
        Uninstall-PSResource -Name $testScriptName -Version "*" -ErrorAction SilentlyContinue
    }

    AfterAll {
        Get-RevertPSResourceRepositoryFile
    }

    It "Uninstall-Module" {
        Uninstall-Module -Name $testModuleName

        $res = Get-InstalledPSResource $testModuleName
        $res.Count | Should -Be 0
    }    

    It "Uninstall-Script" {
        Uninstall-Script -Name $testScriptName

        $res = Get-InstalledPSResource $testScriptName
        $res.Count | Should -Be 0
    }   

    It "Uninstall-Module with -AllVersions" {
        Install-PSResource $testModuleName -Repository $PSGalleryName -Version "0.0.1"
        Uninstall-Module -Name $testModuleName -AllVersions

        $res = Get-InstalledPSResource $testModuleName
        $res.Count | Should -Be 0
    }

    It "Uninstall-Module with -MinimumVersion" {
        $minVersion = "0.0.2"
        Install-PSResource $testModuleName -Repository $PSGalleryName -Version "0.0.1"
        Uninstall-Module -Name $testModuleName -MinimumVersion $minVersion

        $res = Get-InstalledPSResource $testModuleName
        $res.Version | Should -BeLessThan $minVersion
    }

    It "Uninstall-Module with -MaximumVersion" {
        $maxVersion = "0.0.2"
        Install-PSResource $testModuleName -Repository $PSGalleryName -Version "0.0.1"
        Uninstall-Module -Name $testModuleName -MaximumVersion $maxVersion

        $res = Get-InstalledPSResource $testModuleName
        $res.Version | Should -Not -Contain "0.0.1"
    }

    It "Uninstall-Script with -AllVersions" {
        Install-PSResource $testModuleName -Repository $PSGalleryName -Version "0.0.1"
        Uninstall-Module -Name $testModuleName -AllVersions

        $res = Get-InstalledPSResource $testModuleName
        $res.Count | Should -Be 0
    }

    It "Uninstall-Module with -MinimumVersion" {
        $minVersion = "0.0.2"
        Install-PSResource $testModuleName -Repository $PSGalleryName -Version "0.0.1"
        Uninstall-Module -Name $testModuleName -MinimumVersion $minVersion

        $res = Get-InstalledPSResource $testModuleName
        $res.Version | Should -BeLessThan $minVersion
    }

    It "Uninstall-Module with -MaximumVersion" {
        $maxVersion = "0.0.2"
        Install-PSResource $testModuleName -Repository $PSGalleryName -Version "0.0.1"
        Uninstall-Module -Name $testModuleName -MaximumVersion $maxVersion

        $res = Get-InstalledPSResource $testModuleName
        $res.Version | Should -Not -Contain "0.0.1"
    }

    It "Uninstall a module when given name and specifying all versions" {
        $null = Install-PSResource $testModuleName -Repository $PSGalleryName -Version "0.0.1" -TrustRepository
        $null = Install-PSResource $testModuleName -Repository $PSGalleryName -Version "0.0.2" -TrustRepository
        $null = Install-PSResource $testModuleName -Repository $PSGalleryName -Version "0.0.3" -TrustRepository

        Uninstall-Module -Name $testModuleName -AllVersions
        $pkgs = Get-InstalledPSResource $testModuleName
        $pkgs.Version | Should -Not -Contain "0.0.1"
        $pkgs.Version | Should -Not -Contain "0.0.2"
        $pkgs.Version | Should -Not -Contain "0.0.3"
    }

    It "Uninstall a module when given name and using the default version (ie all versions, not explicitly specified)" {
        $null = Install-PSResource $testModuleName2 -Repository $PSGalleryName -Version "1.0.0" -SkipDependencyCheck -WarningAction SilentlyContinue
        $null = Install-PSResource $testModuleName2 -Repository $PSGalleryName -Version "3.0.0" -SkipDependencyCheck -WarningAction SilentlyContinue
        $null = Install-PSResource $testModuleName2 -Repository $PSGalleryName -Version "5.0.0" -SkipDependencyCheck -WarningAction SilentlyContinue

        Uninstall-Module -Name $testModuleName2
        $pkgs = Get-InstalledPSResource $testModuleName2
        $pkgs.Version | Should -Not -Contain "1.0.0"
        $pkgs.Version | Should -Not -Contain "3.0.0"
        $pkgs.Version | Should -Not -Contain "5.0.0"
    }

    It "Uninstall module when given Name and specifying exact version" {
        $null = Install-PSResource $testModuleName2 -Repository $PSGalleryName -Version "1.0.0" -SkipDependencyCheck -WarningAction SilentlyContinue
        $null = Install-PSResource $testModuleName2 -Repository $PSGalleryName -Version "3.0.0" -SkipDependencyCheck -WarningAction SilentlyContinue
        $null = Install-PSResource $testModuleName2 -Repository $PSGalleryName -Version "5.0.0" -SkipDependencyCheck -WarningAction SilentlyContinue

        Uninstall-Module -Name $testModuleName2 -RequiredVersion "3.0.0"
        $pkgs = Get-InstalledPSResource -Name $testModuleName2
        $pkgs.Version | Should -Not -Contain "1.0.0"
    }

    $testCases = @{Version="[1.0.0.0]";          ExpectedVersion="1.0.0.0"; Reason="validate version, exact match"},
                 @{Version="1.0.0.0";            ExpectedVersion="1.0.0.0"; Reason="validate version, exact match without bracket syntax"}
    It "Uninstall module when given Name to <Reason> <Version>" -TestCases $testCases {
        param($Version, $ExpectedVersion)
        Uninstall-Module -Name $testModuleName2 -AllVersions
        $null = Install-PSResource $testModuleName2 -Repository $PSGalleryName -Version "1.0.0" -SkipDependencyCheck -WarningAction SilentlyContinue
        $null = Install-PSResource $testModuleName2 -Repository $PSGalleryName -Version "3.0.0" -SkipDependencyCheck -WarningAction SilentlyContinue
        $null = Install-PSResource $testModuleName2 -Repository $PSGalleryName -Version "5.0.0" -SkipDependencyCheck -WarningAction SilentlyContinue

        Uninstall-Module -Name $testModuleName2 -RequiredVersion $Version
        $pkgs = Get-InstalledPSResource $testModuleName2
        $pkgs.Version | Should -Not -Contain $Version
    }

    $testCases2 =  @{Version='[5.*.0]';         Description="version with wilcard in middle"},
    @{Version='[*.0.0.0]';       Description="version with wilcard at start"},
    @{Version='[5.*.0.0]';       Description="version with wildcard at second digit"},
    @{Version='[5.0.*.0]';       Description="version with wildcard at third digit"}
    @{Version='[5.0.0.*]';       Description="version with wildcard at end"},
    @{Version='[5..0.0]';        Description="version with missing digit in middle"},
    @{Version='[5.0.0.]';        Description="version with missing digit at end"},
    @{Version='[5.0.0.0.0]';     Description="version with more than 4 digits"}

    It "Do not uninstall module with incorrectly formatted version such as <Description>" -TestCases $testCases2 {
        param($Version, $Description)

        {Uninstall-Module -Name $testModuleName2 -RequiredVersion $Version} | Should -Throw "Argument for -Version parameter is not in the proper format."
    }

    $testCases3 =  @{Version='(5.0.0.0)';       Description="exclusive version (1.0.0.0)"},
    @{Version='[5-0-0-0]';       Description="version formatted with invalid delimiter"}

    It "Do not uninstall module with incorrectly formatted version such as <Description>" -TestCases $testCases3 {
        param($Version, $Description)

        try {
            Uninstall-Module -Name $testModuleName2 -Version $Version -ErrorAction SilentlyContinue
        }
        catch
        {}
        $pkg = Get-InstalledPSResource $testModuleName2 -Version "5.0.0.0"
        $pkg.Version | Should -Be "5.0.0.0"
    }

    It "Uninstall prerelease version module when prerelease version specified" {
        $version = "1.0.0-beta2"
        Install-PSResource -Name $testModuleName -Version $version -Repository $PSGalleryName
        Uninstall-Module -Name $testModuleName -RequiredVersion $version
        $res = Get-InstalledPSResource $testModuleName -Version "1.0.0"
        $res | Should -BeNullOrEmpty
    }

    It "Not uninstall non-prerelease version module when similar prerelease version is specified" {
        # testmodule99 has a version 0.0.1, but no version 0.0.1-preview.
        # despite the core version part being the same this uninstall on a nonexistant prerelease version should not be successful
        Install-PSResource -Name $testModuleName -Version "0.0.1" -Repository $PSGalleryName
        Uninstall-Module -Name $testModuleName -RequiredVersion "0.0.1-preview" -ErrorAction SilentlyContinue
        $res = Get-InstalledPSResource -Name $testModuleName -Version "0.0.1"
        $res.Name | Should -Be $testModuleName
        $res.Version | Should -Be "0.0.1"
    }

    It "Uninstall prerelease version script when prerelease version specified" {
        Install-PSResource -Name $testScriptName -Version "3.0.0-alpha" -Repository $PSGalleryName -TrustRepository
        Uninstall-Script -Name $testScriptName -RequiredVersion "3.0.0-alpha"
        $res = Get-InstalledPSResource -Name $testScriptName
        $res | Should -BeNullOrEmpty
    }

    It "Not uninstall non-prerelease version module when prerelease version specified" {
        Install-PSResource -Name $testScriptName -Version "2.5.0.0" -Repository $PSGalleryName -TrustRepository
        Uninstall-Script -Name $testScriptName -RequiredVersion "2.5.0-alpha001" -ErrorAction SilentlyContinue
        $res = Get-InstalledPSResource -Name $testScriptName -Version "2.5.0.0"
        $res.Name | Should -Be $testScriptName
        $res.Version | Should -Be "2.5"
    }

    $testCases = @{Name="Test?Module";      ErrorId="ErrorFilteringNamesForUnsupportedWildcards"},
    @{Name="Test[Module";      ErrorId="ErrorFilteringNamesForUnsupportedWildcards"}

    It "not uninstall module given Name with invalid wildcard characters" -TestCases $testCases {
        param($Name, $ErrorId)
        Uninstall-Module -Name $Name -ErrorVariable err -ErrorAction SilentlyContinue
        $err.Count | Should -Not -Be 0
        $err[0].FullyQualifiedErrorId | Should -BeExactly "$ErrorId,Microsoft.PowerShell.PowerShellGet.Cmdlets.UninstallPSResource"
        }

        It "Uninstall a list of modules by name" {
        $null = Install-PSResource "testmodule99" -Repository $PSGalleryName -TrustRepository -WarningAction SilentlyContinue -SkipDependencyCheck

        Uninstall-Module -Name $testModuleName, "testmodule99" 
        Get-InstalledPSResource $testModuleName, "testmodule99" | Should -BeNullOrEmpty
    }

    It "Uninstall a specific script by name" {
        $null = Install-PSResource $testScriptName -Repository $PSGalleryName -TrustRepository
        $res = Get-InstalledPSResource -Name $testScriptName
        $res.Name | Should -Be $testScriptName

        Uninstall-Script -Name $testScriptName
        $res = Get-InstalledPSResource -Name $testScriptName
        $res | Should -BeNullOrEmpty
    }

    It "Uninstall a list of scripts by name" {
        $null = Install-PSResource $testScriptName, "Required-Script1" -Repository $PSGalleryName -TrustRepository
        $res = Get-InstalledPSResource -Name $testScriptName
        $res.Name | Should -Be $testScriptName
        $res2 = Get-InstalledPSResource -Name "Required-Script1"
        $res2.Name | Should -Be "Required-Script1"

        Uninstall-Script -Name $testScriptName, "Required-Script1"
        $res = Get-InstalledPSResource -Name $testScriptName
        $res | Should -BeNullOrEmpty
        $res2 = Get-InstalledPSResource -Name "Required-Script1"
        $res2 | Should -BeNullOrEmpty
    }

    It "Uninstall module using -WhatIf, should not uninstall the module" {
        Uninstall-Module -Name $testModuleName -WhatIf
        $pkg = Get-InstalledPSResource $testModuleName
        $pkg.Version | Should -Be "0.0.93"
    }

    It "Do not Uninstall module that is a dependency for another module" {
        $null = Install-PSResource "test_module" -Repository $PSGalleryName -TrustRepository -WarningAction SilentlyContinue

        Uninstall-Module -Name "RequiredModule1" -ErrorVariable ev -ErrorAction SilentlyContinue

        $pkg = Get-InstalledPSResource "RequiredModule1"
        $pkg | Should -Not -Be $null

        $ev.FullyQualifiedErrorId | Should -BeExactly 'UninstallPSResourcePackageIsaDependency,Microsoft.PowerShell.PowerShellGet.Cmdlets.UninstallPSResource', 'UninstallResourceError,Microsoft.PowerShell.PowerShellGet.Cmdlets.UninstallPSResource'
    }

    It "Uninstall PSResourceInfo object piped in" {
        $version = "0.0.93" 
        Install-PSResource -Name $testModuleName -Version $version -Repository $PSGalleryName -TrustRepository
        Get-InstalledPSResource -Name $testModuleName -Version $version | Uninstall-Module
        $res = Get-InstalledPSResource -Name $testModuleName  -Version $version
        $res | Should -BeNullOrEmpty
    }

    It "Uninstall PSResourceInfo object piped in for prerelease version object" {
        Install-PSResource -Name $testModuleName -Version "1.0.0-beta2" -Repository $PSGalleryName -TrustRepository
        Get-InstalledPSResource -Name $testModuleName -Version "1.0.0-beta2" | Uninstall-Module
        $res = Get-InstalledPSResource -Name $testModuleName -Version "1.0.0-beta2"
        $res | Should -BeNullOrEmpty
    }

    It "Uninstall module that is not installed should throw error" {
        Uninstall-Module -Name "NonInstalledModule" -ErrorVariable ev -ErrorAction SilentlyContinue
        $ev.FullyQualifiedErrorId | Should -BeExactly 'UninstallResourceError,Microsoft.PowerShell.PowerShellGet.Cmdlets.UninstallPSResource'
    }
}

# Ensure that PSGet v2 was not loaded during the test via command discovery
$PSGetVersionsLoaded = (Get-Module powershellget).Version
Write-Host "PowerShellGet versions currently loaded: $PSGetVersionsLoaded"
if ($PSGetVersionsLoaded.Count -gt 1) {
    throw  "There was more than one version of PowerShellGet imported into the current session. `
        Imported versions include: $PSGetVersionsLoaded"
}