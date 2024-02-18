----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:26:45 05/18/2021 
-- Design Name: 
-- Module Name:    CONTROL_MC - Behavioral 
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

entity CONTROL_MC is
	Port (	clk : IN STD_LOGIC;
				rst : IN STD_LOGIC;
				-- inputs
				OpCode : IN STD_LOGIC_VECTOR(5 downto 0); --Instr(31 downto 26)
				Func : IN STD_LOGIC_VECTOR(3 downto 0);  -- 11 + Instr(3 downto 0)
				ALU_zero : IN STD_LOGIC; 
			   
				-- For PC 
            PC_LdEn : OUT  STD_LOGIC;
			   PC_sel: OUT STD_LOGIC;
				-- Instr_Reg
			   InstrReg_LdEn : OUT STD_LOGIC;
				-- Decode_stage
            RF_WrEn : OUT  STD_LOGIC;
            RF_WrData_sel : OUT  STD_LOGIC;
            RF_B_sel : OUT  STD_LOGIC;
            ImmExt : OUT  STD_LOGIC_VECTOR (1 downto 0);
				--Register A,B
				Reg_A_WrEn : OUT  STD_LOGIC;
				Reg_B_WrEn : OUT STD_LOGIC;
				-- Execute_stage
				ALU_Func : OUT  STD_LOGIC_VECTOR (3 downto 0);
				--ALU_zero : out  STD_LOGIC;
				ALU_SrcA_sel : OUT  STD_LOGIC; -- control for Mux 2-1
				ALU_SrcB_sel : OUT  STD_LOGIC_VECTOR (1 downto 0); -- control for Mux 4-1 
				-- ALU Register
			   Reg_ALU_WrEn : OUT  STD_LOGIC;
			   -- Mem_stage
            ByteOp : OUT STD_LOGIC;
            Mem_WrEn : OUT STD_LOGIC;
				-- Memory Register
				Reg_MEM_WrEn : OUT STD_LOGIC);
end CONTROL_MC;

architecture Behavioral of CONTROL_MC is
-- signals

-- For PC 
signal PC_LdEn_tmp : STD_LOGIC;
signal PC_sel_tmp : STD_LOGIC;
-- Instr_Reg
signal InstrReg_LdEn_tmp : STD_LOGIC;

-- Decode_stage
signal RF_WrEn_tmp : STD_LOGIC;
signal RF_WrData_sel_tmp : STD_LOGIC;
signal RF_B_sel_tmp : STD_LOGIC;
signal ImmExt_tmp : STD_LOGIC_VECTOR (1 downto 0);
--Register A,B
signal Reg_A_WrEn_tmp : STD_LOGIC;
signal Reg_B_WrEn_tmp : STD_LOGIC;

-- Execute_stage
signal ALU_Func_tmp : STD_LOGIC_VECTOR (3 downto 0); 
signal ALU_SrcA_sel_tmp : STD_LOGIC; 
signal ALU_SrcB_sel_tmp : STD_LOGIC_VECTOR (1 downto 0);
-- ALU Register
signal Reg_ALU_WrEn_tmp : STD_LOGIC;

-- Mem_stage
signal ByteOp_tmp : STD_LOGIC;
signal Mem_WrEn_tmp : STD_LOGIC;
-- Memory Register
signal Reg_MEM_WrEn_tmp : STD_LOGIC;

-- states
-- s0 : IF : IR <= MEM[PC]
-- s1 : Decode : A <= RF[rs], B<= RF[rd]

-- Execute
-- s2 : R-type : ALUreg <= A func B
-- s3 : Load Immed : ALUreg <= R0 + immed
-- s4 : ALU Immed : ALUreg <= R1 func Immed
-- s5 : Branch :  PC <= Next(PC)
-- s6 : BEQ-BNE : PC <= Next(PC) if condition
-- s7 : LW-LB : to aluReg form rega + immed value
-- s8 : SW-SB : to aluReg form rega + immed value

-- Memory
-- s7 -> s9  : From MEM to memReg | MEM[ALUreg] (lw/lb)
-- s8 -> s10 : from reg to MEM

-- RF write back
-- s2,3,4 -> s11 : write to RF from ALUreg
-- s7 -> s9 -> s12 : store to register 

type states is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
SIGNAL currentState, nextState  : states;

