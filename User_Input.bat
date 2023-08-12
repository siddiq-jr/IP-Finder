@echo off 

setlocal
:: The Tool will first go to User input funnction. 
goto :User_input

:: This is the descrioption & Usage of the tool "Help"
:Usage
    echo Here Code For Usage Description!
    goto :eof

:: User Input Function Takes the seecond argument and check for IP-Address Validity, then Sends it to The Next Function.
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

:: Check address function will check for the ip address rouls and "192.168.43" format.
:Check_Addess
    rem This Get's the argument and devide it via " . " delimeter to Three Sections, and Set each section to a valiable.
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
         echo ok 
         ) else (
             goto :warning 
                )
       
    if "%sec2%"=="%emp%" (
         goto :warning 
         )
    if %sec2% LEQ 256 (
         echo ok 
         ) else (
             goto :warning 
                )
       
    if "%sec3%"=="%emp%" (
         goto :warning 
         )
    if %sec3% LEQ 256 (
        echo ok
        goto :Ping_Func
     ) else (
       goto :warning
     )

:: This function shows only if there is an invalid input from user. 
:warning
    echo IP-Address Is Not Valid!
    goto :eof

:: Setup Function Will Be Part Of The Ping Function Code.
:setup
    set adress=%arg%
    echo ip Add = %arg%
    echo Here is the pinging prossess is done!
    goto :eof
endlocal