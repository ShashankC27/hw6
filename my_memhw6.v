`default_nettype none

//`include "my_mem_interface.sv"

module my_memhw6();

   // Declare a 9-bit associative array using the logic data type
  bit [8:0] mem_array [int];
  my_mem_interface mem_in();
   always @(posedge mem_in.clk) begin
      if (mem_in.write) begin
        mem_array[mem_in.address] = mem_in.calc_even_parity(.number(mem_in.data_in));
        display("Written value is %h",data_in);
      //$display("%b Comparing data %b",{^data_in, data_in},calc_even_parity(data_in));
      //$display("%h Comparing data %h",{^data_in, data_in},calc_even_parity(data_in));
      end
      else if (mem_in.read) begin
        mem_in.data_out =  mem_array[mem_in.address];
        //$display("called fead address %h %h",address,data_out);
      end
   end
   
endmodule