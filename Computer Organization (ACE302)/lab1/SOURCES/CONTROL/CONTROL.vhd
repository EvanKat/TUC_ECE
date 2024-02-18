----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:20:15 04/20/2021 
-- Design Name: 
-- Module Name:    CONTROL - Behavioral 
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


entity CONTROL is
    Port (	OpCode : IN STD_LOGIC_VECTOR(5 downto 0); --Instr(31 downto 26)
				Func : IN STD_LOGIC_VECTOR(3 downto 0);  -- 11 + Instr(3 downto 0)
				-- IF_stage
				PC_sel : OUT  std_logic;
				PC_LdEn : OUT  std_logic;
				-- Decode_stage
				RF_WrEn : OUT std_logic;
				RF_WrData_sel : OUT  std_logic;
				RF_B_sel : OUT  std_logic;
				ImmExt : OUT std_logic_VECTOR(1 downto 0);
				-- Execute_stage
				ALU_zero : IN STD_LOGIC;
				ALU_bin_sel : OUT  std_logic;
				ALU_func : OUT  std_logic_vector(3 downto 0);
				-- Memory_Stage
				ByteOp : OUT std_logic;
				MEM_WrEn : OUT  std_logic);
end CONTROL;

architecture Behavioral of CONTROL is
-- temporary signals

signal PC_sel_tmp : std_logic;
signal PC_LdEn_tmp : std_logic;

signal RF_WrEn_tmp : std_logic;
signal RF_WrData_sel_tmp : std_logic;
signal RF_B_sel_tmp : std_logic;
signal ImmExt_tmp : std_logic_VECTOR(1 downto 0);

signal ALU_bin_sel_tmp : std_logic;
signal ALU_func_tmp : std_logic_vector(3 downto 0);

signal ByteOp_tmp : std_logic;
signal MEM_WrEn_tmp : std_logic;

