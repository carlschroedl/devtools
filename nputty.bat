@echo off
setlocal

REM 	first check to see if host is available

	ping -n 1 cschroedldev | grep "Reply from .*: bytes=" > __tmp_nputty_file 

	set /p host= < __tmp_nputty_file

	del __tmp_nputty_file

	REM if the ping command was unsuccesful, skip rest of batch

IF "" == "%host%" GOTO ErrMachineNotExist


REM Now check argument values
	IF %1 LSS 1 GOTO ErrTooSmall

	IF %1 GTR 10 GOTO ErrTooBig

	FOR /L %%G IN (1,1,%1) do (

		REM	this starts a new connection ignoring saved sessions
		REM	START putty xes@cschroedldev

		REM	this loads a previously saved session
		START putty -load "cschroedldev"
	)
GOTO EOF



:ErrMachineNotExist
	ECHO Machine is not on the network.
	GOTO X

:ErrTooBig
	ECHO NO - ONLY 10 at a time
	GOTO X

:ErrTooSmall
	ECHO arg must be > 1

:X
	ECHO Exiting.

:EOF