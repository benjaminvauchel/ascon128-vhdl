-------------------------------------------------------------------------------
-- Title      : FSM
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : fsm_moore_finale.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Machine d'etats finis pilotant les signaux de controle de
--				 l'architecture d'ascon
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

entity fsm_moore_finale is
	port (
		clk_i, resetb_i, data_valid_i	: in std_logic;
		start_i							: in std_logic;
		round_i							: in bit4;
		block_i							: in bit2;
		cipher_valid_o					: out std_logic; -- sortie primaire
		end_o							: out std_logic; -- sortie primaire
		data_sel_o		 				: out std_logic; -- sortie permutation
		en_xor_key_b_o	 				: out std_logic; -- sortie permutation
		en_xor_data_b_o	 				: out std_logic; -- sortie permutation
		en_xor_lsb_e_o					: out std_logic; -- sortie permutation
		en_xor_key_e_o					: out std_logic; -- sortie permutation
		en_reg_state_o					: out std_logic; -- sortie permutation
		en_cipher_o						: out std_logic; -- sortie permutation
		en_tag_o						: out std_logic; -- sortie permutation
		en_cpt_round_o					: out std_logic; -- sortie compteur rondes
		init_a_o						: out std_logic; -- sortie compteur rondes
		init_b_o						: out std_logic; -- sortie compteur rondes
		en_cpt_block_o	  				: out std_logic; -- sortie compteur blocs
		init_cpt_block_o  				: out std_logic -- sortie compteur blocs
	);	
end entity fsm_moore_finale;

architecture fsm_moore_finale_arch of fsm_moore_finale is

	-- définition du type énuméré pour les états
	type state_t is (idle, conf_init, end_conf_init, init, end_init, idle_da, conf_da, da, end_da, idle_crypt, conf_crypt, crypt, end_crypt, idle_final, conf_final, final, end_final, end_ascon);
	-- définition des signaux
	signal etat_present, etat_futur : state_t;

begin

	-- processus séquentiel pour la modélisation du registre d'états
	seq_0 : process (clk_i, resetb_i)
	begin -- process seq_0
		if resetb_i = '0' then
			etat_present <= idle;
		elsif clk_i'event and clk_i = '1' then
			etat_present <= etat_futur;
		end if;
	end process seq_0;
	
	-- modélisation des transitions
	comb0 : process (etat_present, start_i, data_valid_i, round_i, block_i)
	begin
		case etat_present is
			when idle =>
				if start_i = '1' then
					etat_futur <= conf_init;
				else
					etat_futur <= idle; -- ne pas mettre etat_present mais bien idle
				end if;
			when conf_init =>
				etat_futur <= end_conf_init;
			when end_conf_init =>
				etat_futur <= init;
			when init =>
				if round_i = x"A" then
					etat_futur <= end_init;
				else
					etat_futur <= init;
				end if;
			when end_init =>
				etat_futur <= idle_da;
			when idle_da =>
				if data_valid_i = '0' then
					etat_futur <= idle_da;
				else
					etat_futur <= conf_da;
				end if;
			when conf_da =>
				etat_futur <= da;
			when da =>
				if round_i = x"A" then
					etat_futur <= end_da;
				else
					etat_futur <= da;
				end if;
			when end_da =>
				etat_futur <= idle_crypt;
			when idle_crypt =>
				if data_valid_i = '0' then
					etat_futur <= idle_crypt;
				else
					etat_futur <= conf_crypt;
				end if;
			when conf_crypt =>
				etat_futur <= crypt;
			when crypt =>
				if round_i = x"A" then
					etat_futur <= end_crypt;
				else
					etat_futur <= crypt;
				end if;
			when end_crypt =>
				if block_i = "11" then
					etat_futur <= idle_final;
				else
					etat_futur <= idle_crypt;
				end if;
			when idle_final =>
				if data_valid_i = '0' then
					etat_futur <= idle_final;
				else
					etat_futur <= conf_final;
				end if;
			when conf_final =>
				etat_futur <= final;
			when final =>
				if round_i = x"A" then
					etat_futur <= end_final;
				else
					etat_futur <= final;
				end if;
			when end_final =>
				etat_futur <= end_ascon;
			when end_ascon =>
				etat_futur <= end_ascon;
		end case;
	end process comb0;
	
	-- processus combinatoire de contrôle des signaux
	comb1 : process (etat_present)
	begin
			
		cipher_valid_o	  <= '0';  	-- initialisation pour éviter de mettre à 0 ou à 1 les 15 sorties pour chaque état
		end_o			  <= '0';
		data_sel_o		  <= '1'; 
		en_xor_key_b_o	  <= '0';
		en_xor_data_b_o	  <= '0';
		en_xor_lsb_e_o	  <= '0';
		en_xor_key_e_o	  <= '0';
		en_reg_state_o	  <= '0';
		en_cipher_o		  <= '0';
		en_tag_o		  <= '0';
		en_cpt_round_o	  <= '0';
		init_a_o		  <= '0';
		init_b_o		  <= '0';
		en_cpt_block_o	  <= '0';
		init_cpt_block_o  <= '0';

		case etat_present is
			when idle =>
				data_sel_o		<= '0';
			when conf_init =>
				data_sel_o		<= '0';
				en_cpt_round_o	<= '1';
				init_a_o		<= '1';
			when end_conf_init =>
				data_sel_o		<= '0';
				en_reg_state_o	<= '1';
				en_cpt_round_o	<= '1';
			when init =>
				en_reg_state_o  <= '1';
				en_cpt_round_o	<= '1';
			when end_init =>
				en_xor_key_e_o	<= '1';
				en_reg_state_o	<= '1';
			when idle_da =>
				en_cpt_round_o	<= '1';
				init_b_o		<= '1';
			when conf_da =>
				en_reg_state_o	<= '1';
				en_xor_data_b_o <= '1';
				en_cpt_round_o	<= '1';
			when da =>
				en_reg_state_o	<= '1';
				en_cpt_round_o	<= '1';
			when end_da =>
				en_reg_state_o	 <= '1';
				en_xor_lsb_e_o	 <= '1';
				en_cpt_block_o	 <= '1';
				init_cpt_block_o <= '1';
			when idle_crypt =>
				en_cpt_round_o  <= '1'; -- on initialise le cpt round pour le premier bloc C1
				init_b_o	    <= '1';
			when conf_crypt =>
				en_xor_data_b_o <= '1';
				en_reg_state_o  <= '1';
				en_cpt_block_o	<= '1';
				en_cpt_round_o	<= '1';
				en_cipher_o		<= '1';
				cipher_valid_o  <= '1';
			when crypt =>
				en_reg_state_o	<= '1';
				en_cpt_round_o	<= '1';
			when end_crypt =>
				en_reg_state_o	<= '1';
			when idle_final =>
				en_cpt_round_o  <= '1';
				init_a_o	    <= '1';
			when conf_final =>
				en_xor_data_b_o <= '1';
				en_xor_key_b_o	<= '1';
				en_reg_state_o	<= '1';
				en_cpt_round_o	<= '1';
				en_cipher_o		<= '1';
			when final =>
				en_reg_state_o	<= '1';
				en_cpt_round_o	<= '1';
			when end_final =>
				en_xor_key_e_o	<= '1';
				en_reg_state_o	<= '1';
				en_tag_o		<= '1';
			when end_ascon =>
				end_o			<= '1';
		end case;
	end process comb1;
	
end architecture fsm_moore_finale_arch;

