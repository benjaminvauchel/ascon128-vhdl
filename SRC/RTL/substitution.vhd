-------------------------------------------------------------------------------
-- Title      : Substitution
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : substitution.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Couche de substitution appliquant en parallele la substitution
--				 de 5 bits en colonne en utilisant la S-box.
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

entity substitution is
	port(
			state_i : in type_state;
			state_o : out type_state
		);
end entity substitution;

architecture substitution_arch of substitution is

	component sbox
		port (
			data_i : in bit5;
			data_o : out bit5);
	end component;

	signal state_trans_in_s, state_trans_out_s : trans_state;

begin

	-- On transpose l'état intermédiaire en colonnes
	Gen1 : for i in 0 to 63 generate
		state_trans_in_s(i) <= state_i(0)(i) & state_i(1)(i) & state_i(2)(i) & state_i(3)(i) & state_i(4)(i);
	end generate;

	-- On instancie 64 s-boxes pour les 64 colonnes
	Gen2 : for i in 0 to 63 generate
		sboxi : sbox port map (
			data_i => state_trans_in_s(i),
			data_o => state_trans_out_s(i)
		);
	end generate;

	-- On transpose à nouveau l'état intermédiaire en lignes (case par case)
	Gen3: for i in 0 to 4 generate
		Gen4: for j in 0 to 63 generate
			state_o(4-i)(j) <= state_trans_out_s(j)(i);
		end generate;
	end generate;

end architecture substitution_arch;

configuration substitution_conf of substitution is
	for substitution_arch
		for Gen2 -- On utilise l'architecture de l'entité sbox dans ce generate
			for all: sbox
				use entity LIB_RTL.sbox(sbox_arch);
			end for;
		end for;
	end for;
end substitution_conf;
