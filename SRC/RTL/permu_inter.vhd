-------------------------------------------------------------------------------
-- Title      : Permutation intermediaire
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : permu_inter.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Bloc de permutation integrant les operateurs XOR.
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

entity permu_inter is
	port(
			state_i 		: in type_state;
			sel_i 			: in std_logic;
			round_i 		: in bit4;
			resetb_i		: in std_logic;
			clock_i 		: in std_logic;
			key_i			: in bit128;
			data_i			: in bit64;
			en_xor_key_b_i	: in std_logic;
			en_xor_data_b_i : in std_logic;
			en_xor_lsb_e_i	: in std_logic;
			en_xor_key_e_i 	: in std_logic;
			state_o			: out type_state
		);
end entity permu_inter;

architecture permu_inter_arch of permu_inter is

-- déclaration des composants
component mux
	port(
		a_i   : in type_state;
		b_i   : in type_state;
		sel_i : in std_logic;
		s_o   : out type_state
	);
end component mux;

component xor_begin
	port (
		data_i : in bit64;
		key_i : in bit128;
		state_i : in type_state;
		en_xor_data_i : in std_logic;
		en_xor_key_i : in std_logic;
		state_o : out type_state
	);
end component xor_begin;

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

component xor_end
	port (
		key_i : in bit128;
		state_i : in type_state;
		en_xor_lsb_i : in std_logic;
		en_xor_key_i : in std_logic;
		state_o : out type_state
	);
end component xor_end;

component reg
	port(
		resetb_i : in std_logic;
		clock_i : in std_logic;
		d_i : in type_state;
		q_o : out type_state
	);
end component reg;

signal mux_xor_b_s, xor_b_add_s, add_sub_s, sub_dif_s, dif_xor_e_s, xor_e_reg_s, state_out_s : type_state;

begin
-- instanciation des composants

	state_o <= state_out_s;

	mux1 : mux port map (
		a_i		=> state_out_s,
		b_i		=> state_i,
		sel_i	=> sel_i,
		s_o		=> mux_xor_b_s
	);
	xor_begin1 : xor_begin port map (
		data_i			=> data_i,
		key_i			=> key_i,
		state_i			=> mux_xor_b_s,
		en_xor_data_i	=> en_xor_data_b_i,
		en_xor_key_i	=> en_xor_key_b_i,
		state_o			=> xor_b_add_s
	);
	add_const1 : add_const port map (
		round_i => round_i,
		state_i => xor_b_add_s,
		state_o => add_sub_s
	);
	substitution1 : substitution port map (
		state_i => add_sub_s,
		state_o => sub_dif_s
	);
	diffusion1 : diffusion port map (
		state_i => sub_dif_s,
		state_o => dif_xor_e_s
	);
	xor_end1 : xor_end port map (
		key_i			=> key_i,
		state_i			=> dif_xor_e_s,
		en_xor_lsb_i	=> en_xor_lsb_e_i,
		en_xor_key_i 	=> en_xor_key_e_i,
		state_o			=> xor_e_reg_s
	);
	reg1 : reg port map (
		resetb_i => resetb_i,
		clock_i  => clock_i,
		d_i      => xor_e_reg_s,
		q_o      => state_out_s
	);
	


end architecture permu_inter_arch;

configuration permu_inter_conf of permu_inter is -- association d'un modèle pour chaque instance de composant
	for permu_inter_arch
		for all: mux
			use entity LIB_RTL.mux(mux_arch);
		end for;
		for all: xor_begin
			use entity LIB_RTL.xor_begin(xor_begin_arch);
		end for;
		for all: add_const
			use entity LIB_RTL.add_const(add_const_arch);
		end for;
		for all: substitution
			use entity LIB_RTL.substitution(substitution_arch);
		end for;
		for all: diffusion
			use entity LIB_RTL.diffusion(diffusion_arch);
		end for;
		for all: xor_end
			use entity LIB_RTL.xor_end(xor_end_arch);
		end for;
		for all: reg
			use entity LIB_RTL.reg(reg_arch);
		end for;
	end for;
end permu_inter_conf;
