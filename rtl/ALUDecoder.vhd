library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUDecoder is
    Port (
        Funct      : in  STD_LOGIC_VECTOR(5 downto 0);
        ALUOp      : in  STD_LOGIC_VECTOR(1 downto 0);

        ALUControl : out STD_LOGIC_VECTOR(2 downto 0)
    );
end ALUDecoder;

architecture Behavioral of ALUDecoder is

begin

    process(ALUOp, Funct)
    begin

        case ALUOp is

            -- LW / SW / ADDI
            when "00" =>
                ALUControl <= "010";

            -- BEQ
            when "01" =>
                ALUControl <= "110";

            -- R-type
            when "10" =>

                case Funct is

                    when "100000" =>
                        ALUControl <= "010"; -- ADD

                    when "100010" =>
                        ALUControl <= "110"; -- SUB

                    when "100100" =>
                        ALUControl <= "000"; -- AND

                    when "100101" =>
                        ALUControl <= "001"; -- OR

                    when "101010" =>
                        ALUControl <= "111"; -- SLT

                    when others =>
                        ALUControl <= "010";

                end case;

            when others =>
                ALUControl <= "010";

        end case;

    end process;

end Behavioral;