begin
-- clk
process
	begin	
		wait until clk'EVENT and clk='1';
		if (rst = '1') then
			currentState <= s0;
		else
			currentState <= nextState;
		end if;
end process;

-- State Machine
process(OpCode, Func, currentState)
begin
	nextState <= s0; -- init
	-- Execute
	case(currentState) is
		when s0 =>  -- IF
			nextState <= s1;
		when s1 =>  -- DEC
			case(OpCode) is 
				when "100000" => -- R
					nextState <= s2;
				when "111000" => -- Load immed
					nextState <= s3;
				when "111001" => -- Load unsigned immed
					nextState <= s3;
				when "110000" => -- add immed
					nextState <= s4;
				when "110010" => -- nand immed
					nextState <= s4;
				when "110011" => -- or immed
					nextState <= s4;
				when "111111" => -- branch
					nextState <= s5;
				when "000000" => -- beq
					nextState <= s6;
				when "000001" => -- bne
					nextState <= s6;
				when "000011" => -- lb
					nextState <= s7;
				when "001111" => -- lw
					nextState <= s7;
				when "000111" => -- sb
					nextState <= s8;
				when "011111" => -- sw
					nextState <= s8;
				when others => 
					nextState <= s0;
			end case;
		-- Memory
		when s7 =>  -- lb/lw 
				nextState <= s9;
		when s8 =>  -- sb/sw 
				nextState <= s10;
		-- Execute
		when s9 =>  -- from lb/lw store to RF
				nextState <= s12;
		when s2 =>  -- R
				nextState <= s11;
		when s3 =>  -- Load immed/unImmed
				nextState <= s11;
		when s4 =>  -- addi-nandi-ori
				nextState <= s11;
		-- INIT
		when s5 =>  -- branch
				nextState <= s0;
		when s6 =>  -- beq-bne
				nextState <= s0;
		when s10 =>  -- from stored in mem to init
				nextState <= s0;		
		when s11 =>  -- from stored exec-value to init
				nextState <= s0;
		when s12 =>  -- from stored mem-value to init
				nextState <= s0;
		when others =>
				nextState <= s0;
	end case;
end process;



