-- 

sim_heartbeat = create_dataref("AJ37/system/fuel/heartbeat", "number")
sim_heartbeat = 10
function myfilter(currentValue, newValue, amp)

	return ((currentValue*amp) + (newValue))/(amp+1)
	
end
sim_heartbeat = 100

aj37_fuel_sfc_kgs_kN = create_dataref("AJ37/fuel/fuel_sfc_kgs_kN", "number")

dr_override_fuel = find_dataref("sim/operation/override/override_fuel_flow")

dr_fuel_flow =  find_dataref("sim/flightmodel/engine/ENGN_FF_")
dr_thrust = find_dataref("sim/cockpit2/engine/indicators/thrust_n[0]")
dr_burning = find_dataref("sim/flightmodel/engine/ENGN_burnrat[0]")

aj37_ebk_zon1 = create_dataref("AJ37/ebk/zon1", "number")
aj37_ebk_zon2 = create_dataref("AJ37/ebk/zon2", "number")
aj37_ebk_zon3 = create_dataref("AJ37/ebk/zon3", "number")

aj37_fuel_total = create_dataref("AJ37/fuel/total", "number")
aj37_fuel_eta = create_dataref("AJ37/fuel/eta", "number")
aj37_fuel_eta_minuter = create_dataref("AJ37/fuel/eta_minuter", "number")
aj37_fuel_range = create_dataref("AJ37/fuel/range", "number")
aj37_fuel_range_km = create_dataref("AJ37/fuel/range_km", "number")
aj37_fuel_pct = create_dataref("AJ37/fuel/pct", "number")
jas_fuel_pct = find_dataref("JAS/fuel/pct", "number")
aj37_fuel_home = create_dataref("AJ37/fuel/home", "number")
aj37_fuel_b_per_min = create_dataref("AJ37/fuel/b_per_min", "number")

-- aj37_ti_land_dist = find_dataref("AJ37/ti/land/dist")

aj37_fuel = create_dataref("AJ37/fuel", "number")


sim_heartbeat = 101
dr_fire = find_command("sim/weapons/fire_any_armed")
sim_heartbeat = 1011
dr_wpn_sel_console = find_dataref("sim/cockpit/weapons/wpn_sel_console")
sim_heartbeat = 1012
dr_wpn_type = find_dataref("sim/weapons/type") 
sim_heartbeat = 1013
dr_wpn_firing = find_dataref("sim/weapons/firing") 
sim_heartbeat = 1014
dr_wpn_fuel_warhead_mass_now = find_dataref("sim/weapons/fuel_warhead_mass_now") 
sim_heartbeat = 1015
dr_m_fuel_total = find_dataref("sim/flightmodel/weight/m_fuel_total") 
sim_heartbeat = 1016
dr_m_fuel1 = find_dataref("sim/flightmodel/weight/m_fuel1") 
sim_heartbeat = 1017
dr_groundspeed = find_dataref("sim/flightmodel/position/groundspeed") 
sim_heartbeat = 1018

sim_heartbeat = 102

dr_balk1_l_type = find_dataref("sim/weapons/type[1]") -- Balknumrering enligt handbok, 1 Vingspetsar
balk1_l_index = 7
dr_balk1_r_type = find_dataref("sim/weapons/type[2]") -- 1 Vingspetsar
balk1_r_index = 6
dr_balk2_l_type = find_dataref("sim/weapons/type[3]") -- 2 yttervinge
dr_balk2_r_type = find_dataref("sim/weapons/type[4]")
balk2_l_index = 4
balk2_r_index = 5
dr_balk3_l_type = find_dataref("sim/weapons/type[5]") -- 3 innervinge
dr_balk3_r_type = find_dataref("sim/weapons/type[6]")
balk3_l_index = 2
balk3_r_index = 3
dr_balk4_type = find_dataref("sim/weapons/type[7]") -- sidoplats på kroppen
balk4_index = 10
dr_balk5_type = find_dataref("sim/weapons/type[8]") -- Mittenplatsen
balk5_index = 0
dr_balk6_type = find_dataref("sim/weapons/type[9]") -- balk 6 finns inte men hänvisar till AKAN
balk6_index = 1

