----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:23:41 04/15/2021 
-- Design Name: 
-- Module Name:    Mux_2to1 - Behavioral 
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

entity Mux_2to1 is
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           control : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end Mux_2to1;

architecture Behavioral of Mux_2to1 is

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

