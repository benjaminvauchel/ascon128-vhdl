--library declaration
library ieee;
use ieee.std_logic_1164.all;
library lib_rtl;
use LIB_RTL.ascon_pack.all;

-- empty entity
entity permu_base_tb is
end permu_base_tb;

architecture permu_base_tb_arch of permu_base_tb is

	component permu_base
		port (
			state_i  : in type_state;
			sel_i 	 : in std_logic;
			round_i  : in bit4;
			resetb_i : in std_logic;
			clock_i  : in std_logic;
			state_o  : out type_state
		);
	end component;

	-- component ports
	signal state_i_s, state_o_s : type_state;
	signal sel_s, resetb_s : std_logic;
	signal clock_s : std_logic := '0';
	signal round_s : bit4;
	
	begin -- permu_base_tb_arch
	
		-- component instantation
		DUT : permu_base
			port map (
				state_i => state_i_s,
				sel_i => sel_s,
				round_i => round_s,
				resetb_i => resetb_s,
				clock_i => clock_s,
				state_o => state_o_s
			);

	-- stimuli description with inertial delay
	clock_s 	 <= not clock_s after 10 ns; -- 50 MHz clock
	state_i_s(0) <= x"80400c0600000000";
	state_i_s(1) <= x"0001020304050607"; -- poids faible K
	state_i_s(2) <= x"08090a0b0c0d0e0f"; -- poids fort K
	state_i_s(3) <= x"0001020304050607"; -- poids faible N
	state_i_s(4) <= x"08090a0b0c0d0e0f"; -- poids fort N
	
	stimuli : process
		begin
			-- init du registre
			resetb_s <= '0';
			sel_s <= '0';
			round_s <= x"0";
			wait for 155 ns;
			resetb_s <= '1';
			-- entrée de la nouvelle donnée sur state_i_s
			-- sel_s <= '0';
			-- round_s <= x"0";
			wait for 20 ns;
			-- phase où s'incrémente le compteur
			sel_s <= '1';
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
			wait for 20 ns;
		end process;

end permu_base_tb_arch;

configuration permu_base_tb_conf of permu_base_tb is
	for permu_base_tb_arch
		for DUT : permu_base
			use configuration lib_rtl.permu_base_conf;
		end for;
	end for;
end permu_base_tb_conf;
