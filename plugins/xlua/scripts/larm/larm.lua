-------------------------------------------------------
----
---- F11 Museum 2024 Bengt
-------------------------------------------------------

sim_heartbeat = create_dataref("AJ37/heartbeat/larm", "number")
sim_heartbeat = 100

dr_rev_handle = find_dataref("sim/cockpit2/switches/auto_reverse_on") 
dr_groundspeed = find_dataref("sim/flightmodel/position/groundspeed") 
dr_throttle_pos = find_dataref("sim/cockpit2/engine/actuators/throttle_ratio[0]")

dr_nose_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[0]") 
dr_left_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[1]") 
dr_right_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[2]") 

jas_vat_power = find_dataref("JAS/vat/power")

sim_FRP = find_dataref("sim/operation/misc/frame_rate_period")
dr_mach = find_dataref("sim/flightmodel/misc/machno")

debug1 = create_dataref("AJ37/larm/debug1", "number")
debug2 = create_dataref("AJ37/larm/debug2", "number")
debug3 = create_dataref("AJ37/larm/debug3", "number")
debug4 = create_dataref("AJ37/larm/debug4", "number")

-- Knappar


-- Lampor 
io_aj37_lamp_transsonik = find_dataref("JAS/io/aj37/lamp/transsonik")


-- Plugin funktioner


function flight_start() 

end

function aircraft_unload()

end

function do_on_exit()

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

g_markkontakt = 0

function markKontakt()
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
end


-- Lokala variabler
mach_lo = 0.97
mach_hi = 1.04
mach_pass = 0
mach_mute = 0
function transsonik()
  debug2 = 0
	sim_mach = dr_mach + 0.0
	if (sim_mach > mach_lo and sim_mach < mach_hi and mach_pass == 0) then
		io_aj37_lamp_transsonik = 1
	else 
		io_aj37_lamp_transsonik = 0
	end
  if g_markkontakt > 0 then 
    debug2 = 1
    if (dr_throttle_pos > 0.3 and dr_rev_handle == 1 and dr_groundspeed < 30) then
      debug3 = 1
      io_aj37_lamp_transsonik = 1
      
    end
  end
  
end

sim_heartbeat = 300
heartbeat = 0
function before_physics() 

  sim_heartbeat = 301
  blink1sFunc()
  sim_heartbeat = 302
  markKontakt()
  debug1 = g_markkontakt
  sim_heartbeat = 303 
  transsonik()
  sim_heartbeat = 304
  jas_vat_power = 1
  sim_heartbeat = 305 
  
  
  
  sim_heartbeat = 399
  sim_heartbeat = heartbeat
  heartbeat = heartbeat + 1
end

function after_physics() 	

end
