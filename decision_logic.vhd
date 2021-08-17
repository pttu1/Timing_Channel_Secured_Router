library ieee;
use ieee.std_logic_1164.all;

--gets output from routing_table depending on the selected VC(VC selector out).
entity decision_logic is
	generic(pkt_size: integer := 32);
	port(	
		clk: in std_logic;
		reset: in std_logic;
		input: in std_ulogic_vector(pkt_size-1 downto 0);
		out_port: out std_ulogic_vector(4 downto 0);
	    	output: out std_ulogic_vector(pkt_size-1 downto 0)
	);
end decision_logic;

architecture behavior of decision_logic is
	--Define components
	--Component associated with the input - output of routing algorithm (must be HS router if LS router is selected)
	component yx_ra	is
		generic(cur_loc_y: integer := 0;  --packet arrived at router, to be routed
			cur_loc_x: integer := 0;
			pkt_size: integer := 32);
		port(	clk: in std_logic;
	     		reset: in std_logic;
	     		l_pkt_o: out std_ulogic;
			n_pkt_o: out std_ulogic;
 			w_pkt_o: out std_ulogic;
			s_pkt_o: out std_ulogic;
			e_pkt_o: out std_ulogic;
			ip: in std_ulogic_vector(pkt_size-1 downto 0);
			op: out std_ulogic_vector(pkt_size-1 downto 0)
		);
	end component;
	
	--define signals to link
	signal out_vector: std_ulogic_vector(4 downto 0);
	signal loc: std_ulogic_vector(3 downto 0);
	--signal cx, cy: integer;

	begin
	
	
	--build circuit
	U1: yx_ra generic map(cur_loc_y => 0, cur_loc_x => 0, pkt_size => 32)
		port map
		(	clk, reset, out_vector(4), out_vector(3), out_vector(1), out_vector(2), out_vector(0),  input,  output
		);
	out_port <= out_vector;
	--if (loc = "0000") then cx <= 0; cy <= 0; elsif (loc = "0001") then cx <= 0; cy <= 1; elsif (loc = "0100") then cx <= 1; cy <= 0;
	--elsif (loc = "0101") then cx <= 1; cy <= 1; end if;

end behavior;