$v =  "2.2.0-beta1"       # 7.7-beta7"
$vapi = "1.2.0-beta1"     # 7-beta5"

del src/Sanitex.MvcHttp/obj/project.assets.json 
dotnet restore src/Sanitex.MvcCtrl/Sanitex.MvcCtrl.csproj
dotnet restore src/Sanitex.MvcHttp/Sanitex.MvcHttp.csproj

# nuget pack src/Sanitex.MvcHttp/Sanitex.MvcHttp.nuspec  -Verbosity quiet -Symbols -OutputDirectory . -version

dotnet build src/Sanitex.MvcCtrl/Sanitex.MvcCtrl.csproj

# OutDir -> target CopyFilesToOutputDirectory
dotnet build src/Sanitex.MvcHttp/Sanitex.MvcHttp.csproj -o $PWD/lib
dotnet build src/Sanitex.MvcHttp/Sanitex.MvcHttp.csproj -o $PWD\src\Sanitex.MvcHttp\bin\Debug\net451

dotnet build src/Sanitex.MvcCtrl/Sanitex.MvcCtrl.csproj -o $PWD/lib
dotnet build src/Sanitex.HttpApi/Sanitex.HttpApi.csproj -o $PWD/lib

nuget pack src/Sanitex.MvcHttp/Sanitex.MvcHttp.nuspec  -Verbosity quiet -Symbols -version $v -OutputDirectory .

nuget pack src/Sanitex.MvcCtrl/Sanitex.MvcCtrl.nuspec  -Verbosity quiet -Symbols -version $v -OutputDirectory .

nuget pack src/Sanitex.HttpApi/Sanitex.HttpApi.nuspec  -Build -Verbosity quiet -version  $vapi -Symbols -OutputDirectory .
nuget pack src/Sanitex.MvcAuth/Sanitex.MvcAuth.nuspec  -Build -Verbosity quiet -Symbols -OutputDirectory .

# get-childitem src/*.nupkg
# Copy-Item src/Sanitex.HttpApi/bin/Debug/*.nupkg  . -force

# Copy-Item $PWD/Sanitex.MvcHttp.2.1.7.7-beta2.nupkg              
Copy-Item $PWD/Sanitex.MvcHttp.$v.nupkg              c:\Work_Exe\NugetPackages\
Copy-Item $PWD/Sanitex.MvcHttp.$v.symbols.nupkg      c:\Work_Exe\NugetPackages\
Copy-Item $PWD/Sanitex.MvcCtrl.$v.nupkg              c:\Work_Exe\NugetPackages\
Copy-Item $PWD/Sanitex.MvcCtrl.$v.symbols.nupkg      c:\Work_Exe\NugetPackages\

Copy-Item $PWD/Sanitex.HttpApi.$vapi.symbols.nupkg      c:\Work_Exe\NugetPackages\
Copy-Item $PWD/Sanitex.HttpApi.$vapi.symbols.nupkg      c:\Work_Exe\NugetPackages\

dotnet build test\defaultOwin\DefaultOwin.csproj  -o $PWD/lib