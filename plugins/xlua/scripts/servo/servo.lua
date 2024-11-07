-------------------------------------------------------
----
---- F11 Museum 2024 Bengt
-------------------------------------------------------

sim_heartbeat = create_dataref("AJ37/heartbeat/servo", "number")
sim_heartbeat = 100


dr_ias = find_dataref("sim/flightmodel/position/indicated_airspeed")
jas_fuel_pct = find_dataref("JAS/fuel/pct", "number")
sim_heartbeat = 101
io_servo_speed = find_dataref("AJ37/servo/speed")
io_servo_fuel = find_dataref("AJ37/servo/fuel")

sim_heartbeat = 102
debug1 = create_dataref("AJ37/servo/debugRaw", "number")
debug2 = create_dataref("AJ37/servo/debugKmh", "number")
debug3 = create_dataref("AJ37/servo/debugFuel", "number")

sim_heartbeat = 103
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
	servo = 1500
  if kmh < 300 then
    servo = interpolate(150, 800, 300, 1020, kmh)
  
  elseif kmh < 400 then
    servo = interpolate(300, 1020, 400, 1130, kmh)
  
  elseif kmh < 600 then
    servo = interpolate(400, 1130, 600, 1300, kmh)
  
  elseif kmh < 1000 then
    servo = interpolate(600, 1300, 1000, 1600, kmh)
  
  elseif kmh < 1400 then
    servo = interpolate(1000, 1600, 1400, 1850, kmh)
  elseif kmh < 1500 then
    servo = interpolate(1400, 1850, 1500, 1900, kmh)
  
  elseif kmh < 24000 then
    servo = 1900
  end
  debug1 = servo
  debug2 = kmh
  --servo = interpolate(0, 750, 0.89, 2020, servo)
  io_servo_speed = constrain(servo, 750, 1900)
  
end

function servoFuel()
	fuel = jas_fuel_pct
	
  if fuel < 300 then
    servo = interpolate(0, 750, 100, 1885, fuel)
  
  else
    servo = 1000
  
  end
  debug3 = servo
  
  io_servo_fuel = constrain(servo, 750, 2350)
  
end

sim_heartbeat = 300
heartbeat = 0
function before_physics() 

  sim_heartbeat = 301
  servoSpeed()
  sim_heartbeat = 302
  servoFuel()
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
