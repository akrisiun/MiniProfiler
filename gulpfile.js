// gulp build
// # yarn add gulp-dotnet-cli --save-dev
// # yarn add child-process-promise --save-dev

var port = "8001";

var gulp = require('gulp');
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
    
    //var pipe = gulp.src('**/*.sln', {read: false})
    //    .pipe(build({configuration: "Debug"}));
    var pipe = gulp.src('**/*.csproj', {read: false})
        .pipe(restore());

    var calculatedArgs = ["build", "--no-dependencies", "src/MiniProfiler.Shared"];
    // pipe = pipe.pipe(
    cp.spawn("dotnet", calculatedArgs, options);
    calculatedArgs = ["build", "--no-dependencies", "src/MiniProfiler"];

    var calculatedArgs = ["build", "--no-dependencies", "src/MiniProfiler.Mvc5"];
    cp.spawn("dotnet", calculatedArgs, options);
    var calculatedArgs = ["build", "--no-dependencies", "src/MiniProfiler.EntityFrameworkCore"];
    cp.spawn("dotnet", calculatedArgs, options);
    var calculatedArgs = ["build", "--no-dependencies", "src/MiniProfiler.Providers.SqlServer"];
    cp.spawn("dotnet", calculatedArgs, options);
    
    calculatedArgs = ["build", "--no-dependencies", "wwwroot"];
    cp.spawn("dotnet", calculatedArgs, options);
    return pipe;
});

gulp.task('pack', [], ()=>{
    var calculatedArgs = ["-file", "./pack.ps1"];
    cp.spawn("powershell", calculatedArgs, options);
});

gulp.task('iis', [], ()=>{

    var calculatedArgs = ["/port:" + port, "/clr:4.0", "/systray:true", "/path:" + __dirname 
        + "\\wwwroot"];
        
    console.log("iisexpress " + calculatedArgs);
    cp.spawn("C:\\Program Files\\IIS Express\\iisexpress.exe", calculatedArgs, options);
});

gulp.task('test', [], () => {
    // dotnet test -v n --no-build --no-restore
    // var calculatedArgs = ["/c", "test.cmd"];
    var calculatedArgs = ["test", "-v", "n", "--no-build", "--no-restore"];
    cp.spawn("dotnet", calculatedArgs, options);
});
