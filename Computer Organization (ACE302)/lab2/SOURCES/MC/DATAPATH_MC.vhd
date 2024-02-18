----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:00:54 05/16/2021 
-- Design Name: 
-- Module Name:    DATAPATH_MC - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATAPATH_MC is
	Port (  clk : in  STD_LOGIC; --
           rst : in  STD_LOGIC; --
			  -- For PC 
           PC_LdEn : in  STD_LOGIC;
			  PC_sel: in  STD_LOGIC;
			  PC_addr : out  STD_LOGIC_VECTOR (31 downto 0); -- instraction addr from pc to ram
			  -- Instr_Reg
			  InstrReg_LdEn : in  STD_LOGIC; 
			  Instraction : out  STD_LOGIC_VECTOR (31 downto 0); -- instraction to be excecute to control 
			  -- Decode_stage
           RF_WrEn : in  STD_LOGIC;
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
			  --Register A,B
			  Reg_A_WrEn : in  STD_LOGIC;
			  Reg_B_WrEn : in  STD_LOGIC;
			  
			  -- Execute_stage
           --ALU_Bin_sel : in  STD_LOGIC;
           ALU_Func : in  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_zero : out  STD_LOGIC;
			  ALU_SrcA_sel : in  STD_LOGIC; -- control for Mux 2-1
			  ALU_SrcB_sel : in  STD_LOGIC_VECTOR (1 downto 0); -- control for Mux 4-1 
			  
			  -- ALU Register
			  Reg_ALU_WrEn : in  STD_LOGIC;
			  
			  -- Mem_stage
           ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
			  -- Mem_Ram
			  MM_WrEn : out  STD_LOGIC; -- Write enable flag to ram
			  MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0); -- instraction addr to ram
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0); -- data to store to ram
			  MM_RdData_in : in  STD_LOGIC_VECTOR (31 downto 0); -- data FROM Ram
			  MM_instr : in  STD_LOGIC_VECTOR (31 downto 0); -- isntraction to execute from ram
			  
			  -- Memory Register
			  Reg_MEM_WrEn : in  STD_LOGIC
			  );
end DATAPATH_MC;

architecture Behavioral of DATAPATH_MC is

component Decode_stage
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel  : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           clk  : in  STD_LOGIC;
			  rst : in STD_LOGIC; 
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component Execute_stage
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
			  RF_A0 : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
			  RF_B0 : in  STD_LOGIC_VECTOR (31 downto 0);
			  RF_B1 : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_SrcA : in  STD_LOGIC; -- control for Mux 2-1
           ALU_SrcB : in  STD_LOGIC_VECTOR (1 downto 0); -- control for Mux 4-1
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero : out  STD_LOGIC);
end component;

component Memory_stage
    Port ( ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_WrEn : out  STD_LOGIC);
end component;

--  to store exit values of modules
component Register_module is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           WriteEnable : in  STD_LOGIC;
           DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Mux 2-1 fir IF stage
component Mux_2to1 is
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           control : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--: STD_LOGIC;
--: STD_LOGIC_VECTOR (31 downto 0);
-- PC
signal muxToPC : STD_LOGIC_VECTOR (31 downto 0);
signal PC_out : STD_LOGIC_VECTOR (31 downto 0);

-- Instr_Reg
signal InstrReg_out : STD_LOGIC_VECTOR (31 downto 0);

-- Dec_Stage
signal immed_value : STD_LOGIC_VECTOR (31 downto 0);
signal dec_to_rega : STD_LOGIC_VECTOR (31 downto 0);
signal dec_to_regb : STD_LOGIC_VECTOR (31 downto 0);

--Ragisters Reg A, B
signal RegA_out : STD_LOGIC_VECTOR (31 downto 0);
signal RegB_out : STD_LOGIC_VECTOR (31 downto 0);

-- Ex_Stage
signal alu_result: STD_LOGIC_VECTOR (31 downto 0);
signal value_plus_four : STD_LOGIC_VECTOR (31 downto 0) := x"00000004"; -- Constant value for PC + 4 in EX Stage

-- ALU Register
signal AluReg_out: STD_LOGIC_VECTOR (31 downto 0);

