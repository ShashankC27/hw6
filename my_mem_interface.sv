interface my_mem_interface;
  input clk;
  input write;
  input read;
  input [7:0] data_in;
  input [15:0] address;
  output [8:0] data_out;
endinterface