library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity noc_2x2_tb is
end noc_2x2_tb;

architecture behavior of noc_2x2_tb is
	component noc_2x2 is 
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
	end component;
	signal clk: std_ulogic;
	signal reset: std_ulogic;
	signal packet_size : integer := 32;
	signal l_pkt_i0, l_pkt_i1, l_pkt_i2, l_pkt_i3 : std_ulogic_vector(packet_size-1 downto 0);
	signal n_pkt_i0, n_pkt_i1, n_pkt_i2, n_pkt_i3 : std_ulogic_vector(packet_size-1 downto 0);
	signal w_pkt_i0, w_pkt_i1, w_pkt_i2, w_pkt_i3 : std_ulogic_vector(packet_size-1 downto 0);
	signal s_pkt_i0, s_pkt_i1, s_pkt_i2, s_pkt_i3 : std_ulogic_vector(packet_size-1 downto 0);
	signal e_pkt_i0, e_pkt_i1, e_pkt_i2, e_pkt_i3 : std_ulogic_vector(packet_size-1 downto 0);

	signal l_pkt_o0, l_pkt_o1, l_pkt_o2, l_pkt_o3 : std_ulogic_vector(packet_size-1 downto 0);
	signal n_pkt_o0, n_pkt_o1, n_pkt_o2, n_pkt_o3 : std_ulogic_vector(packet_size-1 downto 0);
	signal w_pkt_o0, w_pkt_o1, w_pkt_o2, w_pkt_o3 : std_ulogic_vector(packet_size-1 downto 0);
	signal s_pkt_o0, s_pkt_o1, s_pkt_o2, s_pkt_o3 : std_ulogic_vector(packet_size-1 downto 0);
	signal e_pkt_o0, e_pkt_o1, e_pkt_o2, e_pkt_o3 : std_ulogic_vector(packet_size-1 downto 0);

	begin
		yx_ra_block: noc_2x2
		generic map(packet_size => 32)
		port map(clk,
			 reset,
			 l_pkt_i0, l_pkt_i1, l_pkt_i2, l_pkt_i3,
			 n_pkt_i0, n_pkt_i1, n_pkt_i2, n_pkt_i3,
	     		 w_pkt_i0, w_pkt_i1, w_pkt_i2, w_pkt_i3,
	     		 s_pkt_i0, s_pkt_i1, s_pkt_i2, s_pkt_i3,
	     		 e_pkt_i0, e_pkt_i1, e_pkt_i2, e_pkt_i3,
			 l_pkt_o0, l_pkt_o1, l_pkt_o2, l_pkt_o3,
	     		 n_pkt_o0, n_pkt_o1, n_pkt_o2, n_pkt_o3,
	     		 w_pkt_o0, w_pkt_o1, w_pkt_o2, w_pkt_o3,
	     		 s_pkt_o0, s_pkt_o1, s_pkt_o2, s_pkt_o3,
	     		 e_pkt_o0, e_pkt_o1, e_pkt_o2, e_pkt_o3 
		);

		clocking_p : process begin
			clk <= '0';
			wait for 100ps;
			clk <= '1';
			wait for 100ps;
		end process;
		
		testing : process begin
			reset <= '0';
	
			reset <= '1';
			wait for 200 ps;

			l_pkt_i0 <= "10100001101011001100001010000101";
	     		n_pkt_i0 <= "11111111111111111000000000000100";
	     		w_pkt_i0 <= "11111111000000011111111101000001";
	     		s_pkt_i0 <= "11111111111111111000000000000100";
	     		e_pkt_i0 <= "00000000000000000000000000000000";
			wait for 500 ps;
		end process;
end;
 
