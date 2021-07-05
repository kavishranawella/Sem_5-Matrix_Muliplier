transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {Matrix_multiplier_7_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier {D:/Academics/FPGA-Matrix_Multiplier/Verilog_modules/Sem_5-Matrix_Muliplier/tb_top.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  tb_top

add wave *
view structure
view signals
run -all
