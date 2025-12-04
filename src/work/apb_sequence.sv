class apb_slv_sequence extends uvm_sequence #(apb_slv_seq_item);
  `uvm_object_utils(apb_slv_sequence)

  function new(string name = "apb_slv_sequence");
    super.new(name);
  endfunction : new

  virtual task body();
      req = apb_slv_seq_item::type_id::create("req");
      repeat(20) begin
        wait_for_grant();
        assert(req.randomize());
      send_request(req);
      wait_for_item_done();
      end
  endtask : body

endclass : apb_slv_sequence

class apb_slv_sequence_simple_write extends uvm_sequence#(apb_slv_seq_item);
  `uvm_object_utils(apb_slv_sequence_simple_write)
  
  function new(string name = "apb_slv_sequence_simple_write");
    super.new(name);
  endfunction
  
  task body();
    int addr, data = 5;
    `uvm_do_with(req, {req.penable==0; req.psel == 0; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data; });
    repeat(10) begin
      `uvm_do_with(req, {req.penable==0; req.psel == 1; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data;})
      `uvm_do_with(req, {req.penable==0; req.psel == 1;} );
      addr++;
      data+=5;
    end
  endtask
endclass


class apb_slv_sequence_simple_read extends uvm_sequence#(apb_slv_seq_item);
  `uvm_object_utils(apb_slv_sequence_simple_read)
  
  function new(string name="apb_slv_sequence_simple_read");
    super.new(name);
  endfunction
  
  task body();
    int addr;
    `uvm_do_with(req, {req.penable==0; req.psel == 0; req.paddr == addr; req.pwrite == 0; });
    repeat(10) begin
      `uvm_do_with(req, {req.penable==0; req.psel == 1; req.paddr == addr; req.pwrite == 0; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pwrite == 0;})
      `uvm_do_with(req, {req.penable==0; req.psel == 1;} );
      addr+=30;
    end
  endtask
  
endclass

class apb_slv_sequence_write_read_continous extends uvm_sequence#(apb_slv_seq_item);
  `uvm_object_utils(apb_slv_sequence_write_read_continous)
  
  function new(string name="apb_slv_sequence_write_read_continous");
    super.new(name);
  endfunction
  
  task body();
    int addr = $urandom_range(246,0), data = 5;
    `uvm_do_with(req, {req.penable==0; req.psel == 0; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data; });
    repeat(10) begin // write 10 memory location
      `uvm_do_with(req, {req.penable==0; req.psel == 1; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data;});
//       `uvm_do_with(req, {req.penable==1; req.psel == 1;} );
      `uvm_do_with(req, {req.penable==0; req.psel == 0;} );
      addr+=2;
      data+=5;
    end
    repeat(10) begin // read the same memory location for output !
      `uvm_do_with(req, {req.penable==0; req.psel == 1; req.paddr == addr; req.pwrite == 0; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pwrite == 0;});
      `uvm_do_with(req, {req.penable==0; req.psel == 1;} );
      addr-=2;
    end
  endtask  
endclass


class apb_slv_sequence_strb_enb_write extends uvm_sequence#(apb_slv_seq_item);
  `uvm_object_utils(apb_slv_sequence_strb_enb_write)
  
  function new(string name="apb_slv_sequence_strb_enb_write");
    super.new(name);
  endfunction
  
  task body();
    int addr = $urandom_range(246,0), data; // max data is 255 bcz 1st byte is valid for 'pstrb'
    `uvm_do_with(req, {req.penable==0; req.psel == 0; req.paddr == addr; req.pstrb == 1; req.pwrite == 1; req.pwdata == data; });
    repeat(10) begin // exclude first 8 bits for writing !
      `uvm_do_with(req, {req.penable==0; req.psel == 1; req.paddr == addr; req.pstrb == 1; req.pwrite == 1; req.pwdata == data; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pstrb == 1; req.pwrite == 1; req.pwdata == data;});
      `uvm_do_with(req, {req.penable==0; req.psel == 0;} );
      addr+=5;
      data+=50;
    end
    repeat(10) begin // read the same memory location to check for output !
      `uvm_do_with(req, {req.penable==0; req.psel == 1; req.paddr == addr; req.pwrite == 0; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pwrite == 0;});
      `uvm_do_with(req, {req.penable==0; req.psel == 1;} );      
      addr-=5;
    end
  endtask  
endclass


class apb_slv_sequence_pslverr extends uvm_sequence#(apb_slv_seq_item);
  `uvm_object_utils(apb_slv_sequence_pslverr)
  
  function new(string name="apb_slv_sequence_pslverr");
    super.new(name);
  endfunction
  
  task body();
    int addr = $urandom_range(500,255), data; //addr is out of bound !
    `uvm_do_with(req, {req.penable==0; req.psel == 0; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data; });
    repeat(3) begin // should generate pslverr !
      `uvm_do_with(req, {req.penable==0; req.psel == 1; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data;});
      `uvm_do_with(req, {req.penable==0; req.psel == 0;} );
      addr+=5;
      data+=50;
    end
    repeat(3) begin // read the same memory location to check for output !
      `uvm_do_with(req, {req.penable==0; req.psel == 1; req.paddr == addr; req.pwrite == 0; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pwrite == 0;});
      `uvm_do_with(req, {req.penable==0; req.psel == 1;} );      
      addr-=5;
    end
  endtask   
  
endclass

class apb_slv_sequence_write_followed_by_read extends uvm_sequence#(apb_slv_seq_item);
  `uvm_object_utils(apb_slv_sequence_write_followed_by_read)
  
  function new(string name="apb_slv_sequence_write_followed_by_read");
    super.new(name);
  endfunction
  
  task body();
    int addr, data;
    `uvm_do_with(req, {req.penable==0; req.psel == 0; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data; });
    repeat(5) begin // write data @addr !
      data = $urandom_range(500,1);
      `uvm_do_with(req, {req.penable==0; req.psel == 0; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pstrb == 15; req.pwrite == 1; req.pwdata == data;});
      `uvm_do_with(req, {req.penable==0; req.psel == 1;} );
      // read the same memory location to check for output !
      `uvm_do_with(req, {req.penable==0; req.psel == 1; req.paddr == addr; req.pwrite == 0; });
      `uvm_do_with(req, {req.penable==1; req.psel == 1; req.paddr == addr; req.pwrite == 0;});
      `uvm_do_with(req, {req.penable==0; req.psel == 0;} );      
       addr++;
    end
  endtask     
endclass

class apb_slv_regression_tst extends uvm_sequence#(apb_slv_seq_item);
  `uvm_object_utils(apb_slv_regression_tst)
  
  apb_slv_sequence seq1;
  apb_slv_sequence_simple_write seq2;
  apb_slv_sequence_simple_read seq3;
  apb_slv_sequence_write_read_continous seq4;
  apb_slv_sequence_strb_enb_write seq5;
  apb_slv_sequence_pslverr seq6;
  apb_slv_sequence_write_followed_by_read seq7;
  
  function new(string name="apb_slv_regression_tst");
    super.new(name);
  endfunction
  
  task body();
    `uvm_do(seq1);
    `uvm_do(seq2);
    `uvm_do(seq3);
    `uvm_do(seq4);
    `uvm_do(seq5);
    `uvm_do(seq6);
    `uvm_do(seq7);
  endtask
endclass
