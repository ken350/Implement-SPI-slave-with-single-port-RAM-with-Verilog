vlib work
vlog SPI_slave.v  memory.v SPI_w_RAM.v SPI_RAM_TB.v
vsim -voptargs=+acc work.SPI_RAM_TB
add wave *
run -all 