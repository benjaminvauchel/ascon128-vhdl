--library declaration
library ieee;
use ieee.std_logic_1164.all;
library lib_rtl;
use LIB_RTL.ascon_pack.all;

-- empty entity
entity compteur_double_init_tb is
end compteur_double_init_tb;

architecture compteur_double_init_tb_arch of compteur_double_init_tb is

	component compteur_double_init
		port (
			clock_i  : in  std_logic;
			resetb_i : in  std_logic;
			en_i     : in  std_logic;
			init_a_i : in  std_logic;
			init_b_i : in  std_logic;
			cpt_o    : out bit4
		);
	end component;

	-- component ports
	signal clock_s : std_logic := '0';
	signal resetb_s, en_s, init_a_s, init_b_s : std_logic;
	signal cpt_s : bit4;
	
	begin
	
		-- component instantation
		DUT : compteur_double_init
			port map (
				clock_i  => clock_s,
				resetb_i => resetb_s,
				en_i	 => en_s,
				init_a_i => init_a_s,
				init_b_i => init_b_s,
				cpt_o	 => cpt_s
			);

	clock_s 	<= not clock_s after 10 ns; -- Horloge à 50 MHz
	resetb_s	<= '0', '1' after 5 ns;
	en_s		<= '0', '1' after 15 ns, '0' after 45 ns, '1' after 65 ns;
	init_a_s	<= '0', '1' after 15 ns, '0' after 25 ns;
	init_b_s	<= '0', '1' after 45 ns, '0' after 75 ns;

end compteur_double_init_tb_arch;

configuration compteur_double_init_tb_conf of compteur_double_init_tb is
	for compteur_double_init_tb_arch
		for DUT : compteur_double_init
			use entity lib_rtl.compteur_double_init(compteur_double_init_arch);
		end for;
	end for;
end compteur_double_init_tb_conf;