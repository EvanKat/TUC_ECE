----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:36:57 04/21/2021 
-- Design Name: 
-- Module Name:    Datapath_Ram - Behavioral 
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

entity Datapath_Ram is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  -- IF_stage
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
			  -- Descode_stage
           RF_WrEn : in  STD_LOGIC;
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
			  ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
			  -- Execute_stage
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_zero : out  STD_LOGIC;
			  -- MemStage
           ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC);
end Datapath_Ram;

architecture Behavioral of Datapath_Ram is

component Datapath
    Port ( clk : in  STD_LOGIC; 
           rst : in  STD_LOGIC;  
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
end component;


component RAM 
	port (
		clk : in std_logic;
		inst_addr : in std_logic_vector(10 downto 0);
		inst_dout : out std_logic_vector(31 downto 0);
		data_we : in std_logic;
		data_addr : in std_logic_vector(10 downto 0);
		data_din : in std_logic_vector(31 downto 0);
		data_dout : out std_logic_vector(31 downto 0));
end component;

signal PC_RAM : std_logic_vector(31 downto 0);

signal ramAddr : STD_LOGIC_VECTOR (31 downto 0); -- instraction addr to ram
signal dataIn : STD_LOGIC_VECTOR (31 downto 0);  -- data to store to ram
signal dataOut : STD_LOGIC_VECTOR (31 downto 0); -- data FROM Ram
signal WE : STD_LOGIC;-- Write enable flag to ram

signal instrRam_out : STD_LOGIC_VECTOR (31 downto 0); -- Instraction to excecute

begin

datapath_unit : Datapath port map(
			  clk => clk,
           rst => rst,
			  -- IF_stage
           PC_sel => PC_sel,
           PC_LdEn => PC_LdEn,
			  PC => PC_RAM, --  Next Addres in ram
			  -- Descode_stage
           RF_WrEn => RF_WrEn,
           RF_WrData_sel => RF_WrData_sel,
           RF_B_sel => RF_B_sel,
           ImmExt => ImmExt,
			  -- Execute_stage
           ALU_Bin_sel => ALU_Bin_sel,
           ALU_Func => ALU_func,
			  ALU_zero => ALU_zero,
			  -- Mem_stage
           ByteOp => ByteOp,
           Mem_WrEn => Mem_WrEn,
			  -- Mem_Ram
			  MM_WrEn => WE, -- Write enable flag to ram
			  MM_Addr => ramAddr, -- instraction addr to ram
           MM_WrData => dataIn, -- data to store to ram
			  MM_RdData_in => dataOut, -- data FROM Ram
			  MM_instr => instrRam_out -- isntraction to execute from ram
			  );

memory : RAM port map(
		clk => clk,
		inst_addr => PC_RAM(12 downto 2), --  Next Addres in ram
		inst_dout => instrRam_out, -- Instraction to excecute
		data_we => WE, -- Write enable flag to ram
		data_addr => ramAddr(12 downto 2), -- instraction addr to ram
		data_din => dataIn, -- data to store to ram
		data_dout => dataOut -- Write enable flag to ram
		);

end Behavioral;

