library ieee;
use ieee.std_logic_1164.all;

entity stcm_cdl is
	port( 	clk: in std_logic;
		reset: in std_logic;
		
		ip_from_dl: in std_ulogic;
		states: in std_logic_vector(1 downto 0);
		final_out: out std_logic	
		);
end stcm_cdl;

architecture behavior of stcm_cdl is
	
	--Define signals to link components
	signal count_total: integer := 0; 
	signal count_s1: integer  := 0; -- range 0 to 1; 
	signal count_s2: integer   := 0;--range 0 to 2; 
	signal c : std_ulogic;
	--define vatiables for TSSC
	signal valid_bit: std_ulogic;
	signal slot_allocation: std_ulogic;

	begin 
		
		
		--slot allocation
		proc: process(clk, reset) begin

	
		if(reset = '1') then 
			final_out <= '0';
		elsif (rising_edge(clk)) then
			
			if(states = "10") and (count_s1 < 1) then 
				-- allocate S1, let pass to output
				c <= ip_from_dl;
				count_s1 <= count_s1 + 1; 
				count_total <= count_total + 1;
			elsif(states = "01") and (count_s2 < 2)then
				--allocated s2 twice
				c <= ip_from_dl;
				count_s2 <= count_s2 + 1;
				count_total <= count_total + 1; 
			elsif(states = "11") and ((count_s1 < 2) and (count_s2 < 1)) then
				--allocated s1 twice and s2 once
				c <= ip_from_dl;
				count_s1 <= count_s1 + 1;
				count_s2 <= count_s2 + 1;
				count_total <= count_total + 1; 
			end if; 
			if (count_total = 4) and ((count_s1 = 1) and (count_s2 = 3)) then
			count_s1 <= 0;
			count_s2 <= 0;
			count_total <= 0; 
			end if;
		end if;
		end process; 
end behavior;
