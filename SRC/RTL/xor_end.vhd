-------------------------------------------------------------------------------
-- Title      : XOR end
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : xor_end.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 XOR apres permutation (sur l'etat et la cle)
-------------------------------------------------------------------------------
-- Copyright (c) 2023
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2023-01-02  1.0		vauchel	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity xor_end is
	port(
			key_i : in bit128;
			state_i : in type_state;
			en_xor_lsb_i : in std_logic;
			en_xor_key_i : in std_logic;
			state_o : out type_state
		);
end entity xor_end;

architecture xor_end_arch of xor_end is

	signal x4_s : bit64; -- signal intermédiaire

begin

	state_o(0) <= state_i(0);
	state_o(1) <= state_i(1);
	state_o(2) <= state_i(2);
	state_o(3) <= state_i(3) xor key_i(127 downto 64) when en_xor_key_i = '1' else -- XOR avec les 64 bits de poids fort avec la clé
				  state_i(3);
	x4_s(63 downto 1) <= state_i(4)(63 downto 1);
	x4_s(0) <= state_i(4)(0) xor en_xor_lsb_i; -- XOR avec le lsb
	state_o(4) <= x4_s xor key_i(63 downto 0) when en_xor_key_i = '1' else -- XOR avec les 64 bits de poids faible de la clé
				  x4_s;
	
end architecture xor_end_arch;
