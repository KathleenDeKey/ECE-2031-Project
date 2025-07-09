LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

-- Hexadecimal to 7 Segment Decoder for LED Display
--  1) when free held low, displays latched data
--  2) when free held high, constantly displays input (free-run)
--  3) data is latched on rising edge of CS

ENTITY HEX_DISP IS
  PORT( hex_val  : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        cs       : IN STD_LOGIC := '0';
        free     : IN STD_LOGIC := '0';
        resetn   : IN STD_LOGIC := '1';
        segments : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END HEX_DISP;

ARCHITECTURE a OF HEX_DISP IS
  SIGNAL latched_hex : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL hex_d       : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN

  PROCESS (resetn, cs)
  BEGIN
    IF (resetn = '0') THEN
      latched_hex <= "000000";
    ELSIF ( RISING_EDGE(cs) ) THEN
      latched_hex <= hex_val;
    END IF;
  END PROCESS;
  
  WITH free SELECT
    hex_d  <= latched_hex WHEN '0',
              hex_val     WHEN '1';
           
  WITH hex_d SELECT
    segments <= "1000000" WHEN "000000",	--0
			 "1111001" WHEN "000001",	--1
			 "0100100" WHEN "000010",	--2
			 "0110000" WHEN "000011",	--3
			  "0011001" WHEN "000100",	--4
			  "0010010" WHEN "000101",	--5
			  "0000010" WHEN "000110",	--6
			  "1111000" WHEN "000111",	--7
			  "0000000" WHEN "001000",	--8
			  "0010000" WHEN "001001", 	--9
			  "0001000" WHEN "001010",	--A
				"0000011" WHEN "001011", 	--B
				"1000110" WHEN "001100", 	--C
				"0100001" WHEN "001101",	--D
				"0000110" WHEN "001110", 	--E
				"0001110" WHEN "001111",	--F
			"1000010" WHEN "010000",--G
			"0001011" WHEN "010001",	--H
			"1101110" WHEN "010010",	--I
			"1110010" WHEN "010011",	--J
			"0001010" WHEN "010100",	--K
			"1000111" WHEN "010101",	--L
			"0101010" WHEN "010110",	--M
			"0101011" WHEN "010111",	--N
			"0100011" WHEN "011000",	--O
			"0001100" WHEN "011001",	--P
			"0011000" WHEN "011010",	--Q
			"0101111" WHEN "011011",	--R
			"1010010" WHEN "011100",	--S
			"0000111" WHEN "011101",	--T
			"1100011" WHEN "011110",	--U
			"1010101" WHEN "011111",	--V
			"0010101" WHEN "100000",	--W
			"1101011" WHEN "100001",	--X
			"0010001" WHEN "100010",	--Y
			"1100100" WHEN "100011",	--Z
			"1111111" WHEN "100100",	--Z
			"0111111" WHEN OTHERS;

END a;

