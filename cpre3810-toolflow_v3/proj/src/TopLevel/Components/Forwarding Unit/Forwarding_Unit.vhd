library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity Forwarding_Unit is
  generic(WIDTH : integer := 32);
    port(
    forwardMemtoIdRS1       : in std_logic;
    forwardMemtoExRS1       : in std_logic;
    forwardWbtoExRS1        : in std_logic;
    loadHazardRS1           : in std_logic;
    bypassregfileWBtoRS1    : in std_logic;
    forwardMemtoIdRS2       : in std_logic;
    forwardMemtoExRS2       : in std_logic;
    forwardWbtoExRS2        : in std_logic;
    loadHazardRS2           : in std_logic;
    bypassregfileWBtoRS2    : in std_logic;
    select_rs1mux       : out std_logic_vector(1 downto 0);
    select_rs2mux       : out std_logic_vector(1 downto 0);
    select_rs1bypassmux : out std_logic_vector(1 downto 0);
    select_rs2bypassmux : out std_logic_vector(1 downto 0));

end Forwarding_Unit;

architecture dataflow of Forwarding_Unit is
    begin 

        select_rs1mux <= "00" when (forwardMemtoExRS1 = '0') and (forwardWbtoExRS1 = '0') else 
                         "10" when (forwardMemtoExRS1 = '0') and (forwardWbtoExRS1 = '1') else 
                         "01" when (forwardMemtoExRS1 = '1') and (forwardWbtoExRS1 = '0') else 
                         "01" when (forwardMemtoExRS1 = '1') and (forwardWbtoExRS1 = '1') else
                         "10" when (loadHazardRS1 = '1') else
                         "00";

        select_rs2mux <= "00" when (forwardMemtoExRS2 = '0') and (forwardWbtoExRS2 = '0') else 
                         "01" when (forwardMemtoExRS2 = '1') and (forwardWbtoExRS2 = '0') else 
                         "10" when (forwardMemtoExRS2 = '0') and (forwardWbtoExRS2 = '1') else 
                         "01" when (forwardMemtoExRS2 = '1') and (forwardWbtoExRS2 = '1') else
                         "10" when (loadHazardRS2 = '1') else
                         "00";

        select_rs1bypassmux <= forwardMemtoIdRS1 & bypassregfileWBtoRS1;

        select_rs2bypassmux <= forwardMemtoIdRS2 & bypassregfileWBtoRS2;

end dataflow;

