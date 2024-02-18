----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:03:10 04/15/2021 
-- Design Name: 
-- Module Name:    IF_Stage - Behavioral 
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


entity IF_Stage is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end IF_Stage;

architecture Behavioral of IF_Stage is

component Mux_2to1
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           control : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0) );
end component;

component Adder_2to1
    Port ( in0 : in  STD_LOGIC_VECTOR (31 downto 0);
           in1 : in  STD_LOGIC_VECTOR (31 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;	
	
component Register_module 
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           WriteEnable : in  STD_LOGIC;
           DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal muxToPC: STD_LOGIC_VECTOR (31 downto 0);
signal adder0ToMux: STD_LOGIC_VECTOR (31 downto 0);
signal adder1ToMux: STD_LOGIC_VECTOR (31 downto 0);
signal plus4: STD_LOGIC_VECTOR (31 downto 0) := x"00000004";
signal PCout: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	Mux: Mux_2to1 port map(
				input0 => adder0ToMux, 
				input1 => adder1ToMux,
				control => PC_sel,
				output => muxToPC
				);
	-- adder pc + 4
	Adder0: Adder_2to1 port map(
				in0 => PCout,
				in1 => plus4,
				output => adder0ToMux
				);

	-- adder pc + 4 + immed
	Adder1: Adder_2to1 port map(
				in0 => adder0ToMux,
				in1 => PC_Immed,
				output => adder1ToMux
				);
				
	-- PC
	ProgramCounter: Register_module port map(
			clk => clk,
         rst => rst,
         WriteEnable => PC_LdEn,
         DataIn => muxToPC,
         DataOut => PCout
			);
			
	PC <= PCout;
end Behavioral;

