`timescale 1ns/1ps

module SPI_slave_tb();
    
    reg [9:0] tx_data;
    reg ss_n, rst_n, clk, tx_valid, MOSI;
    wire [9:0] rx_data;
    wire rx_valid, MISO;

    SPI_slave uut (
        .tx_data(tx_data),
        .ss_n(ss_n),
        .rst_n(rst_n),
        .clk(clk),
        .tx_valid(tx_valid),
        .MOSI(MOSI),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .MISO(MISO)
    );
    
    // Clock generation
    initial begin clk=0;forever #5 clk=~clk ;end
    
    initial begin
        // Initialize signals and test reset
        tx_data=0;
        tx_valid=0;
        ss_n=1;
        MOSI=0;
        rst_n=0;
        @(negedge clk);
        rst_n=1;
        //test check state
        ss_n=0; //master ask to communicate and go from check to write
        //repeat(15)@(negedge clk);
        MOSI=1;
        repeat(15)@(negedge clk);
        ss_n=1;
        @(negedge clk);
        ss_n=0;
        @(negedge clk);
        MOSI=1;
        repeat(15)@(negedge clk);
        $stop;
    end
    
    // Monitor signals
    initial begin
        $monitor("Time = %0t | ss_n = %b | MOSI = %b | rx_data = %b | rx_valid = %b | MISO = %b", 
                 $time, ss_n, MOSI, rx_data, rx_valid, MISO);
    end
    
endmodule
