----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:30:32 04/21/2021 
-- Design Name: 
-- Module Name:    Datapath - Behavioral 
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

entity Datapath is
    Port ( clk : in  STD_LOGIC; --
           rst : in  STD_LOGIC; -- 
			  -- IF_stage
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
			  PC : out  STD_LOGIC_VECTOR (31 downto 0);
			  -- Descode_stage
           RF_WrEn : in  STD_LOGIC;
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
			  -- Execute_stage
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_Func : in  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_zero : out  STD_LOGIC;
			  -- Mem_stage
           ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
			  -- Mem_Ram
			  MM_WrEn : out  STD_LOGIC; -- Write enable flag to ram
			  MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0); -- instraction addr to ram
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0); -- data to store to ram
			  MM_RdData_in : in  STD_LOGIC_VECTOR (31 downto 0); -- data FROM Ram
			  MM_instr : in  STD_LOGIC_VECTOR (31 downto 0) -- isntraction to execute from ram
			  );
end Datapath;

architecture Behavioral of Datapath is

component IF_Stage 
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           rst : in  STD_LOGIC; --
           clk : in  STD_LOGIC; -- 
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

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
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
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

--: STD_LOGIC;
--: STD_LOGIC_VECTOR (31 downto 0);
signal immed_value : STD_LOGIC_VECTOR (31 downto 0);
signal reg1: STD_LOGIC_VECTOR (31 downto 0);
signal reg2: STD_LOGIC_VECTOR (31 downto 0);
signal alu_result: STD_LOGIC_VECTOR (31 downto 0);
signal memory_out: STD_LOGIC_VECTOR (31 downto 0);
begin

instr_fetch : IF_Stage port map(
           PC_Immed => immed_value,
           PC_sel => PC_sel,
           PC_LdEn => PC_LdEn,
           rst => rst,
           clk => clk,
           PC => PC
			  );				
			  
			  
decode : Decode_stage port map(
			  Instr => MM_instr,
           RF_WrEn => RF_WrEn,
           ALU_out => alu_result,
           MEM_out => memory_out,
           RF_WrData_sel => RF_WrData_sel,
           RF_B_sel => RF_B_sel,
           ImmExt => ImmExt,
           clk => clk,
			  rst => rst,
           Immed => immed_value,
           RF_A => reg1,
           RF_B => reg2
			  );


execute : Execute_stage port map(
			  RF_A => reg1,
           RF_B => reg2,
           Immed => immed_value,
           ALU_func => ALU_Func,
           ALU_Bin_sel => ALU_Bin_sel,
           ALU_out => alu_result,
           ALU_zero => ALU_zero
			  );


memory : Memory_stage port map(
           ByteOp => ByteOp,
           Mem_WrEn => Mem_WrEn,
           ALU_MEM_Addr => alu_result,
           MEM_DataIn => reg2,
           MM_RdData => MM_RdData_in,
           MEM_DataOut => memory_out,
           MM_Addr => MM_Addr,
           MM_WrData => MM_WrData,
           MM_WrEn => MM_WrEn
			  );
end Behavioral;

