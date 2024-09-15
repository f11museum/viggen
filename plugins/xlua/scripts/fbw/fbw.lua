
sim_heartbeat = create_dataref("AJ37/heartbeat/fbw", "number")
sim_heartbeat = 100

dr_override_surfaces = find_dataref("sim/operation/override/override_control_surfaces") 


dr_gear_deployratio = find_dataref("sim/flightmodel2/gear/deploy_ratio[0]") 

dr_altitude = find_dataref("sim/flightmodel/misc/h_ind") 
dr_airspeed = find_dataref("sim/flightmodel/position/indicated_airspeed") 
dr_mach = find_dataref("sim/flightmodel/misc/machno")
dr_FRP = find_dataref("sim/operation/misc/frame_rate_period")

dr_acf_pitch = find_dataref("sim/flightmodel/position/theta") 
dr_acf_roll = find_dataref("sim/flightmodel/position/phi") 
dr_acf_hdg = find_dataref("sim/flightmodel/position/psi") 
dr_acf_rollrate = find_dataref("sim/flightmodel/position/P") 
dr_acf_pitchrate = find_dataref("sim/flightmodel/position/Q") 
dr_acf_yawrate = find_dataref("sim/flightmodel/position/R") 
dr_acf_rollrate_acc = find_dataref("sim/flightmodel/position/P_dot") 
dr_acf_pitchrate_acc = find_dataref("sim/flightmodel/position/Q_dot") 
dr_acf_yawrate_acc = find_dataref("sim/flightmodel/position/R_dot") 
dr_acf_vx = find_dataref("sim/flightmodel/position/local_vx") 
dr_acf_vy = find_dataref("sim/flightmodel/position/local_vy") 
dr_acf_vz = find_dataref("sim/flightmodel/position/local_vz") 
dr_groundspeed = find_dataref("sim/flightmodel2/position/groundspeed") 


-- input från användaren
dr_yoke_roll_ratio = find_dataref("sim/joystick/yoke_roll_ratio") 
dr_yoke_heading_ratio = find_dataref("sim/joystick/yoke_heading_ratio") 
dr_yoke_pitch_ratio = find_dataref("sim/joystick/yoke_pitch_ratio") 

dr_elevator_trim = find_dataref("sim/cockpit2/controls/elevator_trim") 


dr_jas_button_spak = find_dataref("JAS/io/frontpanel/knapp/spak") 
dr_jas_button_att = find_dataref("JAS/io/frontpanel/knapp/att") 
dr_jas_button_hojd = find_dataref("JAS/io/frontpanel/knapp/hojd") 
dr_jas_button_afk = find_dataref("JAS/io/frontpanel/knapp/afk")
sim_heartbeat = 104


dr_jas_auto_mode = find_dataref("JAS/autopilot/mode")

jas_fbw_extra_roll = find_dataref("JAS/fbw/extra_roll")
jas_fbw_extra_pitch = find_dataref("JAS/fbw/extra_pitch")
jas_fbw_extra_yaw = find_dataref("JAS/fbw/extra_yaw")

-- Vingar
dr_left_elevator = find_dataref("sim/flightmodel/controls/wing4l_elv1def")
dr_right_elevator = find_dataref("sim/flightmodel/controls/wing4r_elv1def")
dr_left_aileron = find_dataref("sim/flightmodel/controls/wing4l_ail1def")
dr_right_aileron = find_dataref("sim/flightmodel/controls/wing4r_ail1def")
-- dr_left_canard = find_dataref("sim/flightmodel/controls/wing4l_elv2def")
-- dr_right_canard = find_dataref("sim/flightmodel/controls/wing4r_elv2def")
dr_vstab = find_dataref("sim/flightmodel/controls/vstab1_rud1def")


dr_left_canard_flaps = find_dataref("sim/flightmodel/controls/wing1l_fla1def")
dr_right_canard_flaps = find_dataref("sim/flightmodel/controls/wing1r_fla1def")

sim_heartbeat = 101

