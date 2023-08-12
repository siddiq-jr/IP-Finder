@echo off 

setlocal
:: The Tool will first go to User input function. 
goto :User_input

:: This is the description & Usage of the tool "Help"
:Usage
    cls
    echo ***********************************************************************************
    echo                        IP-Finder Application - By Siddiq Jr 
    echo ***********************************************************************************
    echo.
    echo Description :
    echo *************
    echo.
    echo App Will Find all Active Addresses in Range /24 and print on screen
    echo and able to collect active address into a list 
    echo.
    echo usage :
    echo ******* 
    echo.
    echo ip-finder                             Will Show this Help Menu
    echo IP-FINDER ^<address^>                 Will scan ^for active addresses in range /24
    echo IP-FINDER ^<address^> ^> file.txt     Will Save the output into a list File
    echo.
    echo Examples:
    echo *********
    echo.
    echo IP-FINDER 192.168.1
    echo IP-FINDER 192.168.1 ^> IP-LIST.txt
    echo.
    echo Use For Good Only !
    echo Author is not responsible for any illegal usage of the application.
    echo ***********************************************************************************
    goto :eof

:: User Input Function Takes the second argument and check for IP-Address Validity, then Sends it to The Next Function.
:User_input
    set arg=%~1
    echo %arg% > Empty_Check.tmp
    for /l %%i in (1,1,1) do (
       type Empty_Check.tmp | find "ECHO is off." > If_Empty.tmp
       set /p argument=<If_Empty.tmp
    )
    del Empty_Check.tmp If_Empty.tmp
    if "%argument%"=="ECHO is off." (
       goto :Usage
       goto :eof
    ) else (
       goto :Check_Addess
    )

:: Check address function will check for the ip address rules and "192.168.43" format.
:Check_Addess
    rem This Get's the argument and divide it via " . " delimiter to Three Sections, and Set each section to a variable.
    echo %arg% > arg.tmp
    for /f "tokens=1,2,3,4,* delims=." %%a in (arg.tmp) do (
        echo %%a > sec1.tmp
        echo %%b > sec2.tmp
        echo %%c > sec3.tmp
       set /p sec1=< sec1.tmp
       set /p sec2=< sec2.tmp
       set /p sec3=< sec3.tmp
       del sec1.tmp sec2.tmp sec3.tmp
    )
    rem delete the temp arguments file
    del arg.tmp
    rem this check each section for validity range (0 - 256).
    set emp=ECHO is off.
    if "%sec1%"=="%emp%" ( 
        goto :warning 
        )
    if %sec1% LEQ 256 (
         echo ok >nul
         ) else (
             goto :warning 
                )
       
    if "%sec2%"=="%emp%" (
         goto :warning 
         )
    if %sec2% LEQ 256 (
         echo ok >nul
         ) else (
             goto :warning 
                )
       
    if "%sec3%"=="%emp%" (
         goto :warning 
         )
    if %sec3% LEQ 256 (
        echo ok >nul
        goto :Ping_Func
     ) else (
       goto :warning
     )

:: This function shows only if there is an invalid input from user. 
:warning
    cls
    echo ***********************************************************************************
    echo                        IP-Finder Application - By Siddiq Jr 
    echo ***********************************************************************************
    echo.
    echo.
    echo.
    echo                            IP-Address Is Not Valid !
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    timeout /t 3 >nul
    goto :Usage

:: Setup Function Will Be Part Of The Ping Function Code.
:setup
    set adress=%arg%
    rem The Below 2 lines are to test this batch only, will be deleted in the full application
    echo ip Add = %arg%
    echo Here is the pinging process is done!
    goto :eof
endlocal