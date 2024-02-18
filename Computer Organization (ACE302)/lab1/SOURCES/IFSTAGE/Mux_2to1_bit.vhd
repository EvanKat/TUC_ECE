----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:32:45 04/16/2021 
-- Design Name: 
-- Module Name:    Mux_2to1_bit - Behavioral 
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

entity Mux_2to1_5bit is
    Port ( input0 : in  STD_LOGIC_VECTOR (4 downto 0);
           input1 : in  STD_LOGIC_VECTOR (4 downto 0);
           control : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (4 downto 0));
end Mux_2to1_5bit;

architecture Behavioral of Mux_2to1_5bit is

begin
	process (input0,input1,control)
	begin
		if (control = '0') then
			output <= input0;
		else 
			output <= input1;
		end if;
	end process;
end Behavioral;