begin
process(OpCode,ALU_Zero,Func)
	begin
		case OpCode is
			-- R_type 
			when "100000" =>
				PC_sel_tmp <= '0'; 	-- not a branch
				PC_LdEn_tmp <= '1'; 	-- next innstr
				
				RF_WrEn_tmp <= '1';	-- write at $rd
				RF_WrData_sel_tmp <= '0'; -- read from ALU
				RF_B_sel_tmp <= '0'; -- set $rt 
				ImmExt_tmp <= "XX"; -- not use here
				
				ALU_bin_sel_tmp <= '0'; --Read from $rt
				ALU_func_tmp <= Func; --Instr(3 downto 0)
				
				ByteOp_tmp <= '0'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
			
			-- I_Type
			when "111000" =>
				PC_sel_tmp <= '0'; 	-- not a branch
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '1';	-- write at $rd
				RF_WrData_sel_tmp <= '0'; -- read from ALU
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "01"; -- sign Extend
				
				ALU_bin_sel_tmp <= '1'; -- Read Immed
				ALU_func_tmp <= "0000"; -- rd + Immed
				
				ByteOp_tmp <= '0'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
			
			-- I_Type (lui)
			when "111001" =>
				PC_sel_tmp <= '0'; 	-- not a branch
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '1';	-- write at $rd
				RF_WrData_sel_tmp <= '0'; -- read from ALU
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "10"; -- Zero Fill & Shift(immed to 31-16)
				
				ALU_bin_sel_tmp <= '1'; -- Read Immed
				ALU_func_tmp <= "0000"; -- rd + Immed
				
				ByteOp_tmp <= '0'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
			
			-- I_Type (addi)
			when "110000" =>
				PC_sel_tmp <= '0'; 	-- not a branch
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '1';	-- write at $rd
				RF_WrData_sel_tmp <= '0'; -- read from ALU
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "01"; -- sign extend
				
				ALU_bin_sel_tmp <= '1'; -- Read Immed
				ALU_func_tmp <= "0000" ; -- add
				
				ByteOp_tmp <= '0'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
			
			-- I_Type (nandi)
			when "110010" =>
				PC_sel_tmp <= '0'; 	-- not a branch
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '1';	-- write at $rd
				RF_WrData_sel_tmp <= '0'; -- read from ALU
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "00"; -- zero fill
				
				ALU_bin_sel_tmp <= '1'; -- Read Immed
				ALU_func_tmp <= "0101"; -- nand
				
				ByteOp_tmp <= '0'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem

			-- I_Type (ori)
			when "110011" =>
				PC_sel_tmp <= '0'; 	-- not a branch
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '1';	-- write at $rd
				RF_WrData_sel_tmp <= '0'; -- read from ALU
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "00"; -- zero fill
				
				ALU_bin_sel_tmp <= '1'; -- Read Immed
				ALU_func_tmp <= "0011"; -- nand
				
				ByteOp_tmp <= '0'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem

			-- I_Type (b)
			when "111111" =>
				PC_sel_tmp <= '1'; 	-- branch
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '0';	-- no use
				RF_WrData_sel_tmp <= 'X'; -- no use
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "11"; -- Shift by 2 and sign extend
				
				ALU_bin_sel_tmp <= 'X'; -- Read Immed
				ALU_func_tmp <= "XXXX"; -- no use
				
				ByteOp_tmp <= '0'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem

			-- I_Type (beq)
			when "000000" =>
				if(ALU_Zero='1') then
					PC_sel_tmp <= '1'; 	-- branch
				else 
					PC_sel_tmp <= '0'; 	-- next instraction
				end if;
				
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '0';	-- no use
				RF_WrData_sel_tmp <= 'X'; -- no use
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "11"; -- Shift by 2 and sign extend
				
				ALU_bin_sel_tmp <= '0'; -- Read $rd
				ALU_func_tmp <= "0001"; -- sub to set ALU_zero flag
				
				ByteOp_tmp <= '0'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem

			-- I_Type (bne)
			when "000001" =>
				if(ALU_Zero='1') then
					PC_sel_tmp <= '0'; 	-- next instraction
				else 
					PC_sel_tmp <= '1'; 	-- branch
				end if;
				
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '0';	-- no use
				RF_WrData_sel_tmp <= 'X'; -- no use
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "11"; -- Shift by 2 and sign extend
				
				ALU_bin_sel_tmp <= '0'; -- Read $rd
				ALU_func_tmp <= "0001"; -- sub to set ALU_zero flag
				
				ByteOp_tmp <= '0'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem

			-- I_Type (lb)
			when "000011" =>
				PC_sel_tmp <= '0'; 	-- next instraction
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '1';	-- store to $rd
				RF_WrData_sel_tmp <= '1'; -- read from mem
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "01"; -- sign extend
				
				ALU_bin_sel_tmp <= '1'; -- Read from mem
				ALU_func_tmp <= "0000"; -- $rs + immed
				
				ByteOp_tmp <= '1'; -- byte
				MEM_WrEn_tmp <= '0'; -- no store to mem

			-- I_Type (sb)
			when "000111" =>
				PC_sel_tmp <= '0'; 	-- next instraction
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '0';	-- not store to rf
				RF_WrData_sel_tmp <= 'X'; -- read from mem
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "01"; -- sign extend
				
				ALU_bin_sel_tmp <= '1'; -- Read from mem
				ALU_func_tmp <= "0000"; -- $rs + immed
				
				ByteOp_tmp <= '1'; -- byte
				MEM_WrEn_tmp <= '1'; -- store to mem

			-- I_Type (lw)
			when "001111" =>
				PC_sel_tmp <= '0'; 	-- next instraction
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '1';	--store to rf
				RF_WrData_sel_tmp <= '1'; -- read from mem
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "01"; -- sign extend
				
				ALU_bin_sel_tmp <= '1'; -- Read from mem
				ALU_func_tmp <= "0000"; -- $rs + immed
				
				ByteOp_tmp <= '0'; -- word
				MEM_WrEn_tmp <= '0'; -- no store to mem

			-- I_Type (sw)
			when "011111" =>
				PC_sel_tmp <= '0'; 	-- next instraction
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '0';	-- not store to rf
				RF_WrData_sel_tmp <= 'X'; -- read from mem
				RF_B_sel_tmp <= '1'; -- set $rd 
				ImmExt_tmp <= "01"; -- sign extend
				
				ALU_bin_sel_tmp <= '1'; -- Read from mem
				ALU_func_tmp <= "0000"; -- $rs + immed
				
				ByteOp_tmp <= '0'; -- word
				MEM_WrEn_tmp <= '1'; -- store to mem
			
			-- others
			when others =>
				PC_sel_tmp <= '0'; 	-- next instraction
				PC_LdEn_tmp <= '1'; 	-- next instr
				
				RF_WrEn_tmp <= '0';	-- not store to rf
				RF_WrData_sel_tmp <= '0'; -- read from mem
				RF_B_sel_tmp <= '0'; -- set $rd 
				ImmExt_tmp <= "00"; -- sign extend
				
				ALU_bin_sel_tmp <= '0'; -- Read from mem
				ALU_func_tmp <= "0000"; -- $rs + immed
				
				ByteOp_tmp <= '0'; -- word
				MEM_WrEn_tmp <= '0'; -- store to mem
			end case;
	end process;
	
-- set output

-- IF_stage
PC_sel <= PC_sel_tmp;
PC_LdEn <= PC_LdEn_tmp;
-- Decode_stage
RF_WrEn <= RF_WrEn_tmp;
RF_WrData_sel<= RF_WrData_sel_tmp ;
RF_B_sel <= RF_B_sel_tmp;
ImmExt <= ImmExt_tmp;
-- Execute_stage
ALU_bin_sel <= ALU_bin_sel_tmp;
ALU_func <= ALU_func_tmp;
-- Memory_Stage
ByteOp <= ByteOp_tmp;
MEM_WrEn <= MEM_WrEn_tmp;
end Behavioral;

