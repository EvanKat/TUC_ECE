----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:50:32 05/16/2021 
-- Design Name: 
-- Module Name:    Mux_4to1 - Behavioral 
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

entity Mux_4to1 is
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           input2 : in  STD_LOGIC_VECTOR (31 downto 0);
           input3 : in  STD_LOGIC_VECTOR (31 downto 0);
           control : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end Mux_4to1;

architecture Behavioral of Mux_4to1 is

begin
	process (input0,input1,input2,input3,control)
	begin
		if (control = "00") then
			output <= input0;
		elsif (control = "01") then
			output <= input1;
		elsif (control = "10") then
			output <= input2;
		else
			output <= input3;
		end if;
	end process;
end Behavioral;
