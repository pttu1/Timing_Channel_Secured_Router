library ieee;
use ieee.std_logic_1164.all;

entity xbar_stage is
    generic (
        packet_size: integer := 32
    );
    port (
        l_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	n_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	w_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	s_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
	e_pkt_i : in std_ulogic_vector(packet_size-1 downto 0);
        sel: in std_logic_vector (4 downto 0);
        Data_out: out std_ulogic_vector(packet_size-1 downto 0)
    );
end xbar_stage;

architecture behavior of xbar_stage is
  begin
    process(sel, l_pkt_i, n_pkt_i, w_pkt_i, s_pkt_i, e_pkt_i) begin
      case(sel) is
    
    	when "00001" =>
    		Data_out <= l_pkt_i;
    	when "00010" =>
    		Data_out <= n_pkt_i;
    	when "00100" =>
    		Data_out <= w_pkt_i;
    	when "01000" =>
    		Data_out <= s_pkt_i;
    	when others =>
    		Data_out <= e_pkt_i;	
    end case;
   end process;
end behavior;
