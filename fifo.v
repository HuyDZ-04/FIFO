`timescale 1ns / 1ps
module fifo(
     clk,
     rst,
     readsig,         //read signal  
     writesig,        //write signal
     datain,       //data in
     full,      	//full signal
     length,       //len 
	  empty,			//empty signal
     dataout      //data out
     );
	  localparam ADDR = 4;
	  localparam LENGTH =16;
	  localparam WIDTH = 8;
	input clk, rst, readsig, writesig;
	input [WIDTH-1:0] datain;
	output wire full, empty;
	output reg [WIDTH-1:0] dataout;
	output reg [ADDR:0] length = {1'b0,{ADDR{1'b0}}};
	////////tinh toan noi bo////////////////////
	reg [WIDTH-1:0] memory [LENGTH-1:0];
	reg [ADDR:0] fifo_len = {1'b0,{ADDR{1'b0}}};//5'b00000
	reg [ADDR-1:0] wrpnt = {ADDR{1'b0}}; //con tro ghi
	
	wire read;
	assign read = (readsig & !empty);
	wire write;
	assign write = (writesig & !full);
	
	assign empty = (fifo_len == {1'b0,{ADDR{1'b0}}});//length == 5'b00000
	assign full = (fifo_len[ADDR]);
	wire [ADDR-1:0] rdpnt;
	assign rdpnt = wrpnt - fifo_len[ADDR-1:0]; //pointer read
	
	always @ (posedge clk) begin
		begin 
			if (write) memory[wrpnt] <= datain;
		end
	end
	
	always @ (posedge clk) begin 
		if (rst) dataout <= {WIDTH{1'b0}};
		else if (read) dataout <= memory[rdpnt];
		else dataout <= dataout;
	end
	
	/////////////////////////////write pointer logic//////////
	always @(posedge clk) begin
		if (rst) begin
			wrpnt <= {ADDR{1'b0}};//ghi = 0 
		end else begin
			if (write)
			wrpnt <= wrpnt +1'b1;// ghi = ghi +1: ghi lien tuc vao cac o nho
		end
	end
	
	always @ (posedge clk) begin
		if (rst) 
			fifo_len <= {1'b0,{ADDR{1'b0}}}; // length = 5'b00000
		else begin
			case ({read, write})
				2'b01: fifo_len <= fifo_len + 1;
				2'b10: fifo_len <= fifo_len - 1;
				default: fifo_len <= fifo_len ;
			endcase
		end
	end
	
	always @(posedge clk)
    begin
    if(rst) length  <= {1'b0,{ADDR{1'b0}}};
    else
        case({read,write})
        2'b01: length <= length + 1'b1;
        2'b10: length <= length - 1'b1;
        default: length <= length;
        endcase
    end
endmodule
///////////////////////////////////////////////////////