--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:20:22 04/11/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/1st/ACE_Lab/RegisterFile_TB.vhd
-- Project Name:  ACE_Lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RegisterFile
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

ENTITY RegisterFile_TB IS
END RegisterFile_TB;
 
ARCHITECTURE behavior OF RegisterFile_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegisterFile
    PORT(
         Ard1 : IN  std_logic_vector(4 downto 0);
         Ard2 : IN  std_logic_vector(4 downto 0);
         Awr : IN  std_logic_vector(4 downto 0);
         WrEn : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         Din : IN  std_logic_vector(31 downto 0);
         Dout1 : OUT  std_logic_vector(31 downto 0);
         Dout2 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Ard1 : std_logic_vector(4 downto 0) := (others => '0');
   signal Ard2 : std_logic_vector(4 downto 0) := (others => '0');
   signal Awr : std_logic_vector(4 downto 0) := (others => '0');
   signal WrEn : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal Din : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Dout1 : std_logic_vector(31 downto 0);
   signal Dout2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegisterFile PORT MAP (
          Ard1 => Ard1,
          Ard2 => Ard2,
          Awr => Awr,
          WrEn => WrEn,
          clk => clk,
          rst => rst,
          Din => Din,
          Dout1 => Dout1,
          Dout2 => Dout2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus prosscess
   stim_proc: process
   begin		
		wait for 10*clk_period;
		rst <= '1';
		wait for 600 ns;
		rst <= '0';
		
		-- Write to r0
		WrEn <= '1';
		Awr <= "00000";
		Din <= x"00000000";
		wait for clk_period*2;
		
		-- Write to the others
		for i in 1 to 31 loop
		Awr <= Awr + "00001";
		Din <= Din + x"0000001";
		wait for clk_period*2;
		end loop;
		
		-- Check R0
		WrEn <= '0';
		Awr <= "00000";
		Din <= x"00000001";
		Ard1 <= "00000";
		Ard1 <= "00000";
		wait for clk_period*10;
		
		
		-- Read from each register
		for i in 1 to 31 loop
		Ard1 <= Ard1 + "00001";
		wait for clk_period*2;
		Ard2 <= Ard2 + "00001";
		wait for clk_period*2;
		end loop;
		
		-- Check R0
		Ard1 <= "00000";
		Ard2 <= "00000";
		wait for clk_period*100;
   end process;

END;
