-------------------------------------------------------------------------------
-- Title      : FSM intermediaire
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : fsm_moore.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Machine d'etats finis temporaire qui gere les etats de
--				 configuration et d'initialisation. Inutilise.
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

entity fsm_moore is
	port (
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
		init_cpt_block_o  				: out std_logic
	);	
end entity fsm_moore;

architecture fsm_moore_arch of fsm_moore is

	-- définition du type énuméré pour les états
	type state_t is (idle, conf_init, end_conf_init, init, end_init, idle_da);
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
				etat_futur <= idle_da;
		end case;
	end process comb0;
	
	-- processus combinatoire de contrôle des signaux
	comb1 : process (etat_present)
	begin
			
		cipher_valid_o	  <= '0'; 	-- initialisation pour éviter de mettre à 0 ou à 1 les 15 sorties pour chaque état
		end_o			  <= '0';
		data_sel_o		  <= '0'; 
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
				end_o			<= '0'; -- on ne change aucun signal à l'état idle
			when conf_init =>
				en_cpt_round_o	<= '1';
				init_a_o		<= '1';
			when end_conf_init =>
				en_reg_state_o	<= '1';
				en_cpt_round_o	<= '1';
			when init =>
				data_sel_o		<= '1';
				en_reg_state_o  <= '1';
				en_cpt_round_o	<= '1';
			when end_init =>
				data_sel_o		<= '1';
				en_xor_key_e_o	<= '1';
				en_reg_state_o	<= '1';
			when idle_da =>
				data_sel_o		<= '1';
		end case;
	end process comb1;
	
end architecture fsm_moore_arch;

