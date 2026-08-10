library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
    Port (
        Instr : in STD_LOGIC_VECTOR(31 downto 0);

        RegDst   : out STD_LOGIC;
        ALUSrc   : out STD_LOGIC;
        MemtoReg : out STD_LOGIC;
        RegWrite : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
        Branch   : out STD_LOGIC;
        Jump     : out STD_LOGIC;

        ALUOp      : out STD_LOGIC_VECTOR(1 downto 0);
        ALUControl : out STD_LOGIC_VECTOR(2 downto 0)
    );
end ControlUnit;

architecture Behavioral of ControlUnit is

    signal opcode :
        STD_LOGIC_VECTOR(5 downto 0);

    signal funct :
        STD_LOGIC_VECTOR(5 downto 0);

    signal aluop_internal :
        STD_LOGIC_VECTOR(1 downto 0);

begin

    opcode <= Instr(31 downto 26);
    funct  <= Instr(5 downto 0);

    MainControl:
    entity work.MainDecoder
        port map (
            Op       => opcode,

            RegDst   => RegDst,
            ALUSrc   => ALUSrc,
            MemtoReg => MemtoReg,
            RegWrite => RegWrite,
            MemWrite => MemWrite,
            Branch   => Branch,
            Jump     => Jump,

            ALUOp    => aluop_internal
        );

    ALUControlDecoder:
    entity work.ALUDecoder
        port map (
            Funct      => funct,
            ALUOp      => aluop_internal,
            ALUControl => ALUControl
        );

    ALUOp <= aluop_internal;

end Behavioral;
