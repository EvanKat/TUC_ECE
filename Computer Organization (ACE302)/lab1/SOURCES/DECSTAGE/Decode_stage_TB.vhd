--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:47:59 04/16/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/1st/ACE_Lab/Decode_stage_TB.vhd
-- Project Name:  ACE_Lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Decode_stage
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
 
ENTITY Decode_stage_TB IS
END Decode_stage_TB;
 
ARCHITECTURE behavior OF Decode_stage_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Decode_stage
    PORT(
         Instr : IN  std_logic_vector(31 downto 0);
         RF_WrEn : IN  std_logic;
         ALU_out : IN  std_logic_vector(31 downto 0);
         MEM_out : IN  std_logic_vector(31 downto 0);
         RF_WrData_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         ImmExt : IN  std_logic_vector(1 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         Immed : OUT  std_logic_vector(31 downto 0);
         RF_A : OUT  std_logic_vector(31 downto 0);
         RF_B : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrEn : std_logic := '0';
   signal ALU_out : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_out : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrData_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal ImmExt : std_logic_vector(1 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal Immed : std_logic_vector(31 downto 0);
   signal RF_A : std_logic_vector(31 downto 0);
   signal RF_B : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Decode_stage PORT MAP (
          Instr => Instr,
          RF_WrEn => RF_WrEn,
          ALU_out => ALU_out,
          MEM_out => MEM_out,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          clk => clk,
          rst => rst,
          Immed => Immed,
          RF_A => RF_A,
          RF_B => RF_B
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
      wait for clk_period*10;
		rst <= '0';
		
		--Data in 
		ALU_out <= x"f000000f";
		MEM_out <= x"0ffffff0";
		
		--write at R0,R1,R2 with ALU data
		RF_WrEn <= '1';
		RF_WrData_sel <= '0';
	
		--R0
		Instr <= "00000100101000001000010000000000";
		wait for clk_period*2;
		--R1
		Instr <= "00000100101000011000010000000000";
		wait for clk_period*2;
		--R2
		Instr <= "00000100101000101000010000000000";
		wait for clk_period*2;
		--R3
		Instr <= "00000100101000111000010000000000";
		wait for clk_period*2;
		
		--write at R4,R5,R6,R7 with Mem data
		RF_WrData_sel <= '1';
		
		--R4
		Instr <= "00000100101001001000010000000000";
		wait for clk_period*2;
		--R5
		Instr <= "00000100101001011000010000000000";
		wait for clk_period*2;
		--R6
		Instr <= "00000100101001101000010000000000";
		wait for clk_period*2;
		--R7
		Instr <= "00000100101001111000010000000000";
		wait for clk_period*2;
		
		-- Read registers
		RF_WrEn <= '0';
		wait for clk_period*2;
		-- R0 R1
		Instr <= "00000100000000000000110000000000";
		wait for clk_period*2;
		-- R2 R3
		Instr <= "00000100010000000001110000000000";
		wait for clk_period*2;
		-- R4 R5
		Instr <= "00000100100000000010110000000000";
		wait for clk_period*2;
		-- R6 R7
		Instr <= "00000100110000000011110000000000";
		wait for clk_period*2;
		-- R7 R32
		Instr <= "00000101000000001111110000000000";
		wait for clk_period*2;
		Instr <= "00000000000000000000000000000000";
		wait for clk_period*10;
		
		
		-- check sign extend
		-- 
		Instr <= "00001001000000001000000000000001";
		ImmExt <= "00"; --zero fill
		wait for clk_period*2;
		ImmExt <= "01"; --sign extend
		wait for clk_period*2;
		ImmExt <= "10"; -- tail zero fill
		wait for clk_period*2;
		ImmExt <= "11"; -- Shift by 2 and sign extend
		wait for clk_period*2;
		
		
		--R type
		--Instr <= "00000100400  00000 1000000000"
		
      -- insert stimulus here 

      wait;
   end process;

END;
