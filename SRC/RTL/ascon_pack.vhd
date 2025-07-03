-------------------------------------------------------------------------------
-- Title      : PACKAGE DEFINITION
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : ascon_pack.vhd
-- Authors    : Jean-Baptiste RIGAUD  <rigaud@tallinn.emse.fr>
--              Benjamin VAUCHEL <benjamin.vauchel@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-08-25
-- Last update: 2023-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 Conception du chiffrement leger ASCON
-------------------------------------------------------------------------------
-- Copyright (c) 2023
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-08-25  1.0	    rigaud	Created
-- 2023-01-02  1.1      vauchel Modified
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package ascon_pack is

  subtype bit2 is std_logic_vector(1 downto 0);
  subtype bit4 is std_logic_vector(3 downto 0);
  subtype bit5 is std_logic_vector(4 downto 0);
  subtype bit8 is std_logic_vector(7 downto 0);
  subtype bit16 is std_logic_vector(15 downto 0);
  subtype bit32 is std_logic_vector(31 downto 0);
  subtype bit64 is std_logic_vector(63 downto 0);
  subtype bit128 is std_logic_vector(127 downto 0);

  type type_state is array (0 to 4) of bit64;  -- type de l'état intermédiaire de ASCON
  type type_constant is array (0 to 11) of bit8;  -- tableau de constante pour l'addition des constantes
  type type_substitution is array (0 to 31) of bit8; -- tableau de substitution
  type trans_state is array (0 to 63) of bit5; -- type de l'état intermédiaire transposé

  -- définition du tableau des constantes de rondes
  constant round_constant : type_constant := (x"F0", x"E1", x"D2", x"C3", x"B4", x"A5", x"96", x"87", x"78", x"69", x"5A", x"4B");

  constant IV_c : bit64 := x"80400C0600000000";	 -- vecteur d'initialisation pour ASCON128

  -- définition de la table de substitution 
  constant table_substitution : type_substitution := (x"04", x"0B", x"1F", x"14", x"1A", x"15", x"09", x"02", x"1B", x"05", x"08", x"12", x"1D", x"03", x"06", x"1C", x"1E", x"13", x"07", x"0E", x"00", x"0D", x"11", x"18", x"10", x"0C", x"01", x"19", x"16", x"0A", x"0F", x"17");


end package ascon_pack;
