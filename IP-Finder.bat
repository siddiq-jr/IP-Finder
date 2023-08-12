@echo off 

:: this will size the window to the correct size and change the color to green for the application.
mode 84 , 30
color 2
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
    echo IP-FINDER ^<address^>                 Will scan ^for active Addresses in range /24
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
        goto :setup
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

:: This is the setup function, create all needed folders, and will contain the variables needed from the user input function
:setup
    set adress=%arg%
    mkdir FINDER >nul
    mkdir FINDER\TMP >nul
    mkdir FINDER\TMP\SUB >nul
    goto :Ping_Func

::Here will check for all active addresses.
:Ping_Func
    for /l %%i in (0,1,256) do (
       echo %adress%.%%i >> FINDER\TMP\addresses.tmp
    )

:: This is the main ping/check loop, will check for all active addressess. 
    :loop
        rem loop function will handle the addresses list and ping all address one by one.
        for /f %%i in (FINDER\TMP\addresses.tmp) do (
           set add=%%i
           type FINDER\TMP\addresses.tmp | find /c "." > FINDER\TMP\count.tmp
           set /p count=<FINDER\TMP\count.tmp
           del FINDER\TMP\count.tmp

           ping -n 1 -w 1 %%i > FINDER\TMP\pinging.tmp
    
           more +1 FINDER\TMP\addresses.tmp > FINDER\TMP\SUB\addresses.tmp
           del FINDER\TMP\addresses.tmp
           move FINDER\TMP\SUB\addresses.tmp FINDER\TMP\addresses.tmp >nul
           goto :CheckIfEmpty
        )

       :CheckIfEmpty
          rem This will check if there is an address in the list first, and not empty.
          if "%count%"=="1" (
             goto :cleaning
          ) else (
             goto :Pinging
          )
   
       :Pinging
           rem This will ping the first address and delete it from the list after setting variables of valid and invalid addresses.
           for /f "skip=1 tokens=3,* delims==" %%i in (FINDER\TMP\pinging.tmp) do (
             type FINDER\TMP\pinging.tmp | find /c "64" > FINDER\TMP\up.tmp
             type FINDER\TMP\pinging.tmp | find /c "0, Lost" > FINDER\TMP\down.tmp
             set /p up=<FINDER\TMP\up.tmp
             set /p down=<FINDER\TMP\down.tmp
             goto :condition
           )
       
       :condition
          rem This will check if the tested address is valid (if Up), and go to check (if down).
          :stat-up
             if "%up%"=="1" (
                echo %add%
                goto :loop
             ) else (
                goto :stat-down
             )
          rem This will check if the tested address not valid (is down).
          :stat-down
             if "%down%"=="1" (
                goto :loop
             ) else (
                goto :loop
             )

:: This is the cleaning Function To delete all temp files and folders. 
:cleaning
    rmdir /s /q FINDER
endlocal