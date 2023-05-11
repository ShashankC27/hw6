interface my_mem_interface(input bit clk);
   //logic clk;
   logic write;
   logic read;
   logic [7:0] data_in;
   logic [15:0] address;
   logic [8:0] data_out;
   int error_count;

   modport master (input write, read, data_in, address,output data_out);
   modport slave (input data_out,output write, read, data_in, address );

   always @(posedge clk) begin
      if (write && read) begin
            error_count++;
            $display("Both write and read are high and total count =%d",error_count);
        end 
   end
   
   clocking pclk @(posedge clk);
   endclocking

   function automatic logic [8:0] calc_even_parity(logic [7:0] number);
      integer count=0,i=0,length=8;
      do begin
         if(number[i] == 1) begin
            count++;
         end
         i++;
      end while(i<length);
      if(count%2 == 0) begin
         return {1'b0,data_in};
      end
      return {1'b1,data_in};
   endfunction
endinterface