----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:45:56 04/20/2021 
-- Design Name: 
-- Module Name:    Memory_RAM_stage - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Memory_RAM_stage is
    Port ( ByteOp : in  STD_LOGIC;
           MEM_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           clk : in  STD_LOGIC;
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end Memory_RAM_stage;

architecture Behavioral of Memory_RAM_stage is

component Memory_stage
    Port ( ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_WrEn : out  STD_LOGIC);
end component;

component RAM
	port (
		clk : in std_logic;
		inst_addr : in std_logic_vector(10 downto 0);
		inst_dout : out std_logic_vector(31 downto 0);
		data_we : in std_logic;
		data_addr : in std_logic_vector(10 downto 0);
		data_din : in std_logic_vector(31 downto 0);
		data_dout : out std_logic_vector(31 downto 0));
end component;

signal ramAddr : STD_LOGIC_VECTOR (31 downto 0);
signal dataIn : STD_LOGIC_VECTOR (31 downto 0);
signal dataOut : STD_LOGIC_VECTOR (31 downto 0);
signal WE : STD_LOGIC;

begin

Mem_comp : Memory_stage port map(
		ByteOp => ByteOp,
		
		Mem_WrEn => Mem_WrEn,
		MM_WrEn => WE,
      
		ALU_MEM_Addr => ALU_MEM_Addr,
      MM_Addr => ramAddr,
		
		MEM_DataIn => MEM_DataIn,
		MM_WrData => dataIn,
		
		MEM_DataOut => MEM_DataOut,
      MM_RdData => dataOut
		);


memory : RAM port map(
		clk => clk,
		
		data_we => WE,
		
		inst_addr => (others => '0'),
		inst_dout => open,
		
		data_addr => ramAddr(12 downto 2),
		
		data_din => dataIn,
		
		data_dout => dataOut
		);
end Behavioral;

