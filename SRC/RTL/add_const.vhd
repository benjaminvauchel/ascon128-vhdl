-------------------------------------------------------------------------------
-- Title      : ADD CONST OPERATION
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : add_const.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Addition de la constante de ronde  dans le chiffrement leger
-- 				 ASCON
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

entity add_const is
	port(
			round_i : in bit4;
			state_i : in type_state;
			state_o : out type_state
		);
end entity add_const;

architecture add_const_arch of add_const is

begin

	state_o(0) <= state_i(0);
	state_o(1) <= state_i(1);
	state_o(2) <= state_i(2) xor x"00000000000000"&round_constant(to_integer(unsigned(round_i))); -- conversion std_logic_vector vers unsigned vers integer -- bit stuffing à gauche
	state_o(3) <= state_i(3);
	state_o(4) <= state_i(4);

end architecture add_const_arch;
