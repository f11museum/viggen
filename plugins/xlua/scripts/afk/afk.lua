-- 

sim_heartbeat = create_dataref("AJ37/system/afk/heartbeat", "number")
sim_heartbeat = 10
function myfilter(currentValue, newValue, amp)

	return ((currentValue*amp) + (newValue))/(amp+1)
	
end
sim_heartbeat = 100

aj37_afk_alfa = create_dataref("AJ37/afk/alfa", "number")

aj37_afk_debug = create_dataref("AJ37/afk/debug", "number")
aj37_afk_demand = create_dataref("AJ37/afk/demand", "number")
aj37_afk_error = create_dataref("AJ37/afk/error", "number")

jas_button_afk = find_dataref("JAS/io/frontpanel/knapp/afk")
jas_button_alfa = find_dataref("JAS/io/frontpanel/knapp/alfa")

jas_lamps_afk = find_dataref("JAS/io/frontpanel/lamp/afk")
jas_lamps_a14 = find_dataref("JAS/io/frontpanel/lamp/a14")

jas_auto_afk = find_dataref("JAS/autopilot/afk")
jas_auto_afk_mode = find_dataref("JAS/autopilot/afk_mode")

jas_a14 = find_dataref("JAS/a14")

dr_override_throttles = find_dataref("sim/operation/override/override_throttles") 
dr_throttle_use = find_dataref("sim/flightmodel/engine/ENGN_thro_use") 
dr_throttle = find_dataref("sim/flightmodel/engine/ENGN_thro") 
dr_throttle_burner = find_dataref("sim/flightmodel/engine/ENGN_burnrat") 

dr_gear = find_dataref("sim/cockpit/switches/gear_handle_status") 
dr_airspeed_kts_pilot = find_dataref("sim/flightmodel/position/indicated_airspeed") 


dr_pitch = find_dataref("sim/flightmodel/position/theta") 
dr_acf_vx = find_dataref("sim/flightmodel/position/local_vx") 
dr_acf_vy = find_dataref("sim/flightmodel/position/local_vy") 
dr_acf_vz = find_dataref("sim/flightmodel/position/local_vz") 

dr_parking_brake = find_dataref("sim/cockpit2/controls/parking_brake_ratio")
dr_FRP = find_dataref("sim/operation/misc/frame_rate_period")

sim_heartbeat = 103
-- Lokala variabler

sim_FRP = 0.25
function update_dataref()
	sim_FRP = (sim_FRP*19+ dr_FRP)/20
	if sim_FRP == 0 then 
		sim_FRP = 0.25 
	end
end
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
	sim_heartbeat = 502
	if (length > 1.0) then
		alpha = math.asin(vy / length)
		alpha = pitch - math.deg(alpha)
		sim_heartbeat = 503
		return alpha
	else 
		sim_heartbeat = 504
		return 0.0
	end
end

th_cumError = 0
th_lastError = 0
function PIDth(error)
	sim_heartbeat = 400
	l_kp = 0.07
	l_ki = 0.05
	l_kd = 0.1
	-- PID försök 
	sim_heartbeat = 401
	elapsedTime = sim_FRP
	sim_heartbeat = 402
	--error = lock_pitch - dr_pitch -- determine error
	th_cumError = constrain(th_cumError + error * elapsedTime, -10,10) --compute integral
	rateError = constrain((error - th_lastError)/elapsedTime, -10,10) --compute derivative
	sim_heartbeat = 403

	out = 0.5 + l_kp*error + l_ki*th_cumError + l_kd*rateError --PID output               
	sim_heartbeat = 404

	th_lastError = error --remember current error
	sim_heartbeat = 405

	return out
end

function flight_start() 
	sim_heartbeat = 200

	
end

function aircraft_unload()
	dr_override_throttles = 0
end

function do_on_exit()
	dr_override_throttles = 0
end

knapp = 0
knapp2 = 0
current_th = 0
longpress = 0.0

function update_buttons()
	sim_heartbeat = 600
	
	-- AFK
	if (jas_button_alfa == 1) then
		if (knapp == 0) then
			if (jas_a14 == 0) then
				jas_a14 = 1
			else
				jas_a14 = 0
				jas_pratorn_tal_alfa12 = 1
			end
		end
		knapp = 1
	else
		knapp = 0
	end
	
	
	if (jas_button_afk == 1 ) then
		sim_heartbeat = 601
		
		if (dr_gear == 1) then
			current_th = dr_throttle[0] +0
			jas_auto_afk_mode = 3
			
		else
			current_th = dr_throttle[0] +0
			jas_auto_afk_mode = 1
			jas_auto_afk = dr_airspeed_kts_pilot
			if (jas_auto_afk<172) then
				jas_auto_afk = 172
			end
			

		end
		aj37_afk_debug = current_th
	end
	
	sim_heartbeat = 604
	

end

function update_lamps()

	if (jas_a14 == 1) then
		jas_lamps_a14 = 1
	else
		jas_lamps_a14 = 0
	end
	if (jas_auto_afk_mode >= 1) then
		jas_lamps_afk = 1
	else
		jas_lamps_afk = 0
	end
	
end
aj37_afk_debug1 = create_dataref("AJ37/afk/debug1", "number")

aj37_afk_debug2 = create_dataref("AJ37/afk/debug2", "number")


alpha_filtered = 0
alpha_prev = 0
speed_prev = 150
afk_prev_state = 0


heartbeat = 0
function before_physics() 
	sim_heartbeat = 300
	update_dataref()
	sim_heartbeat = 301
	update_buttons()
	sim_heartbeat = 302
	update_lamps()
	sim_heartbeat = 303
	
	if (jas_auto_afk_mode >= 1 ) then
		if (jas_a14 == 1) then
			aj37_afk_alfa = 15.5
		else 
			aj37_afk_alfa = 12
		end
			
		dr_override_throttles = 1
		
		if (jas_auto_afk_mode == 3 ) then
			sim_heartbeat = 3041
			
			--error = -(aj37_afk_alfa - myGetAlpha() ) * 50
			
			sim_heartbeat = 3042
			alpha_prev = myfilter(alpha_prev, myGetAlpha(), 10)
			alpha_delta = aj37_afk_alfa - alpha_prev
			
			sim_heartbeat = 3043
				
			jas_auto_afk = dr_airspeed_kts_pilot - alpha_delta*10
			sim_heartbeat = 3044
			jas_auto_afk = myfilter(speed_prev, jas_auto_afk, 10)
			sim_heartbeat = 3045
			speed_prev = jas_auto_afk
			sim_heartbeat = 3046
			error = jas_auto_afk - dr_airspeed_kts_pilot
		else
			error = jas_auto_afk - dr_airspeed_kts_pilot
		end
		sim_heartbeat = 305
		aj37_afk_error = error
		sim_heartbeat = 306
		--aj37_afk_debug = PIDth(error)
		sim_heartbeat = 307
		demand = constrain(PIDth(error), 0.0,1.0)
		sim_heartbeat = 308
		aj37_afk_demand = demand
		dr_throttle_use[0] = demand
		dr_throttle_burner[0] = constrain( (demand-0.9)*10, 0.0,1.0)
		aj37_afk_debug1 = dr_throttle[0]
		aj37_afk_debug2 = current_th
		if (dr_throttle[0]>current_th+0.1 or dr_throttle[0]<current_th-0.1) then
			-- stäng av auto throttle om någon rör vid gasen
			jas_auto_afk_mode = 0
		end
		
	else
		dr_override_throttles = 0
		--dr_throttle_use[0] = dr_throttle[0]
	end
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end

sim_heartbeat = 199



	