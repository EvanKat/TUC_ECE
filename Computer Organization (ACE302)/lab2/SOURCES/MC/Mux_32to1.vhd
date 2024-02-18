----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:27:33 04/11/2021 
-- Design Name: 
-- Module Name:    Mux_32to1 - Behavioral 
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

entity Mux_32to1 is
    Port ( in0 : in  STD_LOGIC_VECTOR (31 downto 0);
           in1 : in  STD_LOGIC_VECTOR (31 downto 0);
           in2 : in  STD_LOGIC_VECTOR (31 downto 0);
           in3 : in  STD_LOGIC_VECTOR (31 downto 0);
           in4 : in  STD_LOGIC_VECTOR (31 downto 0);
           in5 : in  STD_LOGIC_VECTOR (31 downto 0);
           in6 : in  STD_LOGIC_VECTOR (31 downto 0);
           in7 : in  STD_LOGIC_VECTOR (31 downto 0);
           in8 : in  STD_LOGIC_VECTOR (31 downto 0);
           in9 : in  STD_LOGIC_VECTOR (31 downto 0);
           in10 : in  STD_LOGIC_VECTOR (31 downto 0);
           in11 : in  STD_LOGIC_VECTOR (31 downto 0);
           in12 : in  STD_LOGIC_VECTOR (31 downto 0);
           in13 : in  STD_LOGIC_VECTOR (31 downto 0);
           in14 : in  STD_LOGIC_VECTOR (31 downto 0);
           in15 : in  STD_LOGIC_VECTOR (31 downto 0);
           in16 : in  STD_LOGIC_VECTOR (31 downto 0);
           in17 : in  STD_LOGIC_VECTOR (31 downto 0);
           in18 : in  STD_LOGIC_VECTOR (31 downto 0);
           in19 : in  STD_LOGIC_VECTOR (31 downto 0);
           in20 : in  STD_LOGIC_VECTOR (31 downto 0);
           in21 : in  STD_LOGIC_VECTOR (31 downto 0);
           in22 : in  STD_LOGIC_VECTOR (31 downto 0);
           in23 : in  STD_LOGIC_VECTOR (31 downto 0);
           in24 : in  STD_LOGIC_VECTOR (31 downto 0);
           in25 : in  STD_LOGIC_VECTOR (31 downto 0);
           in26 : in  STD_LOGIC_VECTOR (31 downto 0);
           in27 : in  STD_LOGIC_VECTOR (31 downto 0);
           in28 : in  STD_LOGIC_VECTOR (31 downto 0);
           in29 : in  STD_LOGIC_VECTOR (31 downto 0);
           in30 : in  STD_LOGIC_VECTOR (31 downto 0);
           in31 : in  STD_LOGIC_VECTOR (31 downto 0);
           input : in  STD_LOGIC_VECTOR (4 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end Mux_32to1;

architecture Behavioral of Mux_32to1 is
signal out_temp : STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); 
begin
process(input)
	begin
	if (input="00000") then
		out_temp <= in0; --R0
	elsif (input="00001") then
		out_temp <= in1; --R1
	elsif (input="00010") then
		out_temp <= in2; --R2
	elsif (input="00011") then
		out_temp <= in3; --R3
	elsif (input="00100") then
		out_temp <= in4; --R4
	elsif (input="00101") then
		out_temp <= in5; --R5
	elsif (input="00110") then
		out_temp <= in6; --R6
	elsif (input="00111") then
		out_temp <= in7; --R7
	elsif (input="01000") then
		out_temp <= in8; --R8
	elsif (input="01001") then
		out_temp <= in9; --R9
	elsif (input="01010") then
		out_temp <= in10; --R10		
	elsif (input="01011") then
		out_temp <= in11; --R11
	elsif (input="01100") then
		out_temp <= in12; --R12
	elsif (input="01101") then
		out_temp <= in13; --R13
	elsif (input="01110") then
		out_temp <= in14; --R14
	elsif (input="01111") then
		out_temp <= in15; --R15
	elsif (input="10000") then
		out_temp <= in16; --R16
	elsif (input="10001") then
		out_temp <= in17; --R17
	elsif (input="10010") then
		out_temp <= in18; --R18
	elsif (input="10011") then
		out_temp <= in19; --R19
	elsif (input="10100") then
		out_temp <= in20; --R20
	elsif (input="10101") then
		out_temp <= in21; --R21
	elsif (input="10110") then
		out_temp <= in22; --R22
	elsif (input="10111") then
		out_temp <= in23; --R23
	elsif (input="11000") then
		out_temp <= in24; --R24
	elsif (input="11001") then
		out_temp <= in25; --R25
	elsif (input="11010") then
		out_temp <= in26; --R26
	elsif (input="11011") then
		out_temp <= in27; --R27
	elsif (input="11100") then
		out_temp <= in28; --R28
	elsif (input="11101") then
		out_temp <= in29; --R29
	elsif (input="11110") then
		out_temp <= in30; --R30
	else
		out_temp <= in31; --R31 
	end if;
end process;

output <= out_temp after 10 ns;
end Behavioral;

