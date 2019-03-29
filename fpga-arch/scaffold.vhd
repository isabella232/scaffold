-- This file is part of Scaffold
--
-- Scaffold is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
--
--
-- Copyright 2019 Ledger SAS, written by Olivier Hériveaux
--
--
-- Root entities of Scaffold VHDL architecture.
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity scaffold is
generic (
    -- Number of programmables IOs;
    io_count: positive := 22 );
port (
    -- System clock.
    clock: in std_logic;
    -- System reset, active low.
    reset_n: in std_logic;
    -- UART transmission to FT232
    tx: out std_logic;
    rx: in std_logic;
    -- TLC5927 LEDs driver control signals.
    leds_sin: out std_logic;
    leds_sclk: out std_logic;
    leds_lat: out std_logic;
    leds_blank: out std_logic;
    io: inout std_logic_vector(io_count-1 downto 0);
    -- Direction control for A0, A1, B0, B1, C0, C1.
    io_dir: out std_logic_vector(2 downto 0);
    teardown: in std_logic;
    -- Power control outputs
    power_dut: out std_logic;
    power_platform: out std_logic;
    -- Debug signals
    debug: out std_logic_vector(3 downto 0) );
end;


architecture behavior of scaffold is
    -- Output of the PLL. 100 MHz clock.
    signal system_clock: std_logic;
begin
    -- Use a PLL to raise input clock frequency up to 100 MHz
    e_pll: entity work.pll port map (
        areset => not reset_n,
        inclk0 => clock,
        c0 => system_clock );

    -- Instantiate the main architecture with the system clock.
    e_system: entity work.system 
    generic map (
        system_frequency => 100000000,
        io_count => io_count )
    port map (
        clock => system_clock,
        reset_n => reset_n,
        tx => tx,
        rx => rx,
        leds_sin => leds_sin,
        leds_sclk => leds_sclk,
        leds_lat => leds_lat,
        leds_blank => leds_blank,
        io => io,
        teardown_async => teardown,
        power_dut => power_dut,
        power_platform => power_platform);

    io_dir <= "111";
end;
