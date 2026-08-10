library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataMemory is
    Port (
        clk : in  STD_LOGIC;
        we  : in  STD_LOGIC;
        a   : in  STD_LOGIC_VECTOR(31 downto 0);
        wd  : in  STD_LOGIC_VECTOR(31 downto 0);
        rd  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end DataMemory;

architecture Behavioral of DataMemory is

    constant DEPTH : integer := 16;

    type ram_t is array (0 to DEPTH-1)
        of STD_LOGIC_VECTOR(31 downto 0);

    signal mem : ram_t := (
        0 => x"00000000",
        1 => x"00000010",
        2 => x"00000020",
        3 => x"00000030",
        others => x"00000000"
    );

    signal windex : integer range 0 to DEPTH-1;

begin

    -- Word-addressed memory.
    windex <= to_integer(unsigned(a(3 downto 0)));

    -- Combinational read.
    rd <= mem(windex);

    -- Synchronous write.
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                mem(windex) <= wd;
            end if;
        end if;
    end process;

end Behavioral;
