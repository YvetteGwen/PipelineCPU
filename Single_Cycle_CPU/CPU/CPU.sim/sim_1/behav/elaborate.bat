@echo off
set xv_path=D:\\Program\\xilinx_vivado\\Vivado\\2015.3\\bin
call %xv_path%/xelab  -wto b39a15f07d504971bcc387e74e81784e -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot top_sim_behav xil_defaultlib.top_sim xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