-- MEM stage
signal REG_ALU_to_MEM: STD_LOGIC_VECTOR (31 downto 0);
signal memory_out: STD_LOGIC_VECTOR (31 downto 0);

-- Memory Register
signal MemReg_Out: STD_LOGIC_VECTOR (31 downto 0);

begin

-- instr_fetch : mux -> PC register -> Instraction register
REG_PC : Register_module port map(
			  clk => clk,
           rst => rst,
           WriteEnable => PC_LdEn,
           DataIn =>  muxToPC,
           DataOut => PC_out
			  );
-- mux
mux_2_1 : Mux_2to1 port map(
			  input0 => alu_result,
           input1 => AluReg_out,
           control => PC_sel,
           output => muxToPC
			  );
-- InstrReg
InstrReg :  Register_module port map(
			  clk => clk,
           rst => rst,
           WriteEnable => InstrReg_LdEn,
           DataIn => MM_instr, -- Instraction to execute -> dec_stage
           DataOut => InstrReg_out 
			  );

-- Decode
-- Instraction register --> decode -> Registers A,B
decode : Decode_stage port map(
			  Instr => InstrReg_out, --instr from InstrReg
           RF_WrEn => RF_WrEn,
           ALU_out => AluReg_out, -- From ALU Register
           MEM_out => MemReg_Out, -- From MEM register
           RF_WrData_sel => RF_WrData_sel,
           RF_B_sel => RF_B_sel, 
           ImmExt => ImmExt,
           clk => clk,
			  rst => rst,
           Immed => immed_value,
           RF_A => dec_to_rega, -- dtata to Rega
           RF_B => dec_to_regb  -- dtata to Regb
			  );

--Registers A,B
Reg_A :  Register_module port map(
			  clk => clk,
           rst => rst,
           WriteEnable => Reg_A_WrEn, -- in flag
           DataIn => dec_to_rega, -- Instraction to execute -> dec_stage
           DataOut => RegA_out 
			  );

Reg_B :  Register_module port map(
			  clk => clk,
           rst => rst,
           WriteEnable => Reg_B_WrEn, -- in flag
           DataIn => dec_to_regb, -- Instraction to execute -> dec_stage
           DataOut => RegB_out
			  );

-- Execute Stage 
-- EX_Stage -> REG_ALU
execute : Execute_stage port map(
			  RF_A => PC_out, -- From PC
			  RF_A0 => RegA_out, -- From RegA
           RF_B => RegB_out, -- From RegB
			  RF_B0 => value_plus_four, --Constant Value
			  RF_B1 => immed_value, -- Immed value from Dec Stage \          
           ALU_func => ALU_Func,
			  ALU_SrcA => ALU_SrcA_sel, -- control for Mux 2-1
           ALU_SrcB => ALU_SrcB_sel, -- control for Mux 4-1
           --ALU_Bin_sel : in  STD_LOGIC;
           ALU_out => alu_result,
           ALU_zero => ALU_zero
			  );
-- REG_ALU
Reg_ALU :  Register_module port map(
			  clk => clk,
           rst => rst,
           WriteEnable => Reg_ALU_WrEn, -- Write enable for reg
           DataIn => alu_result, -- ALU out
           DataOut => AluReg_out
			  );

-- MEM stage
-- MEM stage -> REG_mem
memory : Memory_stage port map(
           ByteOp => ByteOp,
           Mem_WrEn => Mem_WrEn,
           ALU_MEM_Addr => AluReg_out, -- From alu register
           MEM_DataIn => RegB_out, -- From B 
           MM_RdData => MM_RdData_in,
           MEM_DataOut => memory_out,
           MM_Addr => MM_Addr,
           MM_WrData => MM_WrData,
           MM_WrEn => MM_WrEn
			  );
			  
-- Memory Register			  
Reg_MEM :  Register_module port map(
			  clk => clk,
           rst => rst,
           WriteEnable => Reg_MEM_WrEn, -- Write enable for reg
           DataIn => memory_out, -- ALU out
           DataOut => MemReg_Out
			  );
			  
PC_addr <= PC_out;
Instraction <= InstrReg_out;
end Behavioral;

