--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:47:25 04/17/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/1st/ACE_Lab/Execute_stage_TB.vhd
-- Project Name:  ACE_Lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Execute_stage
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
 
ENTITY Execute_stage_TB IS
END Execute_stage_TB;
 
ARCHITECTURE behavior OF Execute_stage_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Execute_stage
    PORT(
         RF_A : IN  std_logic_vector(31 downto 0);
         RF_B : IN  std_logic_vector(31 downto 0);
         Immed : IN  std_logic_vector(31 downto 0);
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_Bin_sel : IN  std_logic;
         ALU_out : OUT  std_logic_vector(31 downto 0);
         ALU_zero : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RF_A : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_B : std_logic_vector(31 downto 0) := (others => '0');
   signal Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');
   signal ALU_Bin_sel : std_logic := '0';

 	--Outputs
   signal ALU_out : std_logic_vector(31 downto 0);
   signal ALU_zero : std_logic;
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Execute_stage PORT MAP (
          RF_A => RF_A,
          RF_B => RF_B,
          Immed => Immed,
          ALU_func => ALU_func,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_out => ALU_out,
          ALU_zero => ALU_zero
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      RF_A <= x"fff0f000";
		RF_B <= x"ffffff0f";
		Immed <= x"fffffff1";
		ALU_Bin_sel <= '0';
		ALU_func <= x"0";
		wait for 100 ns;	
      -- insert stimulus here 
		ALU_Bin_sel <= '1';
		wait for 100 ns;
		-- Execute each operation
		for i in 1 to 11 loop
		ALU_func <= ALU_func + "0001";
		ALU_Bin_sel <= Not ALU_Bin_sel;
		wait for 100 ns;
		end loop;
      wait;
   end process;

END;
