$private:packagelist = $(
    [pscustomobject]@{
        Name = 'rconsharp'
        FilePath = '/lib/netstandard2.1/rconsharp.dll'
    }
    [pscustomobject]@{
        Name = 'system.io.pipelines'
        FilePath = '/lib/netstandard2.0/system.io.pipelines.dll'
        Version = '4.7.2'
    }
)

foreach ($private:packagelistItem in $private:packagelist) {
    $private:packageExtraArgs = @{}
    if ($private:packagelistItem.Version){
        $private:packageExtraArgs.RequiredVersion = $private:packagelistItem.Version
    }
    $private:PackageSearch = Get-Package -Name $private:packagelistItem.Name @private:packageExtraArgs | Select-Object -First 1
    if (-not $private:PackageSearch) {
        # install from nuget
        Write-Warning "Package $($private:packagelistItem.Name) not installed, attmepting to fetch from nuget.org"
        $private:PackageSearch = Install-Package -Name $private:packagelistItem.Name @private:packageExtraArgs -SkipDependencies -Scope CurrentUser
        $private:PackageSearch = Get-Package -Name $private:packagelistItem.Name @private:packageExtraArgs | Select-Object -First 1
    }

    if (-not $private:PackageSearch) {
        Write-Error "Failed to find or install required package $($private:packagelistItem.Name). Please install with 'Install-Package -Name $($private:packagelistItem.Name)'"
        continue
    }

    Add-Type -LiteralPath ((Split-Path -Path $private:PackageSearch.Source -Parent) + $private:packagelistItem.FilePath)
}