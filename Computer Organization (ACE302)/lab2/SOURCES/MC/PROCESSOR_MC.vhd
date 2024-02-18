----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:49:23 05/19/2021 
-- Design Name: 
-- Module Name:    PROCESSOR_MC - Behavioral 
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

entity PROCESSOR_MC is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  -- PC_reg to ram
			  PC_addr : out  STD_LOGIC_VECTOR (31 downto 0); -- instraction addr from pc to ram
			  -- Mem_Ram out
			  MM_WrEn : out  STD_LOGIC; -- Write enable flag to ram
			  MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0); -- instraction addr to ram
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0); -- data to store to ram
			  -- Mem_Ram in
			  MM_RdData_in : in  STD_LOGIC_VECTOR (31 downto 0); -- data FROM Ram
			  MM_instr : in  STD_LOGIC_VECTOR (31 downto 0) -- isntraction to execute from ram		  
			  );
end PROCESSOR_MC;

architecture Behavioral of PROCESSOR_MC is

component DATAPATH_MC is
	Port (  clk : in  STD_LOGIC; --
           rst : in  STD_LOGIC; --
			  -- For PC 
           PC_LdEn : in  STD_LOGIC;
			  PC_sel: in  STD_LOGIC;
			  PC_addr : out  STD_LOGIC_VECTOR (31 downto 0); -- instraction addr from pc to ram
			  -- Instr_Reg
			  InstrReg_LdEn : in  STD_LOGIC; 
			  Instraction : out  STD_LOGIC_VECTOR (31 downto 0); -- instraction from instr_reg to control
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
end component;

component CONTROL_MC 
	Port (	clk : IN STD_LOGIC;
				rst : IN STD_LOGIC;
				-- inputs
				OpCode : IN STD_LOGIC_VECTOR(5 downto 0); --Instr(31 downto 26)
				Func : IN STD_LOGIC_VECTOR(3 downto 0);  -- 11 + Instr(3 downto 0)
				ALU_zero : IN STD_LOGIC; 
			   
				-- For PC 
            PC_LdEn : OUT  STD_LOGIC;
			   PC_sel: OUT STD_LOGIC;
				-- Instr_Reg
			   InstrReg_LdEn : OUT STD_LOGIC;
				-- Decode_stage
            RF_WrEn : OUT  STD_LOGIC;
            RF_WrData_sel : OUT  STD_LOGIC;
            RF_B_sel : OUT  STD_LOGIC;
            ImmExt : OUT  STD_LOGIC_VECTOR (1 downto 0);
				--Register A,B
				Reg_A_WrEn : OUT  STD_LOGIC;
				Reg_B_WrEn : OUT STD_LOGIC;
				-- Execute_stage
				ALU_Func : OUT  STD_LOGIC_VECTOR (3 downto 0);
				--ALU_zero : out  STD_LOGIC;
				ALU_SrcA_sel : OUT  STD_LOGIC; -- control for Mux 2-1
				ALU_SrcB_sel : OUT  STD_LOGIC_VECTOR (1 downto 0); -- control for Mux 4-1 
				-- ALU Register
			   Reg_ALU_WrEn : OUT  STD_LOGIC;
			   -- Mem_stage
            ByteOp : OUT STD_LOGIC;
            Mem_WrEn : OUT STD_LOGIC;
				-- Memory Register
				Reg_MEM_WrEn : OUT STD_LOGIC);
end component;

signal PC_LdEn_tmp : STD_LOGIC;
signal PC_sel_tmp : STD_LOGIC;
signal PC_addr_tmp : STD_LOGIC_VECTOR (31 downto 0);
signal InstrReg_LdEn_tmp : STD_LOGIC;
signal Instraction_tmp : STD_LOGIC_VECTOR (31 downto 0);

signal RF_WrEn_tmp : STD_LOGIC;
signal RF_WrData_sel_tmp : STD_LOGIC;
signal RF_B_sel_tmp : STD_LOGIC;
signal ImmExt_tmp : STD_LOGIC_VECTOR (1 downto 0);
signal Reg_A_WrEn_tmp : STD_LOGIC;
signal Reg_B_WrEn_tmp : STD_LOGIC;

signal ALU_Func_tmp : STD_LOGIC_VECTOR (3 downto 0);
signal ALU_zero_tmp : STD_LOGIC;
signal ALU_SrcA_sel_tmp : STD_LOGIC;
signal ALU_SrcB_sel_tmp : STD_LOGIC_VECTOR (1 downto 0);

signal Reg_ALU_WrEn_tmp : STD_LOGIC;
signal ByteOp_tmp : STD_LOGIC;
signal Mem_WrEn_tmp : STD_LOGIC;


signal Reg_MEM_WrEn_tmp : STD_LOGIC;
begin
datapath_comp : DATAPATH_MC port map(
			  clk => clk,
           rst => rst,
			  -- For PC 
           PC_LdEn => PC_LdEn_tmp,
			  PC_sel => PC_sel_tmp,
			  PC_addr => PC_addr_tmp,
			  -- Instr_Reg
			  InstrReg_LdEn => InstrReg_LdEn_tmp,
			  Instraction => Instraction_tmp,
			  -- Decode_stage
           RF_WrEn => RF_WrEn_tmp,
           RF_WrData_sel => RF_WrData_sel_tmp,
           RF_B_sel => RF_B_sel_tmp,
           ImmExt => ImmExt_tmp,
			  --Register A,B
			  Reg_A_WrEn => Reg_A_WrEn_tmp,
			  Reg_B_WrEn => Reg_B_WrEn_tmp,
			  
			  -- Execute_stage
           --ALU_Bin_sel : in  STD_LOGIC;
           ALU_Func => ALU_Func_tmp,
			  ALU_zero => ALU_zero_tmp,
			  ALU_SrcA_sel => ALU_SrcA_sel_tmp,
			  ALU_SrcB_sel => ALU_SrcB_sel_tmp,
			  
			  -- ALU Register
			  Reg_ALU_WrEn => Reg_ALU_WrEn_tmp,
			  
			  -- Mem_stage
           ByteOp => ByteOp_tmp,
           Mem_WrEn => Mem_WrEn_tmp,
			  -- Mem_Ram
			  MM_WrEn => MM_WrEn, -- Write enable flag to ram
			  MM_Addr => MM_Addr, -- instraction addr to ram
           MM_WrData =>MM_WrData, -- data to store to ram
			  MM_RdData_in => MM_RdData_in,  -- data FROM Ram
			  MM_instr => MM_instr, -- isntraction to execute from ram
			  
			  -- Memory Register
			  Reg_MEM_WrEn => Reg_MEM_WrEn_tmp
			  );

control_comp:  CONTROL_MC port map(
				clk => clk,
            rst => rst,
				-- inputs
				OpCode => Instraction_tmp(31 downto 26),
				Func => Instraction_tmp(3 downto 0),
				ALU_zero => ALU_zero_tmp,
			   
				-- For PC 
            PC_LdEn => PC_LdEn_tmp,
			   PC_sel => PC_sel_tmp,
				-- Instr_Reg
			   InstrReg_LdEn => InstrReg_LdEn_tmp,
				-- Decode_stage
            RF_WrEn => RF_WrEn_tmp,
            RF_WrData_sel => RF_WrData_sel_tmp,
            RF_B_sel => RF_B_sel_tmp,
            ImmExt => ImmExt_tmp,
				--Register A,B
				Reg_A_WrEn => Reg_A_WrEn_tmp,
				Reg_B_WrEn => Reg_B_WrEn_tmp,
				-- Execute_stage
				ALU_Func => ALU_Func_tmp,
				--ALU_zero : out  STD_LOGIC;
				ALU_SrcA_sel => ALU_SrcA_sel_tmp,
				ALU_SrcB_sel => ALU_SrcB_sel_tmp,
				-- ALU Register
			   Reg_ALU_WrEn => Reg_ALU_WrEn_tmp,
			   -- Mem_stage
            ByteOp => ByteOp_tmp,
            Mem_WrEn => Mem_WrEn_tmp,
				-- Memory Register
				Reg_MEM_WrEn => Reg_MEM_WrEn_tmp
				);

PC_addr <= PC_addr_tmp;

end Behavioral;

