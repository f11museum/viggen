-------------------------------------------------------
----
---- F11 Museum 2024 Bengt
-------------------------------------------------------

sim_heartbeat = create_dataref("AJ37/heartbeat/servo", "number")
sim_heartbeat = 100


dr_ias = find_dataref("sim/flightmodel/position/indicated_airspeed")

io_servo_speed = find_dataref("AJ37/servo/speed")


debug1 = create_dataref("AJ37/servo/debug1", "number")


-- Knappar


-- Lampor 


-- Plugin funktioner
function constrain(val, lower, upper)

	if lower > upper then 
		lower, upper = upper, lower 
	end -- swap if boundaries supplied the wrong way
	return math.max(lower, math.min(upper, val))
end

function interpolate(x1, y1, x2, y2, value)
	y = y1 + (y2-y1)/(x2-x1)*(value-x1)
	return y
end

function flight_start() 

end

function aircraft_unload()

end

function do_on_exit()

end


function servoSpeed()
	kmh = dr_ias * 1.852
	servo = kmh
  if kmh < 300 then
    servo = interpolate(150, 0.89, 300, 0.635, kmh)
  
  elseif kmh < 400 then
    servo = interpolate(300, 0.635, 400, 0.51, kmh)
  
  elseif kmh < 600 then
    servo = interpolate(400, 0.51, 600, 0.34, kmh)
  
  elseif kmh < 1000 then
    servo = interpolate(600, 0.34, 1000, 0.12, kmh)
  
  elseif kmh < 1300 then
    servo = interpolate(1000, 0.12, 1300, 0.0, kmh)
  end
  debug1 = kmh
  servo = interpolate(0, 750, 0.89, 2020, servo)
  io_servo_speed = constrain(servo, 700, 2020)
  
end


sim_heartbeat = 300
heartbeat = 0
function before_physics() 

  sim_heartbeat = 301
  servoSpeed()
  sim_heartbeat = 302
  
  sim_heartbeat = 303 
  
  sim_heartbeat = 304
  
  sim_heartbeat = 305 
	
  sim_heartbeat = 306 
	
  sim_heartbeat = 307
  
  
  
  sim_heartbeat = 399
  sim_heartbeat = heartbeat
  heartbeat = heartbeat + 1
end

function after_physics() 	

end
