library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity routing_pipeline is
	generic(size: integer := 32);
	port(   clk: in std_logic;
		reset: in std_logic;
		ip: in std_ulogic_vector(size-1 downto 0);
		op: out std_ulogic_vector(size-1 downto 0)
	);
end routing_pipeline;

architecture config of routing_pipeline is
begin
	routing_pipeline_process : process(clk, reset, ip)
	variable i : std_ulogic_vector(size-1 downto 0);
	begin
		if reset = '0' then
			i := (others => '0');
		elsif (rising_edge(clk)) then
			i := ip;
		end if;
	end process;
	op <= ip;
end config;
