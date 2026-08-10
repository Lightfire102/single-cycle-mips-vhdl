library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        A          : in  STD_LOGIC_VECTOR(31 downto 0);
        B          : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl : in  STD_LOGIC_VECTOR(2 downto 0);

        Result     : out STD_LOGIC_VECTOR(31 downto 0);
        Zero       : out STD_LOGIC
    );
end ALU;

architecture Behavioral of ALU is

    signal result_internal :
        STD_LOGIC_VECTOR(31 downto 0);

begin

    process(A, B, ALUControl)

        variable temp :
            STD_LOGIC_VECTOR(31 downto 0);

    begin

        temp := (others => '0');

        case ALUControl is

            when "000" =>
                temp := A and B;

            when "001" =>
                temp := A or B;

            when "010" =>
                temp :=
                    STD_LOGIC_VECTOR(
                        signed(A) + signed(B)
                    );

            when "110" =>
                temp :=
                    STD_LOGIC_VECTOR(
                        signed(A) - signed(B)
                    );

            when "111" =>

                temp := (others => '0');

                if signed(A) < signed(B) then
                    temp(0) := '1';
                end if;

            when others =>
                temp := (others => '0');

        end case;

        result_internal <= temp;

    end process;

    Result <= result_internal;

    Zero <= '1'
            when result_internal = x"00000000"
            else '0';

end Behavioral;
