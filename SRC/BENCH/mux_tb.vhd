library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lib_rtl;
use LIB_RTL.ascon_pack.all;

entity mux_tb is-- entite vide
end entity mux_tb;

architecture mux_tb_arch of mux_tb is
-- description structurelle
-- déclaration du composant à simuler

component mux
	port(
		a_i   : in type_state;
		b_i   : in type_state;
		sel_i : in std_logic;
		s_o   : out type_state
	);
end component mux;

signal a_s : type_state;
signal b_s : type_state;
signal sel_s : std_logic;
signal s_s : type_state;

begin
-- description de l'architecture
-- instance du composant à simuler

DUT : mux port map (
	a_i => a_s,
	b_i => b_s,
	sel_i => sel_s,
	s_o => s_s
);

-- stimuli
-- valeurs aléatoires pour tester la sélection

a_s(0) <= x"AAAAAAAAAAAAAAAA";
a_s(1) <= x"AAAAAAAAAAAAAAAA";
a_s(2) <= x"AAAAAAAAAAAAAAAA";
a_s(3) <= x"AAAAAAAAAAAAAAAA";
a_s(4) <= x"AAAAAAAAAAAAAAAA";

b_s(0) <= x"BBBBBBBBBBBBBBBB";
b_s(1) <= x"BBBBBBBBBBBBBBBB";
b_s(2) <= x"BBBBBBBBBBBBBBBB";
b_s(3) <= x"BBBBBBBBBBBBBBBB";
b_s(4) <= x"BBBBBBBBBBBBBBBB";

sel_s <= '1', '0' after 20 ns;

end architecture mux_tb_arch;

configuration mux_tb_conf of mux_tb is

	for mux_tb_arch -- configuration de l'architecture
		for all : mux
			use entity lib_rtl.mux(mux_arch);
		end for; 
	end for;

end configuration mux_tb_conf;

