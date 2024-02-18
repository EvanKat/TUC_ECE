----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:16:01 03/24/2021 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.NUMERIC_STD.ALL; -- arithmetic functions with Signed or Unsigned values
use IEEE.STD_LOGIC_SIGNED.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           OpCode : in  STD_LOGIC_VECTOR (3 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0);
           ZeroFlag : out  STD_LOGIC;
			  Cout : out STD_LOGIC;
           OverflowFlag : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
	signal OutputTemp : STD_LOGIC_VECTOR (31 downto 0);
	signal OutExendedTemp : STD_LOGIC_VECTOR (32 downto 0):= (others => '0');
	signal ZeroFlagTemp : STD_LOGIC := '0';
	signal OverflowFlagTemp : STD_LOGIC := '0';
	signal CoutTemp: STD_LOGIC := '0';
	
	
begin
	-- OpCode based operations
	process (A,B,OpCode)
	begin
		case (OpCode) is 
			-- Addition
			when "0000" =>
				OutputTemp <= A + B;
			
			-- Subtraction
			when "0001" =>
				OutputTemp <= A - B;
			
			-- Lgical AND
			when "0010" =>
				OutputTemp <= A AND B;
			
			-- Logical OR
			when "0011" =>
				OutputTemp <= A OR B;
			
			-- Logical NOT of A input
			when "0100" =>
				OutputTemp <= NOT A;
			
			-- Logical NAND
			when "0101" =>
				OutputTemp <= A NAND B;
		  
			-- Logical NOR
			when "0110" =>
				OutputTemp <= A NOR B;
		  
			-- Arithmetic Shift Right by 1
			when "1000" =>
				OutputTemp <= std_logic_vector(shift_right(signed(A), 1));
				--Output <= signed(A) sra 1;
				
			-- Logicaly Shift Right by 1
			when "1001" =>
				OutputTemp <= std_logic_vector(shift_right(unsigned(A), 1));
				--Output <= unsigned(A) srl 1;
				
			-- Logicaly Shift Left by 1
			when "1010" =>
				OutputTemp <= std_logic_vector(shift_left(unsigned(A), 1));
						
			-- Roatate Left by 1
			when "1100" =>
				OutputTemp <= std_logic_vector(signed(A) rol 1);
				--Output <= A ROL 1;
				
			-- Rotate Right by 1	
			when "1101" =>
				OutputTemp <= std_logic_vector(signed(A) ror 1);

			when others =>
				-- OutputTemp <= A;
		end case;
	end process;
	
	-- Zero Flag
	process(A,B,OpCode,OutputTemp)
	begin
		if to_integer(unsigned(OutputTemp)) = 0 then 
			ZeroFlagTemp <= '1';
		else 
			ZeroFlagTemp <= '0';
		end if;		
	
		case (OpCode) is 
				when "0000" =>
				if ((A(31) = B(31)) and (A(31) /=  OutputTemp(31))) then --MSB must be the same 
					OverflowFlagTemp <= '1';
				else 
					OverflowFlagTemp <= '0';
				end if;
				-- Carry out
				OutExendedTemp <= ((A(31) & A) + (B(31) & B));
				CoutTemp <= OutExendedTemp(32);
				
				when "0001" =>
					-- Overflow Flag at subtraction
				if ((A(31) /= B(31)) and (A(31) /=  OutputTemp(31))) then --In Case of MSB of a,b not equal, then overflow we have when Out MSB ~= A MSB
						OverflowFlagTemp <= '1';
				else 
						OverflowFlagTemp <= '0';
				end if;
				-- Carry out
				OutExendedTemp <= (A(31) & A) - (B(31) & B);
				CoutTemp <= OutExendedTemp(32);
				
		when others =>
			OverflowFlagTemp <= '0';
			CoutTemp <= '0';
		end case;
	end process;
	
	
	-- Set the final Signals
	Output <= OutputTemp after 10ns;
	ZeroFlag <= ZeroFlagTemp after 10ns;
	Cout <= Couttemp after 10ns; 
	OverflowFlag <= OverflowFlagTemp after 10ns;
end Behavioral;

