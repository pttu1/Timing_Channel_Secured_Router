library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--abbreviation format : t - temp; 
-- l,n,w,s,e are local, north, west, south, east; 
-- pkt - packet, 
-- i - input; 
-- o - output.

entity noc_2X2 is 
	generic (packet_size : integer := 32);
	port
	(	clk: in std_logic;
		reset: in std_logic;
		
		l_pkt_i0, l_pkt_i1, l_pkt_i2, l_pkt_i3 : in std_ulogic_vector(packet_size-1 downto 0);
	     	n_pkt_i0, n_pkt_i1, n_pkt_i2, n_pkt_i3 : in std_ulogic_vector(packet_size-1 downto 0);
	     	w_pkt_i0, w_pkt_i1, w_pkt_i2, w_pkt_i3 : in std_ulogic_vector(packet_size-1 downto 0);
	     	s_pkt_i0, s_pkt_i1, s_pkt_i2, s_pkt_i3 : in std_ulogic_vector(packet_size-1 downto 0);
	     	e_pkt_i0, e_pkt_i1, e_pkt_i2, e_pkt_i3 : in std_ulogic_vector(packet_size-1 downto 0);

	    	l_pkt_o0, l_pkt_o1, l_pkt_o2, l_pkt_o3 : in std_ulogic_vector(packet_size-1 downto 0);
	     	n_pkt_o0, n_pkt_o1, n_pkt_o2, n_pkt_o3 : in std_ulogic_vector(packet_size-1 downto 0);
	     	w_pkt_o0, w_pkt_o1, w_pkt_o2, w_pkt_o3 : in std_ulogic_vector(packet_size-1 downto 0);
	     	s_pkt_o0, s_pkt_o1, s_pkt_o2, s_pkt_o3 : in std_ulogic_vector(packet_size-1 downto 0);
	     	e_pkt_o0, e_pkt_o1, e_pkt_o2, e_pkt_o3 : in std_ulogic_vector(packet_size-1 downto 0)
	);
end noc_2x2;

architecture rtl of noc_2x2 is

	component router is
		generic(
		addr : std_logic_vector(3 downto 0) --
		);
		port
		(
		clk : in std_logic;
       	    	reset : in std_logic;
	
	    	l_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	     	n_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	     	w_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	     	s_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	    	e_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);

	    	l_pkt_o : out std_ulogic_vector(packet_size-1 downto 0);
	    	n_pkt_o : out std_ulogic_vector(packet_size-1 downto 0);
    	    	w_pkt_o : out std_ulogic_vector(packet_size-1 downto 0);
	     	s_pkt_o : out std_ulogic_vector(packet_size-1 downto 0);
	    	e_pkt_o : out std_ulogic_vector(packet_size-1 downto 0)
	   	);
	end component;

	--Define signals
	signal temp: std_logic;
	signal tl_pkt_o0, tn_pkt_o0, tw_pkt_o0, ts_pkt_o0, te_pkt_o0: std_ulogic_vector(packet_size-1 downto 0);
	signal tl_pkt_o1, tn_pkt_o1, tw_pkt_o1, ts_pkt_o1, te_pkt_o1: std_ulogic_vector(packet_size-1 downto 0);
	signal tl_pkt_o2, tn_pkt_o2, tw_pkt_o2, ts_pkt_o2, te_pkt_o2: std_ulogic_vector(packet_size-1 downto 0);
	signal tl_pkt_o3, tn_pkt_o3, tw_pkt_o3, ts_pkt_o3, te_pkt_o3: std_ulogic_vector(packet_size-1 downto 0);
        begin

	--        NoC
--     x --------------->
--  y         ----       ----
--  |        | 0  | --- | 2  |
--  |         ----       ----
--  |          |          |
--  |         ----       ----
--  |        | 1  | --- | 3  |
--  |         ----       ----
--                         

	
	Router_0: router generic map(addr => "0000")
			port map(clk, reset,
			l_pkt_i0, n_pkt_i0, w_pkt_i0, s_pkt_i0, e_pkt_i0,
			tl_pkt_o0, tn_pkt_o0, tw_pkt_o0, ts_pkt_o0, te_pkt_o0
			);

	Router_1: router generic map(addr => "0001")
			port map(clk, reset, 
			l_pkt_i1, n_pkt_i1, w_pkt_i1, s_pkt_i1, e_pkt_i1,
			tl_pkt_o1, tn_pkt_o1, tw_pkt_o1, ts_pkt_o1, te_pkt_o1
			);

	Router_2: router generic map(addr => "0010")
			port map(clk, reset,
			l_pkt_i2, n_pkt_i2, te_pkt_o0, s_pkt_i2, e_pkt_i2,
			tl_pkt_o2, tn_pkt_o2, tw_pkt_o2, ts_pkt_o2, te_pkt_o2
			);

	Router_3: router generic map(addr => "0011")
			port map(clk, reset,
			l_pkt_i3, n_pkt_i3, w_pkt_i3, s_pkt_i3, e_pkt_i3,
			tl_pkt_o3, tn_pkt_o3, tw_pkt_o3, ts_pkt_o3, te_pkt_o3
			);


	--Connect routers together. 
	--(0, 0) to (0,1)
	--te_pkt_o0 <= w_pkt_i2;
	--w_pkt_i2 <= te_pkt_o0;
end rtl;
