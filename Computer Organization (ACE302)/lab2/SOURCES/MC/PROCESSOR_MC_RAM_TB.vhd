--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:18:59 05/20/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/2nd/MC/ACE_MC_Proc/PROCESSOR_MC_RAM_TB.vhd
-- Project Name:  ACE_MC_Proc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PROCESSOR_MC_RAM
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

ENTITY PROCESSOR_MC_RAM_TB IS
END PROCESSOR_MC_RAM_TB;
 
ARCHITECTURE behavior OF PROCESSOR_MC_RAM_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PROCESSOR_MC_RAM
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 400 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PROCESSOR_MC_RAM PORT MAP (
          clk => clk,
          rst => rst
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
	
      rst <= '1';
      wait for clk_period*5;
		rst <= '0';

      wait;
   end process;

END;
