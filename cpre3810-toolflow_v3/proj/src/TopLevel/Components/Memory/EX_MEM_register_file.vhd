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
        output_writedata          : out std_logic_vector(WIDTH-1 downto 0);
    );
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
            outData : out std_logic_vector(WIDTH-1 downto 0)
        );
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
            outData => output_instruction
        );

    -- Control Path Registers
    ALUsrc_reg : neg_edge_nBit_Reg
        generic map(WIDTH => 1)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_ALUsrc,
            outData => output_ALUsrc
        );

    ALUcontrol_reg : neg_edge_nBit_Reg
        generic map(WIDTH => 4)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_ALUcontrol,
            outData => output_ALUcontrol
        );

    FlagMux_reg : neg_edge_nBit_Reg
        generic map(WIDTH => 2)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_FlagMux,
            outData => output_FlagMux
        );

    FlagOrNFlag_reg : neg_edge_nBit_Reg
        generic map(WIDTH => 1)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_FlagOrNFlag,
            outData => output_FlagOrNFlag
        );

    Shift_reg : neg_edge_nBit_Reg
        generic map(WIDTH => 1)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_Shift,
            outData => output_Shift
        );

    AndLink_reg : neg_edge_nBit_Reg
        generic map(WIDTH => 2)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_AndLink,
            outData => output_AndLink
        );

    MemWrite_reg : neg_edge_nBit_Reg
        generic map(WIDTH => 1)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_MemWrite,
            outData => output_MemWrite
        );

    MemtoReg_reg : neg_edge_nBit_Reg
        generic map(WIDTH => 1)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_MemtoReg,
            outData => output_MemtoReg
        );

    RegWrite_reg : neg_edge_nBit_Reg
        generic map(WIDTH => 1)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_RegWrite,
            outData => output_RegWrite
        );
    -- dataflow registers 
    ALUBSout_reg : neg_edge_nBit_Reg
        generic map(WIDTH => WIDTH)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_ALUBSout,
            outData => output_ALUBSout
        );

    
    WriteData_reg : neg_edge_nBit_Reg
        generic map(WIDTH => WIDTH)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_writedata,
            outData => output_writedata
        );
end architecture structure;