library ieee;
use ieee.std_logic_1164.all;

entity router is 
	generic(
		packet_size: integer := 32;		
		addr : std_logic_vector(3 downto 0) := "0000"--
	);
	port(clk : in std_logic;
       	     reset : in std_logic;
	
	     l_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	     n_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	     w_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	     s_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	     e_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);

	     l_pkt_o : out std_logic_vector(packet_size-1 downto 0);
	     n_pkt_o : out std_logic_vector(packet_size-1 downto 0);
    	     w_pkt_o : out std_logic_vector(packet_size-1 downto 0);
	     s_pkt_o : out std_logic_vector(packet_size-1 downto 0);
	     e_pkt_o : out std_logic_vector(packet_size-1 downto 0)
	     );
end router;

architecture rtl of router is
	
	--Define components
	--Component associated with the input - input_to_virtual channels
	component input_to_vcs is
		port
		(
			clk: in std_logic;
	     		reset: in std_logic;
			ipA: in std_ulogic_vector(31 downto 0);
			vc1: out std_logic;
			vc2: out std_logic
		);
	end component;
	
	component vc_selector
		port(	clk: in std_logic;
			reset: in std_logic;
		
			request: in std_ulogic_vector(1 downto 0);
			grant: out std_ulogic_vector(1 downto 0)
		);
	end component;

	component decision_logic is
		generic(pkt_size: integer := 32);
		port
		(	
		clk: in std_logic;
		reset: in std_logic;
		input: in std_ulogic_vector(pkt_size-1 downto 0);
		out_port: out std_ulogic_vector(4 downto 0);
	    	output: out std_ulogic_vector(pkt_size-1 downto 0)
		);
	end component;

	component xbar_stage is
    		generic (
        	packet_size: integer := 32
   		 );
    		port 
		(
        	l_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
		n_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
		w_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
		s_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
		e_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
        	sel: in std_logic_vector (4 downto 0);
        	Data_out: out std_ulogic_vector(packet_size-1 downto 0)
    		);
	end component;

	--Define bus array
	type port_array_type is array(integer range 4 downto 0) of std_ulogic_vector(31 downto 0);

	--Define signals to link components
	signal port_array_in : port_array_type;
	signal port_array_out: port_array_type;
	signal switch_type : std_logic;
	signal ldl_sel, ndl_sel, wdl_sel, sdl_sel, edl_sel: std_ulogic_vector(4 downto 0);
	signal temp_sel: std_logic_vector(4 downto 0);
	signal ltemp_vc1, ltemp_vc2, ntemp_vc1, ntemp_vc2, wtemp_vc1, wtemp_vc2, stemp_vc1, stemp_vc2, etemp_vc1, etemp_vc2 : std_logic; 
	signal ltemp_request, ltemp_grant, ntemp_request, ntemp_grant, wtemp_request, wtemp_grant, stemp_request, stemp_grant, etemp_request, etemp_grant: std_ulogic_vector(1 downto 0); --add temp_vc1 and temp_vc2 to the vector
	signal temp_input, temp_in: std_ulogic_vector(31 downto 0); --to be assigned to designated input while we loop through the arrray
	signal ltemp_output, ntemp_output, wtemp_output, stemp_output, etemp_output: std_ulogic_vector(31 downto 0);
	signal final_output: std_ulogic_vector(31 downto 0);
	begin
	--Start building router circuit
	--split packer and pick controller and use switch case for packet and circuit switching
	local_unit_1: input_to_vcs port map(clk, reset, l_pkt_i, ltemp_vc1, ltemp_vc2); --change local later
	north_unit_1: input_to_vcs port map(clk, reset, n_pkt_i, ntemp_vc1, ntemp_vc2);
	west_unit_1: input_to_vcs port map(clk, reset, w_pkt_i, wtemp_vc1, wtemp_vc2);
	south_unit_1: input_to_vcs port map(clk, reset, s_pkt_i, stemp_vc1, stemp_vc2);
	east_unit_1: input_to_vcs port map(clk, reset, e_pkt_i, etemp_vc1, etemp_vc2);

	local_unit_2: vc_selector port map(clk, reset, ltemp_request, ltemp_grant);
	north_unit_2: vc_selector port map(clk, reset, ntemp_request, ntemp_grant);
	west_unit_2: vc_selector port map(clk, reset, wtemp_request, wtemp_grant);
	south_unit_2: vc_selector port map(clk, reset, stemp_request, stemp_grant);
	east_unit_2: vc_selector port map(clk, reset, etemp_request, etemp_grant);


	local_unit_3: decision_logic port map(clk, reset, l_pkt_i, ldl_sel, ltemp_output);
	north_unit_3: decision_logic port map(clk, reset, n_pkt_i, ndl_sel, ntemp_output);
	west_unit_3: decision_logic port map(clk, reset, w_pkt_i, wdl_sel, wtemp_output);
	south_unit_3: decision_logic port map(clk, reset, s_pkt_i, sdl_sel, stemp_output);
	east_unit_3: decision_logic port map(clk, reset, e_pkt_i, edl_sel, etemp_output);

	--north_unit_3: decision_logic port map(clk, reset, temp_input, dl_sel, temp_in);
	--west_unit_3: decision_logic port map(clk, reset, temp_input, dl_sel, temp_in);
	--south_unit_3: decision_logic port map(clk, reset, temp_input, dl_sel, temp_in);
	--east_unit_3: decision_logic port map(clk, reset, temp_input, dl_sel, temp_in);

	--local_unit_4: xbar_stage port map(port_array_in(0), port_array_in(1), port_array_in(2), port_array_in(3), port_array_in(4), to_stdlogicvector(ldl_sel), final_output);

	local_unit_4: xbar_stage port map(l_pkt_i, n_pkt_i, w_pkt_i, s_pkt_i, e_pkt_i, to_stdlogicvector(ldl_sel), final_output);
	
	ltemp_request(0) <= ltemp_vc1;
	ltemp_request(1) <= ltemp_vc2;
	port_array_in(0) <=  l_pkt_i;
	port_array_in(1) <=  n_pkt_i;
	port_array_in(2) <= w_pkt_i;
	port_array_in(3) <= s_pkt_i;
	port_array_in(4) <= e_pkt_i;
	--exec: process(clk, reset)
	  --type port_array_type is array(integer range 4 downto 0) of std_logic_vector(31 downto 0);
	 -- variable switch_type: unsigned;
	 -- variable port_array_in(0,)
  	-- begin
		--switch_type := unsigned(port_array_in()(13)); --port_array_in(1, 13)
	   -- if reset = '0' then 
		--port_array_out(0) <= (others => '0');
		--port_array_out(1) <= (others => '0');
		--port_array_out(2) <= (others => '0');
		--port_array_out(3) <= (others => '0');
		--port_array_out(4) <= (others => '0');
	  --  elsif (rising_edge(clk)) then
		--for i in 0 to 4 loop
		  
		--end loop;
	  -- end if;
	--end process;

	--local
end rtl;

              