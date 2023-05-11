`timescale 1ns/1ps
`default_nettype none

//`include "my_mem_interface.sv"

module my_memhw6(my_mem_interface mem_in);

   // Declare a 9-bit associative array using the logic data type
  bit [8:0] mem_array [int];

  //my_mem_interface mem_in();
   always @(mem_in.pclk) begin
    $display("In loop %d",mem_in.write);
      if (mem_in.write) begin
        mem_array[mem_in.address] = mem_in.calc_even_parity(.number(mem_in.data_in));
        $display("Written value is %h",mem_in.data_in);
      end
      else if (mem_in.read) begin
        mem_in.data_out =  mem_array[mem_in.address];
        $display("called fead address %h %h",mem_in.address,mem_in.data_out);
      end
   end
   
endmodule