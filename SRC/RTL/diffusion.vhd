-------------------------------------------------------------------------------
-- Title      : Diffusion
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : diffusion.vhd
-- Author     : Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2023-01-02
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Couche de diffusion lineaire du chiffrement leger ascon
-------------------------------------------------------------------------------
-- Copyright (c) 2023
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2023-01-02  1.0		vauchel	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity diffusion is
	port(
			state_i : in type_state;
			state_o : out type_state
		);
end entity diffusion;

architecture diffusion_arch of diffusion is

begin

	-- On effectue les opérations décrites par le sujet avec les rotations cycliques
	state_o(0) <= state_i(0) xor (state_i(0)(18 downto 0) & state_i(0)(63 downto 19)) xor (state_i(0)(27 downto 0) & state_i(0)(63 downto 28));
	state_o(1) <= state_i(1) xor (state_i(1)(60 downto 0) & state_i(1)(63 downto 61)) xor (state_i(1)(38 downto 0) & state_i(1)(63 downto 39));
	state_o(2) <= state_i(2) xor (state_i(2)(0) & state_i(2)(63 downto 1)) xor (state_i(2)(5 downto 0) & state_i(2)(63 downto 6));
	state_o(3) <= state_i(3) xor (state_i(3)(9 downto 0) & state_i(3)(63 downto 10)) xor (state_i(3)(16 downto 0) & state_i(3)(63 downto 17));
	state_o(4) <= state_i(4) xor (state_i(4)(6 downto 0) & state_i(4)(63 downto 7)) xor (state_i(4)(40 downto 0) & state_i(4)(63 downto 41));

end architecture diffusion_arch;
