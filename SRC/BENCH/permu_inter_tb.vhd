library ieee;
use ieee.std_logic_1164.all;
library lib_rtl;
use LIB_RTL.ascon_pack.all;

-- entité vide
entity permu_inter_tb is
end permu_inter_tb;

architecture permu_inter_tb_arch of permu_inter_tb is

	component permu_inter
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
			state_o			: out type_state
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
	
	begin -- permu_inter_tb_arch
	
		-- component instantation
		DUT : permu_inter
			port map (
				state_i => state_i_s,
				sel_i => sel_s,
				round_i => round_s,
				resetb_i => resetb_s,
				clock_i => clock_s,
				state_o => state_o_s,
				key_i => key_s,
				data_i => data_s,
				en_xor_key_b_i => en_xor_key_b_s,
				en_xor_data_b_i => en_xor_data_b_s,
				en_xor_lsb_e_i => en_xor_lsb_e_s,
				en_xor_key_e_i => en_xor_key_e_s
			);

		-- stimuli description with inertial delay
	clock_s 	 <= not clock_s after 10 ns; -- Horloge à 50 MHz
	state_i_s(0) <= x"80400c0600000000"; -- IV_c
	state_i_s(1) <= x"0001020304050607"; -- poids faible K
	state_i_s(2) <= x"08090a0b0c0d0e0f"; -- poids fort K
	state_i_s(3) <= x"0001020304050607"; -- poids faible N
	state_i_s(4) <= x"08090a0b0c0d0e0f"; -- poids fort N
	key_s <= x"000102030405060708090A0B0C0D0E0F";
	data_s <= x"3230303280000000";

	stimuli : process -- processus qui permet de simuler pas à pas avec des wait for
		begin
			-- init du registre
			resetb_s		<= '0';
			sel_s			<= '0';
			round_s			<= x"0";
			en_xor_key_e_s	<= '0';
			en_xor_key_b_s	<= '0';
			en_xor_lsb_e_s	<= '0';
			en_xor_data_b_s	<= '0';
			wait for 5 ns;
			resetb_s <= '1';
			wait for 20 ns;
			-- phase où s'incrémente le compteur
			sel_s <= '1'; -- on sélectionne state_o
			round_s <= x"1";
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
			en_xor_key_e_s <= '1'; -- XOR de fin de permutation
			wait for 20 ns;
		end process;

end permu_inter_tb_arch;

configuration permu_inter_tb_conf of permu_inter_tb is
	for permu_inter_tb_arch
		for DUT : permu_inter
			use configuration lib_rtl.permu_inter_conf;
		end for;
	end for;
end permu_inter_tb_conf;
