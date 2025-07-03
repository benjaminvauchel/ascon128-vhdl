library IEEE;
use IEEE.std_logic_1164.all;

library lib_rtl;
use LIB_RTL.ascon_pack.all;

entity add_const_tb is -- entité vide
end entity add_const_tb;

architecture add_const_tb_arch of add_const_tb is
-- description structurelle
-- déclaration du composant à simuler

component add_const
	port(
		round_i : in bit4;
		state_i : in type_state;
		state_o : out type_state
	);
end component add_const;

signal round_s : bit4;
signal state_i_s : type_state;
signal state_o_s : type_state;

begin
-- description de l'architecture

-- instance du composant à simuler
DUT : add_const port map (
	round_i => round_s,
	state_i => state_i_s,
	state_o => state_o_s
);

-- stimuli
-- On simule l'évolution de l'état courant grâce aux données attendues pour faire une p^6 entière
state_i_s(0) <= IV_c, x"e94618fea85c8f8e" after 20 ns, x"3498e1ec4cdb4952" after 40 ns, x"8414bef0c2779330" after 60 ns, x"e6ee74eda90e8f61" after 80 ns, x"3c27a95888b149b4" after 100 ns;
state_i_s(1) <= x"0001020304050607", x"88417420cb2db357" after 20 ns, x"2011aa1dc3ca4481" after 40 ns, x"77f50ba06d6512a3" after 60 ns, x"a1d364f518e39fc2" after 80 ns, x"5d0b3d582ac4db63" after 100 ns; -- poids faible K
state_i_s(2) <= x"08090A0B0C0D0E0F", x"3fffffffffffff74" after 20 ns, x"28c2d7d459e5be15" after 40 ns, x"2aa9541d2b8f0d53" after 60 ns, x"d17f98ac9be2dd7f" after 80 ns, x"145b4e4b0cd2993b" after 100 ns; -- poids fort K
state_i_s(3) <= x"0001020304050607", x"bc185427038300f0" after 20 ns, x"7c7942682ebe57de" after 40 ns, x"48aa5c75017ee1f3" after 60 ns, x"448f5bd9015f7d6d" after 80 ns, x"021315e702366522" after 100 ns; -- poids faible N
state_i_s(4) <= x"08090A0B0C0D0E0F", x"1d1c1c1e181c1c1c" after 20 ns, x"e6ff6b5776c7da4c" after 40 ns, x"002ff8cd6755f585" after 60 ns, x"4f201960642f78aa" after 80 ns, x"e113e74a04dcb6fd" after 100 ns; -- poids fort N
round_s <= x"0", x"1" after 20 ns, x"2" after 40 ns, x"3" after 60 ns, x"4" after 80 ns, x"5" after 100 ns; -- Incrémentation de la ronde

end architecture add_const_tb_arch;

configuration add_const_tb_conf of add_const_tb is

	for add_const_tb_arch -- configuration de l'architecture
		for all : add_const -- association d'un modele pour chaque instance de composant
			use entity lib_rtl.add_const(add_const_arch);
		end for; 
	end for;

end configuration add_const_tb_conf;

