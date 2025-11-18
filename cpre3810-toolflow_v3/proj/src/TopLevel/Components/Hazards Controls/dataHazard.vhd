library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity dataHazard is

  generic(WIDTH : integer := 32);
 
  port(
    idInst               : in std_logic_vector(WIDTH-1 downto 0); 
    exInst               : in std_logic_vector(WIDTH-1 downto 0);
    memInst              : in std_logic_vector(WIDTH-1 downto 0);
    wbInst               : in std_logic_vector(WIDTH-1 downto 0);
    exRegWrite           : in std_logic;
    memRegWrite          : in std_logic;
    wbRegWrite           : in std_logic;
    idBranch             : in std_logic;
    idJump               : in std_logic;
    stallSignal          : out std_logic;
    memoryStallSignal    : out std_logic;
    forwardMemtoIdRS1    : out std_logic;
    forwardMemtoExRS1    : out std_logic;
    forwardWbtoExRS1     : out std_logic;
    loadHazardRS1        : out std_logic;
    bypassregfileWBtoRS1 : out std_logic;
    forwardMemtoIdRS2    : out std_logic;
    forwardMemtoExRS2    : out std_logic;
    forwardWbtoExRS2     : out std_logic;
    loadHazardRS2        : out std_logic;
    storeLoadHazardRS2   : out std_logic;
    bypassregfileWBtoRS2 : out std_logic);



end dataHazard;


architecture dataflow of dataHazard is

  signal idRS1, idRS2 : std_logic_vector(4 downto 0);
  signal exRS1, exRS2, memRS2 : std_logic_vector(4 downto 0);
  signal exRD, memRD, wbRD : std_logic_vector(4 downto 0);

  signal controlHazardExRS1, controlHazardExRS2, controlHazardMemRS1, controlHazardMemRS2 : std_logic;
  signal cStall, mStall : std_logic;

  constant opcodeI : std_logic_vector(6 downto 0) := "0010011";
  constant loadOpcode : std_logic_vector(6 downto 0) := "0000011";


  begin
    idRS1  <= idInst(19 downto 15);
    idRS2  <= idInst(24 downto 20);  
    exRS1  <= exInst(19 downto 15);
    exRS2  <= exInst(24 downto 20);
    exRD   <= exInst(11 downto 7);
    memRS2 <= memInst(24 downto 20);
    memRD  <= memInst(11 downto 7);
    wbRD   <= wbInst(11 downto 7);

    -- EX-to-EX Forwarding (1 instruction apart: MEM → EX)
    forwardMemtoExRS1 <= '1' when (exRS1 /= "00000") and (exRS1 = memRD) and memRegWrite = '1' else '0';
    forwardMemtoExRS2 <= '1' when (exInst(6 downto 0) /= opcodeI) and (exRS2 /= "00000") and (exRS2 = memRD) and memRegWrite = '1' else '0';

    -- MEM-to-EX Forwarding (2 instructions apart: WB -> EX)
    forwardWbtoExRS1 <= '1' when (exRS1 /= "00000") and (exRS1 = wbRD) and wbRegWrite = '1' else '0';
    forwardWbtoExRS2 <= '1' when (exInst(6 downto 0) /= opcodeI) and (exRS2 /= "00000") and (exRS2 = wbRD) and wbRegWrite = '1' else '0';

    -- Load-Use Hazard Detection (MEM stage load, EX stage use)
    loadHazardRS1 <= '1' when (memInst(6 downto 0) = loadOpcode) and (memRD /= "00000") and (exRS1 = memRD) and memRegWrite = '1' else '0';
    loadHazardRS2 <= '1' when (memInst(6 downto 0) = loadOpcode) and (memRD /= "00000") and (exRS2 = memRD) and memRegWrite = '1' else '0';

    -- Store-Load Hazard (WB stage load, MEM stage store)
    storeLoadHazardRS2 <= '1' when (wbInst(6 downto 0) = loadOpcode) and (wbRD /= "00000") and (memRS2 = wbRD) and wbRegWrite = '1' else '0';

    -- Control Hazard (Mem -> ID)
    forwardMemtoIdRS1 <= '1' when (idRS1 /= "00000") and (idRS1 = memRD) and memRegWrite = '1' else '0';
    forwardMemtoIdRS2 <= '1' when (idRS2 /= "00000") and (idRS2 = memRD) and memRegWrite = '1' else '0';
  
    --Control Hazard (Ex -> ID)
    controlHazardExRS1 <= '1' when (idRS1 /= "00000") and (idRS1 = exRD) and exRegWrite = '1' and (idBranch = '1' or idJump = '1') else '0'; 
    controlHazardExRS2 <= '1' when (idRS2 /= "00000") and (idRS2 = exRD) and exRegWrite = '1' and (idBranch = '1' or idJump = '1') else '0';
    controlHazardMemRS1 <= '1' when (idRS1 /= "00000") and (idRS1 = memRD) and memRegWrite = '1' and (idBranch = '1' or idJump = '1') else '0'; 
    controlHazardMemRS2 <= '1' when (idRS2 /= "00000") and (idRS2 = memRD) and memRegWrite = '1' and (idBranch = '1' or idJump = '1') else '0';

    -- Register File Bypass (WB -> ID)
    bypassregfileWBtoRS1 <= '1' when (idRS1 /= "00000") and (idRS1 = wbRD) and wbRegWrite = '1' else '0';
    bypassregfileWBtoRS2 <= '1' when (idRS2 /= "00000") and (idRS2 = wbRD) and wbRegWrite = '1' else '0';
  

    cStall <= '1' when ((controlHazardExRS1 = '1') or
                        (controlHazardExRS2 = '1') or
                        (controlHazardMemRS1 = '1') or
                        (controlHazardMemRS2 = '1')) else
              '0';
    
    mstall <= '1' when ((loadHazardRS1 = '1') or
                        (loadHazardRS2 = '1')) else
              '0';

    stallSignal <= cStall or mStall;
    memoryStallSignal <= mStall;

end dataflow;