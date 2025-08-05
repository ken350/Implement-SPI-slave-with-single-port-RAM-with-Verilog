module RAM(din, clk, rst_n, rx_vaild, dout, tx_valid);

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input [9:0] din;
input clk, rst_n, rx_vaild;

output reg [7:0] dout;
output reg tx_valid;

reg [7:0] mem [MEM_DEPTH-1:0];

reg [7:0] address;

always @(posedge clk) begin
    if (!rst_n)begin
        dout <= 0;
        tx_valid <= 0;
        address<=0;
    end
    else begin
        
            case(din[9:8])
                2'b00: begin
                    if(rx_vaild)begin
                        address <= din[7:0];
                        tx_valid <= 0;
                    end
                end
                2'b01: begin
                    if(rx_vaild)begin
                        mem[address] <= din[7:0];
                        tx_valid <= 0;
                    end
                end
                2'b10:begin
                    if(rx_vaild)begin
                        address <= din[7:0];
                    end
                    tx_valid <= 1;
                end
                2'b11: begin
                    dout <= mem[address];
                    tx_valid <= 1;
                end
                
            endcase
    
    end
end


endmodule