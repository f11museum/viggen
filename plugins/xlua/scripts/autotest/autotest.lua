-------------------------------------------------------
---- Stabiliserings system för JAS
---- F11 Museum 2021 Bengt
-------------------------------------------------------
sim_heartbeat = create_dataref("AA/heartbeat/autotest", "number")
sim_heartbeat = 100

dr_FRP = find_dataref("sim/operation/misc/frame_rate_period")
sim_heartbeat = 101
-- input från användaren
-- input från användaren
dr_yoke_roll_ratio = find_dataref("sim/joystick/yoke_roll_ratio") 
dr_yoke_heading_ratio = find_dataref("sim/joystick/yoke_heading_ratio") 
dr_yoke_pitch_ratio = find_dataref("sim/joystick/yoke_pitch_ratio") 

dr_pitch = find_dataref("sim/flightmodel/position/theta") 
dr_acf_vx = find_dataref("sim/flightmodel/position/local_vx") 
dr_acf_vy = find_dataref("sim/flightmodel/position/local_vy") 
dr_acf_vz = find_dataref("sim/flightmodel/position/local_vz") 
dr_acf_roll = find_dataref("sim/flightmodel/position/phi") 
dr_acf_rollrate = find_dataref("sim/flightmodel/position/P") 
dr_acf_pitchrate = find_dataref("sim/flightmodel/position/Q") 
dr_acf_yawrate = find_dataref("sim/flightmodel/position/R") 

sim_heartbeat = 102

dr_airspeed_kts_pilot = find_dataref("sim/flightmodel/position/indicated_airspeed") 
dr_ias = find_dataref("sim/flightmodel/position/indicated_airspeed")
dr_gear = find_dataref("sim/cockpit/switches/gear_handle_status") 
dr_groundspeed = find_dataref("sim/flightmodel/position/groundspeed") 
dr_true_speed = find_dataref("sim/flightmodel/position/true_airspeed") 
dr_mach = find_dataref("sim/flightmodel/misc/machno")

dr_altitude = find_dataref("sim/flightmodel/misc/h_ind") 
sim_altitude = find_dataref("sim/flightmodel/misc/h_ind") 


dr_trim_pitch = find_dataref("sim/flightmodel/controls/elv_trim") 
dr_trim_ail = find_dataref("sim/flightmodel/controls/ail_trim") 

dr_nose_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[0]") 
dr_left_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[1]") 
dr_right_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[2]") 


dr_override_throttles = find_dataref("sim/operation/override/override_throttles") 
dr_throttle_use = find_dataref("sim/flightmodel/engine/ENGN_thro_use") 
dr_throttle = find_dataref("sim/flightmodel/engine/ENGN_thro") 
dr_throttle_burner = find_dataref("sim/flightmodel/engine/ENGN_burnrat") 

sim_heartbeat = 103
-- Egna JAS dataref

aa_autofart = create_dataref("AA/autofart", "number")

function command_set12(phase, duration)
	aa_autofart = 12
end

function command_set15(phase, duration)
	aa_autofart = 15
end
function command_set0(phase, duration)
	aa_autofart = 0
end
sim_heartbeat = 1030

c12 = create_command("AA/autothrottle_set12", "Set AFK to alfa 12", command_set12)
sim_heartbeat = 1031
c15 = create_command("AA/autothrottle_set15", "Set AFK to alfa 15.5", command_set15)
c0 = create_command("AA/autothrottle_set0", "Set AFK to off", command_set0)

sim_heartbeat = 104

debug_th_error = create_dataref("AA/debug/th_error", "number")

debug_th_res = create_dataref("AA/debug/th_res", "number")

aj37_true_alpha = create_dataref("AA/calc/true_alpha", "number")
aj37_flight_angle = create_dataref("AA/calc/flight_angle", "number")
aj37_markkontakt = create_dataref("AA/calc/markkontakt", "number")



sim_heartbeat = 106

-- publika variabler

g_groundContact = 0
g_markkontakt = 0

current_fade_out = 1.0
fade_out = 0.6
-- Plugin funktioner

function flight_start() 
	sim_heartbeat = 200
	
	sim_heartbeat = 299
end

function aircraft_unload()
	dr_override_throttles = 0
	--logMsg("EXIT LUA")
end

function do_on_exit()
    dr_override_throttles = 0
	--logMsg("EXIT LUA")
end

function writecallback()

end



-- Hjälpfunktioner

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


