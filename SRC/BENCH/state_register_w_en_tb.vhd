library IEEE;
use IEEE.std_logic_1164.all;

library lib_rtl;
use LIB_RTL.ascon_pack.all;

entity state_register_w_en_tb is -- entité vide
end entity state_register_w_en_tb;

architecture state_register_w_en_tb_arch of state_register_w_en_tb is
-- description structurelle

component state_register_w_en
	port(
		resetb_i : in std_logic;
		clock_i  : in std_logic;
		en_i	 : in std_logic;
		data_i		 : in type_state;
		data_o		 : out type_state
	);
end component state_register_w_en;

signal resetb_s   : std_logic;
signal clock_s    : std_logic := '0';
signal en_s		  : std_logic;
signal data_in_s  : type_state;
signal data_out_s : type_state;

begin
-- description de l'architecture
-- instance du composant à simuler

DUT : state_register_w_en port map (
	resetb_i => resetb_s,
	clock_i  => clock_s,
	en_i	 => en_s,
	data_i		 => data_in_s,
	data_o		 => data_out_s
);

-- stimuli

data_in_s(0) <= IV_c;
data_in_s(1) <= x"0001020304050607"; -- poids faible K
data_in_s(2) <= x"08090A0B0C0D0E0F"; -- poids fort K
data_in_s(3) <= x"0001020304050607"; -- poids faible N
data_in_s(4) <= x"08090A0B0C0D0E0F"; -- poids fort N
clock_s <= not clock_s after 10 ns; -- Horloge à 50 MHz
en_s <= '0', '1' after 25 ns, '0' after 35 ns;
resetb_s <= '0', '1' after 15 ns, '0' after 45 ns;

end architecture state_register_w_en_tb_arch;

configuration state_register_w_en_tb_conf of state_register_w_en_tb is

	for state_register_w_en_tb_arch -- configuration de l'architecture
		for all : state_register_w_en
			use entity lib_rtl.state_register_w_en(state_register_w_en_arch);
		end for; 
	end for;

end configuration state_register_w_en_tb_conf;

