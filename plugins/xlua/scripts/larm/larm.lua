-- 

sim_heartbeat = create_dataref("JA/system/larm/heartbeat", "number")
sim_heartbeat = 100

dr_fog = find_dataref("sim/private/controls/fog/fog_be_gone")
dr_cloud_shadow = find_dataref("sim/private/controls/clouds/cloud_shadow_lighten_ratio")

dr_payload =  find_dataref("sim/flightmodel/weight/m_fixed")

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

heartbeat = 0
function before_physics() 
	sim_heartbeat = 300
	
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end

sim_heartbeat = 199
