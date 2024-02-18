----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:57:41 04/21/2021 
-- Design Name: 
-- Module Name:    IF_stage_RAM - Behavioral 
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

entity IF_stage_RAM is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           Instraction : out  STD_LOGIC_VECTOR (31 downto 0));
end IF_stage_RAM;

architecture Behavioral of IF_stage_RAM is


component IF_Stage
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
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

signal PC_to_RAM : STD_LOGIC_VECTOR (31 downto 0);

begin

IF_comp : IF_Stage port map(
			  PC_Immed => PC_Immed,
           PC_sel => PC_sel,
           PC_LdEn => PC_LdEn,
           rst => rst,
           clk => clk,
           PC => PC_to_RAM
			  );

mem : RAM port map(
			clk => clk,
			inst_addr => PC_to_RAM(12 downto 2),
			inst_dout => Instraction,
			data_we => '0',
			data_addr => "00000000000",
			data_din => x"00000000",
			data_dout => open
			);

end Behavioral;

