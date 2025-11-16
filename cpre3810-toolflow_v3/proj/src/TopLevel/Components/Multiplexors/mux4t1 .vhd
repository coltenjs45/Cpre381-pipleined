library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1 is
    port(
        i_D0 : in std_logic;
        i_D1 : in std_logic;
        i_D2 : in std_logic;
        i_D3 : in std_logic;
        i_S  : in std_logic_vector(1 downto 0);
        o_Y  : out std_logic
    );
end mux4t1;

architecture dataflow of mux4t1 is

begin
  o_Y <= i_D0 when (i_S = "00") else
         i_D1 when (i_S = "01") else
	     i_D2 when (i_S = "10") else
         i_D3 when (i_S = "11") else
         '0';

end dataflow;