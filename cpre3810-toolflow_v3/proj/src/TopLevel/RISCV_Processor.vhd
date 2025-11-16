-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- RISCV_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a RISCV_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity RISCV_Processor is
  generic(N : integer := 32;
          ADDR_WIDTH : integer := 10;
          DATA_WIDTH : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  RISCV_Processor;


architecture structure of RISCV_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 111 0011)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer := 10;
            DATA_WIDTH : integer := 32);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((31) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((31) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

------------------------------------------------------------------INSTRUCTION FETCH COMPONENTS----------------------------------------------------------------------------------

  component IF_register_file
    generic (WIDTH : integer := 32);
    port(
      sysCLK              : in std_logic;
      sysRST              : in std_logic;
      write_enable        : in std_logic;
      input_pc            : in std_logic_vector(WIDTH-1 downto 0);
      input_instruction   : in std_logic_vector(WIDTH-1 downto 0);
      output_pc           : out std_logic_vector(WIDTH-1 downto 0);
      output_instruction  : out std_logic_vector(WIDTH-1 downto 0)
    );
  end component;

  component pcFetch is
    generic(WIDTH : integer := 32);
    port(
      clock               : in std_logic;
      reset               : in std_logic;
      writeEnable         : in std_logic;
      conditionBJ         : in std_logic;
      jumpWithRegister    : in std_logic;
      previousPC          : in std_logic_vector(WIDTH-1 downto 0);
      immediate           : in std_logic_vector(WIDTH-1 downto 0);
      register_plusImm    : in std_logic_vector(WIDTH-1 downto 0);
      pcUp4               : out std_logic_vector(WIDTH-1 downto 0);
      pcUpImm             : out std_logic_vector(WIDTH-1 downto 0);
      programCounter      : out std_logic_vector(WIDTH-1 downto 0));
  end component;

------------------------------------------------------------------INSTRUCTION DECODE COMPONENTS--------------------------------------------------------------------------------

  component controlUnit is
    generic(WIDTH : integer := 32);
    port(
      opcode        : in std_logic_vector(6 downto 0);
      funct3        : in std_logic_vector(2 downto 0);
      funct7        : in std_logic_vector(6 downto 0);
      ALUsrc        : out std_logic;
      ALUctrl       : out std_logic_vector(3 downto 0);
      AndLink       : out std_logic_vector(1 downto 0);
      MemWrite      : out std_logic;
      RegWrite      : out std_logic;
      MemToReg      : out std_logic;
      Branch        : out std_logic;
      Jump          : out std_logic;
      Shift         : out std_logic;
      FlagMux       : out std_logic_vector(1 downto 0);
      FlagOrNFlag   : out std_logic;
      JumpWReg      : out std_logic;
      HaltSignal    : out std_logic);

  end component;

  component imm_generator is
    generic (WIDTH : natural := 32);
    port (
      input  : in  std_logic_vector(WIDTH-1 downto 0);
      output : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component RegFile is
    generic(WIDTH : integer := 32);
    port(
      sysCLK 		    : in std_logic;
      sysRST 		    : in std_logic;
      write_enable	: in std_logic;
      rs1	        	: in std_logic_vector(4 downto 0);
      rs2		        : in std_logic_vector(4 downto 0);
      rd		        : in std_logic_vector(4 downto 0);
      data		      : in std_logic_vector(WIDTH-1 downto 0);
      rOut1		      : out std_logic_vector(WIDTH-1 downto 0);
      rOut2		      : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component comparator is
    port (
      A       : in std_logic_vector(31 downto 0);
      B       : in std_logic_vector(31 downto 0);
      funct3  : in std_logic_vector(2 downto 0);
      compare : out std_logic);
  end component;

  component ID_EX_register_file
    generic (WIDTH : integer := 32);
    port(
        sysCLK              : in  std_logic;
        sysRST              : in  std_logic;
        write_enable        : in  std_logic;
        hazard              : in  std_logic;
        input_instruction   : in  std_logic_vector(WIDTH-1 downto 0);
        output_instruction  : out std_logic_vector(WIDTH-1 downto 0);
        input_ALUsrc        : in  std_logic;
        output_ALUsrc       : out std_logic;
        input_ALUcontrol    : in  std_logic_vector(3 downto 0);
        output_ALUcontrol   : out std_logic_vector(3 downto 0);
        input_FlagMux       : in  std_logic_vector(1 downto 0);
        output_FlagMux      : out std_logic_vector(1 downto 0);
        input_FlagOrNFlag   : in  std_logic;
        output_FlagOrNFlag  : out std_logic;
        input_Shift         : in  std_logic;
        output_Shift        : out std_logic;
        input_AndLink       : in  std_logic_vector(1 downto 0);
        output_AndLink      : out std_logic_vector(1 downto 0);
        input_MemWrite      : in  std_logic;
        output_MemWrite     : out std_logic;
        input_MemtoReg      : in  std_logic;
        output_MemtoReg     : out std_logic;
        input_RegWrite      : in  std_logic;
        output_RegWrite     : out std_logic;
        input_Halt          : in  std_logic;
        output_Halt         : out std_logic;
        input_rs1           : in  std_logic_vector(WIDTH-1 downto 0);
        output_rs1          : out std_logic_vector(WIDTH-1 downto 0);
        input_rs2           : in  std_logic_vector(WIDTH-1 downto 0);
        output_rs2          : out std_logic_vector(WIDTH-1 downto 0);
        input_imm           : in  std_logic_vector(WIDTH-1 downto 0);
        output_imm          : out std_logic_vector(WIDTH-1 downto 0);
        input_pcUp4         : in  std_logic_vector(WIDTH-1 downto 0);
        output_pcUp4        : out std_logic_vector(WIDTH-1 downto 0);
        input_pcUpImm       : in  std_logic_vector(WIDTH-1 downto 0);
        output_pcUpImm      : out std_logic_vector(WIDTH-1 downto 0));
  end component;

-------------------------------------------------------------------------EXECUTE COMPONENTS------------------------------------------------------------------------------------

  component ALUUnit is
    generic (WIDTH : integer := 32);
    port(
      Alucontrol : in std_logic_vector(3 downto 0);
      flag_mux : in std_logic_vector(1 downto 0);
      input_A : in std_logic_vector (WIDTH-1 downto 0);
      input_B : in std_logic_vector (WIDTH-1 downto 0);
      output_result : out std_logic_vector (WIDTH-1 downto 0);
      overflowFlag : out std_logic;
      flag : out std_logic);
  end component;

  component barrel_shifter is
    port (
      data_in  : in  std_logic_vector(31 downto 0);
      shamt    : in  std_logic_vector(4 downto 0);
      op       : in  std_logic_vector(1 downto 0);
      data_out : out std_logic_vector(31 downto 0));
  end component;

  component EX_MEM_register_file
    generic (WIDTH : integer := 32);
    port(
        sysCLK              : in  std_logic;
        sysRST              : in  std_logic;
        write_enable        : in  std_logic;
        input_instruction   : in  std_logic_vector(WIDTH-1 downto 0);
        output_instruction  : out std_logic_vector(WIDTH-1 downto 0);
        input_ALUsrc        : in  std_logic;
        output_ALUsrc       : out std_logic;
        input_ALUcontrol    : in  std_logic_vector(3 downto 0);
        output_ALUcontrol   : out std_logic_vector(3 downto 0);
        input_FlagMux       : in  std_logic_vector(1 downto 0);
        output_FlagMux      : out std_logic_vector(1 downto 0);
        input_FlagOrNFlag   : in  std_logic;
        output_FlagOrNFlag  : out std_logic;
        input_Shift         : in  std_logic;
        output_Shift        : out std_logic;
        input_AndLink       : in  std_logic_vector(1 downto 0);
        output_AndLink      : out std_logic_vector(1 downto 0);
        input_MemWrite      : in  std_logic;
        output_MemWrite     : out std_logic;
        input_MemtoReg      : in  std_logic;
        output_MemtoReg     : out std_logic;
        input_RegWrite      : in  std_logic;
        output_RegWrite     : out std_logic;
        input_Halt          : in  std_logic;
        output_Halt         : out std_logic;        
        input_ALUBSout      : in  std_logic_vector(WIDTH-1 downto 0);
        output_ALUBSout     : out std_logic_vector(WIDTH-1 downto 0);
        input_writedata     : in  std_logic_vector(WIDTH-1 downto 0);
        output_writedata    : out std_logic_vector(WIDTH-1 downto 0));
  end component;

--------------------------------------------------------------------------MEMORY COMPONENTS------------------------------------------------------------------------------------

  component memorySlicer is
      port (
          funct3    : in std_logic_vector(2 downto 0);
          addr      : in std_logic_vector(1 downto 0);
          input     : in std_logic_vector(31 downto 0);
          output    : out std_logic_vector(31 downto 0));
  end component;

-------------------------------------------------------------------------WRITEBACK COMPONENTS----------------------------------------------------------------------------------

  component MEM_WB_register_file is
    generic (
        WIDTH : integer := 32
    );
    port(
        sysCLK              : in  std_logic;
        sysRST              : in  std_logic;
        write_enable        : in  std_logic;
        input_instruction   : in  std_logic_vector(WIDTH-1 downto 0);
        output_instruction  : out std_logic_vector(WIDTH-1 downto 0);
        input_ALUsrc        : in  std_logic;
        output_ALUsrc       : out std_logic;
        input_ALUcontrol    : in  std_logic_vector(3 downto 0);
        output_ALUcontrol   : out std_logic_vector(3 downto 0);
        input_FlagMux       : in  std_logic_vector(1 downto 0);
        output_FlagMux      : out std_logic_vector(1 downto 0);
        input_FlagOrNFlag   : in  std_logic;
        output_FlagOrNFlag  : out std_logic;
        input_Shift         : in  std_logic;
        output_Shift        : out std_logic;
        input_AndLink       : in  std_logic_vector(1 downto 0);
        output_AndLink      : out std_logic_vector(1 downto 0);
        input_MemWrite      : in  std_logic;
        output_MemWrite     : out std_logic;
        input_MemtoReg      : in  std_logic;
        output_MemtoReg     : out std_logic;
        input_RegWrite      : in  std_logic;
        output_RegWrite     : out std_logic;
        input_Halt          : in  std_logic;
        output_Halt         : out std_logic;
        input_ALUWriteBack  : in  std_logic_vector(WIDTH-1 downto 0);
        output_ALUWriteback : out std_logic_vector(WIDTH-1 downto 0);
        input_MemOut        : in  std_logic_vector(WIDTH-1 downto 0);
        output_MemOut       : out std_logic_vector(WIDTH-1 downto 0));
  end component;

--------------------------------------------------------------------------GENERAL COMPONENTS-----------------------------------------------------------------------------------

  component zero_extender is
    generic (OUT_WIDTH : natural := 32);
      port (
          input     : in std_logic;
          output    : out std_logic_vector(OUT_WIDTH-1 downto 0));
  end component;

  component nbit_LookAheadAdder
    generic(WIDTH : integer := 32);
    port(
      in_C   : in  std_logic;
      i_A    : in  std_logic_vector(WIDTH-1 downto 0);
      i_B    : in  std_logic_vector(WIDTH-1 downto 0);
      o_SUM  : out std_logic_vector(WIDTH-1 downto 0);
      out_C  : out std_logic);
  end component;

---------------------------------------------------------------------------HAZARD CONTROLS-------------------------------------------------------------------------------------

component dataHazard is
  generic(WIDTH : integer := 32);

  port(
    idInst       : in std_logic_vector(WIDTH-1 downto 0); 
    exInst       : in std_logic_vector(WIDTH-1 downto 0);
    memInst      : in std_logic_vector(WIDTH-1 downto 0);
    wbInst       : in std_logic_vector(WIDTH-1 downto 0);
    exRegWrite   : in std_logic;
    memRegWrite  : in std_logic;
    wbRegWrite   : in std_logic;
    outSignal    : out std_logic;
    forwardMemtoExRS1 : out  std_logic;
    forwardWbtoExRS1 : out  std_logic;
    bypassregfileWBtoRS1 : out  std_logic;
    forwardMemtoExRS2 : out  std_logic;
    forwardWbtoExRS2 : out  std_logic;
    bypassregfileWBtoRS2 : out  std_logic);

end component;

---------------------------------------------------------------------------FORWARDING CONTROLS-------------------------------------------------------------------------------------
component Forwarding_Unit is

  generic(WIDTH : integer := 32);
    port(
    forwardMemtoExRS1    : in std_logic;
    forwardWbtoExRS1    : in std_logic;
    bypassregfileWBtoRS1    : in std_logic;
    forwardMemtoExRS2    : in std_logic;
    forwardWbtoExRS2    : in std_logic;
    bypassregfileWBtoRS2    : in std_logic;
    selectline_rs1mux : out std_logic_vector(1 downto 0);
    selectline_rs2mux : out std_logic_vector(1 downto 0);
    selectline_rs1bypassmux: out std_logic;
    selectline_rs2bypassmux: out std_logic;
    );
    
end component;


-----------------------------------------------------------------------------MULTIPLEXERS--------------------------------------------------------------------------------------

  component mux2t1_dataflow
    port(
      SEL     : in std_logic;
      iA 		  : in std_logic;
      iB 		  : in std_logic;
      OUTPUT 	: out std_logic);
  end component;

  component mux2t1_N
    port(
      i_S          : in std_logic;
      i_D0         : in std_logic_vector(N-1 downto 0);
      i_D1         : in std_logic_vector(N-1 downto 0);
      o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component mux4t1
    port(
      i_D0 : in std_logic;
      i_D1 : in std_logic;
      i_D2 : in std_logic;
      i_D3 : in std_logic;
      i_S  : in std_logic_vector(1 downto 0);
      o_Y  : out std_logic
    );  
  end component;

  component mux32x4t1 is
    port(
      sel       : in std_logic_vector(1 downto 0);
      bus_in		: in t_bus_4x32;
      o_output 	: out std_logic_vector(31 downto 0));
  end component;

  component mux4t1_N
    port(
      i_S          : in std_logic;
      i_D0         : in std_logic_vector(N-1 downto 0);
      i_D1         : in std_logic_vector(N-1 downto 0);
      i_D2         : in std_logic_vector(N-1 downto 0);
      i_D3         : in std_logic_vector(N-1 downto 0);
      o_O          : out std_logic_vector(N-1 downto 0));
  end component;

--------------------------------------------------------------------------------GATES------------------------------------------------------------------------------------------

  component invg is
    port(
      i_A          : in std_logic;
      o_F          : out std_logic);
  end component;

  component andg2 is
    port(i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic);
  end component;

  component org2 is
    port(i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic);
  end component;



----------------------------------------------------------------------INSTRUCTION FETCH SIGNALS----------------------------------------------------------------------------------

  --IF Register Signals
  signal s_IDpc, s_idInst : std_logic_vector(31 downto 0);

  --Fetch Unit Signals
  signal s_IDpcUp4, s_IDpcUpImm, s_RegPlusImm : std_logic_vector(31 downto 0);
  signal s_branchLogic, s_idBranchOrJump : std_logic;

----------------------------------------------------------------------INSTRUCTION DECODE SIGNALS---------------------------------------------------------------------------------

  --Control Unit signals
  signal s_idALUsrc, s_idRegWrite, s_idMemWrite, s_idMemToReg, s_idBranch, s_idJump, s_idShift, s_idFlagOrNFlag, s_idJumpWReg, s_idHalt : std_logic;
  signal s_idALUctrl : std_logic_vector(3 downto 0);
  signal s_idAndLink, s_idFlagMux: std_logic_vector(1 downto 0);

  --Immediate Generator Signals
  signal s_idImmediate : std_logic_vector(31 downto 0);

  --Reg File Signals
  signal s_IDrOut1, s_IDrOut2 : std_logic_vector(31 downto 0);

  -- Comparator
  signal s_branchCompare : std_logic;

  --Data Hazard Singals
  signal s_DataHazardOutput, s_NotDHO, s_idExRst, s_forwardMemtoExRS1, s_forwardWbtoExRS1, s_bypassregfileWBtoRS1, s_forwardMemtoExRS2, s_forwardWbtoExRS2, s_bypassregfileWBtoRS2 : std_logic;

  --Forwarding signals 
  signal s_rs1mux,s_rs2mux : std_logic_vector(1 downto 0);
  signal s_rs1bypass, s_rs2bypass: std_logic;

  --ID/EX Register Signals
  signal s_exALUsrc, s_exRegWrite, s_exMemWrite, s_exMemToReg, s_exShift, s_exFlagOrNFlag, s_exHalt : std_logic;
  signal s_exALUctrl : std_logic_vector(3 downto 0);
  signal s_exAndLink, s_exFlagMux: std_logic_vector(1 downto 0);
  signal s_exImmediate, s_EXpcUp4, s_EXpcUpImm, s_exRS1, s_exRS2, s_exInst : std_logic_vector(31 downto 0);


---------------------------------------------------------------------------EXECUTE SIGNALS---------------------------------------------------------------------------------------

  --ALU Unit Signals
  signal s_ALUresult, s_inputA, s_inputB : std_logic_vector(31 downto 0);
  signal s_flag, s_notFlag, s_flagToWriteBack : std_logic;

  --Barrel Shifter Signals
  signal s_BSresult : std_logic_vector(31 downto 0);

  -- BS or ALU mux
  signal s_result, s_barrelInput : std_logic_vector(31 downto 0);

  --32x4t1 bus for WriteBack
  signal s_writeback : t_bus_4x32;
  signal s_extFlagToWriteBack, s_exStageOut : std_logic_vector(31 downto 0);

  --EX/MEM Register Signals
  signal s_memALUsrc, s_memRegWrite, s_memMemWrite, s_memMemToReg, s_memShift, s_memFlagOrNFlag, s_memHalt : std_logic;
  signal s_memALUctrl : std_logic_vector(3 downto 0);
  signal s_memAndLink, s_memFlagMux: std_logic_vector(1 downto 0);
  signal s_memALUWriteBack, s_memInst : std_logic_vector(31 downto 0);

----------------------------------------------------------------------------MEMORY SIGNALS---------------------------------------------------------------------------------------

  --Memory Slicer
  signal s_memMemOut : std_logic_vector(31 downto 0);

  --MEM/WB Register Signals
  signal s_wbALUsrc, s_wbRegWrite, s_wbMemWrite, s_wbMemToReg, s_wbShift, s_wbFlagOrNFlag, s_wbHalt : std_logic;
  signal s_wbALUctrl : std_logic_vector(3 downto 0);
  signal s_wbAndLink, s_wbFlagMux: std_logic_vector(1 downto 0);
  signal s_wbInst, s_wbALUWriteBack, s_wbMemOut : std_logic_vector(31 downto 0);  

---------------------------------------------------------------------------WRITEBACK SIGNALS-------------------------------------------------------------------------------------

  

begin
---------------------------------------------------------------------------MEMORY COMPONENTS-------------------------------------------------------------------------------------

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. 
  --       If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 001 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 
  
--------------------------------------------------------------------INSTRUCTION FETCH STAGE COMPONENTS---------------------------------------------------------------------------

  dataHazardInv : invg
    port map(
      i_A => s_DataHazardOutput,
      o_F => s_NotDHO);


  IF_Register : IF_register_file
    port map(
      sysCLK             => iCLK,
      sysRST             => iRST,
      write_enable       => s_NotDHO,
      input_pc           => s_NextInstAddr,
      input_instruction  => s_Inst,
      output_pc          => s_IDpc,
      output_instruction => s_idInst);

  --IF/ID Stages
  FetchUnit : pcFetch --ADD writeEnable to PC reg, wire to (NOT) data hazard output
    port map(
      clock            => iCLK,
      reset            => iRST,
      writeEnable      => s_NotDHO,
      conditionBJ      => s_idBranchOrJump,
      jumpWithRegister => s_idJumpWReg,
      previousPC       => s_IDpc,
      immediate        => s_idImmediate,
      register_plusImm => s_RegPlusImm,
      pcUp4            => s_IDpcUp4,
      pcUpImm          => s_IDpcUpImm,
      programCounter   => s_NextInstAddr);


--------------------------------------------------------------------INSTRUCTION DECODE STAGE COMPONENTS--------------------------------------------------------------------------

  --ID Stage
  CTRLunit : controlUnit
    port map(
      opcode        => s_idInst(6 downto 0),
      funct3        => s_idInst(14 downto 12),
      funct7        => s_idInst(31 downto 25),
      ALUsrc        => s_idALUsrc,
      ALUctrl       => s_idALUctrl,
      AndLink       => s_idAndLink,
      MemWrite      => s_idMemWrite,
      RegWrite      => s_idRegWrite,
      MemToReg      => s_idMemToReg,
      Branch        => s_idBranch,
      Jump          => s_idJump,
      Shift         => s_idShift,
      FlagMux       => s_idFlagMux,
      FlagOrNFlag   => s_idFlagOrNFlag,
      JumpWReg      => s_idJumpWReg,
      HaltSignal    => s_idHalt);

  --ID Stage
  Registers : RegFile
    port map(
      sysCLK 		    => iCLK,
      sysRST 		    => iRST,
	    write_enable	=> s_wbRegWrite,
      rs1	        	=> s_idInst(19 downto 15),
      rs2		        => s_idInst(24 downto 20),
      rd		        => s_RegWrAddr,
      data		      => s_RegWrData,
      rOut1		      => s_IDrOut1,
      rOut2		      => s_IDrOut2);  

  --ID Stage
  --Pre-ALU JALR adder
  addRegImmForJALR : nbit_LookaheadAdder
    port map(
      in_C  => '0', 
      i_A   => s_IDrOut1,
      i_B   => s_idImmediate,
      o_SUM => s_RegPlusImm, 
      out_C => open);

  --ID Stage
  ImmGen : imm_generator
    port map(
      input   => s_idInst,
      output  => s_idImmediate);
  
  --ID Stage
  --Pre-ALU comparator for Branch instructions
  branchCompare : comparator
    port map(
      A       => s_IDrOut1,
      B       => s_IDrOut2,
      funct3  => s_idInst(14 downto 12),
      compare => s_branchCompare);

  --ID Stage
  --Control Signal Branch gating comparison signals
  branchAnd : andg2
    port map(
      i_A => s_idBranch,
      i_B => s_branchCompare,
      o_F => s_branchLogic);

  --ID Stage
  --If Branch logic in total or Jump is active, Affect PC
  branchJump : org2
    port map(
      i_A => s_branchLogic,
      i_B => s_idJump,
      o_F => s_idBranchOrJump);

  dataHazardUnit : dataHazard
    port map(
      idInst       => s_idInst,
      exInst       => s_exInst,
      memInst      => s_memInst,
      wbInst       => s_wbInst,
      exRegWrite   => s_exRegWrite,
      memRegWrite  => s_memRegWrite,
      wbRegWrite   => s_wbRegWrite,
      outSignal    => s_DataHazardOutput,
      forwardMemtoExRS1 => s_forwardMemtoExRS1,
      forwardWbtoExRS1 => s_forwardWbtoExRS1,
      bypassregfileWBtoRS1 => s_bypassregfileWBtoRS1,
      forwardMemtoExRS2 => s_forwardMemtoExRS2,
      forwardWbtoExRS2 => s_forwardWbtoExRS2,
      bypassregfileWBtoRS2 => s_bypassregfileWBtoRS2);
  
  Forwarding_unit : Forwarding_Unit
    port map(
      forwardMemtoExRS1 => s_forwardMemtoExRS1,
      forwardWbtoExRS1  => s_forwardWbtoExRS1,
      bypassregfileWBtoRS1 => s_bypassregfileWBtoRS1,
      forwardMemtoExRS2   => s_forwardMemtoExRS2,
      forwardWbtoExRS2    => s_forwardWbtoExRS2,
      bypassregfileWBtoRS2=> s_bypassregfileWBtoRS2,
      selectline_rs1mux => s_rs1mux,
      selectline_rs2mux => s_rs2mux,
      selectline_rs1bypassmux => s_rs1bypass,
      selectline_rs2bypassmux => s_rs1bypass);

  ID_EX_Register : ID_EX_register_file
    port map(
      sysCLK             => iCLK,
      sysRST             => iRST,
      write_enable       => '1',
      hazard             => s_DataHazardOutput,
      input_instruction  => s_idInst,
      output_instruction => s_exInst,
      input_ALUsrc       => s_idALUsrc,
      output_ALUsrc      => s_exALUsrc,
      input_ALUcontrol   => s_idALUctrl,
      output_ALUcontrol  => s_exALUctrl,
      input_FlagMux      => s_idFlagMux,
      output_FlagMux     => s_exFlagMux,
      input_FlagOrNFlag  => s_idFlagOrNFlag,
      output_FlagOrNFlag => s_exFlagOrNFlag,
      input_Shift        => s_idShift,
      output_Shift       => s_exShift,
      input_AndLink      => s_idAndLink,
      output_AndLink     => s_exAndLink,
      input_MemWrite     => s_idMemWrite,
      output_MemWrite    => s_exMemWrite,
      input_MemtoReg     => s_idMemToReg,
      output_MemtoReg    => s_exMemToReg,
      input_RegWrite     => s_idRegWrite,
      output_RegWrite    => s_exRegWrite,
      input_Halt         => s_idHalt,
      output_Halt        => s_exHalt,      
      input_rs1          => s_IDrOut1,
      output_rs1         => s_exRS1,
      input_rs2          => s_IDrOut2,
      output_rs2         => s_exRS2,
      input_imm          => s_idImmediate,
      output_imm         => s_exImmediate,
      input_pcUp4        => s_IDpcUp4,
      output_pcUp4       => s_EXpcUp4,
      input_pcUpImm      => s_IDpcUpImm,
      output_pcUpImm     => s_EXpcUpImm);

--------------------------------------------------------------------------EXECUTION STAGE COMPONENTS-----------------------------------------------------------------------------

  --EX Stage
  --RS2 or Immediate assignment to INPUT B
  InputBMux : mux2t1_N
    port map(
      i_S   => s_exALUsrc,
      i_D0  => s_inputBRegister,
      i_D1  => s_exImmediate,
      o_O   => s_inputB);
  
  --RS2 regular forward froim MEM of forward from wb
  InputBRegisterMux: mux4t1_N
    port map(
      i_S   => s_rs2mux,
      i_D0  => s_exRS2,
      i_D1  => s_memALUWriteBack, -- s_forwardMemtoExRS2,
      i_D2  => s_RegWrData, -- s_forwardWbtoExRS2,
      i_D3  => open,
      o_O   => s_inputBRegister);

  InputAMUX :mux4t1_N
    port map(
      i_S   => rs1mux,
      i_D0  => s_exRS1,
      i_D1  => s_memALUWriteBack,--s__forwardMemtoExRS2,
      i_D2  => s_RegWrData,--s_forwardMemtoExRS2,
      i_D3  => open,
      o_O   => s_inputA);

  --EX Stage
  --For swapping RS1 and Immediate when LUI needs to shift the Immediate
  lui_mux : mux2t1_N
    port map(
      i_S  => s_exALUctrl(3),
      i_D0 => s_exRS1,
      i_D1 => s_exImmediate,
      o_O  => s_barrelInput);

  --EX Stage
  ALU : ALUUNit
    port map(
      Alucontrol    => s_exALUctrl,
      flag_mux      => s_exFlagMux,
      input_A       => s_inputA,
      input_B       => s_inputB,
      output_result => s_ALUresult,
      overflowFlag  => s_Ovfl,
      flag          => s_flag);

  oALUOut <= s_ALUresult;

  --EX Stage
  Shifter : barrel_shifter
    port map (
      data_in  => s_barrelInput,
      shamt    => s_inputB(4 downto 0),
      op       => s_exALUctrl(1 downto 0),
      data_out => s_BSresult);

  --EX Stage
  --Selecting ALU or Barrel Shifter Output for Writeback
  ALUorBSmux : mux2t1_N
    port map(
      i_S   => s_exShift,
      i_D0  => s_ALUresult,
      i_D1  => s_BSresult,
      o_O   => s_result); 

  --EX Stage
  --Inverting the ALU Flag output
  flagNot : invg
    port map(
      i_A => s_flag,
      o_F => s_notFlag);

  --EX Stage
  --Selecting the ALU Flag or its inverse
  FlagOrNot : mux2t1_dataflow
    port map(
      SEL     => s_exFlagOrNFlag,
      iA 		  => s_flag,
      iB 		  => s_notFlag,
      OUTPUT 	=> s_flagToWriteBack);

  --EX Stage
  flagExtender : zero_extender
    port map(
      input => s_flagToWriteBack,
      output => s_extFlagToWriteBack);

   --EX Stage   
  --ANDLINK MUX INPUTS
  s_writeback(0) <= s_result;  -- ALU/BS mux output
  s_writeback(1) <= s_EXpcUp4;
  s_writeback(2) <= s_extFlagToWriteBack;
  s_writeback(3) <= s_EXpcUpImm;

  --EX Stage
  --Selecting writeback options w/ ANDLINK
  WriteBackSelectMux : mux32x4t1
    port map(
      sel        => s_exAndLink,
      bus_in		 => s_writeback,
      o_output 	 => s_exStageOut);

  EX_MEM_Register : EX_MEM_register_file
    port map(
      sysCLK             => iCLK,
      sysRST             => iRST,
      write_enable       => '1',
      input_instruction  => s_exInst,
      output_instruction => s_memInst,
      input_ALUsrc       => s_exALUsrc,
      output_ALUsrc      => s_memALUsrc,
      input_ALUcontrol   => s_exALUctrl,
      output_ALUcontrol  => s_memALUctrl,
      input_FlagMux      => s_exFlagMux,
      output_FlagMux     => s_memFlagMux,
      input_FlagOrNFlag  => s_exFlagOrNFlag,
      output_FlagOrNFlag => s_memFlagOrNFlag,
      input_Shift        => s_exShift,
      output_Shift       => s_memShift,
      input_AndLink      => s_exAndLink,
      output_AndLink     => s_memAndLink,
      input_MemWrite     => s_exMemWrite,
      output_MemWrite    => s_memMemWrite,
      input_MemtoReg     => s_exMemToReg,
      output_MemtoReg    => s_memMemToReg,
      input_RegWrite     => s_exRegWrite,
      output_RegWrite    => s_memRegWrite,
      input_Halt         => s_exHalt,
      output_Halt        => s_memHalt,       
      input_ALUBSout     => s_exStageOut,
      output_ALUBSout    => s_memALUWriteBack,
      input_writedata    => s_inputBRegister, --Will change in HW implementation -- changed
      output_writedata   => s_DMemData);
----------------------------------------------------------------------------MEMORY STAGE COMPONENTS------------------------------------------------------------------------------

  s_DMemAddr <= s_memALUWriteBack;
  s_DMemWr   <= s_memMemWrite;

  --MEM Stage
  --LB/LH/LW Segment Selector
  memSlicer : memorySlicer
    port map(
      funct3 => s_memInst(14 downto 12),
      addr   => s_DMemAddr(1 downto 0),
      input  => s_DMemOut,
      output => s_memMemOut);
  
  MEM_WB_Register : MEM_WB_register_file
    port map(
      sysCLK              => iCLK,
      sysRST              => iRST,
      write_enable        => '1',
      input_instruction   => s_memInst,
      output_instruction  => s_wbInst,
      input_ALUsrc        => s_memALUsrc,
      output_ALUsrc       => s_wbALUsrc,
      input_ALUcontrol    => s_memALUctrl,
      output_ALUcontrol   => s_wbALUctrl,
      input_FlagMux       => s_memFlagMux,
      output_FlagMux      => s_wbFlagMux,
      input_FlagOrNFlag   => s_memFlagOrNFlag,
      output_FlagOrNFlag  => s_wbFlagOrNFlag,
      input_Shift         => s_memShift,
      output_Shift        => s_wbShift,
      input_AndLink       => s_memAndLink,
      output_AndLink      => s_wbAndLink,
      input_MemWrite      => s_memMemWrite,
      output_MemWrite     => s_wbMemWrite,
      input_MemtoReg      => s_memMemToReg,
      output_MemtoReg     => s_wbMemToReg,
      input_RegWrite      => s_memRegWrite,
      output_RegWrite     => s_wbRegWrite,
      input_Halt          => s_memHalt,
      output_Halt         => s_wbHalt,
      input_ALUWriteBack  => s_memALUWriteBack,
      output_ALUWriteback => s_wbALUWriteBack,
      input_MemOut        => s_memMemOut,
      output_MemOut       => s_wbMemOut);

---------------------------------------------------------------------------WRITEBACK STAGE COMPONENTS----------------------------------------------------------------------------

  --WB Stage
  MemOrCPUmux : mux2t1_N
    port map(
      i_S   => s_wbMemToReg,
      i_D0  => s_wbMemOut,
      i_D1  => s_wbALUWriteBack,
      o_O   => s_RegWrData); 

  --Writeback RegFile Address
  s_RegWr <= s_wbRegWrite;
  
  s_RegWrAddr <= s_wbInst(11 downto 7);

  s_Halt <= s_wbHalt;

end structure;
