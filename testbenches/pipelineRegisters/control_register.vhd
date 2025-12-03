library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity control_register is
    generic (
        WIDTH : integer := 32
    );
    port(
        -- Clock and Reset
        CLK              : in  std_logic;
        RST              : in  std_logic;

        -- Write Enable
        wr_en            : in  std_logic;

        -- Control Path Signals
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

end entity control_register;

architecture structure of control_register is

  component negdffg is
    port(
      i_CLK        : in std_logic;
      i_RST        : in std_logic;
      i_WE         : in std_logic;
      i_D          : in std_logic;
      o_Q          : out std_logic);
  end component;

  component neg_edge_nBit_Reg is
    generic (WIDTH : integer := 32);
    port(
      CLK     : in std_logic;
      RST     : in std_logic;
      wEnable : in std_logic;
      inData  : in std_logic_vector(WIDTH-1 downto 0);
      outData : out std_logic_vector(WIDTH-1 downto 0));
    end component;

begin

    -- Control Path Registers
    ALUsrc_reg : negdffg
      port map(
        i_CLK => CLK,
        i_RST => RST,
        i_WE  => wr_en,
        i_D   => in_ALUsrc,
        o_Q   => out_ALUsrc);

    ALUcontrol_reg : neg_edge_nBit_Reg
      generic map(WIDTH => 4)
      port map(
        CLK     => CLK,
        RST     => RST,
        wEnable => wr_en,
        inData  => in_ALUcontrol,
        outData => out_ALUcontrol);

    FlagMux_reg : neg_edge_nBit_Reg
      generic map(WIDTH => 2)
      port map(
        CLK     => CLK,
        RST     => RST,
        wEnable => wr_en,
        inData  => in_FlagMux,
        outData => out_FlagMux);

    FlagOrNFlag_reg : negdffg
      port map(
        i_CLK => CLK,
        i_RST => RST,
        i_WE  => wr_en,
        i_D   => in_FlagOrNFlag,
        o_Q   => out_FlagOrNFlag);

    Shift_reg : negdffg
      port map(
        i_CLK => CLK,
        i_RST => RST,
        i_WE  => wr_en,
        i_D   => in_Shift,
        o_Q   => out_Shift);

    AndLink_reg : neg_edge_nBit_Reg
      generic map(WIDTH => 2)
      port map(
        CLK     => CLK,
        RST     => RST,
        wEnable => wr_en,
        inData  => in_AndLink,
        outData => out_AndLink);

    MemWrite_reg : negdffg
      port map(
        i_CLK => CLK,
        i_RST => RST,
        i_WE  => wr_en,
        i_D   => in_MemWrite,
        o_Q   => out_MemWrite);

    MemtoReg_reg : negdffg
      port map(
        i_CLK => CLK,
        i_RST => RST,
        i_WE  => wr_en,
        i_D   => in_MemtoReg,
        o_Q   => out_MemtoReg);

    RegWrite_reg : negdffg
      port map(
        i_CLK => CLK,
        i_RST => RST,
        i_WE  => wr_en,
        i_D   => in_RegWrite,
        o_Q   => out_RegWrite);

    Halt_reg : negdffg
      port map(
        i_CLK => CLK,
        i_RST => RST,
        i_WE  => wr_en,
        i_D   => in_Halt,
        o_Q   => out_Halt);

end architecture structure;