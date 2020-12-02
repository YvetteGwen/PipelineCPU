@echo off
set xv_path=D:\\Program\\xilinx_vivado\\Vivado\\2015.3\\bin
call %xv_path%/xsim pipelineCPU_sim_behav -key {Behavioral:sim_1:Functional:pipelineCPU_sim} -tclbatch pipelineCPU_sim.tcl -view D:/A_GW/Courses/Computer_organization/lab/vivado/PipelineCPU/pipelineCPU_sim_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
