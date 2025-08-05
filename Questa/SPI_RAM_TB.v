module SPI_RAM_TB();
    
    //signal declaration
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    wire MISO;
    reg MOSI;
    reg rst_n , ss_n , clk;

    //free running clk
    initial begin clk=0;forever #5 clk=~clk;end

    //DUT instantiation
    SPI_w_RAM SM1(.*);

    //test stimulus generator
    initial begin
        
        //initialize ram and mosi and ss_ n
        $readmemh("mem.dat",SM1.R1.mem); 
        MOSI=0;
        ss_n=1;
        
        //testing rst
        rst_n=0;
        @(negedge clk);
        rst_n=1;
        ss_n=0;
        
        @(negedge clk);

        //testing read op (provide address)
        MOSI=1; //control signal from master
        @(negedge clk);
        MOSI=1;
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        repeat(8)begin
            MOSI=$random;
            @(negedge clk);
        end

        ss_n=1; // backe to IDLE
        @(negedge clk);
        ss_n=0; // master want to communicate again
        @(negedge clk);

        //testing read op (read data)
        MOSI=1; //control signal from master 
        @(negedge clk);
        MOSI=1;
        @(negedge clk);
        MOSI=1;
        @(negedge clk);
        repeat(20)begin //dummy data
            MOSI=$random;
        @(negedge clk);
        end

        ss_n=1; // back to IDLE
        @(negedge clk)
        ss_n=0; // master want to communicate again
        @(negedge clk);

        //testing write op (address)
        MOSI=0; //control signal 
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        repeat(8)begin 
            MOSI=$random;
        @(negedge clk);
        end

        ss_n=1; // back to IDLE
        @(negedge clk)
        ss_n=0; // master want to communicate again
        @(negedge clk);

        //testing write op (data)
        MOSI=0; //control signal 
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        MOSI=1;
        @(negedge clk);
        repeat(9)begin 
            MOSI=1;
        @(negedge clk);
        end







        $stop;
    end
endmodule