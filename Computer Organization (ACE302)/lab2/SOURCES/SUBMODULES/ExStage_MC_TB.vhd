--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:03:36 05/16/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/2nd/MC/ACE_MC_Proc/ExStage_MC_TB.vhd
-- Project Name:  ACE_MC_Proc
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
 
ENTITY ExStage_MC_TB IS
END ExStage_MC_TB;
 
ARCHITECTURE behavior OF ExStage_MC_TB IS 
 
  
 
    COMPONENT Execute_stage
    PORT(
         RF_A : IN  std_logic_vector(31 downto 0);
         RF_A0 : IN  std_logic_vector(31 downto 0);
         RF_B : IN  std_logic_vector(31 downto 0);
         RF_B0 : IN  std_logic_vector(31 downto 0);
         RF_B1 : IN  std_logic_vector(31 downto 0);
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_SrcA : IN  std_logic;
         ALU_SrcB : IN  std_logic_vector(1 downto 0);
         ALU_out : OUT  std_logic_vector(31 downto 0);
         ALU_zero : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RF_A : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_A0 : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_B : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_B0 : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_B1 : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');
   signal ALU_SrcA : std_logic := '0';
   signal ALU_SrcB : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal ALU_out : std_logic_vector(31 downto 0);
   signal ALU_zero : std_logic;
  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Execute_stage PORT MAP (
          RF_A => RF_A,
          RF_A0 => RF_A0,
          RF_B => RF_B,
          RF_B0 => RF_B0,
          RF_B1 => RF_B1,
          ALU_func => ALU_func,
          ALU_SrcA => ALU_SrcA,
          ALU_SrcB => ALU_SrcB,
          ALU_out => ALU_out,
          ALU_zero => ALU_zero
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;

      RF_A <= x"fff0f000";
		RF_A0 <= x"ffffff0f";
		RF_B <= x"fff0f000";
		RF_B0 <= x"00000004";
		RF_B1 <= x"fffffff1"; -- Immed <= x"fffffff1";
		-- Controls
		ALU_SrcA <= '0'; -- take PC
		ALU_SrcB <= "00"; --RF b
		ALU_func <= x"0";
		wait for 100 ns;	
      
		-- Controls
		ALU_SrcA <= '1'; -- take RFa
		ALU_SrcB <= "01"; -- +4
		ALU_func <= x"0";
		wait for 100 ns;
		ALU_SrcB <= "10";
		-- Execute each operation
		for i in 1 to 11 loop
		ALU_func <= ALU_func + "0001";
		ALU_SrcA <= Not ALU_SrcA;
		wait for 100 ns;
		end loop;

      wait;
   end process;

END;
