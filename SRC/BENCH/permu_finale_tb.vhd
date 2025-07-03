--library declaration
library ieee;
use ieee.std_logic_1164.all;
library lib_rtl;
use LIB_RTL.ascon_pack.all;

--empty entity
entity permu_finale_tb is
end permu_finale_tb;

architecture permu_finale_tb_arch of permu_finale_tb is

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
	end component;

	-- component ports
	signal state_i_s, state_o_s : type_state;
	signal sel_s, resetb_s : std_logic;
	signal clock_s : std_logic := '0';
	signal round_s : bit4;
	signal key_s : bit128;
	signal data_s : bit64;
	signal en_xor_key_b_s, en_xor_data_b_s, en_xor_lsb_e_s, en_xor_key_e_s : std_logic;
	signal en_reg_state_s, en_cipher_s, en_tag_s : std_logic;
	signal cipher_s : bit64;
	signal tag_s : bit128;
	
	begin -- permu_finale_tb_arch
	
		-- component instantation
		DUT : permu_finale
			port map (
				state_i			=> state_i_s,
				sel_i			=> sel_s,
				round_i			=> round_s,
				resetb_i		=> resetb_s,
				clock_i			=> clock_s,
				state_o			=> state_o_s,
				key_i			=> key_s,
				data_i			=> data_s,
				en_xor_key_b_i	=> en_xor_key_b_s,
				en_xor_data_b_i => en_xor_data_b_s,
				en_xor_lsb_e_i	=> en_xor_lsb_e_s,
				en_xor_key_e_i	=> en_xor_key_e_s,
				en_reg_state_i	=> en_reg_state_s,
				en_cipher_i		=> en_cipher_s,
				en_tag_i		=> en_tag_s,
				cipher_o		=> cipher_s,
				tag_o			=> tag_s
			);

		-- stimuli description with inertial delay
	clock_s 	 <= not clock_s after 10 ns;
	state_i_s(0) <= x"4484a574cc1220e9";
	state_i_s(1) <= x"b9d821ead71902ef";
	state_i_s(2) <= x"74491c2a9ada9011";
	state_i_s(3) <= x"c36df040c62a25a2";
	state_i_s(4) <= x"c77518af6e08589f";
	en_reg_state_s <= '1';
	key_s <= x"000102030405060708090A0B0C0D0E0F";
	data_s <= x"6167652056484480";
	
	stimuli : process
		begin
			-- init du registre
			resetb_s <= '0';
			sel_s <= '0';
			round_s <= x"0";
			en_cipher_s <= '0';
			en_tag_s <= '0';
			en_xor_key_e_s <= '0';
			en_xor_key_b_s <= '1';
			en_xor_lsb_e_s <= '0';
			en_xor_data_b_s <= '0';
			wait for 5 ns;
			resetb_s <= '1';
			-- entrée de la nouvelle donnée sur state_i_s
			--sel_s <= '0';
			--round_s <= x"0";
			wait for 20 ns;
			-- phase où s'incrémente le compteur
			sel_s <= '1';
			round_s <= x"1";
			en_xor_key_b_s <= '0';
			wait for 20 ns;
			round_s <= x"2";
			wait for 20 ns;
			round_s <= x"3";
			wait for 20 ns;
			round_s <= x"4";
			wait for 20 ns;
			round_s <= x"5";
			wait for 20 ns;
			round_s <= x"6";
			wait for 20 ns;
			round_s <= x"7";
			wait for 20 ns;
			round_s <= x"8";
			wait for 20 ns;
			round_s <= x"9";
			wait for 20 ns;
			round_s <= x"A";
			wait for 20 ns;
			round_s <= x"B";
			en_xor_key_e_s <= '1';
			en_tag_s <= '1';
			wait for 20 ns;
		end process;

end permu_finale_tb_arch;

configuration permu_finale_tb_conf of permu_finale_tb is
	for permu_finale_tb_arch
		for DUT : permu_finale
			use configuration lib_rtl.permu_finale_conf;
		end for;
	end for;
end permu_finale_tb_conf;
