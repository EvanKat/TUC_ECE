--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:52:46 04/20/2021
-- Design Name:   
-- Module Name:   C:/Users/EvanKat/Documents/ece_TUC/8o/ACE302/Project/1st/ACE_Lab/Memory_RAM_stage_TB.vhd
-- Project Name:  ACE_Lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Memory_RAM_stage
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
 
ENTITY Memory_RAM_stage_TB IS
END Memory_RAM_stage_TB;
 
ARCHITECTURE behavior OF Memory_RAM_stage_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Memory_RAM_stage
    PORT(
         ByteOp : IN  std_logic;
         MEM_WrEn : IN  std_logic;
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         MEM_DataIn : IN  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         MEM_DataOut : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ByteOp : std_logic := '0';
   signal MEM_WrEn : std_logic := '0';
   signal ALU_MEM_Addr : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_DataIn : std_logic_vector(31 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal MEM_DataOut : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Memory_RAM_stage PORT MAP (
          ByteOp => ByteOp,
          MEM_WrEn => MEM_WrEn,
          ALU_MEM_Addr => ALU_MEM_Addr,
          MEM_DataIn => MEM_DataIn,
          clk => clk,
          MEM_DataOut => MEM_DataOut
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
      wait for clk_period*20;

		-- Read from data
		MEM_WrEn <= '0';
		ALU_MEM_Addr <= x"00000000";
		wait for clk_period*10;	
		ALU_MEM_Addr <= x"00000004";
		wait for clk_period*10;	
		ALU_MEM_Addr <= x"00000008";
		wait for clk_period*10;	
		ALU_MEM_Addr <= x"0000000c";
		wait for clk_period*10;	
		
		-- Write to data segment
		ByteOp <= '0'; -- word
		MEM_WrEn <= '0'; 
		
		ALU_MEM_Addr <= x"00000000";
		MEM_DataIn <= x"f0f0f0f0";
      wait for clk_period*10;
		
		MEM_WrEn <= '1'; 
		ALU_MEM_Addr <= x"00000000";
		MEM_DataIn <= x"f0f0f0f0";
		wait for clk_period*10;
		ALU_MEM_Addr <= x"00000004";
		MEM_DataIn <= x"f0f0f0ff";
		wait for clk_period*10;
		ALU_MEM_Addr <= x"00000008";
		MEM_DataIn <= x"f0f0ffff";
		wait for clk_period*10;		
		ALU_MEM_Addr <= x"0000000c";
		MEM_DataIn <= x"f0ffffff";
		wait for clk_period*10;		
		MEM_DataIn <= x"00000000";
		-- Read from data
		MEM_WrEn <= '0';
		ALU_MEM_Addr <= x"00000000";
		wait for clk_period*10;	
		ALU_MEM_Addr <= x"00000004";
		wait for clk_period*10;	
		ALU_MEM_Addr <= x"00000008";
		wait for clk_period*10;	
		ALU_MEM_Addr <= x"0000000c";
		wait for clk_period*10;	
		ALU_MEM_Addr <= x"00000010";
		
		-- Read from data segment
		
      -- insert stimulus here 

      wait;
   end process;

END;
