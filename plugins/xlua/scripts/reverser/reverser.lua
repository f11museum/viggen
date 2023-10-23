sim_heartbeat = create_dataref("AJ37/heartbeat/reverser", "number")
sim_heartbeat = 100
dr_nose_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[0]") 
dr_rev_handle = find_dataref("sim/cockpit2/switches/auto_reverse_on") 
dr_rev_status = find_dataref("sim/cockpit2/annunciators/reverser_deployed") 
rev_cmd = find_command("sim/engines/thrust_reverse_toggle")

dr_flap = find_dataref("sim/cockpit2/controls/flap_handle_request_ratio") 

sim_heartbeat = 102
heartbeat = 0

function before_physics() 
	sim_heartbeat = 300
    
    if dr_nose_gear_depress == 0 then
        markkontakt = 0
    else
        markkontakt = 1
    end
    if dr_rev_handle == 1 then
        if markkontakt == 1 then
            if dr_rev_status == 0 then
                rev_cmd:once()
            end
        else
            if dr_rev_status == 1 then
                rev_cmd:once()
            end
        end
    end
    if dr_rev_handle == 0 then
        if dr_rev_status == 1 then
            rev_cmd:once()
        end
    end
	sim_heartbeat = 310
    -- ibland startar spelet med flaps ute, detta fixar det
    dr_flap = 0
    
	sim_heartbeat = 399
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end