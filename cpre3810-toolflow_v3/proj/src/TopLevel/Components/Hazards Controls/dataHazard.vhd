library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity dataHazard is

  generic(WIDTH : integer := 32);
 
  port(
    idInst       : in std_logic_vector(WIDTH-1 downto 0); 
    exInst       : in std_logic_vector(WIDTH-1 downto 0);
    memInst      : in std_logic_vector(WIDTH-1 downto 0);
    wbInst       : in std_logic_vector(WIDTH-1 downto 0);
    exRegWrite   : in std_logic;
    memRegWrite  : in std_logic;
    wbRegWrite   : in std_logic;
    outSignal    : out std_logic);

end dataHazard;


architecture dataflow of dataHazard is
 
  signal idRS1, idRS2 : std_logic_vector(4 downto 0);
  signal exRD, memRD, wbRD : std_logic_vector(4 downto 0);

  begin
    idRS1 <= idInst(19 downto 15);
    idRS2 <= idInst(24 downto 20);
    exRD  <= exInst(11 downto 7);
    memRD <= memInst(11 downto 7);
    wbRD  <= wbInst(11 downto 7);

    outSignal <= '1' when (idRS1 /= "00000") and (idRS1 = exRD) and exRegWrite = '1' else
                 '1' when (idRS1 /= "00000") and (idRS1 = memRD) and memRegWrite = '1' else
                 '1' when (idRS1 /= "00000") and (idRS1 = wbRD) and wbRegWrite = '1' else
                 '1' when (idRS2 /= "00000") and (idRS2 = exRD) and exRegWrite = '1' else
                 '1' when (idRS2 /= "00000") and (idRS2 = memRD) and memRegWrite = '1' else
                 '1' when (idRS2 /= "00000") and (idRS2 = wbRD) and wbRegWrite = '1' else
                 '0';


end dataflow;