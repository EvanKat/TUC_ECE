----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:45:34 04/04/2021 
-- Design Name: 
-- Module Name:    Register_module - Behavioral 
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

entity Register_module is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           WriteEnable : in  STD_LOGIC;
           DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end Register_module;

architecture Behavioral of Register_module is
signal dout : STD_LOGIC_VECTOR (31 downto 0):= x"00000000";
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				dout <= x"00000000";
			else 
				if (WriteEnable = '1') then
					dout <= DataIn;
				else 
					dout <= dout;
				end if;
			end if;
		end if;
	end process;
	
	Dataout <= dout after 10 ns;
end Behavioral;

