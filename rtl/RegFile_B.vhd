library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegFile_B is
    Port (
        CLK    : in STD_LOGIC;
        Instr  : in STD_LOGIC_VECTOR(31 downto 0);

        RegDst : in STD_LOGIC;
        WD3    : in STD_LOGIC_VECTOR(31 downto 0);
        WE3    : in STD_LOGIC;

        RD1    : out STD_LOGIC_VECTOR(31 downto 0);
        RD2    : out STD_LOGIC_VECTOR(31 downto 0);

        A1_o   : out STD_LOGIC_VECTOR(4 downto 0);
        A2_o   : out STD_LOGIC_VECTOR(4 downto 0);
        A3_o   : out STD_LOGIC_VECTOR(4 downto 0)
    );
end RegFile_B;

architecture Behavioral of RegFile_B is

    signal a1 : STD_LOGIC_VECTOR(4 downto 0);
    signal a2 : STD_LOGIC_VECTOR(4 downto 0);
    signal a3 : STD_LOGIC_VECTOR(4 downto 0);

begin

    -- rs
    a1 <= Instr(25 downto 21);

    -- rt
    a2 <= Instr(20 downto 16);

    -- R-type writes rd.
    -- I-type writes rt.
    a3 <= Instr(15 downto 11)
          when RegDst = '1'
          else Instr(20 downto 16);

    A1_o <= a1;
    A2_o <= a2;
    A3_o <= a3;

    RF:
    entity work.RegFile
        port map (
            clk => CLK,
            we3 => WE3,

            a1  => a1,
            a2  => a2,
            a3  => a3,

            wd3 => WD3,

            rd1 => RD1,
            rd2 => RD2
        );

end Behavioral;
