-- Prat datorn, pratorn

-- Sätter variabler i AJ37/pratorn/* som sedan spelas upp av externt program.
-- Sätt till 1 för att bara spela ljudet en gång
-- Sätt till 2 för att spela repeterande så länge som variabeln är kvar som 2
-- Sätt till 3 för att spela upprepande men med lite längre mellanrum


sim_heartbeat = find_dataref("AJ37/heartbeat/pratornlua") 

sim_heartbeat = 100

-- Tal signaler
jas_pratorn_tal_spak = find_dataref("AJ37/pratorn/tal/spak")
jas_pratorn_tal_taupp = find_dataref("AJ37/pratorn/tal/taupp")
jas_pratorn_tal_okapadrag = find_dataref("AJ37/pratorn/tal/okapadrag")
jas_pratorn_tal_alfa12 = find_dataref("AJ37/pratorn/tal/alfa12")
jas_pratorn_tal_fix = find_dataref("AJ37/pratorn/tal/fix")
jas_pratorn_tal_minskafart = find_dataref("AJ37/pratorn/tal/minskafart")
jas_pratorn_tal_ejtils = find_dataref("AJ37/pratorn/tal/ejtils")
jas_pratorn_tal_hojd = find_dataref("AJ37/pratorn/tal/hojd")
jas_pratorn_tal_marktryckfel = find_dataref("AJ37/pratorn/tal/marktryckfel")
jas_pratorn_tal_transsonik = find_dataref("AJ37/pratorn/tal/transsonik")
jas_pratorn_tal_systemtest = find_dataref("AJ37/pratorn/tal/systemtest")
sim_heartbeat = 101
jas_pratorn_larm_mkv = find_dataref("AJ37/pratorn/larm/mkv")

jas_pratorn_larm_transsonik = find_dataref("AJ37/pratorn/larm/transsonik")
jas_pratorn_larm_gransvarde = find_dataref("AJ37/pratorn/larm/gransvarde")
jas_pratorn_larm_master = find_dataref("AJ37/pratorn/larm/master")
sim_heartbeat = 102
sim_heartbeat = 103
jas_pratorn_larm_gransvarde_g = find_dataref("AJ37/pratorn/larm/gransvarde_g")
sim_heartbeat = 104
-- Knappar
jas_io_vu22_knapp_syst = find_dataref("AJ37/io/vu22/knapp/syst")

-- Egna dataref

jas_sys_mkv_larm = find_dataref("AJ37/system/mkv/larm")
jas_sys_larm_transsonik = find_dataref("AJ37/system/larm/transsonik")
jas_sys_larm_minskafart = find_dataref("AJ37/system/larm/minskafart")
jas_sys_larm_okapadrag = find_dataref("AJ37/system/larm/okapadrag")
jas_sys_larm_master = find_dataref("AJ37/system/larm/master")

-- Dataref från x-plane
dr_FRP = find_dataref("sim/operation/misc/frame_rate_period")
dr_mach = find_dataref("sim/flightmodel/misc/machno")

dr_ias = find_dataref("sim/flightmodel/position/indicated_airspeed")
dr_gear = find_dataref("sim/cockpit/switches/gear_handle_status") 
dr_nose_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[0]") 
dr_left_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[1]") 
dr_right_gear_depress = find_dataref("sim/flightmodel/parts/tire_vrt_def_veh[2]") 
dr_alpha = find_dataref("sim/flightmodel/position/alpha") 
dr_g_nrml = find_dataref("sim/flightmodel/forces/g_nrml") 
sim_heartbeat = 103



-- Lokala variabler
mach_lo = 0.96
mach_hi = 1.04
mach_pass = 0
mach_mute = 0

function flight_start() 
	sim_heartbeat = 200
end

function aircraft_unload()

end

function do_on_exit()

end

function transsonic()
	sim_mach = dr_mach + 0.0
	if (sim_mach > mach_lo and sim_mach < mach_hi and mach_pass == 0) then
			jas_pratorn_larm_transsonik = 1
	end
end

function stall()
	
	if (dr_ias>50 and dr_alpha>18) then
		jas_pratorn_larm_gransvarde = 1
  else
    
  	jas_pratorn_larm_gransvarde = 0
	end
end

function maxg()
	
	if (dr_g_nrml > 6.1) then
		jas_pratorn_larm_gransvarde_g = 1
  else
    jas_pratorn_larm_gransvarde_g = 0
	end
end

sys_test_counter = 0
function systest()
	sim_heartbeat = 900
	if (jas_io_vu22_knapp_syst == 1) then
		
		sys_test_counter = sys_test_counter +dr_FRP
		time1 = math.floor(sys_test_counter)
		if (time1 == 0) then
			jas_pratorn_tal_systemtest = 1
		end
		if (time1 == 1) then
			--jas_pratorn_tal_systemtest = 1
		end
		
		if (time1 >= 2) then
			sys_test_counter = 0
		end
	end
end

transsonik_once = 0

heartbeat = 0
function before_physics() 
	sim_heartbeat = 300
	
	
	stall()
  sim_heartbeat = 301
	maxg()
	sim_heartbeat = 302
	transsonic()
  sim_heartbeat = 303
	if (jas_sys_mkv_larm >= 1) then
    jas_sys_larm_master = 1
	end
  
  sim_heartbeat = 304
	--Minska fart
	if (jas_sys_larm_minskafart >= 1) then
		jas_pratorn_tal_minskafart = 1
		jas_pratorn_larm_transsonik = 1
	end
	
	-- Öka pådrag
	if (jas_sys_larm_okapadrag >= 1) then
		jas_pratorn_tal_okapadrag = 1
		--jas_pratorn_larm_gransvarde = 1
	end
	
	-- Huvudvarning
	if (jas_sys_larm_master >=1) then
		jas_pratorn_larm_master = 2
    jas_sys_larm_master = 0
	else
		jas_pratorn_larm_master = 0
	end
	
	systest()
	sim_heartbeat = heartbeat
    heartbeat = heartbeat + 1
end

sim_heartbeat = 199
