`default_nettype none
//`include "my_mem_interface.sv"


module top;
    bit clk=0;
    always #5 clk=~clk;
    my_mem_interface inf(clk);
    my_mem_tbhw6 acc_dut(inf.master);
    my_mem_tbhw6 tb(inf.slave);

    initial begin
        $vcdpluson;
        $vcdplusmemon;
    end

endmodule

module my_mem_tbhw6(my_mem_interface inf);
    integer i,size=6,j=0;

    //my_mem_interface mem_inf(clk);
    //declared an structure with the mentioned features that are add,data,expected arra adn actual data
    
    typedef struct {
        bit [15:0] Address_to_rw;
        bit [7:0] Data_to_Write;
        bit [8:0] Expected_data_Read;
        bit [8:0] Actual_data_Read;  
    } memorystructure;

    memorystructure memarray[];
    //memorystructure memarray_queue[$];
    my_memhw6 tb(mem_inf.master);
    
    initial begin
        mem_inf.error_count=0;
        mem_inf.write=0;
        mem_inf.read=0;
        memarray =new[6];//declaiung the array structure with name memarray
    end

    initial begin
    $dumpfile ("my_mem_tbhw5.vcd");
    $dumpvars ();
    $vcdpluson;
    $vcdplusmemon;
    //fork
    //write_read_checker();
    //join_none
    end

    integer Ecount=0; // declaring variable to count the errors obtained in testing
 
    initial begin
        i=0;
        //for (i = 0; i < size; i++) begin 
       /* do begin
            write=1;
            read=1;
            $display("Error need to be dispalyed");
            i++;
            #5;
            write=0;
            read=0;
        end while(i<size);
        i=0;*/
        do begin
            memarray[i].Address_to_rw = $unsigned($urandom());
            memarray[i].Data_to_Write = $urandom();
            $display("VAlues feed are %h and %h",memarray[i].Address_to_rw ,memarray[i].Data_to_Write);
            i++;
        end while(i<size);
    end

    //always #5 write_read_checker();

    always @(posedge inf.pclk ) begin
        if(j<size) begin
            writefunc(j); //calling the write func to write into the memory
            j++;
            #5;
        end
        else if(j==6) begin
            shufflefun();//using this to shuffle the array after inserting the data and filling the array structure with address and data and expected array
            j++;
        end
        else if(j>6 && j<13 ) begin
            readfunc(j); //callign the read func to read the memory data
            j++;
            #5;
        end
        else if(j==13) begin
            mem_inf.write=1;
            mem_inf.read=1;
            #10;
             // checking the checker function
            j++;
        end
        else begin
            lastdisplay();
            $finish; // finishing the run
        end
        //write_read_checker();
        //join_none
    end

task writefunc(integer j);
    mem_inf.data_in=memarray[j].Data_to_Write;//inserting data
    mem_inf.address=memarray[j].Address_to_rw;// inserting address
    memarray[j].Expected_data_Read = {^memarray[j].Data_to_Write,memarray[j].Data_to_Write}; //inserting the expected array
    mem_inf.write=1;//enabling write pin
    #10;
    mem_inf.write=0;
endtask

task readfunc(integer j);
    mem_inf.address=memarray[j-7].Address_to_rw; // reading the address
    mem_inf.read=1;//enabling read high
    //clk=0;
    #10;
    //$display("and values are = %h",data_out);
    //$display("and values are = %h",data_read_expect_assoc[address]);
    memarray[j-7].Actual_data_Read = mem_inf.data_out;//excluding the parity
    //memarray_queue.data_out[j-7]=mem_in.data_out;
    if(memarray[j-7].Actual_data_Read != memarray[j-7].Expected_data_Read) begin
        $display("Obtained Error : Expected data %h and Actualdata received is %h",memarray[j-7].Expected_data_Read,memarray[j-7].Actual_data_Read);
        mem_inf.error_count++;//if expected is not mathced to received data its error and added
        end
    mem_inf.read=0;
endtask

task lastdisplay();
    $display("Total Errors = %d and size is %d",mem_inf.error_count,size);
        //foreach (my_element;data_read_queue_arr) begin
    for (i = 0; i < size; i++) begin
            $display("address  %h and elements =%h",memarray[i].Address_to_rw,memarray[i].Actual_data_Read);
    end
endtask

task shufflefun();//shuffling the structure
integer s,k;
memorystructure tmp;//used general shuffling method
    for( s=0;s<size;s++) begin
        k=$urandom_range(s,5);//using random range between the iterate number and maximum size
         tmp = memarray[s];
         memarray[s]=memarray[k];
         memarray[k]=tmp;
        end
endtask
endmodule