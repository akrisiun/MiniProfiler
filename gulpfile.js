// gulp build
// # yarn add gulp-dotnet-cli --save-dev
// # yarn add child-process-promise --save-dev

var port = "8040";

var gulp = require('gulp');
// let {restore, build, test, pack, publish} 
var restore = require('gulp-dotnet-cli').restore;
var build = require('gulp-dotnet-cli').build;
var cp = require('child-process-promise');
var options = { "stdio": "inherit" };
var PWD = __dirname;

gulp.task('all', ['restore', 'build', 'iis'], () => { });
gulp.task('restore', ()=>{
    return gulp.src('**/*.csproj', {read: false})
            .pipe(restore());
});

gulp.task('build', [], ()=>{
    
    var pipe = gulp.src('**/*.sln', {read: false})
        .pipe(build({configuration: "Debug"}));

    var calculatedArgs = ["build", "src/Sanitex.WebMvc.Dx.csproj", "-o", PWD + "\\lib"];
    pipe = pipe.pipe(cp.spawn("dotnet", calculatedArgs, options));
    calculatedArgs = ["build", "src/Sanitex.MvcCtrl/Sanitex.MvcCtrl.csproj", "-o", PWD + "\\lib"];
    pipe = pipe.pipe(cp.spawn("dotnet", calculatedArgs, options));
    calculatedArgs = ["build", "src/Sanitex.MvcHttp/Sanitex.MvcHttp.csproj", "-o", PWD + "\\lib"];
    pipe = pipe.pipe(cp.spawn("dotnet", calculatedArgs, options));
    calculatedArgs = ["build", "src/Sanitex.HttpApi/Sanitex.HttpApi.csproj", "-o", PWD + "\\lib"];
    pipe = pipe.pipe(cp.spawn("dotnet", calculatedArgs, options));
    
    calculatedArgs = ["build", "test/defaultOwin/DefaultOwin.csproj", "-o", PWD + "\\lib"];
    pipe = pipe.pipe(cp.spawn("dotnet", calculatedArgs, options));
    return pipe;
});

gulp.task('pack', [], ()=>{
    var calculatedArgs = ["-file", "./pack.ps1"];
    cp.spawn("powershell", calculatedArgs, options);
});

gulp.task('lib', [], ()=>{
    // dotnet 
    var calculatedArgs = ["build", "test/defaultOwin/DefaultOwin.csproj", "-o", PWD + "\\lib"];
    cp.spawn("dotnet", calculatedArgs, options);

    calculatedArgs = ["build", "src/Sanitex.MvcCtrl/Sanitex.MvcCtrl.csproj", "-o", PWD + "\\lib"];
    cp.spawn("dotnet", calculatedArgs, options);
    calculatedArgs = ["build", "src/Sanitex.MvcHttp/Sanitex.MvcHttp.csproj", "-o", PWD + "\\lib"];
    cp.spawn("dotnet", calculatedArgs, options);

    calculatedArgs = ["build", "src/Sanitex.HttpApi/Sanitex.HttpApi.csproj", "-o", PWD + "\\lib"];
    cp.spawn("dotnet", calculatedArgs, options);

    var dir = PWD + "\\..\\prekes\\lib";
    calculatedArgs = ["build", "src/Sanitex.MvcHttp/Sanitex.MvcHttp.csproj", "-o", dir];
    cp.spawn("dotnet", calculatedArgs, options);

    calculatedArgs = ["build", "src/Sanitex.HttpApi/Sanitex.HttpApi.csproj", "-o", dir];
    cp.spawn("dotnet", calculatedArgs, options);
    
});

gulp.task('iis', [], ()=>{

    var calculatedArgs = ["/port:" + port, "/clr:4.0", "/systray:true", "/path:" + __dirname 
        + "\\test\\defaultOwin"];
    console.log("iisexpress " + calculatedArgs);
    cp.spawn("C:\\Program Files (x86)\\IIS Express\\iisexpress.exe", calculatedArgs, options);
});

gulp.task('test', [], () => {
    // dotnet test -v n --no-build --no-restore
    // var calculatedArgs = ["/c", "test.cmd"];
    var calculatedArgs = ["test", "test/TestWeb/Sanitex.Web.Test.csproj", "-v", "n", "--no-build", "--no-restore"];
    cp.spawn("dotnet", calculatedArgs, options);
});
