library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegFile is
    Port (
        clk : in STD_LOGIC;
        we3 : in STD_LOGIC;

        a1  : in STD_LOGIC_VECTOR(4 downto 0);
        a2  : in STD_LOGIC_VECTOR(4 downto 0);
        a3  : in STD_LOGIC_VECTOR(4 downto 0);

        wd3 : in STD_LOGIC_VECTOR(31 downto 0);

        rd1 : out STD_LOGIC_VECTOR(31 downto 0);
        rd2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
end RegFile;

architecture Behavioral of RegFile is

    type reg_array is array (0 to 31)
        of STD_LOGIC_VECTOR(31 downto 0);

    signal registers : reg_array :=
        (others => (others => '0'));

begin

    -- Register write
    process(clk)
    begin
        if rising_edge(clk) then

            if we3 = '1' and a3 /= "00000" then
                registers(
                    to_integer(unsigned(a3))
                ) <= wd3;
            end if;

        end if;
    end process;

    -- Two combinational read ports.
    rd1 <=
        (others => '0') when a1 = "00000"
        else registers(to_integer(unsigned(a1)));

    rd2 <=
        (others => '0') when a2 = "00000"
        else registers(to_integer(unsigned(a2)));

end Behavioral;
