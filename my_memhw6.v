`default_nettype none

`include "my_mem_interface.sv"

module my_memhw6(my_mem_interface mem_inf);

   // Declare a 9-bit associative array using the logic data type
  bit [8:0] mem_array [int];
  
   always @(posedge mem_inf.clk) begin
      if (mem_inf.write) begin
        mem_array[mem_inf.address] = calc_even_parity(.number(mem_inf.data_in));
      //$display("%b Comparing data %b",{^data_in, data_in},calc_even_parity(data_in));
      //$display("%h Comparing data %h",{^data_in, data_in},calc_even_parity(data_in));
      end
      else if (mem_inf.read) begin
        mem_inf.data_out =  mem_array[mem_inf.address];
        //$display("called fead address %h %h",address,data_out);
      end
   end
   
endmodule