dr_payload =  find_dataref("sim/flightmodel/weight/m_fixed") -- den dumma extra vikten som x-plane alltid lägger på planet
sim_heartbeat = 103
-- Lokala variabler
-- justerade från verkliga siffror för att matcha dom riktiga graferna på flygtider och bränsleåtgång
zon3 = 0.0000790 --713
zon2 = 0.0000436778993647
dry  = 0.0000284 -- enligt verklig data 0.0000173

function flight_start() 
	sim_heartbeat = 200
	dr_payload = 0
	dr_fog = 0.1
	
end

function aircraft_unload()
	dr_override_fuel = 0
end

function do_on_exit()
	dr_override_fuel = 0
end



function isFuelTank(index) 
	-- sim_heartbeat = 40020
	if (dr_wpn_type[index] == 23 and dr_wpn_firing[index] == 0) then
		-- sim_heartbeat = 40021
		return 1
	end
	-- sim_heartbeat = 40022
	return 0
end

function getFuelInTank(index) 
	-- sim_heartbeat = 40010
	if (isFuelTank(index) == 1) then
		return dr_wpn_fuel_warhead_mass_now[index]
	end
	return 0.0
end

eta_prev = 0
total_prev = 0
function totalFuel()
	-- sim_heartbeat = 4000
	total = 0.0
	total = total + dr_m_fuel_total
	-- sim_heartbeat = 400
	total = total + getFuelInTank(0)
	-- sim_heartbeat = 401
	total = total + getFuelInTank(2)
	-- sim_heartbeat = 402
	total = total + getFuelInTank(3)
	total = total + getFuelInTank(4)
	total = total + getFuelInTank(5)
	sim_heartbeat = 406
	aj37_fuel_total = total
	
	sim_heartbeat = 4061
	aj37_fuel_pct = aj37_fuel_total /(4200)*100
	jas_fuel_pct = aj37_fuel_pct
	sim_heartbeat = 4062
	-- d_fuel = aj37_fuel
	if (dr_fuel_flow[0]>0) then
		eta = total / dr_fuel_flow[0]
		aj37_fuel_eta = myfilter(eta_prev,eta , 10)
		aj37_fuel_eta_minuter = aj37_fuel_eta /60
		eta_prev = eta
	end
	sim_heartbeat = 407
	aj37_fuel_range = dr_groundspeed * aj37_fuel_eta
	aj37_fuel_range_km = aj37_fuel_range /1000
	-- aj37_fuel_home = aj37_ti_land_dist /4500
	sim_heartbeat = 408
	
	aj37_fuel_b_per_min = ((total_prev - aj37_fuel_total)*60.0) /42
	total_prev = aj37_fuel_total
end

run_at_interval(totalFuel, 1.0)

function EBKLampor()
	if dr_burning > 0 then
		
		if dr_burning < 0.25 then
			aj37_ebk_zon1 = 1
			aj37_ebk_zon2 = 0
			aj37_ebk_zon3 = 0
		elseif dr_burning < 0.52 then
			aj37_ebk_zon1 = 1
			aj37_ebk_zon2 = 1
			aj37_ebk_zon3 = 0
		elseif dr_burning < 1.1 then
			aj37_ebk_zon1 = 1
			aj37_ebk_zon2 = 1
			aj37_ebk_zon3 = 1
		end
	else 
		aj37_ebk_zon1 = 0
		aj37_ebk_zon2 = 0
		aj37_ebk_zon3 = 0
	end
end

heartbeat = 0
function before_physics() 
	sim_heartbeat = 300
	--dr_m_fuel1 = 2341
	dr_override_fuel = 1
	if dr_burning > 0.02 then
		sim_heartbeat = 301
		dr_override_fuel = 1
		sim_heartbeat = 302
		dr_fuel_flow[0] = dr_thrust * zon3
		sim_heartbeat = 303
	else
		dr_override_fuel = 1
		dr_fuel_flow[0] = dr_thrust * dry
	end
	
	aj37_fuel_sfc_kgs_kN = dr_fuel_flow[0]/dr_thrust*1000
	sim_heartbeat = 305
	EBKLampor()
	sim_heartbeat = 306
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end

sim_heartbeat = 199
