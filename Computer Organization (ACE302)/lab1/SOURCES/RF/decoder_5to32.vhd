----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:07:11 04/11/2021 
-- Design Name: 
-- Module Name:    decoder_5to32 - Behavioral 
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

entity decoder_5to32 is
    Port ( input : in  STD_LOGIC_VECTOR (4 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end decoder_5to32;

architecture Behavioral of decoder_5to32 is
signal out_temp : STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); 
begin

process(input)
	begin
	if (input="00000") then
		out_temp <= "00000000000000000000000000000001"; --R0
	elsif (input="00001") then
		out_temp <= "00000000000000000000000000000010"; --R1
	elsif (input="00010") then
		out_temp <= "00000000000000000000000000000100"; --R2
	elsif (input="00011") then
		out_temp <= "00000000000000000000000000001000"; --R3
	elsif (input="00100") then
		out_temp <= "00000000000000000000000000010000"; --R4
	elsif (input="00101") then
		out_temp <= "00000000000000000000000000100000"; --R5
	elsif (input="00110") then
		out_temp <= "00000000000000000000000001000000"; --R6
	elsif (input="00111") then
		out_temp <= "00000000000000000000000010000000"; --R7
	elsif (input="01000") then
		out_temp <= "00000000000000000000000100000000"; --R8
	elsif (input="01001") then
		out_temp <= "00000000000000000000001000000000"; --R9
	elsif (input="01010") then
		out_temp <= "00000000000000000000010000000000"; --R10		
	elsif (input="01011") then
		out_temp <= "00000000000000000000100000000000"; --R11
	elsif (input="01100") then
		out_temp <= "00000000000000000001000000000000"; --R12
	elsif (input="01101") then
		out_temp <= "00000000000000000010000000000000"; --R13
	elsif (input="01110") then
		out_temp <= "00000000000000000100000000000000"; --R14
	elsif (input="01111") then
		out_temp <= "00000000000000001000000000000000"; --R15
	elsif (input="10000") then
		out_temp <= "00000000000000010000000000000000"; --R16
	elsif (input="10001") then
		out_temp <= "00000000000000100000000000000000"; --R17
	elsif (input="10010") then
		out_temp <= "00000000000001000000000000000000"; --R18
	elsif (input="10011") then
		out_temp <= "00000000000010000000000000000000"; --R19
	elsif (input="10100") then
		out_temp <= "00000000000100000000000000000000"; --R20
	elsif (input="10101") then
		out_temp <= "00000000001000000000000000000000"; --R21
	elsif (input="10110") then
		out_temp <= "00000000010000000000000000000000"; --R22
	elsif (input="10111") then
		out_temp <= "00000000100000000000000000000000"; --R23
	elsif (input="11000") then
		out_temp <= "00000001000000000000000000000000"; --R24
	elsif (input="11001") then
		out_temp <= "00000010000000000000000000000000"; --R25
	elsif (input="11010") then
		out_temp <= "00000100000000000000000000000000"; --R26
	elsif (input="11011") then
		out_temp <= "00001000000000000000000000000000"; --R27
	elsif (input="11100") then
		out_temp <= "00010000000000000000000000000000"; --R28
	elsif (input="11101") then
		out_temp <= "00100000000000000000000000000000"; --R29
	elsif (input="11110") then
		out_temp <= "01000000000000000000000000000000"; --R30
	else
		out_temp <= "10000000000000000000000000000000"; --R31 
	end if;
end process;

output <= out_temp  after 10 ns;

end Behavioral;

