library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lib_rtl;
use LIB_RTL.ascon_pack.all;

entity sbox_tb is-- entite vide
end entity sbox_tb;

architecture sbox_tb_arch of sbox_tb is
-- description structurelle
-- déclaration du composant à simuler

component sbox
	port(
		data_i : in bit5;
		data_o : out bit5
	);
end component sbox;

signal data_i_s : bit5;
signal data_o_s : bit5;

begin
-- description de l'architecture
-- instance du composant à simuler

DUT : sbox port map ( -- mapping
	data_i => data_i_s,
	data_o => data_o_s
);

-- stimulus
data_i_s <= 5x"08", 5x"1D" after 10 ns; -- compiler avec le flag -2008

end architecture sbox_tb_arch;

configuration sbox_tb_conf of sbox_tb is

	for sbox_tb_arch -- configuration de l'architecture
		for all : sbox -- association d'un modele pour chaque instance de composant
			use entity lib_rtl.sbox(sbox_arch);
		end for; 
	end for;

end configuration sbox_tb_conf;

