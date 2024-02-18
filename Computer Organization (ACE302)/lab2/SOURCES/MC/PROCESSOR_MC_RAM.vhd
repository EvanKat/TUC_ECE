----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:55:23 05/19/2021 
-- Design Name: 
-- Module Name:    PROCESSOR_MC_RAM - Behavioral 
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

entity PROCESSOR_MC_RAM is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end PROCESSOR_MC_RAM;

architecture Behavioral of PROCESSOR_MC_RAM is

component PROCESSOR_MC 
	Port (  clk : in  STD_LOGIC;
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
end component ;

signal PC_RAM : std_logic_vector(31 downto 0); -- instraction addr to ram from pc
signal RAM_WE : std_logic;  -- write enable
signal ramAddr: std_logic_vector(31 downto 0); -- instraction addr to ram
signal instrRam_out :  std_logic_vector(31 downto 0); -- Instraction to excecute
signal dataIn : STD_LOGIC_VECTOR (31 downto 0);  -- data to store to ram
signal dataOut : STD_LOGIC_VECTOR (31 downto 0); -- data FROM Ram

begin

proc_mc_comp : PROCESSOR_MC port map(
			  clk => clk,
           rst => rst,
			  -- PC_reg to ram
			  PC_addr => PC_RAM,
			  -- Mem_Ram out
			  MM_WrEn => RAM_WE, -- Write enable flag to ram
			  MM_Addr => ramAddr, -- instraction addr to ram
           MM_WrData => dataIn, -- data to store to ram
			  -- Mem_Ram in
			  MM_RdData_in => dataOut, -- data FROM Ram
			  MM_instr => instrRam_out -- isntraction to execute from ram		  
			  );


ram_comp: RAM port map(
		clk => clk,
		inst_addr => PC_RAM(12 downto 2),
		inst_dout => instrRam_out,
		data_we => RAM_WE, -- Write enable flag to ram
		data_addr => ramAddr(12 downto 2),
		data_din => dataIn, -- data to store to ram
		data_dout => dataOut
		);
		
end Behavioral;

