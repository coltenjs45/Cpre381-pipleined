library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sp_Reg is
  generic(WIDTH : integer := 32);
  port( CLK : in std_logic;
        RST : in std_logic;
        wEnable : in std_logic;
        inData : in std_logic_vector(WIDTH-1 downto 0);
        outData : out std_logic_vector(WIDTH-1 downto 0));
end sp_Reg;

architecture structure of sp_Reg is

  component pc_dffg
    port(i_CLK : in std_logic;
         i_RST : in std_logic;
         i_WE : in std_logic;
         i_INIT : in std_logic;
         i_D : in std_logic;
         o_Q : out std_logic);
  end component;

  constant INIT_VALUE : std_logic_vector(WIDTH-1 downto 0) := x"7FFFEFFC";
  signal q_internal : std_logic_vector(WIDTH-1 downto 0);

begin

  sp_Reg: for i in 0 to WIDTH-1 generate
    pcDFFN: pc_dffg port map(
      i_CLK => CLK,
      i_RST => RST,
      i_WE => wEnable,
      i_D => inData(i),
      i_INIT => INIT_VALUE(i),
      o_Q => q_internal(i));
  end generate sp_Reg;

  outData <= q_internal;

end structure;