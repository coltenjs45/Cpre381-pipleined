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

  component mux2t1_dataflow is
    port(
      SEL    : in std_logic;
      iA     : in std_logic;
      iB     : in std_logic;
      OUTPUT : out std_logic
    );
  end component;

  -- intermediate outputs from first stage
  signal L0_0, L0_1 : std_logic_vector(N-1 downto 0);

begin

  -- First stage: D0 vs D1
  L0_0_Gen : for i in 0 to N-1 generate
    M0: mux2t1_dataflow
      port map(
        SEL    => i_S(0),
        iA     => i_D0(i),
        iB     => i_D1(i),
        OUTPUT => L0_0(i)
      );
  end generate;

  -- First stage: D2 vs D3
  L0_1_Gen : for i in 0 to N-1 generate
    M1: mux2t1_dataflow
      port map(
        SEL    => i_S(0),
        iA     => i_D2(i),
        iB     => i_D3(i),
        OUTPUT => L0_1(i)
      );
  end generate;

  -- Second stage: select between the two results
  L1_Gen : for i in 0 to N-1 generate
    M2: mux2t1_dataflow
      port map(
        SEL    => i_S(1),
        iA     => L0_0(i),
        iB     => L0_1(i),
        OUTPUT => o_O(i)
      );
  end generate;

end structural;
