-- 

sim_heartbeat = create_dataref("AJ37/system/larm/heartbeat", "number")
sim_heartbeat = 100

dr_fog = find_dataref("sim/private/controls/fog/fog_be_gone")
dr_cloud_shadow = find_dataref("sim/private/controls/clouds/cloud_shadow_lighten_ratio")

dr_payload =  find_dataref("sim/flightmodel/weight/m_fixed")
dr_speedbrake_ratio = find_dataref("sim/cockpit2/controls/speedbrake_ratio")

sim_jas_lamps_airbrake = find_dataref("JAS/io/frontpanel/lamp/airbrake")


-- Lokala variabler
g_markkontakt = 1

function flight_start() 
	sim_heartbeat = 200
	dr_payload = 0
    dr_fog = 0.1
end

function aircraft_unload()

end

function do_on_exit()

end

function lampAirbrake()

    if (dr_speedbrake_ratio > 0) then
		sim_jas_lamps_airbrake = 1
    else
		sim_jas_lamps_airbrake = 0
	end
end

heartbeat = 0
function before_physics() 
	sim_heartbeat = 300
	lampAirbrake()
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end

sim_heartbeat = 199
