# 32-bit Single-Cycle MIPS CPU in VHDL

A modular educational implementation of a simplified 32-bit
single-cycle MIPS processor written in VHDL and simulated in
AMD/Xilinx Vivado.

## Supported Instructions

- R-type ADD
- ADDI
- LW
- SW
- BEQ
- J

## Architecture

The processor integrates:

- Program counter
- Instruction memory
- 32 x 32-bit register file
- Main control decoder
- ALU decoder
- Sign extender
- 32-bit ALU
- Data memory
- ALUSrc and MemtoReg datapath selection
- Branch and jump PC-selection logic

## Datapath

```mermaid
flowchart LR
    PC[Program Counter] --> IMEM[Instruction Memory]
    IMEM --> CTRL[Control Unit]
    IMEM --> RF[Register File]
    IMEM --> EXT[Sign Extend]

    RF --> ALU[32-bit ALU]
    EXT --> ALU

    CTRL --> RF
    CTRL --> ALU
    CTRL --> DMEM[Data Memory]

    ALU --> DMEM
    ALU --> WB[Writeback Mux]
    DMEM --> WB
    WB --> RF

    ALU --> PCLOGIC[Branch / Jump Logic]
    CTRL --> PCLOGIC
    PCLOGIC --> PC