debug_flaps = create_dataref("AJ37/fbw/flaps", "number")
debug_elv = create_dataref("AJ37/fbw/elv", "number")
debug_ail = create_dataref("AJ37/fbw/ail", "number")
debug_roder = create_dataref("AJ37/fbw/roder", "number")
debug_trim = create_dataref("AJ37/fbw/trim", "number")
debug_mach = create_dataref("AJ37/fbw/fademach", "number")
debug_speed = create_dataref("AJ37/fbw/fadespeed", "number")
debug_vexel = create_dataref("AJ37/fbw/vexel", "number")

sim_heartbeat = 102


-- lokala variabler 
motor_speed_elevator = 45
motor_speed_aileron = 30
s_left_elevator = 0
s_right_elevator = 0

s_left_aileron = 0
s_right_aileron = 0

s_roder = 0
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

function motor(inval, target, spd)
	
	elapsedTime = constrain(dr_FRP, 0,0.040)
	local retval = inval
	-- retval = target
	-- return retval
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

function myGetFlightAngle() 
	
 	vx = dr_acf_vx
	vy = dr_acf_vy
	vz = dr_acf_vz
	pitch = dr_acf_pitch
	
	length = math.sqrt(vy * vy + vx * vx + vz * vz)
	if (length > 1.0) then
		angle = math.asin(vy / length)
		return math.deg(angle)
	else 
		return 0.0
	end
end

function aircraft_unload()
  
  dr_override_surfaces = 0
end

function do_on_exit()
  
  dr_override_surfaces = 0
end


rollvexel = 1
rollvexel_ratio = 0.5
rollvexel_speed = (1-rollvexel_ratio) / 5
function calculateRoll()
  -- Roll
  roll = interpolate(-1, -20, 1, 20.0, dr_yoke_roll_ratio )
  m_vexel = 1
  if (dr_airspeed > 189) then
    m_vexel = rollvexel_ratio
  end
  rollvexel = motor(rollvexel, m_vexel, rollvexel_speed)
  debug_vexel = rollvexel
  -- Vid 350km/h 189knop ska den skifta från högfartsroll till lågfarts roll, under 350km/h ska vi få mer roll utslag, övergången sker under 5s
  roll = roll * rollvexel
  roll = constrain(roll, -20,20.0)
  sim_heartbeat = 3032
  
  debug_ail = roll
  
  return roll
end



rudder_delta_prev = 0
sim_acf_yawrate_filtered = 1

function calculateRudder()
  
  -- ej klart
	fadelagg = 1/sim_FRP
	machfade = constrain(1.5-dr_mach, 0.1,1)

	rate_to_deg = (fadelagg*18)/320
	input = 0
	if (sim_yoke_heading_ratio<deadzone_pedaler and sim_yoke_heading_ratio > -deadzone_pedaler) then
		input = 0
	else
		-- piloten rör pedaler
		if (sim_yoke_heading_ratio<0) then
			input = sim_yoke_heading_ratio + deadzone_pedaler
		else
			input = sim_yoke_heading_ratio - deadzone_pedaler
		end
		machfade = constrain(1.5-dr_mach, 0.5,1)
	end
	d_machfade = machfade
	-- Först kollar vi vad piloten vill ha för ändring på rollen, multiplicerat med en faktor för maximal roitationshastighet
	wanted_rate = input * max_yaw_rate
	sim_acf_yawrate_filtered = myfilter (sim_acf_yawrate_filtered, dr_acf_yawrate, 2)
	-- Kollar vad planet har för nuvarande rotationshastighet 
	current_rate = dr_acf_yawrate
	
	-- räknar ut en skillnad mellan nuvarande rotation och den piloten begär
	delta = -current_rate*0.1

	
	rudder_delta_prev = delta

	-- ## GAMLA roderuträkningen
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
	nos = interpolate(0, 30, 20, 1, dr_groundspeed )
	nos_multi = math.abs(constrain(nos, 5,45))
	nos_auto = constrain(m_rudder*0.9, -10,10)
	d_nos = nos_multi
	dr_tire_steer = constrain(input * nos_multi + nos_auto, -30,30)
	dr_tire_steer2 = input * nos_multi + nos_auto
end

