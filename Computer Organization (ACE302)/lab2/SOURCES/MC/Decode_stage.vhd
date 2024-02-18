----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:04:22 04/16/2021 
-- Design Name: 
-- Module Name:    Decode_stage - Behavioral 
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

entity Decode_stage is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel  : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           clk  : in  STD_LOGIC;
			  rst : in STD_LOGIC; -----
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
end Decode_stage;

architecture Behavioral of Decode_stage is

-- RF
component RegisterFile
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           WrEn : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Cloud (Immed)
component cloud_unit 
    Port ( input : in  STD_LOGIC_VECTOR (15 downto 0);
           control : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Mux 5bit
component Mux_2to1_5bit 
    Port ( input0 : in  STD_LOGIC_VECTOR (4 downto 0);
           input1 : in  STD_LOGIC_VECTOR (4 downto 0);
           control : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

-- Mux 32bit
component Mux_2to1 is
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           control : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- mid signals
signal inst_muxToRF : STD_LOGIC_VECTOR (4 downto 0);
signal store_muxToRF : STD_LOGIC_VECTOR (31 downto 0);

begin

-- RF
register_File : RegisterFile port map (
			  Ard1 => Instr(25 downto 21),
           Ard2 => inst_muxToRF,
           Awr => Instr(20 downto 16),
           WrEn => RF_WrEn,
           clk => clk,
           rst => rst,
           Din => store_muxToRF,
           Dout1 => RF_A,
           Dout2 => RF_B
			  );
-- Mux 5bit
mux_5bit : Mux_2to1_5bit port map(
			  input0 => Instr(15 downto 11),
           input1 => Instr(20 downto 16),
           control => RF_B_sel,
           output => inst_muxToRF
			  );

-- Mux 32bit
mux_32bit : Mux_2to1 port map(
			  input0 => ALU_out,
           input1 => MEM_out,
           control => RF_WrData_sel,
           output => store_muxToRF
			  );

-- Cloud 
cloud : cloud_unit port map(
			  input => Instr(15 downto 0),
           control => ImmExt,
           output => Immed
			  );

end Behavioral;

