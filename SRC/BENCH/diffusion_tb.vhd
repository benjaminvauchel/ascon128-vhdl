library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lib_rtl;
use LIB_RTL.ascon_pack.all;

entity diffusion_tb is-- entite vide
end entity diffusion_tb;

architecture diffusion_tb_arch of diffusion_tb is
--description structurelle
-- déclaration du composant à simuler

component diffusion
	port(
		state_i : in type_state;
		state_o : out type_state
	);
end component diffusion;

signal state_i_s : type_state;
signal state_o_s : type_state;

begin -- description de l'architecture
-- instance du composant à simuler

DUT : diffusion port map (
	state_i => state_i_s,
	state_o => state_o_s
);
-- stimuli

state_i_s(4) <= x"0808080a08080808";
state_i_s(3) <= x"80400406000000f0"; -- poids faible K
state_i_s(2) <= x"ffffffffffffff0f"; -- poids fort K
state_i_s(1) <= x"80410e05040506f7"; -- poids faible N
state_i_s(0) <= x"8849060f0c0d0eff"; -- poids fort N

end architecture diffusion_tb_arch;

configuration diffusion_tb_conf of diffusion_tb is

	for diffusion_tb_arch -- configuration de l'architecture
		for all : diffusion -- association d'un modele pour chaque instance de composant
			use entity lib_rtl.diffusion(diffusion_arch);
		end for; 
	end for;

end configuration diffusion_tb_conf;

