-------------------------------------------------------------------------------
-- Title      : Permutation de base
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : permu_base.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Fonction de permutation de base dans l'algorithme leger ascon.
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

entity permu_base is
	port(
			state_i  : in type_state;
			sel_i 	 : in std_logic;
			round_i  : in bit4;
			resetb_i : in std_logic;
			clock_i  : in std_logic;
			state_o	 : out type_state
		);
end entity permu_base;

architecture permu_base_arch of permu_base is

-- déclaration de tous les composants de la permutation de base

component mux
	port(
		a_i   : in type_state;
		b_i   : in type_state;
		sel_i : in std_logic;
		s_o   : out type_state
	);
end component mux;

component add_const
	port(
		round_i : in bit4;
		state_i : in type_state;
		state_o : out type_state
	);
end component add_const;

component substitution
	port (
		state_i : in type_state;
		state_o : out type_state
	);
end component;

component diffusion
	port(
		state_i : in type_state;
		state_o : out type_state
	);
end component diffusion;

component reg
	port(
		resetb_i : in std_logic;
		clock_i : in std_logic;
		d_i : in type_state;
		q_o : out type_state
	);
end component reg;


signal state_out_s : type_state;
signal mux_add_s, add_sub_s, sub_dif_s, dif_reg_s : type_state;

begin -- instanciation des composants
-- port map permet de relier les signaux/entrées/sorties

	state_o <= state_out_s;

	mux1 : mux port map (
		a_i => state_out_s,
		b_i => state_i,
		sel_i => sel_i,
		s_o => mux_add_s
	);
	add_const1 : add_const port map (
		round_i => round_i,
		state_i => mux_add_s,
		state_o => add_sub_s
	);
	substitution1 : substitution port map (
		state_i => add_sub_s,
		state_o => sub_dif_s
	);
	diffusion1 : diffusion port map (
		state_i => sub_dif_s,
		state_o => dif_reg_s
	);
	reg1 : reg port map (
		resetb_i => resetb_i,
		clock_i  => clock_i,
		d_i      => dif_reg_s,
		q_o      => state_out_s
	);


end architecture permu_base_arch;

configuration permu_base_conf of permu_base is -- association d'un modèle pour chaque instance de composant
	for permu_base_arch
		for all: add_const
			use entity LIB_RTL.add_const(add_const_arch);
		end for;
		for all: mux
			use entity LIB_RTL.mux(mux_arch);
		end for;
		for all: substitution
			use entity LIB_RTL.substitution(substitution_arch);
		end for;
		for all: diffusion
			use entity LIB_RTL.diffusion(diffusion_arch);
		end for;
		for all: reg
			use entity LIB_RTL.reg(reg_arch);
		end for;
	end for;
end permu_base_conf;
