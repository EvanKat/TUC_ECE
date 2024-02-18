----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:53:40 04/20/2021 
-- Design Name: 
-- Module Name:    Memory_stage - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;
--use IEEE.std_logic_signed.all;
use IEEE.NUMERIC_STD.ALL;
entity Memory_stage is
    Port ( ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_WrEn : out  STD_LOGIC);
end Memory_stage;

architecture Behavioral of Memory_stage is

component Adder_2to1 
    Port ( in0 : in  STD_LOGIC_VECTOR (31 downto 0);
           in1 : in  STD_LOGIC_VECTOR (31 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0) );
end component;

signal adderToMem : STD_LOGIC_VECTOR (31 downto 0);
signal dataIn : STD_LOGIC_VECTOR (31 downto 0);
signal dataOut : STD_LOGIC_VECTOR (31 downto 0);

begin
-- Set the offset to write in data segment
adder: Adder_2to1 port map(
			  in0 => ALU_MEM_Addr,
			  --in1 => x"00000400", -- its 1024 in hexademical but has 2 LSB
           in1 => "00000000000000000001000000000000", -- 2 LSB are out
           output => adderToMem
			  );
			  
-- Case of sw/sb and lw/lb
process(ByteOP,MM_RdData)
begin 
	if (ByteOP = '0') then -- word
		--dataIn <= MEM_DataIn;
		dataOut <= MM_RdData;
	else -- Set mask (byte)
		--dataIn <= MEM_DataIn and x"000000FF";
		dataOut <= x"000000FF" AND MM_RdData  ;
	end if;
end process;

process(ByteOP,MEM_DataIn)
begin 
	if (ByteOP = '0') then -- byte
		dataIn <= MEM_DataIn;
		--dataOut <= MM_RdData;
	else -- Set mask (byte)
		dataIn <= x"000000FF" AND MEM_DataIn;
		--dataOut <= MM_RdData and x"000000FF";
	end if;
end process;


MM_Addr <= adderToMem; 
MEM_DataOut <= dataOut; -- sw/sb 
MM_WrData <= dataIn; -- lw/lb
MM_WrEn <= Mem_WrEn;


end Behavioral;

