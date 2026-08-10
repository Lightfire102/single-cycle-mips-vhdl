library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExt is
    Port (
        imm16 : in  STD_LOGIC_VECTOR(15 downto 0);
        imm32 : out STD_LOGIC_VECTOR(31 downto 0)
    );
end SignExt;

architecture Behavioral of SignExt is

begin

    imm32(15 downto 0)
        <= imm16;

    imm32(31 downto 16)
        <= (others => imm16(15));

end Behavioral;
