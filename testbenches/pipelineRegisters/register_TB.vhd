library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity register_TB is
  generic(gCLK_HPER   : time := 50 ns);
  end register_TB;

architecture behavior of register_TB is

  signal s_CLK, s_RST : std_logic;

  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

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

  component EX_MEM_register_file
    generic (WIDTH : integer := 32);
    port(
        sysCLK              : in  std_logic;
        sysRST              : in  std_logic;
        write_enable        : in  std_logic;
        hazard              : in std_logic;
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

  component MEM_WB_register_file is
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
        input_ALUWriteBack  : in  std_logic_vector(WIDTH-1 downto 0);
        output_ALUWriteback : out std_logic_vector(WIDTH-1 downto 0);
        input_MemOut        : in  std_logic_vector(WIDTH-1 downto 0);
        output_MemOut       : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  signal s_IFpc, s_IDpc, s_Inst, s_idInst : std_logic_vector(31 downto 0);
  
  signal s_idALUsrc, s_idRegWrite, s_idMemWrite, s_idMemToReg, s_idShift, s_idFlagOrNFlag, s_idJumpWReg, s_idHalt : std_logic;
  signal s_idALUctrl : std_logic_vector(3 downto 0);
  signal s_idAndLink, s_idFlagMux: std_logic_vector(1 downto 0);

  signal s_idRS1, s_idRS2, s_idImmediate, s_IDpcUp4, s_IDpcUpImm : std_logic_vector(31 downto 0);

  signal s_exALUsrc, s_exRegWrite, s_exMemWrite, s_exMemToReg, s_exShift, s_exFlagOrNFlag, s_exHalt : std_logic;
  signal s_exALUctrl : std_logic_vector(3 downto 0);
  signal s_exAndLink, s_exFlagMux: std_logic_vector(1 downto 0);
  signal s_exImmediate, s_EXpcUp4, s_EXpcUpImm, s_exRS1, s_exRS2, s_exInst, s_exResult, s_exMemoryData : std_logic_vector(31 downto 0);

  signal s_memALUsrc, s_memRegWrite, s_memMemWrite, s_memMemToReg, s_memShift, s_memFlagOrNFlag, s_memHalt : std_logic;
  signal s_memALUctrl : std_logic_vector(3 downto 0);
  signal s_memAndLink, s_memFlagMux: std_logic_vector(1 downto 0);
  signal s_memALUWriteBack, s_memInst, s_memMemoryData, s_memMemOut, s_memWriteback : std_logic_vector(31 downto 0);

  signal s_wbALUsrc, s_wbRegWrite, s_wbMemWrite, s_wbMemToReg, s_wbShift, s_wbFlagOrNFlag, s_wbHalt : std_logic;
  signal s_wbALUctrl : std_logic_vector(3 downto 0);
  signal s_wbAndLink, s_wbFlagMux: std_logic_vector(1 downto 0);
  signal s_wbInst, s_wbALUWriteBack, s_wbMemOut : std_logic_vector(31 downto 0);  

  signal s_controlMaker : std_logic_vector(14 downto 0);
  signal s_IDstall, s_EXstall, s_MEMstall, s_WBstall : std_logic;
  signal s_EXnop, s_MEMnop : std_logic;

begin

  IF_ID_reg : IF_Register_file
    port map(
      sysCLK             => s_CLK,
      sysRST             => s_RST,
      write_enable       => s_IDstall,
      input_pc           => s_IFpc,
      input_instruction  => s_Inst,
      output_pc          => s_IDpc,
      output_instruction => s_idInst);

  ID_EX_reg : ID_EX_register_file
    port map(
      sysCLK             => s_CLK,
      sysRST             => s_RST,
      write_enable       => s_EXstall,
      hazard             => s_EXnop,

      input_instruction  => s_idInst,
      output_instruction => s_exInst,
      input_ALUsrc       => s_controlMaker(0),
      output_ALUsrc      => s_exALUsrc,
      input_ALUcontrol   => s_controlMaker(10 downto 7),
      output_ALUcontrol  => s_exALUctrl,
      input_FlagMux      => s_controlMaker(14 downto 13),
      output_FlagMux     => s_exFlagMux,
      input_FlagOrNFlag  => s_controlMaker(5),
      output_FlagOrNFlag => s_exFlagOrNFlag,
      input_Shift        => s_controlMaker(4),
      output_Shift       => s_exShift,
      input_AndLink      => s_controlMaker(12 downto 11),
      output_AndLink     => s_exAndLink,
      input_MemWrite     => s_controlMaker(2),
      output_MemWrite    => s_exMemWrite,
      input_MemtoReg     => s_controlMaker(3),
      output_MemtoReg    => s_exMemToReg,
      input_RegWrite     => s_controlMaker(1),
      output_RegWrite    => s_exRegWrite,
      input_Halt         => s_controlMaker(6),
      output_Halt        => s_exHalt,

      input_rs1          => s_idRS1,
      output_rs1         => s_exRS1,
      input_rs2          => s_idRS1,
      output_rs2         => s_exRS2,
      input_imm          => s_idImmediate,
      output_imm         => s_exImmediate,
      input_pcUp4        => s_IDpcUp4,
      output_pcUp4       => s_EXpcUp4,
      input_pcUpImm      => s_IDpcUpImm,
      output_pcUpImm     => s_EXpcUpImm);

  EX_MEM_reg : EX_MEM_register_file
    port map(
      sysCLK             => s_CLK,
      sysRST             => s_RST,
      write_enable       => s_MEMstall,
      hazard             => s_MEMnop,

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

      input_ALUBSout     => s_exResult,
      output_ALUBSout    => s_memALUWriteBack,
      input_writedata    => s_exMemoryData,
      output_writedata   => s_memMemoryData); 

  MEM_WB_reg : MEM_WB_register_file
    port map(
      sysCLK              => s_CLK,
      sysRST              => s_RST,
      write_enable        => s_WBstall,
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

  --Fs_RST 7 bits is the 7 single bit
  --Next 4 is ALUCtrl
  --Next 2 AndLink Next 2 FlagMux
  
  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER; 
    s_CLK <= '1';
    wait for gCLK_HPER; 
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    s_RST	<= '1';
    wait for gCLK_HPER/2;
    s_RST	<= '0';
    
    --INITIALIZE
    
    --IF/ID Register
    s_Inst          <= x"00000000";
    s_IFpc          <= x"10010000";
    s_IDstall       <= not '0';

    --ID/EX Register
                    --"00 00 0000 0 0 0 0 0 0 0"  
    s_controlMaker  <= "000000000000000";

    s_idRS1         <= x"00000000";
    s_idRS2         <= x"00000000";
    s_idImmediate   <= x"00000000";
    s_IDpcUp4       <= x"10010004";
    s_IDpcUpImm     <= x"10010000";

    s_EXstall       <= not '0';
    s_EXnop         <= '0';

    --EX/MEM Register
    s_exResult      <= x"00000000";
    s_exMemoryData  <= x"00000000";

    s_MEMstall      <= not'0';
    s_MEMnop        <= '0';

    --MEM/WB Register
    s_memWriteBack  <= x"00000000";
    s_memMemOut     <= x"00000000";

    s_WBstall      <= not '0';

    wait;
  end process;
  
end behavior;