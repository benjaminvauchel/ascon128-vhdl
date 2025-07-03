-------------------------------------------------------------------------------
-- Title      : Registre d'etat (obsolete)
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : reg.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Registre d'etat obsolete sans le signal write enable
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

entity reg is
	port(
		resetb_i : in std_logic;
		clock_i : in std_logic;
		d_i : in type_state;
		q_o : out type_state
		);
end entity reg;

architecture reg_arch of reg is

signal q_s : type_state;

begin
	-- processus obligatoire pour utiliser if then else
	seq_0 : process (clock_i, resetb_i) is -- liste de sensibilité : on entre dans le processus quand clock_i OU resetb_i change de valeur
	begin
		if resetb_i = '0' then
			q_s(0) <= x"0000000000000000";
			q_s(1) <= x"0000000000000000";
			q_s(2) <= x"0000000000000000";
			q_s(3) <= x"0000000000000000";
			q_s(4) <= x"0000000000000000"; -- ou q_s <= (OTHERS => (OTHERS => '0'));
		elsif clock_i'event and clock_i = '1' then -- détection front montant de l'horloge
			q_s <= d_i;
		else
			q_s <= q_s;
		end if;
	end process seq_0;

q_o <= q_s;

end architecture reg_arch;
