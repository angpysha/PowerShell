# first check to see which platform we're on. If we're on windows we should be able
# to be sure whether we're running elevated. If we're on Linux, we can use whoami to
# determine whether we're elevated
Describe "Set-Date" -Tag "CI" {
    BeforeAll {
        $IsElevated = Test-IsElevated
    }

    It "Set-Date should be able to set the date in an elevated context" -Skip:(! $IsElevated) {
        { Get-Date | Set-Date } | Should Not Throw
    }

    It "Set-Date should be able to set the date with -Date parameter" -Skip:(! $IsElevated) {
        $target = Get-Date
        $expected = $target
        Set-Date -Date $target | Should Be $expected
    }

    It "Set-Date should produce an error in a non-elevated context" -Skip:($IsElevated) {
        { Get-Date | Set-Date } | ShouldBeErrorId "System.ComponentModel.Win32Exception,Microsoft.PowerShell.Commands.SetDateCommand"
    }
}
