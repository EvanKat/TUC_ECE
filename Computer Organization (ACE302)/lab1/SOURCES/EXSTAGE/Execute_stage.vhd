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



entity Execute_stage is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
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

-- Mux
component Mux_2to1 is
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           control : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Mid signals
signal muxToALU : STD_LOGIC_VECTOR (31 downto 0);

begin
	
	ALU_component : ALU port map(
			  A => RF_A,
           B => muxToALU,
           OpCode => ALU_func, 
           Output => ALU_out,
           ZeroFlag => ALU_zero,
			  Cout => open,
           OverflowFlag => open
			  );
	
	mux : Mux_2to1 port map(
			  input0 => RF_B,
			  input1 => Immed,
			  control => ALU_Bin_sel,
			  output => muxToALU
			  );
			  
end Behavioral;

