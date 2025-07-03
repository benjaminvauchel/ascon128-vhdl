library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use LIB_RTL.ascon_pack.all;

-- entité vide
entity ascon_top_tb is
end ascon_top_tb;

architecture ascon_top_tb_arch of ascon_top_tb is
-- description structurelle

-- déclaration du composant à simuler
component ascon_top
	port (
		clock_i			: in std_logic;
		resetb_i		: in std_logic;
		start_i			: in std_logic;
		data_valid_i	: in std_logic;
		data_i			: in bit64;
		key_i			: in bit128;
		nonce_i			: in bit128;
		cipher_valid_o	: out std_logic;
		end_o			: out std_logic;
		cipher_o		: out bit64;
		tag_o			: out bit128
	);
end component ascon_top;

signal clock_s : std_logic := '0'; -- on initialise la clock à 0
signal resetb_s, data_valid_s, start_s	: std_logic;
signal data_s, cipher_s : bit64;
signal key_s, nonce_s, tag_s : bit128;
signal end_s, cipher_valid_s : std_logic;

begin
-- description de l'architecture
-- instance du composant à simuler

DUT : ascon_top port map (
	clock_i			=> clock_s,
	resetb_i		=> resetb_s,
	start_i			=> start_s,
	data_valid_i	=> data_valid_s,
	data_i			=> data_s,
	key_i			=> key_s,
	nonce_i			=> nonce_s,
	cipher_valid_o	=> cipher_valid_s,
	end_o			=> end_s,
	cipher_o		=> cipher_s,
	tag_o			=> tag_s
);

-- stimuli
clock_s			<= not clock_s after 10 ns; -- horloge cadencée à 50 MHz
resetb_s		<= '0', '1' after 15 ns;
start_s			<= '0', '1' after 25 ns;
-- on entre les données les unes après les autres au bon moment
data_valid_s	<= '0', '1' after 325 ns, '0' after 345 ns, '1' after 455 ns, '0' after 475 ns, '1' after 595 ns, '0' after 615 ns, '1' after 735 ns, '0' after 755 ns, '1' after 875 ns, '0' after 895 ns;
data_s			<= IV_c, x"3230323280000000" after 320 ns, x"446576656c6f7070" after 450 ns, x"657a204153434f4e" after 590 ns, x"20656e206c616e67" after 730 ns, x"6167652056484480" after 870 ns;
key_s			<= x"000102030405060708090A0B0C0D0E0F";
nonce_s			<= x"000102030405060708090A0B0C0D0E0F";

end architecture ascon_top_tb_arch;

configuration ascon_top_tb_conf of ascon_top_tb is

	for ascon_top_tb_arch -- configuration de l'architecture
		for all : ascon_top
			use entity lib_rtl.ascon_top(ascon_top_arch);
		end for; 
	end for;

end configuration ascon_top_tb_conf;

