transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/memory_control_unit.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/demux_8.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/mux_16_4inputs.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/mux_8.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/ALU.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/decoder_4to16.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/reg16.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/reg8_inc.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/reg16_inc.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/reg8.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/core.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/regAC.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/control_unit.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/decoder_3to8.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/top.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/IRAM.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/DRAM.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/regCID.v}
vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/mux_32.v}

vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/tb_top.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_top

add wave *
view structure
view signals
run -all
