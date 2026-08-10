library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_MIPS_CPU is
end TB_MIPS_CPU;

architecture Behavioral of TB_MIPS_CPU is

    signal clk :
        STD_LOGIC := '0';

    signal sim_done :
        STD_LOGIC := '0';

    signal pc_idx :
        STD_LOGIC_VECTOR(2 downto 0);

    signal instr :
        STD_LOGIC_VECTOR(31 downto 0);

    signal rd1 :
        STD_LOGIC_VECTOR(31 downto 0);

    signal rd2 :
        STD_LOGIC_VECTOR(31 downto 0);

    signal alu_out :
        STD_LOGIC_VECTOR(31 downto 0);

    signal dm_rd :
        STD_LOGIC_VECTOR(31 downto 0);

    signal RegDst :
        STD_LOGIC;

    signal ALUSrc :
        STD_LOGIC;

    signal MemtoReg :
        STD_LOGIC;

    signal RegWrite :
        STD_LOGIC;

    signal MemWrite :
        STD_LOGIC;

    signal Branch :
        STD_LOGIC;

    signal Jump :
        STD_LOGIC;

    signal Zero :
        STD_LOGIC;

    signal ALUOp :
        STD_LOGIC_VECTOR(1 downto 0);

    signal ALUControl :
        STD_LOGIC_VECTOR(2 downto 0);

begin

    DUT:
    entity work.MIPS_CPU
        port map (
            clk => clk,

            pc_idx_o  => pc_idx,
            instr_o   => instr,

            rd1_o     => rd1,
            rd2_o     => rd2,

            alu_out_o => alu_out,
            dm_rd_o   => dm_rd,

            RegDst_o   => RegDst,
            ALUSrc_o   => ALUSrc,
            MemtoReg_o => MemtoReg,
            RegWrite_o => RegWrite,
            MemWrite_o => MemWrite,
            Branch_o   => Branch,
            Jump_o     => Jump,
            Zero_o     => Zero,

            ALUOp_o      => ALUOp,
            ALUControl_o => ALUControl
        );

    ----------------------------------------------------------------
    -- Clock
    ----------------------------------------------------------------

    clock_process:
    process
    begin

        while sim_done = '0' loop

            clk <= '0';
            wait for 5 ns;

            clk <= '1';
            wait for 5 ns;

        end loop;

        wait;

    end process;

    ----------------------------------------------------------------
    -- Simulation length
    ----------------------------------------------------------------

    stimulus:
    process
    begin

        wait for 120 ns;

        sim_done <= '1';

        wait;

    end process;

end Behavioral;
