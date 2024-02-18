----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:42:40 04/05/2021 
-- Design Name: 
-- Module Name:    RegisterFile - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;


entity RegisterFile is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           WrEn : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is

-- Decoder 
component decoder_5to32
    Port ( input : in  STD_LOGIC_VECTOR (4 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Register
component Register_module is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           WriteEnable : in  STD_LOGIC;
           DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Mux 
component Mux_32to1 is
    Port ( in0 : in  STD_LOGIC_VECTOR (31 downto 0);
           in1 : in  STD_LOGIC_VECTOR (31 downto 0);
           in2 : in  STD_LOGIC_VECTOR (31 downto 0);
           in3 : in  STD_LOGIC_VECTOR (31 downto 0);
           in4 : in  STD_LOGIC_VECTOR (31 downto 0);
           in5 : in  STD_LOGIC_VECTOR (31 downto 0);
           in6 : in  STD_LOGIC_VECTOR (31 downto 0);
           in7 : in  STD_LOGIC_VECTOR (31 downto 0);
           in8 : in  STD_LOGIC_VECTOR (31 downto 0);
           in9 : in  STD_LOGIC_VECTOR (31 downto 0);
           in10 : in  STD_LOGIC_VECTOR (31 downto 0);
           in11 : in  STD_LOGIC_VECTOR (31 downto 0);
           in12 : in  STD_LOGIC_VECTOR (31 downto 0);
           in13 : in  STD_LOGIC_VECTOR (31 downto 0);
           in14 : in  STD_LOGIC_VECTOR (31 downto 0);
           in15 : in  STD_LOGIC_VECTOR (31 downto 0);
           in16 : in  STD_LOGIC_VECTOR (31 downto 0);
           in17 : in  STD_LOGIC_VECTOR (31 downto 0);
           in18 : in  STD_LOGIC_VECTOR (31 downto 0);
           in19 : in  STD_LOGIC_VECTOR (31 downto 0);
           in20 : in  STD_LOGIC_VECTOR (31 downto 0);
           in21 : in  STD_LOGIC_VECTOR (31 downto 0);
           in22 : in  STD_LOGIC_VECTOR (31 downto 0);
           in23 : in  STD_LOGIC_VECTOR (31 downto 0);
           in24 : in  STD_LOGIC_VECTOR (31 downto 0);
           in25 : in  STD_LOGIC_VECTOR (31 downto 0);
           in26 : in  STD_LOGIC_VECTOR (31 downto 0);
           in27 : in  STD_LOGIC_VECTOR (31 downto 0);
           in28 : in  STD_LOGIC_VECTOR (31 downto 0);
           in29 : in  STD_LOGIC_VECTOR (31 downto 0);
           in30 : in  STD_LOGIC_VECTOR (31 downto 0);
           in31 : in  STD_LOGIC_VECTOR (31 downto 0);
           input : in  STD_LOGIC_VECTOR (4 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Decoder -> And 
signal decoder_out : STD_LOGIC_VECTOR (31 downto 0);
-- AND -> Reg registers
signal wrightEnable : STD_LOGIC_VECTOR (31 downto 0);

-- Registers -> Mux (array of 32bit vectors)
type RegToMuxType is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
signal RegToMux: RegToMuxType;

--signal dout1Temp : std_logic_vector (31 downto 0) := x"00000000";
--signal dout2Temp : std_logic_vector (31 downto 0) := x"00000000";

begin

-- Decoder
decoder: decoder_5to32 port map(
				input => Awr,
				output => decoder_out
			);

-- And Gates
wrightEnable(0) <= (decoder_out(0) AND '0') after 2 ns; 
wrightEnable(1) <= (decoder_out(1) AND WrEn) after 2 ns;
wrightEnable(2) <= (decoder_out(2) AND WrEn) after 2 ns;
wrightEnable(3) <= (decoder_out(3) AND WrEn) after 2 ns;
wrightEnable(4) <= (decoder_out(4) AND WrEn) after 2 ns;
wrightEnable(5) <= (decoder_out(5) AND WrEn) after 2 ns;
wrightEnable(6) <= (decoder_out(6) AND WrEn) after 2 ns;
wrightEnable(7) <= (decoder_out(7) AND WrEn) after 2 ns;
wrightEnable(8) <= (decoder_out(8) AND WrEn) after 2 ns;
wrightEnable(9) <= (decoder_out(9) AND WrEn) after 2 ns;
wrightEnable(10) <= (decoder_out(10) AND WrEn) after 2 ns;
wrightEnable(11) <= (decoder_out(11) AND WrEn) after 2 ns;
wrightEnable(12) <= (decoder_out(12) AND WrEn) after 2 ns;
wrightEnable(13) <= (decoder_out(13) AND WrEn) after 2 ns;
wrightEnable(14) <= (decoder_out(14) AND WrEn) after 2 ns;
wrightEnable(15) <= (decoder_out(15) AND WrEn) after 2 ns;
wrightEnable(16) <= (decoder_out(16) AND WrEn) after 2 ns;
wrightEnable(17) <= (decoder_out(17) AND WrEn) after 2 ns;
wrightEnable(18) <= (decoder_out(18) AND WrEn) after 2 ns;
wrightEnable(19) <= (decoder_out(19) AND WrEn) after 2 ns;
wrightEnable(20) <= (decoder_out(20) AND WrEn) after 2 ns;
wrightEnable(21) <= (decoder_out(21) AND WrEn) after 2 ns;
wrightEnable(22) <= (decoder_out(22) AND WrEn) after 2 ns;
wrightEnable(23) <= (decoder_out(23) AND WrEn) after 2 ns;
wrightEnable(24) <= (decoder_out(24) AND WrEn) after 2 ns;
wrightEnable(25) <= (decoder_out(25) AND WrEn) after 2 ns;
wrightEnable(26) <= (decoder_out(26) AND WrEn) after 2 ns;
wrightEnable(27) <= (decoder_out(27) AND WrEn) after 2 ns;
wrightEnable(28) <= (decoder_out(28) AND WrEn) after 2 ns;
wrightEnable(29) <= (decoder_out(29) AND WrEn) after 2 ns;
wrightEnable(30) <= (decoder_out(30) AND WrEn) after 2 ns;
wrightEnable(31) <= (decoder_out(31) AND WrEn) after 2 ns;

--Registers
AllReg: for i in 1 to 31 generate
				reg: Register_module port map(
					clk =>clk,
					rst => rst,
					WriteEnable => wrightEnable(i),
					DataIn => Din,
					DataOut => RegToMux(i)
				);
end generate AllReg;

-- R0
reg: Register_module port map(
				clk =>clk,
				rst => '1',
				WriteEnable => wrightEnable(0),
				DataIn => x"00000000",
				DataOut => RegToMux(0)
			);

-- Mux1
Mux1: Mux_32to1 port map(
			in0 => RegToMux(0),
         in1 => RegToMux(1),
			in2 => RegToMux(2),
			in3 => RegToMux(3),
			in4 => RegToMux(4),
			in5 => RegToMux(5),
			in6 => RegToMux(6),
			in7 => RegToMux(7),
         in8 => RegToMux(8),
         in9 => RegToMux(9),
         in10 => RegToMux(10),
			in11 => RegToMux(11),
			in12 => RegToMux(12),
			in13 => RegToMux(13),
			in14 => RegToMux(14),
			in15 => RegToMux(15),
			in16 => RegToMux(16),
			in17 => RegToMux(17),
			in18 => RegToMux(18),
			in19 => RegToMux(19),
			in20 => RegToMux(20),
			in21 => RegToMux(21),
			in22 => RegToMux(22),
			in23 => RegToMux(23),
			in24 => RegToMux(24),
			in25 => RegToMux(25),
			in26 => RegToMux(26),
			in27 => RegToMux(27),
			in28 => RegToMux(28),
			in29 => RegToMux(29),
			in30 => RegToMux(30),
			in31 => RegToMux(31),
			input => Ard1,
			output => Dout1 
		);
-- Mux2
Mux2: Mux_32to1 port map(
			in0 => RegToMux(0),
         in1 => RegToMux(1),
			in2 => RegToMux(2),
			in3 => RegToMux(3),
			in4 => RegToMux(4),
			in5 => RegToMux(5),
			in6 => RegToMux(6),
			in7 => RegToMux(7),
         in8 => RegToMux(8),
         in9 => RegToMux(9),
         in10 => RegToMux(10),
			in11 => RegToMux(11),
			in12 => RegToMux(12),
			in13 => RegToMux(13),
			in14 => RegToMux(14),
			in15 => RegToMux(15),
			in16 => RegToMux(16),
			in17 => RegToMux(17),
			in18 => RegToMux(18),
			in19 => RegToMux(19),
			in20 => RegToMux(20),
			in21 => RegToMux(21),
			in22 => RegToMux(22),
			in23 => RegToMux(23),
			in24 => RegToMux(24),
			in25 => RegToMux(25),
			in26 => RegToMux(26),
			in27 => RegToMux(27),
			in28 => RegToMux(28),
			in29 => RegToMux(29),
			in30 => RegToMux(30),
			in31 => RegToMux(31),
			input => Ard2,
			output => Dout2
		); 
		
		
end Behavioral;