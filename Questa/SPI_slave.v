module SPI_slave(
    input [7:0] tx_data,
    input ss_n, rst_n, clk, tx_valid, MOSI,
    output reg [9:0] rx_data, 
    output reg rx_valid, MISO
);
    reg check_read=0;

    //counter declaration
    reg[3:0] counter;

    //flip_flops
    reg[2:0] cs, ns;

    //states assignment
    parameter IDLE      = 3'b000,
              CHK_CMD   = 3'b001,
              WRITE     = 3'b010,
              READ_DATA = 3'b011,
              READ_ADD  = 3'b100;

    //Dff model
    always @(posedge clk)
        if(!rst_n)begin
            cs <= IDLE;
            
        end
        else begin
            cs <= ns;
        end

    //next state logic
    always@(*)begin
        case(cs)
            IDLE: begin
                if(ss_n == 1)
                    ns = IDLE;
                else    
                    ns = CHK_CMD;
            end 
            CHK_CMD: begin
                case({check_read, MOSI})
                    2'b00,2'b10: 
                        ns = WRITE;
                    2'b01:
                        ns = READ_ADD;
                    2'b11:
                        ns = READ_DATA;
                endcase
            end
            WRITE: begin
                if(ss_n==0)
                    ns = WRITE;
                else 
                    ns = IDLE;
            end
            READ_ADD: begin
                if(ss_n==0)
                    ns = READ_ADD;
                else
                    ns = IDLE;
            end
            READ_DATA: begin
                if(ss_n==0)
                    ns = READ_DATA;
                else 
                    ns = IDLE;
            end
            default: ns = IDLE; 
        endcase
    end

    

    //output logic
    always@(posedge clk)begin
        if (!rst_n)begin
            rx_data <= 0;
            rx_valid <= 0;
            check_read <= 0;
            MISO <= 0;
            counter <= 0;
        end
        else begin    
            case(cs)
                IDLE:
                    begin
                        rx_data <= 0;
                        rx_valid<=0;
                        MISO <= 0;
                    end

                CHK_CMD:
                    begin
                        rx_data <= 0;
                        rx_valid <= 0;
                        MISO <= 0;
                    end

                WRITE: begin
                    rx_data <= {rx_data[8:0],MOSI};
                    counter <= counter+1;
                    if(counter == 10)begin
                        rx_valid <= 1;
                        counter <= 0;
                    end
                    else
                        rx_valid <= 0;
                end

                READ_ADD: begin
                    rx_data <= {rx_data[8:0],MOSI};
                    counter <= counter+1;
                    if(counter == 10)begin
                        rx_valid <= 1;
                        counter <= 0;
                        check_read <=  1; /// flag to know if it's ( address or data )
                    end
                    else
                        rx_valid <= 0;
                end

                READ_DATA: begin
                    rx_data <= {rx_data[8:0],MOSI};
                    counter <= counter+1;
                    if(counter == 10)begin
                        rx_valid <= 1;
                        counter <= 0;
                        check_read <=  1; /// flag to know if it's ( address or data )
                    end
                    else
                        rx_valid <= 0;

                    if((tx_valid==1)&&(counter<7||counter==7))
                        MISO <= tx_data[7-counter];
                    else
                        MISO<=0;
                    end
            endcase
        end
    end



endmodule