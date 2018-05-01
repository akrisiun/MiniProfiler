$v =  "4.0.55"
# ./build -IsBuild 0 -CreatePackages 1

# del src/obj/project.assets.json 
dotnet restore

# nuget pack src/MiniProfiler/MiniProfiler.nuspec  -Verbosity quiet -Symbols -OutputDirectory . -version
# OutDir -> target CopyFilesToOutputDirectory
dotnet build src/MiniProfiler/MiniProfiler.csproj      -o $PWD/lib
dotnet build src/MiniProfiler.Mvc5/MiniProfiler.Mvc5.csproj -o $PWD/lib

# $v =  "4.0.55.beta1"
dotnet pack  src/MiniProfiler.Shared/MiniProfiler.Shared.csproj -o $PWD /p:PackageVersion=$v --include-source
dotnet pack  src/MiniProfiler/MiniProfiler.csproj               -o $PWD /p:PackageVersion=$v --include-source
dotnet pack  src/MiniProfiler.Mvc5/MiniProfiler.Mvc5.csproj     -o $PWD /p:PackageVersion=$v --include-source

# dotnet pack  src/MiniProfiler.Mvc5/MiniProfiler.Mvc5.csproj -o $PWD /p:PackageVersion=4.0.55 --include-source
# get-childitem src/*.nupkg
# Copy-Item src/MiniProfiler/MiniProfiler/bin/Debug/*.nupkg  . -force
# Copy-Item $PWD/MiniProfiler-beta1.nupkg              
# Copy-Item $PWD/MiniProfiler.$v.nupkg     c:\Work_Exe\NugetPackages\