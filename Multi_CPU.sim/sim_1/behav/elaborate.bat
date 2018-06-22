@echo off
set xv_path=E:\\Vivado\\2015.2\\bin
call %xv_path%/xelab  -wto 8dfe94c002874bc19523a2c710e31190 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot cpu_test_behav xil_defaultlib.cpu_test xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
