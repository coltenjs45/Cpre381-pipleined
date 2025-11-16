library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity Forwarding_Unit is
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
    selectline_rs2bypassmux: out std_logic
    );

end Forwarding_Unit;

architecture dataflow of Forwarding_Unit is
    begin 

        selectline_rs1mux <= '00' when (forwardMemtoExRS1 = '0') and (forwardWbtoExRS1 = '0') else 
                             '01' when (forwardMemtoExRS1 = '1') and (forwardWbtoExRS1 = '0') else 
                             '10' when (forwardMemtoExRS1 = '0') and (forwardWbtoExRS1 = '1') else 
                             '00';

        selectline_rs1mux <= '00' when (forwardMemtoExRS2 = '0') and (forwardWbtoExRS2 = '0') else 
                             '01' when (forwardMemtoExRS2 = '1') and (forwardWbtoExRS2 = '0') else 
                             '10' when (forwardMemtoExRS2 = '0') and (forwardWbtoExRS2 = '1') else 
                             '00';

        selectline_rs1bypassmux <= '1' when (bypassregfileWBtoRS1 = '1') else 
                                   '0';

        selectline_rs2bypassmux <= '1' when (bypassregfileWBtoRS1 = '1') else 
                                   '0';



