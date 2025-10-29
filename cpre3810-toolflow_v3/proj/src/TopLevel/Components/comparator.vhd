library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
    port (
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        compare : out std_logic
    );
end entity comparator;

architecture mixed of comparator is

  component mux4t1
    port(
      i_D0 : in std_logic;
      i_D1 : in std_logic;
      i_D2 : in std_logic;
      i_D3 : in std_logic;
      i_S  : in std_logic_vector(1 downto 0);
      o_Y  : out std_logic);  
  end component;

    signal A_signed, B_signed : signed(31 downto 0);
    signal s_GT, s_LT, s_EQ, s_NE, s_GTEQ, s_branchCompare : std_logic;

    begin
    A_signed <= signed(A);
    B_signed <= signed(B);   
    -- Concurrent signal assignments for comparison
    s_GT <= '1' when (A_signed > B_signed) and (funct3(2 downto 1) = "10") else
            '1' when (A > B) else 
            '0';

    s_LT <= '1' when (A_signed < B_signed) and (funct3(2 downto 1) = "10") else 
            '1' when (A < B) else 
            '0';

    s_EQ <= '1' when A = B else '0';
    s_NE <= '1' when A /= B else '0';
    s_GTEQ <= '1' when s_GT or s_EQ else '0';


    BranchSelect : mux4t1
      port map(
        i_D0 => s_EQ,
        i_D1 => s_NE,    
        i_D2 => s_LT,
        i_D3 => s_GTEQ,
        i_S  => funct3(2) & funct3(0),
        o_Y  => compare);

end architecture mixed;