process(currentState,OpCode,ALU_Zero,Func)
	begin
		case currentState is
			-- IF
			when s0 =>
				PC_sel_tmp <= '0'; 	-- ALU_out
				PC_LdEn_tmp <= '1'; 	-- next innstr
				InstrReg_LdEn_tmp <= '1'; -- instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= '0'; -- read from ALU reg
				RF_B_sel_tmp <= 'X'; -- set $rt 
				ImmExt_tmp <= "XX"; -- no use here
				Reg_A_WrEn_tmp <= '0';-- no write in exA
				Reg_B_WrEn_tmp <= '0';-- no write in exB
				
				ALU_Func_tmp <= "0000"; -- add
				ALU_SrcA_sel_tmp <= '0'; -- from pc
				ALU_SrcB_sel_tmp <= "01"; -- +4
				Reg_ALU_WrEn_tmp <= '0'; -- no write at reg
				
				ByteOp_tmp <= 'X'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; 

			-- Decode
			when s1 =>
				PC_sel_tmp <= '0'; 	-- ALU_out
				PC_LdEn_tmp <= '0'; 	-- no next innstr
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				
				--case OpCode is
				--	when "100000" => 	-- Rtype
				--		RF_B_sel_tmp <= '0';	-- RF[rt]
				--	when others =>    -- Itype
				--		RF_B_sel_tmp <= '1';	--RF[rd]
				--end case;
				
				-- Rtype vs Itype
				-- When R-type OpCode <= 100000
				-- When I-type OpCode <= 11*0**
				RF_B_sel_tmp <= not OpCode(5);
				
				ImmExt_tmp <= "11"; -- <<2 & Immed
				Reg_A_WrEn_tmp <= '1';-- load to exA
				Reg_B_WrEn_tmp <= '1';-- load to exB
				
				ALU_Func_tmp <= "0000"; -- add
				ALU_SrcA_sel_tmp <= '0'; -- from pc
				ALU_SrcB_sel_tmp <= "10"; -- immed value
				Reg_ALU_WrEn_tmp <= '1'; -- write at reg
				
				ByteOp_tmp <= 'X'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; 				
			
			-- ExStage
			-- EXEC Rtype 
			when s2 =>
				PC_sel_tmp <= 'X'; 	-- Dont care
				PC_LdEn_tmp <= '0'; 	-- no next innstr
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				RF_B_sel_tmp <= 'X';	-- 
				ImmExt_tmp <= "XX"; -- dont care
				Reg_A_WrEn_tmp <= '0';-- no load to exA
				Reg_B_WrEn_tmp <= '0';-- no load to exB
				
				ALU_Func_tmp <= Func; -- Instr(3 downto 0)
				ALU_SrcA_sel_tmp <= '1'; -- from RF a
				ALU_SrcB_sel_tmp <= "00"; -- from RF b
				Reg_ALU_WrEn_tmp <= '1'; -- write at reg
				
				ByteOp_tmp <= 'X'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; 		
			
			-- EXEC Itype li-lui
			when s3 =>
				PC_sel_tmp <= 'X'; 	-- dont care
				PC_LdEn_tmp <= '0'; 	-- no next innstr
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				RF_B_sel_tmp <= 'X';	-- 
				ImmExt_tmp <= (others => OpCode(0));
				--if(OpCode(0) = '0') then
				--	ImmExt_tmp <= "01"; -- li : signeg extend 
				--else 
				--	ImmExt_tmp <= "10"; -- lui : shift & zeroFill
				--end if;
				Reg_A_WrEn_tmp <= '0';-- load to exA
				Reg_B_WrEn_tmp <= '0';-- load to exB
				
				ALU_Func_tmp <= "0000"; -- Instr(3 downto 0)
				ALU_SrcA_sel_tmp <= '1'; -- from RF a (R0)
				ALU_SrcB_sel_tmp <= "10"; -- Immed
				Reg_ALU_WrEn_tmp <= '1'; -- write at reg
				
				ByteOp_tmp <= 'X'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; 	
			
			-- EXEC Itype li-lui
			when s4 =>
				PC_sel_tmp <= 'X'; 	-- dont care
				PC_LdEn_tmp <= '0'; 	-- no next innstr
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				RF_B_sel_tmp <= 'X';	-- 
				--ImmExt_tmp <= "01"; -- li : signeg extend 
				Reg_A_WrEn_tmp <= '0';-- load to exA
				Reg_B_WrEn_tmp <= '0';-- load to exB
				
				case OpCode is
					when "110000" => -- addi
						ALU_Func_tmp <= "0000";
						ImmExt_tmp <= "01"; -- sign extend
					when "110010" => -- nandi
						ALU_Func_tmp <= "0101"; -- nand
						ImmExt_tmp <= "00"; --zero fill
					when others => -- ori
						ALU_Func_tmp <= "0011"; -- or
						ImmExt_tmp <= "00"; --zero fill
				end case;
				
				--ALU_Func_tmp <= "0000"; -- Instr(3 downto 0)
				ALU_SrcA_sel_tmp <= '1'; -- from RF a (R0)
				ALU_SrcB_sel_tmp <= "10"; -- Immed
				Reg_ALU_WrEn_tmp <= '1'; -- write at reg
				
				ByteOp_tmp <= 'X'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; 	
			
			--Branch
			when s5 =>
				PC_sel_tmp <= '1'; 	-- ALU reg
				PC_LdEn_tmp <= '1'; 	-- next innstr
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				RF_B_sel_tmp <= 'X';	-- 
				ImmExt_tmp <= "XX"; -- dont care
				Reg_A_WrEn_tmp <= '0';-- load to exA
				Reg_B_WrEn_tmp <= '0';-- load to exB
				
				ALU_Func_tmp <= "0000"; -- dont care
				ALU_SrcA_sel_tmp <= '0'; -- dont care
				ALU_SrcB_sel_tmp <= "00"; -- dont care
				Reg_ALU_WrEn_tmp <= '0'; -- no write at reg
				
				ByteOp_tmp <= 'X'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; 	
			
			-- beq-bne
			when s6 =>
				-- if beq -> Opcode(0) = 0. If ALU_zero = 1 => branch else no
				--	if bn1 -> Opcode(0) = 1. If ALU_zero = 0 => branch else no
				PC_sel_tmp <= Opcode(0) xor ALU_zero;  
				PC_LdEn_tmp <= Opcode(0) xor ALU_zero;
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				RF_B_sel_tmp <= 'X';	-- 
				ImmExt_tmp <= "XX"; -- dont care
				Reg_A_WrEn_tmp <= '0';-- no load to exA
				Reg_B_WrEn_tmp <= '0';-- no load to exB
				
				ALU_Func_tmp <= "0001"; -- sub
				ALU_SrcA_sel_tmp <= '1'; -- register A
				ALU_SrcB_sel_tmp <= "00"; -- register B
				Reg_ALU_WrEn_tmp <= '0'; -- no write at reg
				
				ByteOp_tmp <= 'X'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; 
			
			-- Lb-Lw
			when s7 =>
				PC_sel_tmp <= 'X'; -- dont care  
				PC_LdEn_tmp <= '0'; -- no next instraction
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				RF_B_sel_tmp <= 'X';	-- 
				ImmExt_tmp <= "01"; -- Sign Extend
				Reg_A_WrEn_tmp <= '0';-- no load to exA
				Reg_B_WrEn_tmp <= '0';-- no load to exB
				
				ALU_Func_tmp <= "0000"; -- add
				ALU_SrcA_sel_tmp <= '1'; -- register A
				ALU_SrcB_sel_tmp <= "10"; -- immed value
				Reg_ALU_WrEn_tmp <= '1'; -- write at reg (mem addr)
				
				ByteOp_tmp <= 'X'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; 				
			
			
			-- Sb-Sw
			when s8 =>
				PC_sel_tmp <= 'X'; -- dont care  
				PC_LdEn_tmp <= '0'; -- no next instraction
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				RF_B_sel_tmp <= 'X';	-- 
				ImmExt_tmp <= "01"; -- Sign Extend
				Reg_A_WrEn_tmp <= '0';-- no load to exA
				Reg_B_WrEn_tmp <= '0';-- no load to exB
				
				ALU_Func_tmp <= "0000"; -- add
				ALU_SrcA_sel_tmp <= '1'; -- register A
				ALU_SrcB_sel_tmp <= "10"; -- immed value
				Reg_ALU_WrEn_tmp <= '1'; -- write at reg (mem addr)
				
				ByteOp_tmp <= 'X'; -- no use here
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; 				
			-----------------------------------------------------------------
			
			-- MEM STAGE
			-- Lb-Lw
			when s9 =>
				PC_sel_tmp <= 'X'; -- dont care  
				PC_LdEn_tmp <= '0'; -- no next instraction
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				RF_B_sel_tmp <= 'X';	-- 
				ImmExt_tmp <= "XX"; -- dont care
				Reg_A_WrEn_tmp <= '0';-- no load to exA
				Reg_B_WrEn_tmp <= '0';-- no load to exB
				
				ALU_Func_tmp <= "0000"; -- dont care
				ALU_SrcA_sel_tmp <= 'X'; -- dont care
				ALU_SrcB_sel_tmp <= "XX"; -- dont care
				Reg_ALU_WrEn_tmp <= '0'; -- dont write at reg
				
				-- if LW then Opcode = 001.1.11 => byteOp -> 0
				-- if Lb then Opcode = 000.0.11 => byteOp -> 1
				ByteOp_tmp <= not Opcode(2); --
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '1'; -- write to mem reg
			
			-- Sb-sw
			when s10 =>
				PC_sel_tmp <= 'X'; -- dont care  
				PC_LdEn_tmp <= '0'; -- no next instraction
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '0';	-- no write in rf
				RF_WrData_sel_tmp <= 'X'; -- dont care
				RF_B_sel_tmp <= 'X';	-- 
				ImmExt_tmp <= "XX"; -- dont care
				Reg_A_WrEn_tmp <= '0';-- no load to exA
				Reg_B_WrEn_tmp <= '0';-- no load to exB
				
				ALU_Func_tmp <= "0000"; -- dont care
				ALU_SrcA_sel_tmp <= 'X'; -- dont care
				ALU_SrcB_sel_tmp <= "XX"; -- dont care
				Reg_ALU_WrEn_tmp <= '0'; -- dont write at reg
				
				-- if SW then Opcode = 01.1.111 => byteOp -> 0
				-- if Sb then Opcode = 00.0.111 => byteOp -> 1
				ByteOp_tmp <= not Opcode(4); --
				MEM_WrEn_tmp <= '1'; -- store to mem
				Reg_MEM_WrEn_tmp <= '0'; -- no write to mem reg

			------------------------------------------------------
			
			-- Write back to RF
			
			-- Write back to rf from ALU reg
			when s11 =>
				PC_sel_tmp <= 'X'; -- dont care  
				PC_LdEn_tmp <= '0'; -- no next instraction
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '1';	-- store in rf
				RF_WrData_sel_tmp <= '0'; -- From ALU reg
				RF_B_sel_tmp <= 'X';	-- 
				ImmExt_tmp <= "XX"; -- dont care
				Reg_A_WrEn_tmp <= '0';-- no load to exA
				Reg_B_WrEn_tmp <= '0';-- no load to exB
				
				ALU_Func_tmp <= "0000"; -- dont care
				ALU_SrcA_sel_tmp <= 'X'; -- dont care
				ALU_SrcB_sel_tmp <= "XX"; -- dont care
				Reg_ALU_WrEn_tmp <= '0'; -- dont write at reg
				
				ByteOp_tmp <= 'X'; -- dont care
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; -- no write to mem reg

			-- Write back to rf from mem reg
			when s12 =>
				PC_sel_tmp <= 'X'; -- dont care  
				PC_LdEn_tmp <= '0'; -- no next instraction
				InstrReg_LdEn_tmp <= '0'; -- no load instr to register
				
				RF_WrEn_tmp <= '1';	-- store in rf
				RF_WrData_sel_tmp <= '1'; -- From mem reg
				RF_B_sel_tmp <= 'X';	-- dont care
				ImmExt_tmp <= "XX"; -- dont care
				Reg_A_WrEn_tmp <= '0';-- no load to exA
				Reg_B_WrEn_tmp <= '0';-- no load to exB
				
				ALU_Func_tmp <= "0000"; -- dont care
				ALU_SrcA_sel_tmp <= 'X'; -- dont care
				ALU_SrcB_sel_tmp <= "XX"; -- dont care
				Reg_ALU_WrEn_tmp <= '0'; -- dont write at reg
				
				ByteOp_tmp <= 'X'; -- dont care
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; -- no write to mem reg
			
			when others => 
				PC_sel_tmp <= '0'; -- dont care  
				PC_LdEn_tmp <= '1'; -- no next instraction
				InstrReg_LdEn_tmp <= '1'; -- load instr to register
				
				RF_WrEn_tmp <= '0';	
				RF_WrData_sel_tmp <= '0'; 
				RF_B_sel_tmp <= 'X';	-- dont care
				ImmExt_tmp <= "XX"; -- dont care
				Reg_A_WrEn_tmp <= '0';-- no load to exA
				Reg_B_WrEn_tmp <= '0';-- no load to exB
				
				ALU_Func_tmp <= "0000"; 
				ALU_SrcA_sel_tmp <= '0'; -- PC
				ALU_SrcB_sel_tmp <= "01"; -- +4
				Reg_ALU_WrEn_tmp <= '0'; -- dont write at reg
				
				ByteOp_tmp <= 'X'; -- dont care
				MEM_WrEn_tmp <= '0'; -- no store to mem
				Reg_MEM_WrEn_tmp <= '0'; -- no write to mem reg
			
		end case;
end process;		
	
-- set output



PC_sel <= PC_sel_tmp;
PC_LdEn <= PC_LdEn_tmp;
InstrReg_LdEn <= InstrReg_LdEn_tmp;

RF_WrEn <= RF_WrEn_tmp;	
RF_WrData_sel <= RF_WrData_sel_tmp; 
RF_B_sel <= RF_B_sel_tmp;
ImmExt <= ImmExt_tmp; 
Reg_A_WrEn <= Reg_A_WrEn_tmp;
Reg_B_WrEn <= Reg_B_WrEn_tmp;
				
ALU_Func <= ALU_Func_tmp; 
ALU_SrcA_sel <= ALU_SrcA_sel_tmp;
ALU_SrcB_sel <= ALU_SrcB_sel_tmp;
Reg_ALU_WrEn <= Reg_ALU_WrEn_tmp;
				
ByteOp <= ByteOp_tmp; 
MEM_WrEn <= MEM_WrEn_tmp;
Reg_MEM_WrEn <= Reg_MEM_WrEn_tmp;

end Behavioral;

