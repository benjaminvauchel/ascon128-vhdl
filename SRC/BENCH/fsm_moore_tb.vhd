library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use LIB_RTL.ascon_pack.all;

--empty entity
entity fsm_moore_tb is
end fsm_moore_tb;

architecture fsm_moore_tb_arch of fsm_moore_tb is
--description structurelle
-- déclaration du composant à simuler

component fsm_moore
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
		init_cpt_block_o  				: out std_logic
	);
end component fsm_moore;

	signal clk_s : std_logic := '0';
	signal resetb_s, data_valid_s, start_s	: std_logic;
	signal round_s : bit4;
	signal block_s : bit2;
	signal data_valid_in_s, cipher_valid_out_s, end_s, data_sel_s, en_xor_key_b_s, en_xor_data_b_s, en_xor_lsb_e_s, en_xor_key_e_s, en_reg_state_s, en_cipher_s, en_tag_s, en_cpt_round_s, init_a_s, init_b_s, en_cpt_block_s, init_cpt_block_s : std_logic;


begin -- description de l'architecture
-- instance du composant à simuler

DUT : fsm_moore port map (
	resetb_i		=> resetb_s,
	clk_i 			=> clk_s,
	start_i 		=> start_s,
	data_valid_i	=> data_valid_in_s,
	round_i 		=> round_s,
	block_i 		=> block_s,

	end_o 			=> end_s,
 
	data_sel_o		=> data_sel_s,
		
	cipher_valid_o 	=> cipher_valid_out_s,

	en_xor_key_b_o	=> en_xor_key_b_s,
	en_xor_data_b_o	=> en_xor_data_b_s,
	en_xor_lsb_e_o	=> en_xor_lsb_e_s,
	en_xor_key_e_o	=> en_xor_key_e_s,

	en_reg_state_o	=> en_reg_state_s,
	en_cipher_o		=> en_cipher_s,
	en_tag_o		=> en_tag_s,

	en_cpt_round_o	=> en_cpt_round_s,
	init_a_o		=> init_a_s,
	init_b_o		=> init_b_s

);

-- stimuli
clk_s <= not clk_s after 10 ns;
resetb_s <= '0', '1' after 5 ns;
start_s <= '0', '1' after 15 ns;
data_valid_in_s <= '0';
round_s <= x"0", x"1" after 70 ns, x"2" after 90 ns, x"3" after 110 ns, x"4" after 130 ns, x"5" after 150 ns, x"6" after 170 ns, x"7" after 190 ns, x"8" after 210 ns, x"9" after 230 ns, x"A" after 250 ns, x"B" after 270 ns;
block_s <= "00";

end architecture fsm_moore_tb_arch;

configuration fsm_moore_tb_conf of fsm_moore_tb is

	for fsm_moore_tb_arch -- configuration de l'architecture
		for all : fsm_moore -- association d'un modele pour chaque instance de composant
			use entity lib_rtl.fsm_moore(fsm_moore_arch);
		end for; 
	end for;

end configuration fsm_moore_tb_conf;

