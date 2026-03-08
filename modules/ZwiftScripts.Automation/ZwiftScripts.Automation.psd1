@{
    RootModule        = 'ZwiftScripts.Automation.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '2d8d2de7-0a76-4cf1-a44f-6d0efdbddb15'
    Author            = 'Nick2bad4u'
    CompanyName       = 'Personal Project'
    Copyright         = '(c) 2025 Nick. All rights reserved.'
    Description       = 'Automation helpers for ZwiftScripts (preflight, timeouts, logging, OBS control).'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Invoke-MonitorZwift',
        'Invoke-ZwiftPreflight'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            ProjectUri = 'https://github.com/Nick2bad4u/ZwiftScripts'
            LicenseUri = 'https://opensource.org/licenses/MIT'
            Tags       = @('Zwift', 'PowerShell', 'Automation', 'OBS', 'FreeFileSync', 'PowerToys')
        }
    }
}
