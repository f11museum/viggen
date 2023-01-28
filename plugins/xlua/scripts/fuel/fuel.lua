-- 

sim_heartbeat = create_dataref("AJ37/system/fuel/heartbeat", "number")
sim_heartbeat = 100
aj37_fuel_sfc_kgs_kN = create_dataref("AJ37/system/fuel/fuel_sfc_kgs_kN", "number")

dr_override_fuel = find_dataref("sim/operation/override/override_fuel_flow")

dr_fuel_flow =  find_dataref("sim/flightmodel/engine/ENGN_FF_[0]")
dr_thrust = find_dataref("sim/cockpit2/engine/indicators/thrust_n[0]")
dr_burning = find_dataref("sim/flightmodel/engine/ENGN_burnrat[0]")

-- Lokala variabler
zon3 = 0.000080714
zon2 = 0.0000436778993647
dry = 0.0000173

function flight_start() 
	sim_heartbeat = 200
	dr_payload = 0
	dr_fog = 0.1
	
end

function aircraft_unload()

end

function do_on_exit()

end

heartbeat = 0
function before_physics() 
	sim_heartbeat = 300
	dr_override_fuel = 1
	if dr_burning > 0.02 then
		sim_heartbeat = 301
		dr_override_fuel = 1
		sim_heartbeat = 302
		dr_fuel_flow = dr_thrust * zon3
		sim_heartbeat = 303
	else
		dr_override_fuel = 1
		dr_fuel_flow = dr_thrust * dry
	end
	
	aj37_fuel_sfc_kgs_kN = dr_fuel_flow/dr_thrust*1000
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end

sim_heartbeat = 199
