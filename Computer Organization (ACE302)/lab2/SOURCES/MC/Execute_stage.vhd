----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:28:59 04/17/2021 
-- Design Name: 
-- Module Name:    Execute_stage - Behavioral 
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
-- 2 MUXs give the inputs to ALU
-- 1st has 2 inputs: 1st => PC ('0') | 2nd => REG A  ('1')
-- 2nd has 4 inputs: 1st => REG B ('00') | 2nd => +4 ('01')| 3rd => REG Immed value ('10')| 4rth => no use ('11')

entity Execute_stage is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
			  RF_A0 : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
			  RF_B0 : in  STD_LOGIC_VECTOR (31 downto 0);
			  RF_B1 : in  STD_LOGIC_VECTOR (31 downto 0);
           --Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_SrcA : in  STD_LOGIC; -- control for Mux 2-1
           ALU_SrcB : in  STD_LOGIC_VECTOR (1 downto 0); -- control for Mux 4-1
           --ALU_Bin_sel : in  STD_LOGIC;
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero : out  STD_LOGIC);
end Execute_stage;

architecture Behavioral of Execute_stage is

-- ALU
component ALU is 
	port(	  A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           OpCode : in  STD_LOGIC_VECTOR (3 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0);
           ZeroFlag : out  STD_LOGIC;
			  Cout : out STD_LOGIC;
           OverflowFlag : out  STD_LOGIC);
end component;

-- Mux 2-1
component Mux_2to1 is
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           control : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Mux 4-1
component Mux_4to1 is
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           input2 : in  STD_LOGIC_VECTOR (31 downto 0);
           input3 : in  STD_LOGIC_VECTOR (31 downto 0);
           control : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Mid signals
signal mux_2to1_ALU : STD_LOGIC_VECTOR (31 downto 0);
signal mux_4to1_ALU : STD_LOGIC_VECTOR (31 downto 0);


begin
	
	ALU_component : ALU port map(
			  A => mux_2to1_ALU,
           B => mux_4to1_ALU,
           OpCode => ALU_func, 
           Output => ALU_out,
           ZeroFlag => ALU_zero,
			  Cout => open,
           OverflowFlag => open
			  );
	
	mux2_1 : Mux_2to1 port map(
			  input0 => RF_A, -- PC
			  input1 => RF_A0, -- RF_A
			  control => ALU_SrcA,
			  output => mux_2to1_ALU
			  );
			  
	mux4_1 : Mux_4to1 port map(
			  input0 => RF_B,-- RF_B 
           input1 => RF_B0, -- +4 
           input2 => RF_B1, -- Immed
           input3 => (others => '0'),
           control => ALU_SrcB,
           output => mux_4to1_ALU
			  );

end Behavioral;

