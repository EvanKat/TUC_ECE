----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:15:38 04/16/2021 
-- Design Name: 
-- Module Name:    ccloud_unit - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity cloud_unit is
    Port ( input : in  STD_LOGIC_VECTOR (15 downto 0);
           control : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end cloud_unit;

architecture Behavioral of cloud_unit is

signal tmp : STD_LOGIC_VECTOR (31 downto 0);

begin   
process(input,control)
begin
case control is 
	-- Zero fill
	when "00" =>
		--output<=std_logic_vector(resize(unsigned(input),output'length));
		output <= (31 downto 16 => '0') & input; 
	-- Sign Extend
	when "01" =>
		output <= (31 downto 16 => input(15)) & input; 
	-- Zero Fill & Shift
	when "10" =>
		output <= input & (31 downto 16 => '0'); 
	-- Sign Extend and shift
	when others =>
		output <= std_logic_vector(shift_left(unsigned(resize(signed(input), 32)), 2));
end case;
end process;
end Behavioral;

