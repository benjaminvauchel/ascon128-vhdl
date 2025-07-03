-------------------------------------------------------------------------------
-- Title      : XOR begin
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : xor_begin.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 XOR avant permutation (sur l'etat, la data et la cle)
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

entity xor_begin is
	port(
			data_i : in bit64;
			key_i : in bit128;
			state_i : in type_state;
			en_xor_data_i : in std_logic;
			en_xor_key_i : in std_logic;
			state_o : out type_state
		);
end entity xor_begin;

architecture xor_begin_arch of xor_begin is

begin

	state_o(0) <=	data_i xor state_i(0) when en_xor_data_i = '1' else -- XOR avec la donnée data_i quand enabled
					state_i(0);
	state_o(1) <= key_i(127 downto 64) xor state_i(1) when en_xor_key_i = '1' else -- XOR avec les 64 bits de poids fort de key_i
					state_i(1);
	state_o(2) <= key_i(63 downto 0) xor state_i(2) when en_xor_key_i = '1' else -- XOR avec les 64 bits de poids faible de key_i
					state_i(2);
	state_o(3) <= state_i(3);
	state_o(4) <= state_i(4);
	
end architecture xor_begin_arch;
