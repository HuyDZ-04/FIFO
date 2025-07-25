`timescale 1ns / 1ps

module tb;

    // Inputs
    reg clk;
    reg rst;
    reg readsig;
    reg writesig;
    reg [7:0] datain;

    // Outputs
    wire full;
    wire [4:0] length;
    wire empty;
    wire [7:0] dataout;
	   // Instantiate the Unit Under Test (UUT)
    fifo uut (
        .clk(clk), 
        .rst(rst), 
        .readsig(readsig), 
        .writesig(writesig), 
        .datain(datain), 
        .full(full), 
        .length(length), 
        .empty(empty), 
        .dataout(dataout)
    );
	 
    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        readsig = 0;
        writesig = 0;
        datain = 8'd0;

        // Reset
        #20;
        rst = 0;

        // === Ghi 4 giá trị vào FIFO ===
        repeat (4) begin
            @(negedge clk);
            writesig = 1;
            datain = datain + 1;
        end
        @(negedge clk);
        writesig = 0;
		   // === Đợi 2 chu kỳ rồi đọc FIFO ===
        #20;
        repeat (4) begin
            @(negedge clk);
            readsig = 1;
        end
        @(negedge clk);
        readsig = 0;

        // === Kết thúc ===
        #50;
        $finish;
    end

    // Hiển thị giá trị khi đọc
    always @(posedge clk) begin
        if (readsig && !empty)
            $display("Time %t: Read data = %d, FIFO length = %d", $time, dataout, length);
    end

endmodule
		  