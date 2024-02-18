--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   06:04:44 04/21/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/1st/ACE_Lab/IF_stage_RAM_TB.vhd
-- Project Name:  ACE_Lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IF_stage_RAM
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
 
ENTITY IF_stage_RAM_TB IS
END IF_stage_RAM_TB;
 
ARCHITECTURE behavior OF IF_stage_RAM_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IF_stage_RAM
    PORT(
         PC_Immed : IN  std_logic_vector(31 downto 0);
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         Instraction : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal PC_Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal Instraction : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IF_stage_RAM PORT MAP (
          PC_Immed => PC_Immed,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          rst => rst,
          clk => clk,
          Instraction => Instraction
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
		wait for clk_period*10;
		rst <= '0';
		
		PC_LdEn <= '1';
		PC_sel <= '0'; -- (+=4) * 3
		wait for clk_period*3; -- PC = 12
		PC_LdEn <= '0';
		wait for clk_period*3; -- PC = 12
		
		PC_LdEn <= '1';
		PC_sel <= '1'; -- (+4 + imed)
		PC_Immed <= x"000f0000";
		wait for clk_period; -- PC = 12 + 4 + PC_Immed
		PC_Immed <= x"0000ff00";
		wait for clk_period; -- PC = prevPC + 4 + PC_Immed
		PC_LdEn <= '0';
		wait for clk_period;
		
		PC_LdEn <= '1';
		PC_sel <= '0'; 
		wait for clk_period;
		PC_LdEn <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
