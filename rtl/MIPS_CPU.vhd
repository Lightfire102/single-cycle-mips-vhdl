library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_CPU is
    Port (
        clk : in STD_LOGIC;

        -- Debug outputs for simulation.
        pc_idx_o     : out STD_LOGIC_VECTOR(2 downto 0);
        instr_o      : out STD_LOGIC_VECTOR(31 downto 0);

        rd1_o        : out STD_LOGIC_VECTOR(31 downto 0);
        rd2_o        : out STD_LOGIC_VECTOR(31 downto 0);

        alu_out_o    : out STD_LOGIC_VECTOR(31 downto 0);
        dm_rd_o      : out STD_LOGIC_VECTOR(31 downto 0);

        RegDst_o     : out STD_LOGIC;
        ALUSrc_o     : out STD_LOGIC;
        MemtoReg_o   : out STD_LOGIC;
        RegWrite_o   : out STD_LOGIC;
        MemWrite_o   : out STD_LOGIC;
        Branch_o     : out STD_LOGIC;
        Jump_o       : out STD_LOGIC;
        Zero_o       : out STD_LOGIC;

        ALUOp_o      : out STD_LOGIC_VECTOR(1 downto 0);
        ALUControl_o : out STD_LOGIC_VECTOR(2 downto 0)
    );
end MIPS_CPU;

architecture rtl of MIPS_CPU is

    ----------------------------------------------------------------
    -- Program counter
    ----------------------------------------------------------------

    signal pc :
        unsigned(2 downto 0) :=
        (others => '0');

    signal pc_next :
        unsigned(2 downto 0);

    signal pc_plus1 :
        unsigned(2 downto 0);

    signal branch_target :
        unsigned(2 downto 0);

    signal branch_taken :
        STD_LOGIC;

    ----------------------------------------------------------------
    -- Instruction
    ----------------------------------------------------------------

    signal instr :
        STD_LOGIC_VECTOR(31 downto 0);

    ----------------------------------------------------------------
    -- Control
    ----------------------------------------------------------------

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

    signal ALUOp :
        STD_LOGIC_VECTOR(1 downto 0);

    signal ALUControl :
        STD_LOGIC_VECTOR(2 downto 0);

    ----------------------------------------------------------------
    -- Register file
    ----------------------------------------------------------------

    signal RD1 :
        STD_LOGIC_VECTOR(31 downto 0);

    signal RD2 :
        STD_LOGIC_VECTOR(31 downto 0);

    signal WD3 :
        STD_LOGIC_VECTOR(31 downto 0);

    ----------------------------------------------------------------
    -- Immediate
    ----------------------------------------------------------------

    signal imm32 :
        STD_LOGIC_VECTOR(31 downto 0);

    ----------------------------------------------------------------
    -- ALU
    ----------------------------------------------------------------

    signal srcB :
        STD_LOGIC_VECTOR(31 downto 0);

    signal alu_result :
        STD_LOGIC_VECTOR(31 downto 0);

    signal Zero :
        STD_LOGIC;

    ----------------------------------------------------------------
    -- Data Memory
    ----------------------------------------------------------------

    signal memory_read_data :
        STD_LOGIC_VECTOR(31 downto 0);

begin

    ----------------------------------------------------------------
    -- FETCH
    ----------------------------------------------------------------

    IMEM:
    entity work.InstructionMemory
        port map (
            a  => STD_LOGIC_VECTOR(pc),
            rd => instr
        );

    ----------------------------------------------------------------
    -- DECODE
    ----------------------------------------------------------------

    CONTROL:
    entity work.ControlUnit
        port map (
            Instr      => instr,

            RegDst     => RegDst,
            ALUSrc     => ALUSrc,
            MemtoReg   => MemtoReg,
            RegWrite   => RegWrite,
            MemWrite   => MemWrite,
            Branch     => Branch,
            Jump       => Jump,

            ALUOp      => ALUOp,
            ALUControl => ALUControl
        );

    REGISTERS:
    entity work.RegFile_B
        port map (
            CLK    => clk,
            Instr  => instr,

            RegDst => RegDst,

            WD3    => WD3,
            WE3    => RegWrite,

            RD1    => RD1,
            RD2    => RD2,

            A1_o   => open,
            A2_o   => open,
            A3_o   => open
        );

    SIGN_EXTEND:
    entity work.SignExt
        port map (
            imm16 => instr(15 downto 0),
            imm32 => imm32
        );

    ----------------------------------------------------------------
    -- EXECUTE
    ----------------------------------------------------------------

    -- ALUSrc mux:
    -- 0 -> register operand
    -- 1 -> immediate
    srcB <=
        imm32 when ALUSrc = '1'
        else RD2;

    EXECUTION_ALU:
    entity work.ALU
        port map (
            A          => RD1,
            B          => srcB,

            ALUControl => ALUControl,

            Result     => alu_result,
            Zero       => Zero
        );

    ----------------------------------------------------------------
    -- MEMORY
    ----------------------------------------------------------------

    DMEM:
    entity work.DataMemory
        port map (
            clk => clk,
            we  => MemWrite,

            a   => alu_result,
            wd  => RD2,

            rd  => memory_read_data
        );

    ----------------------------------------------------------------
    -- WRITEBACK
    ----------------------------------------------------------------

    -- MemtoReg mux
    WD3 <=
        memory_read_data when MemtoReg = '1'
        else alu_result;

    ----------------------------------------------------------------
    -- NEXT PC
    ----------------------------------------------------------------

    pc_plus1 <= pc + 1;

    branch_taken <=
        Branch and Zero;

    -- Simplified word-addressed branch target.
    branch_target <=
        pc_plus1 +
        unsigned(imm32(2 downto 0));

    process(
        Jump,
        branch_taken,
        instr,
        branch_target,
        pc_plus1
    )
    begin

        if Jump = '1' then

            pc_next <=
                unsigned(instr(2 downto 0));

        elsif branch_taken = '1' then

            pc_next <= branch_target;

        else

            pc_next <= pc_plus1;

        end if;

    end process;

    ----------------------------------------------------------------
    -- PC register
    ----------------------------------------------------------------

    process(clk)
    begin

        if rising_edge(clk) then
            pc <= pc_next;
        end if;

    end process;

    ----------------------------------------------------------------
    -- Simulation / debug outputs
    ----------------------------------------------------------------

    pc_idx_o  <= STD_LOGIC_VECTOR(pc);
    instr_o   <= instr;

    rd1_o     <= RD1;
    rd2_o     <= RD2;

    alu_out_o <= alu_result;
    dm_rd_o   <= memory_read_data;

    RegDst_o   <= RegDst;
    ALUSrc_o   <= ALUSrc;
    MemtoReg_o <= MemtoReg;
    RegWrite_o <= RegWrite;
    MemWrite_o <= MemWrite;
    Branch_o   <= Branch;
    Jump_o     <= Jump;
    Zero_o     <= Zero;

    ALUOp_o      <= ALUOp;
    ALUControl_o <= ALUControl;

end rtl;
