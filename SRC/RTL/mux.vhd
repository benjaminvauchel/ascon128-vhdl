-------------------------------------------------------------------------------
-- Title      : Multiplexeur
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : mux.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Multiplexeur 2 vers 1
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

entity mux is
	port(
			a_i   : in type_state;
			b_i   : in type_state;
			sel_i : in std_logic;
			s_o   : out type_state
		);
end entity mux;

architecture mux_arch of mux is

begin

	s_o <=	a_i when sel_i = '1' else
			b_i;

end architecture mux_arch;
