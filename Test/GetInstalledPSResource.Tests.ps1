# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

$ProgressPreference = "SilentlyContinue"
$modPath = "$psscriptroot/../PSGetTestUtils.psm1"
Import-Module $modPath -Force -Verbose
Write-Verbose -Verbose -Message "PowerShellGet version currently loaded: $($(Get-Module powershellget).Version)"

Describe 'Test CompatPowerShellGet: Get-InstalledPSResource' -tags 'CI' {

    BeforeAll{
        $PSGalleryName = Get-PSGalleryName
        $testModuleName = "testmodule99"
        $testScriptName = "test_script"
        Get-NewPSResourceRepositoryFile
        Set-PSResourceRepository PSGallery -Trusted

        Install-PSResource -Name $testModuleName -Repository $PSGalleryName
        Install-PSResource -Name $testModuleName -Repository $PSGalleryName -Version "0.0.1"
        Install-PSResource -Name $testModuleName -Repository $PSGalleryName -Version "0.0.2"
        Install-PSResource -Name $testModuleName -Repository $PSGalleryName -Version "0.0.3"
        Install-PSResource -Name $testScriptName -Repository $PSGalleryName -SkipDependencyCheck
    }

    AfterAll {
        Uninstall-PSResource -Name $testModuleName -Version "*" -ErrorAction SilentlyContinue
        Uninstall-PSResource -Name $testScriptName -Version "*" -ErrorAction SilentlyContinue
        Get-RevertPSResourceRepositoryFile
    }

    It "Get-InstalledModule with MinimumVersion available" {        
        $res = Get-InstalledModule -Name $testModuleName -MinimumVersion "0.0.1"
        $res.Count | Should -BeGreaterThan 1   
        foreach ($pkg in $res)
        {
            $pkg.Version | Should -BeGreaterOrEqual ([System.Version] "0.0.1")
        }
    }

    It "Get-InstalledScript with MinimumVersion available" {        
        $res = Get-InstalledScript -Name $testScriptName -MinimumVersion "1.0.0"
        $res.Count | Should -BeGreaterOrEqual 1     
        foreach ($pkg in $res)
        {
            $pkg.Version | Should -BeGreaterOrEqual ([System.Version] "1.0.0")
        }    
    }

    It "Get-InstalledModule with MinimumVersion not available" {        
        $res = Get-InstalledModule -Name $testModuleName -MinimumVersion "1.0.0"
        $res | Should -HaveCount 0    
    }

    It "Get-InstalledModule with min/max range" {
        $res = Get-InstalledModule -Name $testModuleName -MinimumVersion "0.0.15" -MaximumVersion "0.0.25" 
        foreach ($pkg in $res)
        {
            $pkg.Version | Should -BeGreaterOrEqual ([System.Version] "0.0.2")
        }       
    }

    It "Get-InstalledModule with -RequiredVersion" {
        $version = "0.0.2"
        $res = Get-InstalledModule -Name $testModuleName -RequiredVersion $version
        $res.Version | Should -Be $version    
    }
    
    It "Get prerelease version module when version with correct prerelease label is specified" {
        Install-PSResource -Name $testModuleName -Version "1.0.0-beta2" -Repository $PSGalleryName
        $res = Get-InstalledModule -Name $testModuleName -RequiredVersion "1.0.0"
        $res | Should -BeNullOrEmpty
        $res = Get-InstalledModule -Name $testModuleName -RequiredVersion "1.0.0-beta2"
        $res.Name | Should -Be $testModuleName
        $res.Version | Should -Be "1.0.0"
        $res.Prerelease | Should -Be "beta2"
    }

    It "Get prerelease version script when version with correct prerelease label is specified" {
        Install-PSResource -Name $testScriptName -Version "3.0.0-alpha" -Repository $PSGalleryName -TrustRepository
        $res = Get-InstalledScript -Name $testScriptName -RequiredVersion "3.0.0"
        $res | Should -BeNullOrEmpty
        $res = Get-InstalledScript -Name $testScriptName -RequiredVersion "3.0.0-alpha"
        $res.Name | Should -Be $testScriptName
        $res.Version | Should -Be "3.0.0"
        $res.Prerelease | Should -Be "alpha"
    }

    It "Get-InstalledModule with Wildcard" {
        $module = Get-InstalledModule -Name "testmodule9*"
        $module.Count | Should -BeGreaterOrEqual 3   
    }

    It "Get-InstalledModule with Wildcard" {
        $module = Get-InstalledScript -Name "test_scri*"
        $module.Count | Should -BeGreaterOrEqual 1
    }
    
    It "Get modules without any parameter values" {
        $pkgs = Get-InstalledScript
        $pkgs.Count | Should -BeGreaterThan 1
    }

    It "Get scripts without any parameter values" {
        $pkgs = Get-InstalledModule
        $pkgs.Count | Should -BeGreaterThan 1
    }

    It "Get specific module resource by name" {
        $pkg = Get-InstalledModule -Name $testModuleName
        $pkg.Name | Should -Contain $testModuleName
    }

    It "Get specific script resource by name" {
        $pkg = Get-InstalledScript -Name $testScriptName
        $pkg.Name | Should -Be $testScriptName
    }

    It "Get resource when given Name to " {
        $pkgs = Get-InstalledModule -Name "*estmodul*"
        $pkgs.Name | Should -Contain $testModuleName
    }

    It "Get resource when given Name to <Reason>" -TestCases @(
        @{Name="*estmodul*";    Reason="validate name, with wildcard at beginning and end of name: *estmodul*"},
        @{Name="testmod*";      Reason="validate name, with wildcard at end of name: testmod*"},
        @{Name="*estmodule99";  Reason="validate name, with wildcard at beginning of name: *estmodule99"},
        @{Name="tes*ule99";     Reason="validate name, with wildcard in middle of name: tes*ule99"}
    ) {
        param($Name)
        $pkgs = Get-InstalledModule -Name $Name
        $pkgs.Name | Should -Contain $testModuleName
    }
}

# Ensure that PSGet v2 was not loaded during the test via command discovery
$PSGetVersionsLoaded = (Get-Module powershellget).Version
Write-Host "PowerShellGet versions currently loaded: $PSGetVersionsLoaded"
if ($PSGetVersionsLoaded.Count -gt 1) {
    throw  "There was more than one version of PowerShellGet imported into the current session. `
        Imported versions include: $PSGetVersionsLoaded"
}