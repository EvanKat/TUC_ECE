--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:53:27 04/04/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/1st/ACE_Lab/RegisterModule_TB.vhd
-- Project Name:  ACE_Lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Register_module
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY RegisterModule_TB IS
END RegisterModule_TB;
 
ARCHITECTURE behavior OF RegisterModule_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Register_module
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         WriteEnable : IN  std_logic;
         DataIn : IN  std_logic_vector(31 downto 0);
         DataOut : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal WriteEnable : std_logic := '0';
   signal DataIn : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal DataOut : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit sdUnder Test (UUT)
   uut: Register_module PORT MAP (
          clk => clk,
          rst => rst,
          WriteEnable => WriteEnable,
          DataIn => DataIn,
          DataOut => DataOut
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
	-- hold reset state for 100 ns.
      wait for 100 ns;	
		
      wait for clk_period*10;
		
		--reset for 100 ns.
		rst <= '1';
      wait for 100 ns;
		rst <= '0';
		
		--write
		DataIn <= x"00000abc";
		WriteEnable <= '0';
      wait for CLK_period;
		
		--write
		DataIn <= x"00000abc";
		WriteEnable <= '1';
      wait for CLK_period;
		
		--reset
		--rst<='1';
      --wait for CLK_period;
		--rst<='0';
		
		--write
		DataIn <= x"00000fff";
		WriteEnable <= '1';
      wait for CLK_period;
		
		--write
		DataIn <= x"FFFFABCD";
		WriteEnable <= '1';
      wait for CLK_period;
		
		--reset
		rst <= '1';
      wait for CLK_period;
		rst <= '0';
		
		--write while reset
		rst<='1';
		DataIn <= x"00000ABC";
		WriteEnable <= '1';
      wait for CLK_period;
		--rst<='0';
		
		--write
		DataIn <= x"FFFFABCD";
		WriteEnable <= '1';
      wait for CLK_period;
		
      wait;
   end process;

END;
