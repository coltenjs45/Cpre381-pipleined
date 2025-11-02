library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity EX_MEM_register_file is
    generic (
        WIDTH : integer := 32
    );
    port(
        -- Clock and Reset
        sysCLK              : in  std_logic;
        sysRST              : in  std_logic;

        -- Write Enable
        write_enable        : in  std_logic;

        -- Instruction
        input_instruction   : in  std_logic_vector(WIDTH-1 downto 0);
        output_instruction  : out std_logic_vector(WIDTH-1 downto 0);

        -- Control Path Signals
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

        -- Data Path Signals
        input_ALUBSout           : in  std_logic_vector(WIDTH-1 downto 0);
        output_ALUBSout          : out std_logic_vector(WIDTH-1 downto 0);

        input_writedata           : in  std_logic_vector(WIDTH-1 downto 0);
        output_writedata          : out std_logic_vector(WIDTH-1 downto 0));

end entity EX_MEM_register_file;

architecture structure of EX_MEM_register_file is

    component neg_edge_nBit_Reg is
        generic (
            WIDTH : integer := 32
        );
        port(
            CLK     : in std_logic;
            RST     : in std_logic;
            wEnable : in std_logic;
            inData  : in std_logic_vector(WIDTH-1 downto 0);
            outData : out std_logic_vector(WIDTH-1 downto 0));
    end component;

    component control_register is
      generic (WIDTH : integer := 32);
      port(
        CLK              : in  std_logic;
        RST              : in  std_logic;
        wr_en            : in  std_logic;
        in_ALUsrc        : in  std_logic;
        out_ALUsrc       : out std_logic;
        in_ALUcontrol    : in  std_logic_vector(3 downto 0);
        out_ALUcontrol   : out std_logic_vector(3 downto 0);
        in_FlagMux       : in  std_logic_vector(1 downto 0);
        out_FlagMux      : out std_logic_vector(1 downto 0);
        in_FlagOrNFlag   : in  std_logic;
        out_FlagOrNFlag  : out std_logic;
        in_Shift         : in  std_logic;
        out_Shift        : out std_logic;
        in_AndLink       : in  std_logic_vector(1 downto 0);
        out_AndLink      : out std_logic_vector(1 downto 0);
        in_MemWrite      : in  std_logic;
        out_MemWrite     : out std_logic;
        in_MemtoReg      : in  std_logic;
        out_MemtoReg     : out std_logic;
        in_RegWrite      : in  std_logic;
        out_RegWrite     : out std_logic;
        in_Halt          : in  std_logic;
        out_Halt         : out std_logic);
    end component;
    
begin
    -- Instruction Register
    instruction_reg : neg_edge_nBit_Reg
        generic map(WIDTH => WIDTH)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_instruction,
            outData => output_instruction);

    Control_reg : control_register
      port map(
        CLK             => sysCLK,
        RST             => sysRST,
        wr_en           => write_enable,
        in_ALUsrc       => input_ALUsrc,
        out_ALUsrc      => output_ALUsrc,
        in_ALUcontrol   => input_ALUcontrol,
        out_ALUcontrol  => output_ALUcontrol,
        in_FlagMux      => input_FlagMux,
        out_FlagMux     => output_FlagMux,
        in_FlagOrNFlag  => input_FlagOrNFlag,
        out_FlagOrNFlag => output_FlagOrNFlag,
        in_Shift        => input_Shift,
        out_Shift       => output_Shift,
        in_AndLink      => input_AndLink,
        out_AndLink     => output_AndLink,
        in_MemWrite     => input_MemWrite,
        out_MemWrite    => output_MemWrite,
        in_MemtoReg     => input_MemToReg,
        out_MemtoReg    => output_MemToReg,
        in_RegWrite     => input_RegWrite,
        out_RegWrite    => output_RegWrite,
        in_Halt         => input_Halt,
        out_Halt        => output_Halt);

    -- dataflow registers 
    ALUBSout_reg : neg_edge_nBit_Reg
        generic map(WIDTH => WIDTH)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_ALUBSout,
            outData => output_ALUBSout);

    
    WriteData_reg : neg_edge_nBit_Reg
        generic map(WIDTH => WIDTH)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_writedata,
            outData => output_writedata);

end architecture structure;