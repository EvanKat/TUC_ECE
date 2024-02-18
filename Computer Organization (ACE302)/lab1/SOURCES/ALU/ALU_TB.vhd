--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:34:47 03/29/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/1st/ACE_Lab/ALU_TB.vhd
-- Project Name:  ACE_Lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY ALU_TB IS
END ALU_TB;
 
ARCHITECTURE behavior OF ALU_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         OpCode : IN  std_logic_vector(3 downto 0);
         Output : OUT  std_logic_vector(31 downto 0);
         ZeroFlag : OUT  std_logic;
         Cout : OUT  std_logic;
         OverflowFlag : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal OpCode : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(31 downto 0);
   signal ZeroFlag : std_logic;
   signal Cout : std_logic;
   signal OverflowFlag : std_logic;
	
	-- Wait time
	--constant wt : time := 100 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          OpCode => OpCode,
          Output => Output,
          ZeroFlag => ZeroFlag,
          Cout => Cout,
          OverflowFlag => OverflowFlag
        );
 

   -- Stimulus process
   stim_proc: process
   begin
		
		-- Add
		OpCode <= "0000";
		A <= x"00000001";
		B <= x"00000002";
		wait for 100 ns;	
		
		-- Sub
		OpCode <= "0001";
		A <= x"0000000f";
		B <= x"00000001";
		wait for 100 ns;
		
		-- Overflow at add
		OpCode <= "0000";
		A <= x"7fffffff";
		B <= x"00000001";
		wait for 100 ns;	
		
		-- Cout & over at add
		OpCode <= "0000";
		A <= x"80000000";
		B <= x"ffffffff";
		wait for 100 ns;
		
		-- Sub
		OpCode <= "0001";
		A <= x"00000002";
		B <= x"00000001";
		wait for 100 ns;	
		
		-- Overflow at sub
		OpCode <= "0001";
		A <= x"7fffffff";
		B <= x"ffffffff";
		wait for 100 ns;
		
		-- Cout at sub
		OpCode <= "0001";
		A <= x"fffffffe";
		B <= x"ffffffff";
		wait for 100 ns;
		
		-- AND
		OpCode  <= "0010";
		A <= x"0000003c";
		B <= x"000000ff";
		wait for 100 ns;
		
		-- OR
		OpCode <= "0011";
		A <= x"00000055";
		B <= x"000000ff";
		wait for 100 ns;
		
		-- NOT
		OpCode <= "0100";
		A <= x"f0f0f0f0";
		B <= x"00000000";
		wait for 100 ns;
		
		-- NAND
		OpCode <= "0101";
		A <= x"0000003c";
		B <= x"000000ff";
		wait for 100 ns;
		
		-- NOR
		OpCode <= "0110";
		A <= x"0000003c";
		B <= x"000000ff";
		wait for 100 ns;
		
		-- Arithmetic right Shift
		OpCode <= "1000";
		A <= x"90000008";
		B <= x"00000000";
		wait for 100 ns;
		
		-- Logical right Shift
		OpCode <= "1001";
		A <= x"9003c009";
		B <= x"00000000";
		wait for 100 ns;
		
		-- Logical Left Shift 
		OpCode <= "1010";
		A <= x"9003c009";
		B <= x"00000000";
		wait for 100 ns;
		
		-- Rotate Left
		OpCode <= "1100";
		A <= x"0fffffff";
		B <= x"00000000";
		wait for 100 ns;

		-- Rotate Right
		OpCode <= "1101";
		A <= x"0000000f";
		B <= x"00000000";
		wait for 100 ns;		
   end process;

END;
