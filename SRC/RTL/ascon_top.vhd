-------------------------------------------------------------------------------
-- Title      : ASCON TOP LEVEL
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : ascon_top.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Top level de l'algorithme leger ascon
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

entity ascon_top is
	port (
		clock_i			: in std_logic;
		resetb_i		: in std_logic;
		start_i			: in std_logic;
		data_valid_i	: in std_logic;
		data_i			: in bit64;
		key_i			: in bit128;
		nonce_i			: in bit128;
		cipher_valid_o	: out std_logic; -- ou data_valid_o
		end_o			: out std_logic;
		cipher_o		: out bit64;
		tag_o			: out bit128
	);
end entity ascon_top;

architecture ascon_top_arch of ascon_top is
-- description structurelle
-- déclaration des composants de ascon_top

component fsm_moore_finale
	port(
		clk_i, resetb_i, data_valid_i	: in std_logic;
		start_i							: in std_logic;
		round_i							: in bit4;
		block_i							: in bit2;
		cipher_valid_o					: out std_logic;
		end_o							: out std_logic;
		data_sel_o		 				: out std_logic;
		en_xor_key_b_o	 				: out std_logic;
		en_xor_data_b_o	 				: out std_logic;
		en_xor_lsb_e_o					: out std_logic;
		en_xor_key_e_o					: out std_logic;
		en_reg_state_o					: out std_logic;
		en_cipher_o						: out std_logic;
		en_tag_o						: out std_logic;
		en_cpt_round_o					: out std_logic;
		init_a_o						: out std_logic;
		init_b_o						: out std_logic;
		en_cpt_block_o	  				: out std_logic;
		init_cpt_block_o				: out std_logic
	);
end component fsm_moore_finale;

component compteur
  port (
	clock_i  : in  std_logic;
	resetb_i : in  std_logic;
	en_i     : in  std_logic;
	init_i	 : in  std_logic;
	cpt_o    : out bit2
	);
end component compteur;

component compteur_double_init
  port (
	clock_i  : in  std_logic;
	resetb_i : in  std_logic;
	en_i     : in  std_logic;
	init_a_i : in  std_logic;
	init_b_i : in  std_logic;
	cpt_o    : out bit4
	);
end component compteur_double_init;

component permu_finale
	port (
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
end component permu_finale;

-- signaux intermédiaires
signal round_s : bit4;
signal block_s : bit2;
signal data_sel_s, en_xor_key_b_s, en_xor_data_b_s, en_xor_lsb_e_s, en_xor_key_e_s, en_reg_state_s, en_cipher_s, en_tag_s, en_cpt_round_s, init_a_s, init_b_s, en_cpt_block_s, init_cpt_block_s : std_logic;
signal state_i_s, state_o_s : type_state;

begin -- description de l'architecture
-- instances des composants

-- initialisation état courant S
state_i_s(0) <= data_i;
state_i_s(1) <= key_i(127 downto 64);
state_i_s(2) <= key_i(63 downto 0);
state_i_s(3) <= nonce_i(127 downto 64);
state_i_s(4) <= nonce_i(63 downto 0);

fsm_moore_finale1 : fsm_moore_finale
	port map (
		resetb_i		=> resetb_i,
		clk_i 			=> clock_i,
		start_i 		=> start_i,
		data_valid_i	=> data_valid_i,
		round_i 		=> round_s,
		block_i 		=> block_s,

		end_o 			=> end_o,
	 
		data_sel_o		=> data_sel_s,
			
		cipher_valid_o 	=> cipher_valid_o,

		en_xor_key_b_o	=> en_xor_key_b_s,
		en_xor_data_b_o	=> en_xor_data_b_s,
		en_xor_lsb_e_o	=> en_xor_lsb_e_s,
		en_xor_key_e_o	=> en_xor_key_e_s,

		en_reg_state_o	=> en_reg_state_s,
		en_cipher_o		=> en_cipher_s,
		en_tag_o		=> en_tag_s,

		en_cpt_round_o	=> en_cpt_round_s,
		init_a_o		=> init_a_s,
		init_b_o		=> init_b_s,

		en_cpt_block_o		=> en_cpt_block_s,
		init_cpt_block_o	=> init_cpt_block_s
	);

compteur_block : compteur
	port map (
		clock_i	 => clock_i,
		resetb_i => resetb_i,
		en_i	 => en_cpt_block_s,
		init_i	 => init_cpt_block_s,
		cpt_o	 => block_s
	);

compteur_round : compteur_double_init
	port map (
		clock_i  => clock_i,
		resetb_i => resetb_i,
		en_i     => en_cpt_round_s,
		init_a_i => init_a_s,
		init_b_i => init_b_s,
		cpt_o    => round_s
	);

permu_finale1 : permu_finale
	port map (
		state_i			=> state_i_s,
		sel_i			=> data_sel_s,
		round_i			=> round_s,
		resetb_i		=> resetb_i,
		clock_i			=> clock_i,
		state_o			=> state_o_s,
		key_i			=> key_i,
		data_i			=> data_i,
		en_xor_key_b_i	=> en_xor_key_b_s,
		en_xor_data_b_i => en_xor_data_b_s,
		en_xor_lsb_e_i	=> en_xor_lsb_e_s,
		en_xor_key_e_i	=> en_xor_key_e_s,
		en_reg_state_i	=> en_reg_state_s,
		en_cipher_i		=> en_cipher_s,
		en_tag_i		=> en_tag_s,
		cipher_o		=> cipher_o,
		tag_o			=> tag_o
	);

end architecture ascon_top_arch;

configuration ascon_top_conf of ascon_top is

	for ascon_top_arch -- configuration de l'architecture
		for all : fsm_moore_finale -- association d'un modele pour chaque instance de composant
			use entity lib_rtl.fsm_moore_finale(fsm_moore_finale_arch);
		end for; 
		for all: compteur
			use entity LIB_RTL.compteur(compteur_arch);
		end for;
		for all: compteur_double_init
			use entity LIB_RTL.compteur_double_init(compteur_double_init_arch);
		end for;
		for all: permu_finale
			use entity LIB_RTL.permu_finale(permu_finale_arch);
		end for;
	end for;

end configuration ascon_top_conf;

