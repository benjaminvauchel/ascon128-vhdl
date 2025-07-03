library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lib_rtl;
use LIB_RTL.ascon_pack.all;

-- entité pas entièrement vide car on précise la variable générique
entity register_w_en_tb is
	generic (
		nb_bits_g : natural := 32);
end entity register_w_en_tb;

architecture register_w_en_tb_arch of register_w_en_tb is
-- description structurelle
-- déclaration du composant à simuler

component register_w_en
	generic ( -- ne pas oublier cette partie
    	nb_bits_g : natural := 32); -- par défaut 32 bits
  	port (
		clock_i  : in  std_logic;
		resetb_i : in  std_logic;
		en_i     : in  std_logic;
		data_i   : in  std_logic_vector(nb_bits_g-1 downto 0);
		data_o   : out std_logic_vector(nb_bits_g-1 downto 0)
    );
end component register_w_en;

signal clock_s : std_logic := '0';
signal resetb_s : std_logic;
signal en_s : std_logic;
signal data_in_s : std_logic_vector(nb_bits_g-1 downto 0);

begin -- description de l'architecture

-- instance du composant à simuler
DUT : register_w_en
	generic map ( -- permet d'attribuer la valeur aux variables génériques
		nb_bits_g => 32	
	)
	port map (
		clock_i => clock_s,
		resetb_i => resetb_s,
		en_i => en_s,
		data_i => data_in_s
	);

-- stimuli
clock_s <= not clock_s after 10 ns; -- Horloge à 50 MHz
resetb_s <= '0', '1' after 5 ns, '0' after 45 ns;
en_s <= '0', '1' after 25 ns;
data_in_s <= x"12345678";

end architecture register_w_en_tb_arch;

configuration register_w_en_tb_conf of register_w_en_tb is

	for register_w_en_tb_arch -- configuration de l'architecture
		for all : register_w_en
			use entity lib_rtl.register_w_en(register_w_en_arch)
				generic map (
					nb_bits_g => 32);
		end for; 
	end for;

end configuration register_w_en_tb_conf;

