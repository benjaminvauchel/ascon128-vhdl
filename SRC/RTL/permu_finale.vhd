-------------------------------------------------------------------------------
-- Title      : Permutation finale
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : permu_finale.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Permutation & XOR avec le registre pour le TAG et le registre
--				 pour les blocs chiffres.
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

entity permu_finale is
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
			en_reg_state_i	: in std_logic;
			en_cipher_i		: in std_logic;
			en_tag_i		: in std_logic;
			state_o			: out type_state;
			cipher_o		: out bit64;
			tag_o			: out bit128
		);
end entity permu_finale;

architecture permu_finale_arch of permu_finale is

-- déclaration des composants de la permutation finale
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
		data_i		  : in  bit64;
		key_i		  : in  bit128;
		state_i		  : in  type_state;
		en_xor_data_i : in  std_logic;
		en_xor_key_i  : in  std_logic;
		state_o		  : out type_state
	);
end component xor_begin;

component register_w_en
	generic (
    	nb_bits_g : natural);
  	port (
		clock_i  : in  std_logic;
		resetb_i : in  std_logic;
		en_i     : in  std_logic;
		data_i   : in  std_logic_vector(nb_bits_g-1 downto 0);
		data_o   : out std_logic_vector(nb_bits_g-1 downto 0)
    );
end component register_w_en;

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
		key_i		 : in  bit128;
		state_i		 : in  type_state;
		en_xor_lsb_i : in  std_logic;
		en_xor_key_i : in  std_logic;
		state_o		 : out type_state
	);
end component xor_end;

component state_register_w_en
	port(
		clock_i  : in  std_logic;
		resetb_i : in  std_logic;
		en_i     : in  std_logic;
		data_i   : in  type_state;
		data_o   : out type_state
	);
end component state_register_w_en;

-- déclaration des signaux intermédiaires
signal mux_xor_b_s, xor_b_add_s, add_sub_s, sub_dif_s, dif_xor_e_s, xor_e_reg_s, state_out_s : type_state;
signal xor_e_reg_s_34 : bit128;

begin

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
	
	reg_cipher : register_w_en
	generic map (		  -- generic map permet d'associer une valeur à la variable générique
		nb_bits_g => 64)
	port map (
		clock_i		=> clock_i,
		resetb_i	=> resetb_i,
		en_i		=> en_cipher_i,
		data_i		=> xor_b_add_s(0), -- registre 0 de l'état courant
		data_o		=> cipher_o
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
	
	reg_tag : register_w_en
		generic map (
			nb_bits_g => 128)
		port map (
			clock_i		=> clock_i,
			resetb_i	=> resetb_i,
			en_i		=> en_tag_i,
			data_i		=> xor_e_reg_s_34,
			data_o		=> tag_o
	);
		
	state_reg : state_register_w_en port map (
		resetb_i => resetb_i,
		clock_i  => clock_i,
		en_i	 => en_reg_state_i,
		data_i   => xor_e_reg_s,
		data_o   => state_out_s
	);
	
	xor_e_reg_s_34 <= xor_e_reg_s(3) & xor_e_reg_s(4); -- on concatène les registres 3 et 4 de l'état courant pour avoir les 128 bits en entrée du registre générique
	

end architecture permu_finale_arch;

configuration permu_finale_conf of permu_finale is
	for permu_finale_arch
		for all: mux
			use entity LIB_RTL.mux(mux_arch);
		end for;
		for all: xor_begin
			use entity LIB_RTL.xor_begin(xor_begin_arch);
		end for;
		for reg_cipher: register_w_en
			use entity LIB_RTL.register_w_en(register_w_en_arch)
			generic map (			-- nécessaire
				nb_bits_g => 64);
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
		for reg_tag: register_w_en
			use entity LIB_RTL.register_w_en(register_w_en_arch)
			generic map (
				nb_bits_g => 128);
		end for;
		for all: state_register_w_en
			use entity LIB_RTL.state_register_w_en(state_register_w_en_arch);
		end for;
	end for;
end permu_finale_conf;
