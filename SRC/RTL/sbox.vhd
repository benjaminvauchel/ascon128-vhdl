-------------------------------------------------------------------------------
-- Title      : S-Box
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : sbox.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Table de substitution S-box
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

entity sbox is
	port(
			data_i : in bit5;
			data_o : out bit5
		);
end entity sbox;

architecture sbox_arch of sbox is

begin

	data_o <= table_substitution(to_integer(unsigned(data_i)))(4 downto 0); -- conversion std_logic_vector vers unsigned vers integer et sélection des 5 bits de poids faible

end architecture sbox_arch;
