--library declaration
library ieee;
use ieee.std_logic_1164.all;
library lib_rtl;
use LIB_RTL.ascon_pack.all;

--empty entity
entity substitution_tb is
end substitution_tb;

architecture substitution_tb_arch of substitution_tb is

	component substitution
		port (
			state_i : in type_state;
			state_o : out type_state
		);
	end component;

	-- component ports
	signal state_i_s, state_o_s : type_state;
	
	begin -- adder_tb_arch
	
		-- component instantation
		DUT : substitution
			port map (
				state_i => state_i_s,
				state_o => state_o_s
			);

		-- stimuli description with inertial delay

	state_i_s(0) <= x"80400c0600000000";
	state_i_s(1) <= x"0001020304050607"; -- poids faible K
	state_i_s(2) <= x"08090a0b0c0d0eff"; -- poids fort K
	state_i_s(3) <= x"0001020304050607"; -- poids faible N
	state_i_s(4) <= x"08090a0b0c0d0e0f"; -- poids fort N

end substitution_tb_arch;

configuration substitution_tb_conf of substitution_tb is
	for substitution_tb_arch
		for DUT : substitution
			use configuration lib_rtl.substitution_conf;
		end for;
	end for;
end substitution_tb_conf;
