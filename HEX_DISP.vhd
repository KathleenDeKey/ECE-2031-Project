LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

-- Hexadecimal to 7 Segment Decoder for LED Display
--  1) when free held low, displays latched data
--  2) when free held high, constantly displays input (free-run)
--  3) data is latched on rising edge of CS

ENTITY HEX_DISP IS
  PORT( hex_val  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        cs       : IN STD_LOGIC := '0';
        free     : IN STD_LOGIC := '0';
        resetn   : IN STD_LOGIC := '1';
        segments : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END HEX_DISP;

ARCHITECTURE a OF HEX_DISP IS
  SIGNAL latched_hex : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL hex_d       : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL encoding : std_logic_vector(5 downto 0);

BEGIN

  PROCESS (resetn, cs)
  BEGIN
    IF (resetn = '0') THEN
      latched_hex <= "00000000";
    ELSIF ( RISING_EDGE(cs) ) THEN
      latched_hex <= hex_val;
    END IF;
  END PROCESS;
  
  WITH free SELECT	
    hex_d  <= latched_hex WHEN '0',
              hex_val     WHEN '1';
        
  PROCESS (hex_d)
  BEGIN
  IF hex_d(7) = '1' THEN
    segments <= not hex_d(6 downto 0);  -- raw segment pattern
  ELSE
    encoding <= hex_d(5 downto 0);

    CASE encoding IS
      WHEN "000000" => segments <= "1000000"; -- 0
      WHEN "000001" => segments <= "1111001"; -- 1
      WHEN "000010" => segments <= "0100100"; -- 2
      WHEN "000011" => segments <= "0110000"; -- 3
      WHEN "000100" => segments <= "0011001"; -- 4
      WHEN "000101" => segments <= "0010010"; -- 5
      WHEN "000110" => segments <= "0000010"; -- 6
      WHEN "000111" => segments <= "1111000"; -- 7
      WHEN "001000" => segments <= "0000000"; -- 8
      WHEN "001001" => segments <= "0010000"; -- 9
      WHEN "001010" => segments <= "0001000"; -- A
      WHEN "001011" => segments <= "0000011"; -- B
      WHEN "001100" => segments <= "0100111"; -- C
      WHEN "001101" => segments <= "0100001"; -- D
      WHEN "001110" => segments <= "0000110"; -- E
      WHEN "001111" => segments <= "0001110"; -- F
      WHEN "010000" => segments <= "1000010"; -- G
      WHEN "010001" => segments <= "0001011"; -- H
      WHEN "010010" => segments <= "1101110"; -- I
      WHEN "010011" => segments <= "1110010"; -- J
      WHEN "010100" => segments <= "0001010"; -- K
      WHEN "010101" => segments <= "1000111"; -- L
      WHEN "010110" => segments <= "0101010"; -- M
      WHEN "010111" => segments <= "0101011"; -- N
      WHEN "011000" => segments <= "0100011"; -- O
      WHEN "011001" => segments <= "0001100"; -- P
      WHEN "011010" => segments <= "0011000"; -- Q
      WHEN "011011" => segments <= "0101111"; -- R
      WHEN "011100" => segments <= "1010010"; -- S
      WHEN "011101" => segments <= "0000111"; -- T
      WHEN "011110" => segments <= "1100011"; -- U
      WHEN "011111" => segments <= "1010101"; -- V
      WHEN "100000" => segments <= "0010101"; -- W
      WHEN "100001" => segments <= "1101011"; -- X
      WHEN "100010" => segments <= "0010001"; -- Y
      WHEN "100011" => segments <= "1100100"; -- Z
      WHEN "100100" => segments <= "1111111"; -- blank/error
      WHEN OTHERS   => segments <= "0111111"; -- default (e.g. dash)
    END CASE;
  END IF;
END PROCESS;


END a;
