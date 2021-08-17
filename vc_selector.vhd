library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity vc_selector is
	port(	clk: in std_logic;
		reset: in std_logic;
		
		request: in std_ulogic_vector(1 downto 0);
		grant: out std_ulogic_vector(1 downto 0)
	);

end vc_selector;

architecture behavior of vc_selector is
	signal counter_total: integer := 0; 
	signal counter_ls: integer  := 0; -- range 0 to 1; 
	signal counter_hs: integer   := 0;--range 0 to 2; 
	signal c : std_ulogic_vector(1 downto 0); 
	begin
	proc: process(clk, reset) begin
	
	if(reset = '0') then 
		grant <= (others => '0');
	elsif (rising_edge(clk)) then 
		c(0) <= request(0);
		c(1) <= request(1) and not request(0);

		if(c(0) = '1') and (counter_ls < 1) then 
			grant <= c;
			counter_ls <= counter_ls + 1; 
			counter_total <= counter_total + 1;
		elsif(c(1) = '1') and (counter_hs < 3)then
			grant <= c;
			counter_hs <= counter_hs + 1;
			counter_total <= counter_total + 1; 
		end if; 
		if (counter_total = 4) and ((counter_ls = 1) and (counter_hs = 3)) then
			counter_ls <= 0;
			counter_hs <= 0;
			counter_total <= 0; 
		end if;
	end if;
	end process; 
end behavior;