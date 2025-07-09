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
    segments <= "1000000" WHEN "000000",
                "1111001" WHEN "000001",
                "0100100" WHEN "000010",
                "0110000" WHEN "000011",
                "0011001" WHEN "000100",
                "0010010" WHEN "000101",
                "0000010" WHEN "000110",
                "1111000" WHEN "000111",
                "0000000" WHEN "001000",
                "0010000" WHEN "001001", 
                "0001000" WHEN "001010",
                "0000011" WHEN "001011", 
                "1000110" WHEN "001100", 
                "0100001" WHEN "001101", 
                "0000110" WHEN "001110", 
                "0001110" WHEN "001111", 
					 "0000010" WHEN "010000",  -- G
					 "0011001" WHEN "010001",  -- H
					 "1111001" WHEN "010010",  -- I (same as 1)
					 "1110001" WHEN "010011",  -- J
					 "0111011" WHEN "010100",  -- K (approximate)
					 "1000111" WHEN "010101",  -- L
					 "1010100" WHEN "010110",  -- M (approximate, not well defined)
					 "1010101" WHEN "010111",  -- N (approximate)
					 "1000000" WHEN "011000",  -- O (same as 0)
					 "0001100" WHEN "011001",  -- P
					 "0011000" WHEN "011010",  -- Q (approximate)
					 "1011111" WHEN "011011",  -- R (approximate)
					 "0010010" WHEN "011100",  -- S (same as 5)
					 "0000111" WHEN "011101",  -- T
					 "1000001" WHEN "011110",  -- U
					 "1100001" WHEN "011111",  -- V (approximate)
					 "1111010" WHEN "100000",  -- W (very approximate)
					 "0111011" WHEN "100001",  -- X (like K)
					 "0010001" WHEN "100010",  -- Y
					 "0100100" WHEN "100011",  -- Z (same as 2)
                "0111111" WHEN OTHERS;
END a;

