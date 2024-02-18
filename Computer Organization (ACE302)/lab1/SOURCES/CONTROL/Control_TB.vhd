--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:41:52 04/20/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/1st/ACE_Lab/Control_TB.vhd
-- Project Name:  ACE_Lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CONTROL
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all; 
use IEEE.NUMERIC_STD.ALL;

ENTITY Control_TB IS
END Control_TB;
 
ARCHITECTURE behavior OF Control_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CONTROL
    PORT(
         OpCode : IN  std_logic_vector(5 downto 0);
         Func : IN  std_logic_vector(3 downto 0);
         PC_sel : OUT  std_logic;
         PC_LdEn : OUT  std_logic;
         RF_WrEn : OUT  std_logic;
         RF_WrData_sel : OUT  std_logic;
         RF_B_sel : OUT  std_logic;
         ImmExt : OUT  std_logic_vector(1 downto 0);
         ALU_zero : IN  std_logic;
         ALU_bin_sel : OUT  std_logic;
         ALU_func : OUT  std_logic_vector(3 downto 0);
         ByteOp : OUT  std_logic;
         MEM_WrEn : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal OpCode : std_logic_vector(5 downto 0) := (others => '0');
   signal Func : std_logic_vector(3 downto 0) := (others => '0');
   signal ALU_zero : std_logic := '0';

 	--Outputs
   signal PC_sel : std_logic;
   signal PC_LdEn : std_logic;
   signal RF_WrEn : std_logic;
   signal RF_WrData_sel : std_logic;
   signal RF_B_sel : std_logic;
   signal ImmExt : std_logic_vector(1 downto 0);
   signal ALU_bin_sel : std_logic;
   signal ALU_func : std_logic_vector(3 downto 0);
   signal ByteOp : std_logic;
   signal MEM_WrEn : std_logic;
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CONTROL PORT MAP (
          OpCode => OpCode,
          Func => Func,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          RF_WrEn => RF_WrEn,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          ALU_zero => ALU_zero,
          ALU_bin_sel => ALU_bin_sel,
          ALU_func => ALU_func,
          ByteOp => ByteOp,
          MEM_WrEn => MEM_WrEn
        );

   

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		OpCode <= "100000";
		Func <= "0000";
		wait for 100 ns;	
		
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		Func <= Func + "0001";
		wait for 100 ns;	
		
		OpCode <= "111000";
		wait for 100 ns;

		OpCode <= "111001";
		wait for 100 ns;
		
		OpCode <= "110000";
		wait for 100 ns;
		
		OpCode <= "110010";
		wait for 100 ns;		
				
		OpCode <= "110011";
		wait for 100 ns;
		
		
		OpCode <= "111111";
		wait for 100 ns;
		
		
		OpCode <= "000000";
		wait for 100 ns;
		ALU_zero <= '1';
		OpCode <= "000000";
		wait for 100 ns;
		
		OpCode <= "000001";
		wait for 100 ns;
		
		OpCode <= "000011";
		wait for 100 ns;
		ALU_zero <= '0';
		OpCode <= "000011";
		wait for 100 ns;
		
		OpCode <= "000111";
		wait for 100 ns;
		
		
		OpCode <= "001111";
		wait for 100 ns;
		
		OpCode <= "011111";
		wait for 100 ns;
		wait;
   end process;

END;
