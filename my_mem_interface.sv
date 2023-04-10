interface my_mem_interface;
  input logic clk;
  input logic write;
  input logic read;
  input logic [7:0] data_in;
  input logic [15:0] address;
  output logic [8:0] data_out;
endinterface