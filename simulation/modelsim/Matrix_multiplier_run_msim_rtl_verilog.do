transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/ALU.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/mux_16.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/decoder_4to16.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/reg16.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/reg8_inc.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/reg16_inc.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/reg8.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/core.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/regAC.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/control_unit.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/decoder_3to8.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/top.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/IRAM.v}
vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/DRAM.v}

vlog -vlog01compat -work work +incdir+D:/Academics/Matrix_multiplier {D:/Academics/Matrix_multiplier/tb_top.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_top

add wave *
view structure
view signals
run -all
