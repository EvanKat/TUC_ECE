--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:08:17 04/22/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/1st/ACE_Lab/Datapath_ram_TB.vhd
-- Project Name:  ACE_Lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Datapath_Ram
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

ENTITY Datapath_ram_TB IS
END Datapath_ram_TB;
 
ARCHITECTURE behavior OF Datapath_ram_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Datapath_Ram
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         RF_WrEn : IN  std_logic;
         RF_WrData_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         ImmExt : IN  std_logic_vector(1 downto 0);
         ALU_Bin_sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_zero : OUT  std_logic;
         ByteOp : IN  std_logic;
         Mem_WrEn : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal RF_WrEn : std_logic := '0';
   signal RF_WrData_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal ImmExt : std_logic_vector(1 downto 0) := (others => '0');
   signal ALU_Bin_sel : std_logic := '0';
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');
   signal ByteOp : std_logic := '0';
   signal Mem_WrEn : std_logic := '0';

 	--Outputs
   signal ALU_zero : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Datapath_Ram PORT MAP (
          clk => clk,
          rst => rst,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          RF_WrEn => RF_WrEn,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          ALU_zero => ALU_zero,
          ByteOp => ByteOp,
          Mem_WrEn => Mem_WrEn
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
		rst <= '1';
      wait for clk_period*100;
		rst <= '0';
		
		-- addi $r5, $r0, 8
		-- No branch, I-type, 
		PC_sel <= '0'; -- next address
      PC_LdEn <= '1'; -- store next address
      RF_WrEn <= '1'; -- We want ro store data to registers
      RF_WrData_sel <= '0'; -- Read result from ALU (add)
      RF_B_sel <= '1'; -- It could be also 0, nd
      ImmExt <= "01"; -- sign extend
      ALU_Bin_sel <= '1'; -- take Immed Value
      ALU_func <= "0000";
      ByteOp <= '0'; -- Neather
      Mem_WrEn <= '0'; -- No write
      wait for clk_period;
		
		-- ori $r3, $r0, 0xABCD
		-- No branch, I-type, 
		PC_sel <= '0'; -- next address
      PC_LdEn <= '1'; -- store next address
      RF_WrEn <= '1'; -- We want ro store data to registers 
      RF_WrData_sel <= '0'; -- Read result from ALU (or)
      RF_B_sel <= '1'; -- It could be also 0, nd
      ImmExt <= "00"; -- zero fill
      ALU_Bin_sel <= '1'; -- take Immed Value
      ALU_func <= "0011"; -- Add
      ByteOp <= '0'; -- Neather
      Mem_WrEn <= '0'; -- No write
      wait for clk_period;
		
		-- sw $r3,4($r0)
		-- No branch, I-type, 
		PC_sel <= '0'; -- next address
      PC_LdEn <= '1'; -- store next address
      RF_WrEn <= '0'; -- We dont want to store data to registers, we want to take them 
      RF_WrData_sel <= '0'; -- Read result from ALU (add)
      RF_B_sel <= '0'; -- dontcare
      ImmExt <= "00"; -- dont care
      ALU_Bin_sel <= '1'; -- take Immed Value
      ALU_func <= "0000"; -- Add
      ByteOp <= '0'; -- Word
      Mem_WrEn <= '1'; -- Write
      wait for clk_period;
		
		-- lw $r10,-4($r5)
		-- No branch, I-type, 
		PC_sel <= '0'; -- next address
      PC_LdEn <= '1'; -- store next address
      RF_WrEn <= '1'; -- We want to store data to registers
      RF_WrData_sel <= '1'; -- Read result from memory
      RF_B_sel <= '0'; -- dontcare
      ImmExt <= "00"; -- dont care
      ALU_Bin_sel <= '1'; -- take Immed Value
      ALU_func <= "0000"; -- Add
      ByteOp <= '0'; -- Word
      Mem_WrEn <= '0'; -- Read
      wait for clk_period;
		
		-- lb $r16,4($r0)
		-- No branch, I-type, 
		PC_sel <= '0'; -- next address
      PC_LdEn <= '1'; -- store next address
      RF_WrEn <= '1'; -- We want to store data to registers
      RF_WrData_sel <= '1'; -- Read result from memory
      RF_B_sel <= '0'; -- dontcare
      ImmExt <= "00"; -- dont care
      ALU_Bin_sel <= '1'; -- take Immed Value
      ALU_func <= "0000"; -- Add
      ByteOp <= '1'; -- Byte
      Mem_WrEn <= '0'; -- Read
      wait for clk_period;
		
		-- nand $r4,$r10,$r16
		-- No branch, R-type, 
		PC_sel <= '0'; -- next address
      PC_LdEn <= '1'; -- store next address
      RF_WrEn <= '1'; -- We want to store data to registers
      RF_WrData_sel <= '0'; -- Read result from ALU
      RF_B_sel <= '0';
      ImmExt <= "00"; -- dont care
      ALU_Bin_sel <= '1'; -- take Immed Value
      ALU_func <= "0101"; -- Add
      ByteOp <= '0';
      Mem_WrEn <= '0'; -- Read
      wait for clk_period;
		
		wait;
   end process;

END;
