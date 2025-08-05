
module RAM_tb;

    reg [9:0] din;
    reg clk, rst_n, rx_vaild;
    wire [7:0] dout;
    wire tx_valid;
    
    // Instantiate the RAM module
    RAM uut (
        .din(din),
        .clk(clk),
        .rst_n(rst_n),
        .rx_vaild(rx_vaild),
        .dout(dout),
        .tx_valid(tx_valid)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        din = 10'b0;
        rx_vaild = 0;
        
        // Reset the RAM
        #10 rst_n = 1;
        
        // Preload memory from file
        $readmemh("mem.dat", uut.mem);
        
        // Write address 8'h05
        #10 din = {2'b00, 8'h06}; rx_vaild = 1;
        #10 rx_vaild = 0;
        
        // Write data 8'hA3 to address 8'h05
        #10 din = {2'b01, 8'hA3}; rx_vaild = 1;
        #10 rx_vaild = 0;
        
        // Read from address 8'h05
        #10 din = {2'b10, 8'h06}; rx_vaild = 1;
        #10 rx_vaild = 0;
        
        // Output the stored value
        #10 din = {2'b11, 8'h00}; rx_vaild = 1;
        #10 rx_vaild = 0;
        
        // End of test
        #50;
        $finish;
    end
    
    // Monitor signals
    initial begin
        $monitor("Time = %t, din = %b, dout = %b, tx_valid = %b", $time, din, dout, tx_valid);
    end
    
endmodule
