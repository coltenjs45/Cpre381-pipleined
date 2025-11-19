library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity IF_register_file is
    generic (
        WIDTH : integer := 32
    );
    port(
        sysCLK              : in std_logic;
        sysRST              : in std_logic;
        write_enable        : in std_logic;
        input_pc            : in std_logic_vector(WIDTH-1 downto 0);
        input_instruction   : in std_logic_vector(WIDTH-1 downto 0);
        output_pc           : out std_logic_vector(WIDTH-1 downto 0);
        output_instruction  : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity IF_register_file;

architecture structure of IF_register_file is

    component neg_edge_nBit_Reg is
        generic (
            WIDTH : integer := 32
        );
        port(
            CLK     : in std_logic;
            RST     : in std_logic;
            wEnable : in std_logic;
            inData  : in std_logic_vector(WIDTH-1 downto 0);
            outData : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

begin
    inst_reg : neg_edge_nBit_Reg
        generic map(WIDTH => WIDTH)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_instruction,
            outData => output_instruction
        );
    pc_reg : neg_edge_nBit_Reg
        generic map(WIDTH => WIDTH)
        port map(
            CLK     => sysCLK,
            RST     => sysRST,
            wEnable => write_enable,
            inData  => input_pc,
            outData => output_pc
        );

end architecture structure;