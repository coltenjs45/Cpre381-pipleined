library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1_N is
  generic(N : integer := 32);
  port(
      i_S  : in std_logic_vector(1 downto 0);   -- 2-bit select
      i_D0 : in std_logic_vector(N-1 downto 0);
      i_D1 : in std_logic_vector(N-1 downto 0);
      i_D2 : in std_logic_vector(N-1 downto 0);
      i_D3 : in std_logic_vector(N-1 downto 0);
      o_O  : out std_logic_vector(N-1 downto 0)
  );
end mux4t1_N;

architecture structural of mux4t1_N is

  component mux4t1 is
    port(
        i_D0 : in std_logic;
        i_D1 : in std_logic;
        i_D2 : in std_logic;
        i_D3 : in std_logic;
        i_S  : in std_logic_vector(1 downto 0);
        o_Y  : out std_logic
    );
  end component;

begin

  G_NBit_MUX: for i in 0 to N-1 generate
    MUXI: mux4t1 port map(
        i_D0 => i_D0(i),
        i_D1 => i_D1(i),
        i_D2 => i_D2(i),
        i_D3 => i_D3(i),
        i_S  => i_S,
        o_Y  => o_O(i));
  end generate G_NBit_MUX;
  
end structural;
