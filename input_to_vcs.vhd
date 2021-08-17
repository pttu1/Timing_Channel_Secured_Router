library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
           
entity input_to_vcs is
	port( 	clk: in std_logic;
	     	reset: in std_logic;
		ipA: in std_ulogic_vector(31 downto 0);
		vc1: out std_logic;
		vc2: out std_logic
	);
end input_to_vcs;

architecture behavior of input_to_vcs is
	signal ctr : std_ulogic_vector (1 downto 0);
	begin
		
		ctr <=  std_ulogic_vector(ipA(10 downto 9));
	
		process (clk, reset, ctr)
		begin
		if reset = '0' then 
				vc1 <= '0';
				vc2 <= '0';
		elsif (rising_edge(clk)) then
			if (ctr(0) = '0') then
				vc1 <= '1';
				vc2 <= '0';
			elsif (ctr(0) = '1') then
				vc2 <= '1';
				vc1 <= '0';
			else
				vc1 <= '0';
				vc2 <= '0';
			end if;
		end if;
		end process;
end behavior;

