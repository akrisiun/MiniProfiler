@ECHO http://localhost:58058
set dir=%~dp0Sample.Mvc

"%ProgramFiles%\IIS Express\IISExpress.exe" /port:58058 /path:%dir% /clr:4.0 /systray:true

@PAUSE