function passThrough()
  sim_heartbeat = 3030
  if (dr_jas_auto_mode > 0) then
    dr_override_surfaces = 1
  else
    dr_override_surfaces = 0
  end
  sim_heartbeat = 3031
  
  fademach = constrain(1.5-dr_mach, 0.9,1)
  debug_mach = fademach
  fadespeed = constrain(interpolate(280, 1, 560, 0.5, dr_airspeed ), 0.6,1)
  debug_speed = fadespeed
  
  roll = calculateRoll()
  
  -- Pitch
  --elevator = interpolate(-1, -15, 1, 30.0, dr_yoke_pitch_ratio )
  if dr_yoke_pitch_ratio >=0 then
    elevator = interpolate(0, 0, 1, 30.0, dr_yoke_pitch_ratio )  
  else
    elevator = interpolate(-1, -15, 0, 0.0, dr_yoke_pitch_ratio )  
  end
  
  if dr_elevator_trim >=0 then
    trim = interpolate(0, 0, 1, 15.0, dr_elevator_trim )  
  else
    trim = interpolate(-1, -10, 0, 0.0, dr_elevator_trim )  
  end
  debug_trim = trim
  elevator = elevator + trim
  elevator = constrain(elevator, -15,30.0)
  debug_elv = elevator
  
  sim_heartbeat = 3032
  
  m_left_elevator = constrain(-elevator + roll, -30,30.0)
  m_right_elevator = constrain(-elevator - roll, -30,30.0)

  m_left_aileron = constrain(s_left_elevator  -jas_fbw_extra_pitch, -30,30.0)  * fademach * fadespeed
  m_right_aileron = constrain(s_right_elevator  -jas_fbw_extra_pitch, -30,30.0) * fademach * fadespeed

  -- m_left_aileron = constrain(m_left_aileron + (roll), -30,30.0) 
  -- m_right_aileron = constrain(m_right_aileron - (roll) , -30,30.0)

  s_left_elevator = motor(s_left_elevator, m_left_elevator, motor_speed_elevator)
  s_right_elevator = motor(s_right_elevator, m_right_elevator, motor_speed_elevator)

  s_left_aileron = motor(s_left_aileron, m_left_aileron, motor_speed_aileron)
  s_right_aileron = motor(s_right_aileron, m_right_aileron, motor_speed_aileron)

  dr_left_elevator = s_left_elevator
  dr_right_elevator = s_right_elevator

  dr_left_aileron = s_left_aileron
  dr_right_aileron = s_right_aileron
    sim_heartbeat = 3035
    
  --Roder
  roder = interpolate(-1, -20, 1, 20.0, dr_yoke_heading_ratio )  
  sim_heartbeat = 30351
  m_roder = constrain(roder, -20,20.0) * fademach * fadespeed
  sim_heartbeat = 30352
  s_roder = motor(s_roder, m_roder, motor_speed_elevator)
  sim_heartbeat = 30353
  
  dr_vstab = s_roder
  sim_heartbeat = 30354
  debug_roder = s_roder
  sim_heartbeat = 30355
  
  -- Nosvingsklaffar  Kan gå -4 eller upp till -7 beroende av last
  flaps = interpolate(0, -4, 1, 30.0, dr_gear_deployratio )
  flaps = constrain(flaps, -7,30.0)
  sim_heartbeat = 3036
  dr_left_canard_flaps = flaps
  dr_right_canard_flaps = flaps
  debug_flaps = flaps
  sim_heartbeat = 3037
end

knapp = 0
knapp2 = 0
current_th = 0



function update_dataref()

	sim_acf_flight_angle = myGetFlightAngle()

end

heartbeat = 0
function before_physics() 
	sim_heartbeat = 300
  update_dataref()
	sim_heartbeat = 301
	sim_heartbeat = 302
	
	sim_heartbeat = 303
	passThrough()
	sim_heartbeat = 304
	sim_heartbeat = 305
	sim_heartbeat = 306
  
	sim_heartbeat = 307
  
	sim_heartbeat = 312

	sim_heartbeat = 399
	sim_heartbeat = heartbeat
	heartbeat = heartbeat + 1
end

function after_physics() 	

end
