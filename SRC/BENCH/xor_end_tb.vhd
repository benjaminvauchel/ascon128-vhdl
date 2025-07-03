library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lib_rtl;
use LIB_RTL.ascon_pack.all;

-- entité vide
entity xor_end_tb is
end entity xor_end_tb;

architecture xor_end_tb_arch of xor_end_tb is
-- description structurelle
-- déclaration du composant à simuler

component xor_end
	port(
		key_i : in bit128;
		state_i : in type_state;
		en_xor_lsb_i : in std_logic;
		en_xor_key_i : in std_logic;
		state_o : out type_state
	);
end component xor_end;

signal key_s : bit128;
signal state_in_s : type_state;
signal en_xor_lsb_s : std_logic;
signal en_xor_key_s : std_logic;
signal state_out_s : type_state;

begin
-- description de l'architecture
-- instance du composant à simuler

DUT : xor_end port map (
	key_i => key_s,
	state_i => state_in_s,
	en_xor_lsb_i => en_xor_lsb_s,
	en_xor_key_i => en_xor_key_s,
	state_o => state_out_s
);
-- stimuli
state_in_s <= (OTHERS => (OTHERS => '1')); -- on met tous les bits à 1 (tableau de dimension 2)
key_s <= (OTHERS => '1'); -- idem (tableau de dimension 1)
en_xor_lsb_s <= '1', '0' after 10 ns;
en_xor_key_s <= '0', '1' after 20 ns;

end architecture xor_end_tb_arch;

configuration xor_end_tb_conf of xor_end_tb is

	for xor_end_tb_arch -- configuration de l'architecture
		for all : xor_end -- association d'un modele pour chaque instance de composant
			use entity lib_rtl.xor_end(xor_end_arch);
		end for; 
	end for;

end configuration xor_end_tb_conf;

