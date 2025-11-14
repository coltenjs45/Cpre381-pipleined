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
    outSignal    : out std_logic;
    forwardMemtoExRS1    : out std_logic;
    forwardWbtoExRS1    : out std_logic;
    bypassregfileWBtoRS1    : out std_logic;
    forwardMemtoExRS2    : out std_logic;
    forwardWbtoExRS2    : out std_logic;
    bypassregfileWBtoRS2    : out std_logic);



end dataHazard;


architecture dataflow of dataHazard is
 
  signal idRS1, idRS2 : std_logic_vector(4 downto 0);
  signal exRD, memRD, wbRD : std_logic_vector(4 downto 0);

  constant opcodeI : std_logic_vector(6 downto 0) := "0010011";

  begin
    idRS1 <= idInst(19 downto 15);
    idRS2 <= idInst(24 downto 20);
    exRD  <= exInst(11 downto 7);
    memRD <= memInst(11 downto 7);
    wbRD  <= wbInst(11 downto 7);

    forwardMemtoExRS1 <= '1' when (idRS1 /= "00000") and (idRS1 = exRD) and exRegWrite = '1' else '0';--1 instruction apart mem back to ex rs1
    forwardWbtoExRS1 <='1' when (idRS1 /= "00000") and (idRS1 = memRD) and memRegWrite = '1' else '0'; -- 2 instructions apart wb to ex rs1
    bypassregfileWBtoRS1 <='1' when (idRS1 /= "00000") and (idRS1 = wbRD) and wbRegWrite = '1' else '0';-- 3 instructions apart register bypass
    forwardMemtoExRS2 <= '1' when (idInst(6 downto 0) /= opcodeI) and (idRS2 /= "00000") and (idRS2 = exRD) and exRegWrite = '1' else '0';--1 instruction apart mem back to ex rs2
    forwardWbtoExRS2 <= '1' when (idInst(6 downto 0) /= opcodeI) and (idRS2 /= "00000") and (idRS2 = memRD) and memRegWrite = '1' else '0';-- 2 instructions apart wb to ex rs2
    bypassregfileWBtoRS2 <='1' when (idInst(6 downto 0) /= opcodeI) and (idRS2 /= "00000") and (idRS2 = wbRD) and wbRegWrite = '1'else '0';-- 3 instructions apart register bypass
    outSignal <=  '1' when ((forwardMemtoExRS1 = '1') or (forwardWbtoExRS1 = '1') or (bypassregfileWBtoRS1= '1') or (forwardMemtoExRS2= '1') or (forwardWbtoExRS2= '1') or (bypassregfileWBtoRS2 = '1')) else '0';


end dataflow;