function myGetAlpha() 
	sim_heartbeat = 500
	vx = dr_acf_vx
	vy = dr_acf_vy
	vz = dr_acf_vz
	pitch = dr_pitch
	sim_heartbeat = 501
	length = math.sqrt(vy * vy + vx * vx + vz * vz)
	if (length > 1.0) then
		alpha = math.asin(vy / length)
		alpha = pitch - math.deg(alpha)
		return alpha
	else 
		return 0.0
	end
end

function myGetFlightAngle() 
	
	vx = dr_acf_vx
	vy = dr_acf_vy
	vz = dr_acf_vz
	pitch = dr_pitch
	
	length = math.sqrt(vy * vy + vx * vx + vz * vz)
	if (length > 1.0) then
		angle = math.asin(vy / length)
		return math.deg(angle)
	else 
		return 0.0
	end
end

blink1s = 0
blink05s = 0
blink032s = 0
blink025s = 0
blinktimer = 0




th_cumError = create_dataref("AA/debug/th/th_cumError", "number")
th_lastError = create_dataref("AA/debug/th/th_lastError", "number")
function PIDth(error)
	l_kp = 0.8
	l_ki = 0.06 -- cumulative error
	l_kd = 0.1 --rate error
	-- PID försök 

	elapsedTime = sim_FRP

	--error = lock_pitch - dr_pitch -- determine error
	th_cumError = constrain(th_cumError + error * elapsedTime, -0,5) --compute integral
	rateError = constrain((error - th_lastError)/elapsedTime, -2,2) --compute derivative

	out = l_kp*error + l_ki*th_cumError + l_kd*rateError --PID output               

	th_lastError = error --remember current error

	return out
end

-- Våra program funktioner
sim_FRP = 1
sim_acf_flight_angle = 0
function update_dataref()
	sim_heartbeat = 4100
	local getnumber = XLuaGetNumber

	-- sim_FRP = (sim_FRP*19+ dr_FRP)/20
	sim_FRP = dr_FRP
	-- sim_FRP = 0.011
	if sim_FRP == 0 then 
		sim_FRP = 0.01 
	end
	sim_heartbeat = 4101
	aj37_true_alpha = myGetAlpha()
	sim_heartbeat = 4102
	aj37_flight_angle = myGetFlightAngle()
	
	sim_heartbeat = 4103
	current_fade_out = interpolate(0, 1.0, 500, fade_out, dr_airspeed_kts_pilot )
	current_fade_out = constrain(current_fade_out, fade_out,1.0)
	sim_heartbeat = 4104
	jas_vat_power = 1
	g_markkontakt = 0
	if (dr_nose_gear_depress>0 ) then
		g_markkontakt = g_markkontakt+1
	end
	if (dr_left_gear_depress>0 ) then
		g_markkontakt = g_markkontakt+1
	end
	if (dr_right_gear_depress>0) then
		g_markkontakt = g_markkontakt+1
	end
	aj37_markkontakt = g_markkontakt
end

function myfilter(currentValue, newValue, amp)

	return ((currentValue*amp) + (newValue))/(amp+1)
	
end

function motor(inval, target, spd)
	
	-- Lånad från Nils anim()
	elapsedTime = constrain(sim_FRP, 0,0.040)
	local retval = inval
	
	if inval == target then
		return retval
	else
		if target > inval then
			retval = inval + spd * elapsedTime
			if retval > target then 
				retval = target 
			end
			return retval 
		else
			retval = inval - spd * elapsedTime
			if retval < target then 
				retval = target 
			end
			return retval 
		end
	end
end




knapp = 0
knapp2 = 0
current_th = 0
longpress = 0.0


