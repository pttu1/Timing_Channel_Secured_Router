library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
           


entity yx_ra is
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
end yx_ra;

architecture config of yx_ra is
	component routing_pipeline is
		generic (size : integer := 32);
		port(	clk: in std_logic;
			ip: in std_ulogic_vector(pkt_size downto 0);     -- ______________________
			op: out std_ulogic_vector(pkt_size downto 0));   --|ft|port_out|__________|
	end component;

	--Delare signals
	signal ip_check, op_check: std_ulogic_vector(4 downto 0);
	signal data: std_ulogic_vector(pkt_size-1 downto 0);
	signal flag: integer := 0;
	begin
		routing_pipeline_data : entity work.routing_pipeline generic map(size => 32)
		port map(
			clk => clk,
			reset => reset,
			ip => ip,
			op => op);

		exec : process(clk, reset, flag)
		variable y, x: unsigned (1 downto 0);
		variable dy, dx: unsigned (1 downto 0);
		variable result: unsigned (4 downto 0);
		variable f_type: unsigned (1 downto 0);

		begin
			if flag = 0 then
				y := to_unsigned(cur_loc_y, 2);
				x := to_unsigned(cur_loc_x, 2);
				flag <= flag + 1;
			end if;
			dy := unsigned(ip(1 downto 0));
			dx := unsigned (ip(3 downto 2)); 
			
			if reset = '0' then 
				result := (others => '0');
			elsif (rising_edge(clk)) then
					if y = dy and x = dx then
						result := "10000";
						y := dy;
						x := dx;
					elsif y > dy then
						result := "01000";
						y := dy;
					elsif y < dy then
						result := "00100";
						y := dy;
					elsif x > dx then
						result := "00010";
						x := dx;
					elsif x < dx then
						result := "00001";
						x := dx;
					end if;
						
			end if;
			op_check <= std_ulogic_vector(result);
			--op_check <= result;
			end process;
			--o
			--Routing paths
			l_pkt_o <= op_check(4);
			n_pkt_o <= op_check(3);
			w_pkt_o <= op_check(1);
			s_pkt_o <= op_check(2);
			e_pkt_o <= op_check(0);
end config;