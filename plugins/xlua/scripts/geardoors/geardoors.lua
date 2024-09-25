sim_heartbeat = create_dataref("AJ37/heartbeat/geardoors", "number")
sim_heartbeat = 100

sim_door_n = create_dataref("AJ37/geardoors/nose", "number")
sim_door_l = create_dataref("AJ37/geardoors/left", "number")
sim_door_r = create_dataref("AJ37/geardoors/right", "number")

dr_door_n = find_dataref("sim/aircraft/parts/acf_gear_deploy[0]")
dr_door_l = find_dataref("sim/aircraft/parts/acf_gear_deploy[2]")
dr_door_r = find_dataref("sim/aircraft/parts/acf_gear_deploy[1]")



sim_heartbeat = 102
heartbeat = 0

function interpolate(x1, y1, x2, y2, value)
	y = y1 + (y2-y1)/(x2-x1)*(value-x1)
	return y
end

function flight_start() 
	sim_heartbeat = 200

end

function before_physics() 
	sim_heartbeat = 300
	
	if (dr_door_l > 0 and dr_door_l<0.1) then
		sim_door_l = interpolate(0, 0, 0.1, 1, dr_door_l)
	end
	if (dr_door_l > 0.8 and dr_door_l<=1) then
		sim_door_l = interpolate(0.8, 1.0, 1.0 ,0.0, dr_door_l)
	end
	if (dr_door_r > 0 and dr_door_r<0.1) then
		sim_door_r = interpolate(0, 0, 0.1, 1, dr_door_r)
	end
	if (dr_door_r > 0.8 and dr_door_r<=1) then
		sim_door_r = interpolate(0.8, 1.0, 1.0 ,0.0, dr_door_r)
	end  
	
	if (dr_door_n > 0 and dr_door_n<0.1) then
		sim_door_n = interpolate(0, 0, 0.1, 1, dr_door_n)
	end
	if (dr_door_n >= 0.1) then
		sim_door_n = 1
	end
	
	sim_heartbeat = 310

	sim_heartbeat = 399
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end