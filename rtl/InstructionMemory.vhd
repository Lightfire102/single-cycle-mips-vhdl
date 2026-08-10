library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionMemory is
    Port (
        a  : in  STD_LOGIC_VECTOR(2 downto 0);
        rd : out STD_LOGIC_VECTOR(31 downto 0)
    );
end InstructionMemory;

architecture Behavioral of InstructionMemory is

    type rom_t is array (0 to 5) of STD_LOGIC_VECTOR(31 downto 0);

    constant ROM : rom_t := (
        0 => x"20080001", -- ADDI $t0, $zero, 1
        1 => x"AC080000", -- SW   $t0, 0($zero)
        2 => x"8C090000", -- LW   $t1, 0($zero)
        3 => x"01095020", -- ADD  $t2, $t0, $t1
        4 => x"11400001", -- BEQ  $t2, $zero, +1
        5 => x"08000000"  -- J    0
    );

begin

    process(a)
        variable index : integer range 0 to 7;
    begin
        index := to_integer(unsigned(a));

        if index <= 5 then
            rd <= ROM(index);
        else
            rd <= (others => '0');
        end if;
    end process;

end Behavioral;
