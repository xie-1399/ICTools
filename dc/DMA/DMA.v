// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : DMA
// Git hash  : e464644612dc5dae2cbb39e43c20b722a99d9827

`timescale 1ns/1ps

module DMA (
  input      [30:0]   io_apb3_PADDR,
  input      [0:0]    io_apb3_PSEL,
  input               io_apb3_PENABLE,
  output              io_apb3_PREADY,
  input               io_apb3_PWRITE,
  input      [31:0]   io_apb3_PWDATA,
  output reg [31:0]   io_apb3_PRDATA,
  output              io_apb3_PSLVERROR,
  output reg          io_axi4_aw_valid,
  input               io_axi4_aw_ready,
  output reg [31:0]   io_axi4_aw_payload_addr,
  output reg [2:0]    io_axi4_aw_payload_id,
  output reg [7:0]    io_axi4_aw_payload_len,
  output reg [2:0]    io_axi4_aw_payload_size,
  output reg [1:0]    io_axi4_aw_payload_burst,
  output reg          io_axi4_w_valid,
  input               io_axi4_w_ready,
  output reg [31:0]   io_axi4_w_payload_data,
  output reg          io_axi4_w_payload_last,
  input               io_axi4_b_valid,
  output reg          io_axi4_b_ready,
  input      [2:0]    io_axi4_b_payload_id,
  output reg          io_axi4_ar_valid,
  input               io_axi4_ar_ready,
  output reg [31:0]   io_axi4_ar_payload_addr,
  output reg [2:0]    io_axi4_ar_payload_id,
  output reg [7:0]    io_axi4_ar_payload_len,
  output reg [2:0]    io_axi4_ar_payload_size,
  output reg [1:0]    io_axi4_ar_payload_burst,
  input               io_axi4_r_valid,
  output reg          io_axi4_r_ready,
  input      [31:0]   io_axi4_r_payload_data,
  input      [2:0]    io_axi4_r_payload_id,
  input               io_axi4_r_payload_last,
  output              io_interrupt,
  input               clk,
  input               reset
);

  reg                 fifo_io_push_valid;
  reg        [31:0]   fifo_io_push_payload;
  reg                 fifo_io_pop_ready;
  wire                fifo_io_push_ready;
  wire                fifo_io_pop_valid;
  wire       [31:0]   fifo_io_pop_payload;
  wire       [6:0]    fifo_io_occupancy;
  wire       [6:0]    fifo_io_availability;
  wire       [31:0]   _zz_reading;
  wire       [11:0]   _zz_reading_1;
  wire       [8:0]    _zz_reading_2;
  wire       [31:0]   _zz_readed;
  wire       [11:0]   _zz_readed_1;
  wire       [8:0]    _zz_readed_2;
  wire       [8:0]    _zz_when_DMA_l143;
  wire       [31:0]   _zz_writing;
  wire       [11:0]   _zz_writing_1;
  wire       [8:0]    _zz_writing_2;
  wire       [31:0]   _zz_writed;
  wire       [11:0]   _zz_writed_1;
  wire       [8:0]    _zz_writed_2;
  wire       [0:0]    _zz_start;
  wire       [0:0]    _zz_clear;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [1:0]    channelState;
  reg                 start;
  reg                 clear;
  reg        [31:0]   source;
  reg        [31:0]   target;
  reg        [31:0]   length;
  reg        [8:0]    len;
  reg        [1:0]    readBurst;
  reg                 readValid;
  reg        [31:0]   reading;
  reg        [31:0]   readed;
  reg        [1:0]    writeBurst;
  reg                 writeValid;
  reg        [31:0]   writing;
  reg        [31:0]   writed;
  reg        [7:0]    counter;
  reg                 interrupt;
  wire                when_DMA_l87;
  wire                when_DMA_l97;
  wire                when_DMA_l99;
  wire                when_DMA_l101;
  wire                when_DMA_l101_1;
  wire                when_DMA_l102;
  wire                when_DMA_l105;
  wire                when_DMA_l123;
  wire                when_DMA_l124;
  wire                when_DMA_l125;
  wire                when_DMA_l125_1;
  wire                when_DMA_l126;
  wire                when_DMA_l129;
  wire                when_DMA_l141;
  wire                when_DMA_l143;
  wire                when_DMA_l157;
  wire                when_DMA_l162;
  wire                when_DMA_l170;
  reg                 when_BusSlaveFactory_l377;
  wire                when_BusSlaveFactory_l379;
  reg                 when_BusSlaveFactory_l377_1;
  wire                when_BusSlaveFactory_l379_1;

  assign _zz_reading_1 = (_zz_reading_2 * 3'b100);
  assign _zz_reading = {20'd0, _zz_reading_1};
  assign _zz_reading_2 = (len + 9'h001);
  assign _zz_readed_1 = (_zz_readed_2 * 3'b100);
  assign _zz_readed = {20'd0, _zz_readed_1};
  assign _zz_readed_2 = (len + 9'h001);
  assign _zz_when_DMA_l143 = {1'd0, counter};
  assign _zz_writing_1 = (_zz_writing_2 * 3'b100);
  assign _zz_writing = {20'd0, _zz_writing_1};
  assign _zz_writing_2 = (len + 9'h001);
  assign _zz_writed_1 = (_zz_writed_2 * 3'b100);
  assign _zz_writed = {20'd0, _zz_writed_1};
  assign _zz_writed_2 = (len + 9'h001);
  assign _zz_start = 1'b1;
  assign _zz_clear = 1'b1;
  StreamFifo fifo (
    .io_push_valid   (fifo_io_push_valid        ), //i
    .io_push_ready   (fifo_io_push_ready        ), //o
    .io_push_payload (fifo_io_push_payload[31:0]), //i
    .io_pop_valid    (fifo_io_pop_valid         ), //o
    .io_pop_ready    (fifo_io_pop_ready         ), //i
    .io_pop_payload  (fifo_io_pop_payload[31:0] ), //o
    .io_flush        (1'b0                      ), //i
    .io_occupancy    (fifo_io_occupancy[6:0]    ), //o
    .io_availability (fifo_io_availability[6:0] ), //o
    .clk             (clk                       ), //i
    .reset           (reset                     )  //i
  );
  always @(*) begin
    io_axi4_aw_payload_addr = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        if(when_DMA_l126) begin
          io_axi4_aw_payload_addr = target;
        end
        if(when_DMA_l129) begin
          io_axi4_aw_payload_addr = (target + writed);
        end
      end
    end
  end

  always @(*) begin
    io_axi4_aw_payload_id = 3'bxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        io_axi4_aw_payload_id = 3'b000;
      end
    end
  end

  always @(*) begin
    io_axi4_aw_payload_len = 8'bxxxxxxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        io_axi4_aw_payload_len = len[7 : 0];
      end
    end
  end

  always @(*) begin
    io_axi4_aw_payload_size = 3'bxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        io_axi4_aw_payload_size = 3'b010;
      end
    end
  end

  always @(*) begin
    io_axi4_aw_payload_burst = 2'bxx;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        io_axi4_aw_payload_burst = writeBurst;
      end
    end
  end

  always @(*) begin
    io_axi4_w_valid = 1'b0;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        io_axi4_w_valid = fifo_io_pop_valid;
      end
    end
  end

  always @(*) begin
    io_axi4_w_payload_data = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        io_axi4_w_payload_data = fifo_io_pop_payload;
      end
    end
  end

  always @(*) begin
    io_axi4_w_payload_last = 1'bx;
    io_axi4_w_payload_last = 1'b0;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        if(when_DMA_l141) begin
          if(when_DMA_l143) begin
            io_axi4_w_payload_last = 1'b1;
          end
        end
      end
    end
  end

  always @(*) begin
    io_axi4_b_ready = 1'b0;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        if(io_axi4_b_valid) begin
          io_axi4_b_ready = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_axi4_ar_payload_addr = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l99) begin
        if(when_DMA_l102) begin
          io_axi4_ar_payload_addr = source;
        end
        if(when_DMA_l105) begin
          io_axi4_ar_payload_addr = (source + readed);
        end
      end
    end
  end

  always @(*) begin
    io_axi4_ar_payload_id = 3'bxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l99) begin
        io_axi4_ar_payload_id = 3'b000;
      end
    end
  end

  always @(*) begin
    io_axi4_ar_payload_len = 8'bxxxxxxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l99) begin
        io_axi4_ar_payload_len = len[7 : 0];
      end
    end
  end

  always @(*) begin
    io_axi4_ar_payload_size = 3'bxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l99) begin
        io_axi4_ar_payload_size = 3'b010;
      end
    end
  end

  always @(*) begin
    io_axi4_ar_payload_burst = 2'bxx;
    if(when_DMA_l97) begin
      if(when_DMA_l99) begin
        io_axi4_ar_payload_burst = readBurst;
      end
    end
  end

  always @(*) begin
    io_axi4_r_ready = 1'b0;
    if(when_DMA_l97) begin
      if(when_DMA_l99) begin
        io_axi4_r_ready = fifo_io_push_ready;
      end
    end
  end

  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb3_PREADY = 1'b1;
  always @(*) begin
    io_apb3_PRDATA = 32'h0;
    case(io_apb3_PADDR)
      31'h63000001 : begin
        io_apb3_PRDATA[1 : 0] = channelState;
      end
      31'h63000002 : begin
        io_apb3_PRDATA[1 : 0] = readBurst;
      end
      31'h63000003 : begin
        io_apb3_PRDATA[1 : 0] = writeBurst;
      end
      31'h63000004 : begin
        io_apb3_PRDATA[8 : 0] = len;
      end
      31'h63000008 : begin
        io_apb3_PRDATA[31 : 0] = source;
      end
      31'h63000010 : begin
        io_apb3_PRDATA[31 : 0] = target;
      end
      31'h63000018 : begin
        io_apb3_PRDATA[31 : 0] = length;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb3_PSEL[0] && io_apb3_PENABLE) && io_apb3_PWRITE);
  assign ctrl_askRead = ((io_apb3_PSEL[0] && io_apb3_PENABLE) && (! io_apb3_PWRITE));
  assign ctrl_doWrite = (((io_apb3_PSEL[0] && io_apb3_PENABLE) && io_apb3_PREADY) && io_apb3_PWRITE);
  assign ctrl_doRead = (((io_apb3_PSEL[0] && io_apb3_PENABLE) && io_apb3_PREADY) && (! io_apb3_PWRITE));
  assign io_apb3_PSLVERROR = ((ctrl_doWrite && ctrl_writeErrorFlag) || (ctrl_doRead && ctrl_readErrorFlag));
  always @(*) begin
    start = 1'b0;
    if(when_BusSlaveFactory_l377) begin
      if(when_BusSlaveFactory_l379) begin
        start = _zz_start[0];
      end
    end
  end

  always @(*) begin
    clear = 1'b0;
    if(when_BusSlaveFactory_l377_1) begin
      if(when_BusSlaveFactory_l379_1) begin
        clear = _zz_clear[0];
      end
    end
  end

  always @(*) begin
    fifo_io_push_valid = 1'b0;
    if(when_DMA_l97) begin
      if(when_DMA_l99) begin
        fifo_io_push_valid = io_axi4_r_valid;
      end
    end
  end

  always @(*) begin
    fifo_io_push_payload = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(when_DMA_l97) begin
      if(when_DMA_l99) begin
        fifo_io_push_payload = io_axi4_r_payload_data;
      end
    end
  end

  always @(*) begin
    fifo_io_pop_ready = 1'b0;
    if(when_DMA_l97) begin
      if(when_DMA_l123) begin
        fifo_io_pop_ready = io_axi4_w_ready;
      end
    end
  end

  assign when_DMA_l87 = (channelState == 2'b00);
  assign when_DMA_l97 = (channelState == 2'b01);
  assign when_DMA_l99 = (32'h0 < reading);
  assign when_DMA_l101 = ((7'h08 <= fifo_io_availability) && (! readValid));
  assign when_DMA_l101_1 = (io_axi4_ar_valid && io_axi4_ar_ready);
  assign when_DMA_l102 = (readBurst == 2'b00);
  assign when_DMA_l105 = (readBurst == 2'b01);
  assign when_DMA_l123 = (32'h0 < writing);
  assign when_DMA_l124 = (io_axi4_b_ready && io_axi4_b_valid);
  assign when_DMA_l125 = ((7'h08 <= fifo_io_occupancy) && (! writeValid));
  assign when_DMA_l125_1 = (io_axi4_aw_valid && io_axi4_aw_ready);
  assign when_DMA_l126 = (writeBurst == 2'b00);
  assign when_DMA_l129 = (writeBurst == 2'b01);
  assign when_DMA_l141 = (io_axi4_w_valid && io_axi4_w_ready);
  assign when_DMA_l143 = (_zz_when_DMA_l143 == len);
  assign when_DMA_l157 = ((reading == 32'h0) && (writing == 32'h0));
  assign when_DMA_l162 = (channelState == 2'b10);
  assign when_DMA_l170 = (channelState == 2'b11);
  assign io_interrupt = interrupt;
  always @(*) begin
    when_BusSlaveFactory_l377 = 1'b0;
    case(io_apb3_PADDR)
      31'h63000000 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379 = io_apb3_PWDATA[0];
  always @(*) begin
    when_BusSlaveFactory_l377_1 = 1'b0;
    case(io_apb3_PADDR)
      31'h63000000 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_1 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_1 = io_apb3_PWDATA[1];
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      io_axi4_ar_valid <= 1'b0;
      io_axi4_aw_valid <= 1'b0;
      channelState <= 2'b00;
      readValid <= 1'b0;
      writeValid <= 1'b0;
      counter <= 8'h0;
      interrupt <= 1'b0;
    end else begin
      io_axi4_aw_valid <= 1'b0;
      io_axi4_ar_valid <= 1'b0;
      if(when_DMA_l87) begin
        if(start) begin
          channelState <= 2'b01;
        end
      end
      if(when_DMA_l97) begin
        if(when_DMA_l99) begin
          if(io_axi4_ar_valid) begin
            readValid <= 1'b1;
          end
          if(io_axi4_r_payload_last) begin
            readValid <= 1'b0;
          end
          if(when_DMA_l101) begin
            io_axi4_ar_valid <= 1'b1;
          end
          if(when_DMA_l101_1) begin
            io_axi4_ar_valid <= 1'b0;
          end
        end
        if(when_DMA_l123) begin
          if(io_axi4_aw_valid) begin
            writeValid <= 1'b1;
          end
          if(when_DMA_l124) begin
            writeValid <= 1'b0;
          end
          if(when_DMA_l125) begin
            io_axi4_aw_valid <= 1'b1;
          end
          if(when_DMA_l125_1) begin
            io_axi4_aw_valid <= 1'b0;
          end
          if(when_DMA_l141) begin
            counter <= (counter + 8'h01);
            if(when_DMA_l143) begin
              counter <= 8'h0;
            end
          end
        end
        if(when_DMA_l157) begin
          channelState <= 2'b10;
        end
      end
      if(when_DMA_l162) begin
        interrupt <= 1'b1;
        if(clear) begin
          channelState <= 2'b00;
          interrupt <= 1'b0;
        end
      end
      if(when_DMA_l170) begin
        interrupt <= 1'b1;
        if(clear) begin
          channelState <= 2'b00;
          interrupt <= 1'b0;
        end
      end
    end
  end

  always @(posedge clk) begin
    if(when_DMA_l87) begin
      if(start) begin
        reading <= length;
        readed <= 32'h0;
        writing <= length;
        writed <= 32'h0;
      end
    end
    if(when_DMA_l97) begin
      if(when_DMA_l99) begin
        if(io_axi4_r_payload_last) begin
          reading <= (reading - _zz_reading);
          readed <= (readed + _zz_readed);
        end
      end
      if(when_DMA_l123) begin
        if(io_axi4_b_valid) begin
          writing <= (writing - _zz_writing);
          writed <= (writed + _zz_writed);
        end
      end
    end
    case(io_apb3_PADDR)
      31'h63000002 : begin
        if(ctrl_doWrite) begin
          readBurst <= io_apb3_PWDATA[1 : 0];
        end
      end
      31'h63000003 : begin
        if(ctrl_doWrite) begin
          writeBurst <= io_apb3_PWDATA[1 : 0];
        end
      end
      31'h63000004 : begin
        if(ctrl_doWrite) begin
          len <= io_apb3_PWDATA[8 : 0];
        end
      end
      31'h63000008 : begin
        if(ctrl_doWrite) begin
          source <= io_apb3_PWDATA[31 : 0];
        end
      end
      31'h63000010 : begin
        if(ctrl_doWrite) begin
          target <= io_apb3_PWDATA[31 : 0];
        end
      end
      31'h63000018 : begin
        if(ctrl_doWrite) begin
          length <= io_apb3_PWDATA[31 : 0];
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module StreamFifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [31:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [31:0]   io_pop_payload,
  input               io_flush,
  output     [6:0]    io_occupancy,
  output     [6:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [31:0]   _zz_logic_ram_port0;
  wire       [5:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [5:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [5:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1122;
  wire       [5:0]    logic_ptrDif;
  reg [31:0] logic_ram [0:63];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {5'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {5'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= io_push_payload;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h3f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 6'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h3f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1122 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1122) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule
