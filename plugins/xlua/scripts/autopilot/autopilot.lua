-------------------------------------------------------
---- Stabiliserings system för JAS
---- F11 Museum 2021 Bengt
-------------------------------------------------------
sim_heartbeat = create_dataref("AJ37/heartbeat/autopilot", "number")
sim_heartbeat = 100

dr_FRP = find_dataref("sim/operation/misc/frame_rate_period")
sim_heartbeat = 101
-- input från användaren
-- input från användaren
dr_yoke_roll_ratio = find_dataref("sim/joystick/yoke_roll_ratio") 
dr_yoke_heading_ratio = find_dataref("sim/joystick/yoke_heading_ratio") 
dr_yoke_pitch_ratio = find_dataref("sim/joystick/yoke_pitch_ratio") 

dr_override_wheel = find_dataref("sim/operation/override/override_wheel_steer") 
dr_tire_steer = find_dataref("sim/flightmodel2/gear/tire_steer_command_deg[0]") 

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

sim_heartbeat = 103
-- Egna JAS dataref

aj37_true_alpha = create_dataref("AJ37/calc/true_alpha", "number")
aj37_flight_angle = create_dataref("AJ37/calc/flight_angle", "number")
aj37_markkontakt = create_dataref("AJ37/calc/markkontakt", "number")

jas_button_spak = find_dataref("JAS/io/frontpanel/knapp/spak")
jas_button_att = find_dataref("JAS/io/frontpanel/knapp/att")
jas_button_hojd = find_dataref("JAS/io/frontpanel/knapp/hojd")
jas_button_afk = find_dataref("JAS/io/frontpanel/knapp/afk")
jas_button_alfa = find_dataref("JAS/io/frontpanel/knapp/alfa")

sim_heartbeat = 104

jas_lo_spak = find_dataref("JAS/io/frontpanel/lo/spak") 
jas_lo_att = find_dataref("JAS/io/frontpanel/lo/att") 
jas_vat_power = find_dataref("JAS/vat/power") 

jas_lamps_spak = find_dataref("JAS/io/frontpanel/lamp/spak") 
jas_lamps_att = find_dataref("JAS/io/frontpanel/lamp/att") 
jas_lamps_hojd = find_dataref("JAS/io/frontpanel/lamp/hojd")
jas_lamps_ks = find_dataref("JAS/io/frontpanel/lamp/ks")
jas_lamps_afk = find_dataref("JAS/io/frontpanel/lamp/afk")
jas_lamps_a14 = find_dataref("JAS/io/frontpanel/lamp/a14")
sim_heartbeat = 105

jas_auto_mode = find_dataref("JAS/autopilot/mode")
jas_auto_att = find_dataref("JAS/autopilot/att")
jas_auto_alt = find_dataref("JAS/autopilot/alt")
jas_auto_afk = find_dataref("JAS/autopilot/afk")
jas_auto_afk_mode = find_dataref("JAS/autopilot/afk_mode")
jas_auto_ks_mode = find_dataref("JAS/autopilot/ks_mode")
jas_auto_ks_roll = find_dataref("JAS/autopilot/ks_roll")
jas_a14 = find_dataref("JAS/a14")


sim_jas_sys_test = find_dataref("JAS/io/vu22/knapp/syst")

jas_io_pedaler_left = find_dataref("JAS/io/pedaler/left")
jas_io_pedaler_right = find_dataref("JAS/io/pedaler/right")


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

--ATT/HÖJD ska blinka med 650ms, 325ms släckt 325ms tänd
function blink1sFunc()
	blinktimer = blinktimer + sim_FRP
	t2 = math.floor(blinktimer)
	if (t2 % 2 == 0) then
		blink1s = 1
	else 
		blink1s = 0
	end
	t2 = math.floor(blinktimer*2)
	if (t2 % 2 == 0) then
		blink05s = 1
	else 
		blink05s = 0
	end
	t2 = math.floor(blinktimer*3)
	if (t2 % 2 == 0) then
		blink032s = 1
	else 
		blink032s = 0
	end
	t2 = math.floor(blinktimer*4)
	if (t2 % 2 == 0) then
		blink025s = 1
	else 
		blink025s = 0
	end
end


th_cumError = 0
th_lastError = 0
function PIDth(error)
	l_kp = 0.07
	l_ki = 0.05
	l_kd = 0.1
	-- PID försök 

	elapsedTime = sim_FRP

	--error = lock_pitch - dr_pitch -- determine error
	th_cumError = constrain(th_cumError + error * elapsedTime, -10,10) --compute integral
	rateError = constrain((error - th_lastError)/elapsedTime, -10,10) --compute derivative

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

function update_buttons()
	sim_heartbeat = 600
	
	
	sim_heartbeat = 604
	-- SPAK
	if (jas_button_spak == 1) then
		if (knapp == 0) then
			knapp = 1
			if (jas_auto_mode == 1) then
				jas_auto_mode = 0
			else
				jas_auto_mode = 1
				
				jas_pratorn_tal_spak = 1
			end
		end
	else
		knapp = 0
	end
	sim_heartbeat = 605
	koppla_roll = 0
	-- ATT
	if (jas_button_att == 1) then
		autopilot_hold_att = myGetFlightAngle()
		jas_auto_att = autopilot_hold_att
		jas_auto_mode = 2
		koppla_roll = 1
	end
	sim_heartbeat = 606
	-- HÖJD
	if (jas_button_hojd == 1) then
		autopilot_hold_alti = dr_altitude
		jas_auto_alt = autopilot_hold_alti
		jas_auto_mode = 3
		koppla_roll = 1
		
	end
	if (koppla_roll == 1) then
		if (dr_acf_roll <12 and dr_acf_roll >-12) then
			jas_auto_ks_mode = 1
			jas_auto_ks_roll = 0
		else
			jas_auto_ks_mode = 1
			jas_auto_ks_roll = 0 -- dr_acf_roll -- tagit bort tillfälligt, detta känns skumt beteende
		end
		
		if (jas_auto_ks_roll>90 or jas_auto_ks_roll<-90) then
			jas_auto_ks_roll = 0
		end
		maxroll = interpolate(350, 30.0, 600, 60.0, dr_ias* 1.85200 )
		maxroll = constrain(maxroll, 30.0,60.0)
		if (jas_auto_ks_roll>maxroll) then
			jas_auto_ks_roll = maxroll
		end
		if (jas_auto_ks_roll<-maxroll) then
			jas_auto_ks_roll = -maxroll
		end
	end
	
	
	--sim_heartbeat = 699
end

function update_lamps()
	
	
	jas_lamps_spak = 0
	jas_lamps_att = 0
	jas_lamps_hojd = 0
	if (jas_auto_mode == 20) then
		jas_lamps_spak = 1
		jas_lamps_att = blink032s
	end
	if (jas_auto_mode == 30) then
		jas_lamps_spak = 1
		jas_lamps_att = blink032s
		jas_lamps_hojd = blink032s
	end
	if (jas_auto_mode == 1) then
		jas_lamps_spak = 1
	end
	if (jas_auto_mode == 2) then
		jas_lamps_spak = 1
		jas_lamps_att = 1
	end
	if (jas_auto_mode == 3) then
		jas_lamps_spak = 1
		jas_lamps_att = 1
		jas_lamps_hojd = 1
	end
	
	if (jas_auto_mode == 5) then
		jas_lamps_spak = blink032s
		jas_lamps_att = 0
		jas_lamps_hojd = 1
	end
end


function bromsar()
	-- Gör så fotbromsarna bromsar lika mycket höger och vänster i högre hastigheter
	left = 0
	right = 0
	if (dr_groundspeed > 15) then
		total = math.max(jas_io_pedaler_left, jas_io_pedaler_right)
		left = total
		right = total
	else
		left = jas_io_pedaler_left
		right = jas_io_pedaler_right
	end
	
	dr_braking_ratio_left = left
	dr_braking_ratio_right = right
end



sys_test_counter = 0
function systest()
	if (sim_jas_sys_test == 1) then
		sys_test_counter = sys_test_counter +sim_FRP
		time1 = math.floor(sys_test_counter)
		if (time1 == 0) then
			jas_lamps_afk = 0
		end
		if (time1 == 1) then
			jas_lamps_afk = 1
		end
		if (time1 == 2) then
			jas_lamps_afk = 0
		end
		if (time1 == 3) then
			jas_lamps_afk = 1
			sys_test_counter = 0
		end
		if (sys_test_counter > 4) then
			sys_test_counter = 0
		end
	end
end

function autopilot()
	-- autopilot_hold_alti = dr_altitude
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
	
end

deadzone_pedaler = 0.020
max_yaw_rate = 50
sim_acf_yawrate_filtered = 0
function calculateRudder()
  dr_override_wheel = 1
	fadelagg = 1/sim_FRP
  sim_heartbeat = 3071
	machfade = constrain(1.5-dr_mach, 0.1,1)
	sim_heartbeat = 3072
	
	rate_to_deg = (fadelagg*18)/320
	input = 0
	if (dr_yoke_heading_ratio<deadzone_pedaler and dr_yoke_heading_ratio > -deadzone_pedaler) then
		input = 0
		
	else
		-- piloten rör pedaler
		if (dr_yoke_heading_ratio<0) then
			input = dr_yoke_heading_ratio + deadzone_pedaler
		else
			input = dr_yoke_heading_ratio - deadzone_pedaler
		end
		machfade = constrain(1.5-dr_mach, 0.5,1)
	end
  sim_heartbeat = 3073
	d_machfade = machfade
  sim_heartbeat = 3074
	-- Först kollar vi vad piloten vill ha för ändring på rollen, multiplicerat med en faktor för maximal roitationshastighet
	wanted_rate = input * max_yaw_rate
  sim_heartbeat = 30741
	sim_acf_yawrate_filtered = myfilter (sim_acf_yawrate_filtered, dr_acf_yawrate, 2)
  sim_heartbeat = 3075
	-- Kollar vad planet har för nuvarande rotationshastighet 
	current_rate = dr_acf_yawrate
	sim_heartbeat = 3076
	-- räknar ut en skillnad mellan nuvarande rotation och den piloten begär
	delta = -current_rate*0.1
	--if (g_groundContact == 1) then
	--	delta = 0
	--else
	--	delta = -current_rate*0.1
	--end
	
	sim_heartbeat = 3077
	rudder_delta_prev = delta
	
		-- Först kollar vi vad piloten vill ha för ändring på rollen, multiplicerat med en faktor för maximal roitationshastighet
	wanted_rate = input * max_yaw_rate
	
	-- Kollar vad planet har för nuvarande rotationshastighet 
	current_rate = dr_acf_yawrate
	-- räknar ut en skillnad mellan nuvarande rotation och den piloten begär
	delta = wanted_rate-current_rate

	m_rudder = delta*rate_to_deg * current_fade_out * machfade

	
	
	if (sim_jas_auto_mode == 3) then
		m_rudder = 0
	end
	
	-- Noshjulet
	nos = interpolate(0, 45, 20, 1, dr_groundspeed )
	nos_multi = math.abs(constrain(nos, 5,45))
	nos_auto = constrain(m_rudder*0.9, -10,10)
	d_nos = nos_multi
	dr_tire_steer = constrain(input * nos_multi + nos_auto, -45,45)
end

heartbeat = 0
function before_physics() 
	sim_heartbeat = 300
	blink1sFunc()
	sim_heartbeat = 301

	sim_heartbeat = 302
	update_dataref()
	sim_heartbeat = 303
	
	sim_heartbeat = 304
	update_buttons()
	sim_heartbeat = 305
	update_lamps()
	sim_heartbeat = 306
	autopilot()
  
	sim_heartbeat = 307
  calculateRudder()
  
	sim_heartbeat = 312
	systest()

	sim_heartbeat = 399
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end

-- function after_physics() 	
-- 
-- end
sim_heartbeat = 199