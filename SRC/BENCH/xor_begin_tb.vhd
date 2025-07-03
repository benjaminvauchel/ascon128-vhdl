library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lib_rtl;
use LIB_RTL.ascon_pack.all;

entity xor_begin_tb is -- entité vide
end entity xor_begin_tb;

architecture xor_begin_tb_arch of xor_begin_tb is
-- description structurelle

-- déclaration du composant à simuler
component xor_begin
	port(
		data_i : in bit64;
		key_i : in bit128;
		state_i : in type_state;
		en_xor_data_i : in std_logic;
		en_xor_key_i : in std_logic;
		state_o : out type_state
	);
end component xor_begin;

signal data_in_s : bit64;
signal key_s : bit128;
signal state_in_s : type_state;
signal en_xor_data_s : std_logic;
signal en_xor_key_s : std_logic;
signal state_out_s : type_state;

begin -- description de l'architecture
-- instance du composant à simuler

DUT : xor_begin port map (
	data_i => data_in_s,
	key_i => key_s,
	state_i => state_in_s,
	en_xor_data_i => en_xor_data_s,
	en_xor_key_i => en_xor_key_s,
	state_o => state_out_s
);
-- stimuli
state_in_s <= (OTHERS => (OTHERS => '1')); -- on met tous les bits à 1
data_in_s <= (OTHERS => '1'); -- idem
key_s <= (OTHERS => '1'); -- idem
en_xor_data_s <= '1', '0' after 10 ns;
en_xor_key_s <= '0', '1' after 20 ns;

end architecture xor_begin_tb_arch;

configuration xor_begin_tb_conf of xor_begin_tb is

	for xor_begin_tb_arch -- configuration de l'architecture
		for all : xor_begin
			use entity lib_rtl.xor_begin(xor_begin_arch);
		end for; 
	end for;

end configuration xor_begin_tb_conf;