function calculateThrottle()
	
	if (jas_auto_afk_mode >= 1 and afk_prev_state == 0 ) then
		current_th = dr_throttle[0]
		afk_prev_state = 1
	end
	if (jas_auto_afk_mode == 0) then
		afk_prev_state = 0
	end
		
	
	
	if (dr_gear == 1 and jas_auto_afk_mode == 1) then
		-- Byt läge till alfa12 när landstället fälls ner om afk va aktiv innan
		jas_auto_afk_mode = 2
		jas_pratorn_tal_alfa12 = 1
	end
	
	if (dr_gear == 0 and jas_auto_afk_mode >= 2) then
		-- Byt läge till vanlig afk om stället fälls upp igen
		jas_auto_afk_mode = 1
		jas_auto_afk = dr_airspeed_kts_pilot
		if (jas_auto_afk<172) then
			jas_auto_afk = 172
		end
	end
	
	--dr_override_throttles = 1
	alpha_prev = myfilter(alpha_prev, sim_true_alpha, 100)
	if (jas_auto_afk_mode == 1) then
		
		
		
	elseif (jas_auto_afk_mode == 2 and jas_a14 == 0) then
		--alfa 12
		
		alpha_delta = 11.8-alpha_prev
		jas_auto_afk = dr_airspeed_kts_pilot - alpha_delta*10
		jas_auto_afk = myfilter(speed_prev, jas_auto_afk, 100)
		speed_prev = jas_auto_afk
		

	elseif (jas_auto_afk_mode >= 2 and jas_a14 == 1) then
		-- alfa 14
		
		alpha_delta = 13.8-alpha_prev
		jas_auto_afk = dr_airspeed_kts_pilot - alpha_delta*10
		jas_auto_afk = myfilter(speed_prev, jas_auto_afk, 100)
		speed_prev = jas_auto_afk
		
	else
		
		
	end
	
	if (jas_auto_afk >= 1 and jas_auto_afk_mode >= 1) then
		
		dr_override_throttles = 1
		
		error = jas_auto_afk - dr_airspeed_kts_pilot
		
		demand = constrain(PIDth(error), 0.0,1.0)
		dr_throttle_use[0] = demand
		dr_throttle_burner[0] = constrain( (demand-0.9)*10, 0.0,1.0)
		
		if (dr_throttle[0]>current_th+0.1 or dr_throttle[0]<current_th-0.1) then
			-- stäng av auto throttle om någon rör vid gasen
			jas_auto_afk_mode = 0
		end
	else
		dr_override_throttles = 0
		--dr_throttle_use[0] = dr_throttle[0]
	end
end

gas = 0

function autopilot()
	-- autopilot_hold_alti = dr_altitude
	sim_heartbeat = 3060
	if (jas_auto_mode == 3) then
		delta = aj37_flight_angle
		-- if (delta>0.1) then
		-- 	dr_trim_pitch = dr_trim_pitch - delta*0.00002
		-- elseif (delta < -0.1) then
		-- 	dr_trim_pitch = dr_trim_pitch - delta*0.00002
		-- end
		dr_trim_pitch = dr_trim_pitch - delta*0.0005
		dr_trim_pitch = constrain(dr_trim_pitch, -1.0,1.0)
	end
	sim_heartbeat = 3061
	if (aa_autofart == 12) then
		-- AFK på alfa 12
		error = aj37_true_alpha - 12.0
		res = PIDth(error)
    res = error + 0.6
		sim_heartbeat = 30611
		debug_th_error = res

		dr_override_throttles = 1
		
		--error = jas_auto_afk - dr_airspeed_kts_pilot
		
		demand = constrain(res, 0.2,1.0)
    debug_th_res = demand
		dr_throttle_use[0] = demand
		--dr_throttle_burner[0] = constrain( (demand-0.9)*10, 0.0,1.0)
	end
	sim_heartbeat = 3062
	if (aa_autofart == 15) then
		-- AFK på alfa 12
		error = aj37_true_alpha - 15.0
		res = PIDth(error)
    error = aj37_true_alpha - 15.5
		
    res = error + 0.6
		sim_heartbeat = 30631
		debug_th_error = res

		dr_override_throttles = 1
		
		--error = jas_auto_afk - dr_airspeed_kts_pilot
		
		demand = constrain(PIDth(error), 0.2,1.0)
debug_th_res = demand
		dr_throttle_use[0] = demand
		--dr_throttle_burner[0] = constrain( (demand-0.9)*10, 0.0,1.0)
	end
	if (aa_autofart == 0) then
		dr_override_throttles = 0
	end
	sim_heartbeat = 3063
end


heartbeat = 0
function before_physics() 
	sim_heartbeat = 300
	
	sim_heartbeat = 301

	sim_heartbeat = 302
	update_dataref()
	sim_heartbeat = 303
	
	sim_heartbeat = 304

	sim_heartbeat = 305

	sim_heartbeat = 306
	autopilot()
  
	sim_heartbeat = 307

  
	sim_heartbeat = 312


	sim_heartbeat = 399
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end

-- function after_physics() 	
-- 
-- end
sim_heartbeat = 199
