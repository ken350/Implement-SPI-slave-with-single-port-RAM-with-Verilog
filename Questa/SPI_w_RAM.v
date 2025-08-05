module SPI_w_RAM #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
)(
    output MISO,
    input MOSI,
    input rst_n , ss_n , clk
);

wire[9:0]w1_rx_data;
wire[7:0]w2_tx_data;
wire w3_tx_valid , w4_rx_valid;

//connecting modules

SPI_slave S1(
    .tx_data(w2_tx_data),
    .ss_n(ss_n),
    .rst_n(rst_n),
    .clk(clk),
    .tx_valid(w3_tx_valid),
    .MOSI(MOSI),
    .rx_data(w1_rx_data), 
    .rx_valid(w4_rx_valid),
    .MISO(MISO)
);

RAM #(
    .MEM_DEPTH(MEM_DEPTH),
    .ADDR_SIZE(ADDR_SIZE)
)R1(
    .din(w1_rx_data),
    .clk(clk),
    .rst_n(rst_n),
    .rx_vaild(w4_rx_valid),
    .dout(w2_tx_data),
    .tx_valid(w3_tx_valid)
);

endmodule