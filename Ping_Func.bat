@echo off 

setlocal
:: This is the setup function, create all needed folders, and will contain the variables needed from the user input function
:setup
    mkdir FINDER >nul
    mkdir FINDER\TMP >nul
    mkdir FINDER\TMP\SUB >nul
    goto :Ping_Func

::Here will check for all active addressess
:Ping_Func
    rem address var is for test only and will be set automaticly in the full software
    rem remember to change the rang from 3 to 255
    rem address var will be supplied from the previouse function
    set adress=192.168.216
    for /l %%i in (0,1,3) do (
       echo %adress%.%%i >> FINDER\TMP\addresses.tmp
    )

:: This is the main ping/check loop, will check for all active addresess. 
    :loop
        rem loop function will handel the addressess list and ping all address one by one.
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
           rem This will ping the frist adress and delete it from the list after setting variables of valid and invalid addressess.
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
                echo %add% : Is Active !
                goto :loop
             ) else (
                goto :stat-down
             )
          rem This will ckeck if the tested address not valid (is down).
          :stat-down
             if "%down%"=="1" (
                goto :loop
             ) else (
                goto :loop
             )

:: This is the cleaning Function To delete all temp files and folders. 
:cleaning
    echo This is cleaning function
    rmdir /s /q FINDER
endlocal 