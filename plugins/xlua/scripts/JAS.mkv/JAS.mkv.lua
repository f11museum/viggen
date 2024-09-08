

-- 1.12.4 Markkollisionsvarningssystemet (MKV)
-- För föraren presenteras markkollisionsvarning i fyra olika nivåer beroende på vilken grad av
-- manövrering som krävs för att häva tillståndet. Nedan följer en kortfattad förklaring av
-- nivåerna som benämns A, B, C och D.
-- A MKV-symbolen (pilar) tänds upp med fast sken på samtliga indikatorer och pratorvarning
-- ”ta upp” ges under en viss förvarningstid (3 sek i detta fall) innan föraren måste ansätta
-- upptagningsmanöver med motsvarande 80 % av tillgänglig lyftkraft.
-- B MKV-symbolen börjar blinka och höjdvarningslampan tänds när halva denna förvarningstid
-- gått utan att föraren vidtagit åtgärder. I samband med detta så aktiveras den akustiska
-- varningen i form av en tonorgel med max volym. Blinkningarna upphör när tillräcklig åtgärd
-- vidtagits.
-- C Förvarningstiden är slut och MKV symbolen passerar fartvektorsymbolen.
-- 16
-- D Därefter räcker det inte med manövrering enligt förutbestämda värden (a=80 % av MLLgräns). Då börjar MKV-symbolens pilspetsar att växa och den nödvändiga lastfaktorn skrivs ut
-- i numeriska värden vid symbolens nederkant.


sim_mkv_heartbeat = find_dataref("AJ37/heartbeat/mkv") 

sim_mkv_heartbeat = 100

-- Lampor
jas_io_frontpanel_lamp_hojdvarn = find_dataref("JAS/io/frontpanel/lamp/hojdvarn")

-- Knappar
jas_io_vu22_knapp_syst = find_dataref("JAS/io/vu22/knapp/syst")

-- Knappar VU22
jas_io_vu22_sand = find_dataref("JAS/io/vu22/knapp/sand")
jas_io_vu22_rhm = find_dataref("JAS/io/vu22/knapp/rhm")
jas_io_vu22_mkv = find_dataref("JAS/io/vu22/knapp/mkv")
jas_io_vu22_tb = find_dataref("JAS/io/vu22/knapp/termbatt")

-- Lampor VU22
jas_io_vu22_lamp_sand = find_dataref("JAS/io/vu22/lamp/sand")
jas_io_vu22_lamp_rhm = find_dataref("JAS/io/vu22/lamp/rhm")
jas_io_vu22_lamp_mkv = find_dataref("JAS/io/vu22/lamp/mkv")
jas_io_vu22_lamp_tb = find_dataref("JAS/io/vu22/lamp/termbatt")

-- Egna dataref
jas_sys_mkv_eta = find_dataref("AJ37/system/mkv/eta")
aj_sys_mkv_larm = find_dataref("AJ37/system/mkv/larm")
jas_sys_mkv_larm = find_dataref("JAS/system/mkv/larm") -- för HUD
jas_sys_mkv_gneed = find_dataref("JAS/system/mkv/gneed")
jas_sys_mkv_needmore = find_dataref("JAS/system/mkv/needmore")
jas_sys_mkv_lastfaktor = find_dataref("JAS/system/mkv/lastfaktor")

jas_sys_vat_larmmkv = find_dataref("JAS/vat/larm/larmmkv")

jas_sys_larm_okapadrag = find_dataref("JAS/system/larm/okapadrag")

jas_pratorn_tal_taupp = find_dataref("JAS/pratorn/tal/taupp")
jas_pratorn_larm_mkv = find_dataref("JAS/pratorn/larm/mkv")
jas_pratorn_tal_hojd = find_dataref("JAS/pratorn/tal/hojd")

jas_fbw_max_roll_rate = find_dataref("JAS/fbw/max_roll_rate")
jas_auto_mode = find_dataref("JAS/autopilot/mode")

-- debug
d_tid = create_dataref("AJ37/debug/mkv/tid", "number")
d_upprullningstid = create_dataref("JAS/debug/mkv/upprull", "number")
d_gneed = create_dataref("JAS/debug/mkv/gneed", "number")
d_radie = create_dataref("JAS/debug/mkv/radie", "number")
d_vinkel = create_dataref("JAS/debug/mkv/vinkel", "number")
d_vinkel_m = create_dataref("JAS/debug/mkv/vinkel_m", "number")
d_uppalt = create_dataref("JAS/debug/mkv/uppalt", "number")

-- Dataref från x-plane
sim_FRP = find_dataref("sim/operation/misc/frame_rate_period")
sim_radar_alt = find_dataref("sim/flightmodel/position/y_agl")
dr_above_sea_alt = find_dataref("sim/flightmodel/position/elevation")
sim_vy = find_dataref("sim/flightmodel/position/local_vy")
dr_ias = find_dataref("sim/flightmodel/position/indicated_airspeed")
dr_true_speed = find_dataref("sim/flightmodel/position/true_airspeed") -- är i meter/s
dr_throttle = find_dataref("sim/flightmodel/engine/ENGN_thro") 
dr_acf_roll = find_dataref("sim/flightmodel/position/phi") 
dr_alpha = find_dataref("sim/flightmodel/position/alpha") 
dr_acf_pitch = find_dataref("sim/flightmodel/position/theta") 
dr_g_nrml = find_dataref("sim/flightmodel/forces/g_nrml") 

dr_gear = find_dataref("sim/cockpit/switches/gear_handle_status")


sim_mkv_heartbeat = 101



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

blink1s = 0
blink025s = 0
blinktimer = 0
function blink1sFunc()
	sim_heartbeat = 400
	blinktimer = blinktimer + sim_FRP
	t2 = math.floor(blinktimer)
	if (t2 % 2 == 0) then
		blink1s = 1
	else 
		blink1s = 0
	end
	sim_heartbeat = 402
    t2 = math.floor(blinktimer*4)
	if (t2 % 2 == 0) then
		blink025s = 1
	else 
		blink025s = 0
	end
	sim_heartbeat = 499
end


ground_max = 0

speed_prev = 0

--profil1 = {64,128,192,256,320,384,448,512}
profil1 = {}
profil1[1] = 5
profil1[2] = 64
profil1[3] = 128
profil1[4] = 192
profil1[5] = 256
profil1[6] = 320
profil1[7] = 384
profil1[8] = 448
profil1[9] = 512
--profil2 = {128,256,384,512, 640, 768, 896, 1024 1152,1280,1408,1536,1664,1792,1920}


hojd_timer = 0
vinkel_m_prev = 0
eta_prev = 1
skillnad_prev = 1

sand_off = 0
rhm_off = 0
mkv_off = 0
tb_off = 0
kn1 = 0
function vu22()
	sim_mkv_heartbeat = 500
	kn2 = 0
	if (jas_io_vu22_sand == 1) then
		kn2 = 1
		if (kn1 == 0) then
			kn1 = 1
			if (sand_off == 1) then
				sand_off = 0
				if (rhm_off == 1) then
					rhm_off = 0
				end
				if (mkv_off == 1) then
					mkv_off = 0
				end
			else
				sand_off = 1
				if (rhm_off == 0) then
					rhm_off = 1
				end
				if (mkv_off == 0) then
						mkv_off = 1
				end
			end
		end
	end
	sim_mkv_heartbeat = 501
	if (jas_io_vu22_rhm == 1 and sand_off == 0) then
		kn2 = 1
		if (kn1 == 0) then
			kn1 = 1
			if (rhm_off == 1) then
				rhm_off = 0
				if (mkv_off == 1) then
					mkv_off = 0
				end
			else
				rhm_off = 1
				if (mkv_off == 0) then
					mkv_off = 1
				end
			end
		end
	end
	sim_mkv_heartbeat = 502
	if (jas_io_vu22_mkv == 1 and rhm_off == 0) then
		kn2 = 1
		if (kn1 == 0) then
			kn1 = 1
			if (mkv_off == 1) then
				mkv_off = 0
			else
				mkv_off = 1
			end
		end
	end
	sim_mkv_heartbeat = 503
	if (jas_io_vu22_tb == 1) then
		kn2 = 1
		if (kn1 == 0) then
			kn1 = 1
			if (tb_off == 0) then
				tb_off = 1
			else
				tb_off = 0
			end
		end
	end
	sim_mkv_heartbeat = 504
	if (kn2 == 0) then
		kn1 = 0
	end

	sim_mkv_heartbeat = 505
	jas_io_vu22_lamp_sand = sand_off
	sim_mkv_heartbeat = 506
	jas_io_vu22_lamp_rhm = rhm_off
	sim_mkv_heartbeat = 507
	jas_io_vu22_lamp_mkv = mkv_off
	sim_mkv_heartbeat = 508
	jas_io_vu22_lamp_tb = tb_off
	sim_mkv_heartbeat = 509
end

function mkv()

	sim_mkv_heartbeat = 400
	speed = dr_true_speed
	radaralt = sim_radar_alt
	seaalt = dr_above_sea_alt
	gear = dr_gear
	larm = 0
  
  if (dr_gear == 0) then
    tidkvar = sim_radar_alt / sim_vy
    d_tid = tidkvar
  	sim_mkv_heartbeat = 407
    if (tidkvar <0 and tidkvar > -12 ) then
      larm = 1
      jas_sys_mkv_eta = -tidkvar
    end
  end
  sim_mkv_heartbeat = 408
	jas_sys_mkv_larm = larm
	aj_sys_mkv_larm = larm
  
	
	sim_mkv_heartbeat = 499
end


sys_test_counter = 0
function systest()
	sim_mkv_heartbeat = 900
	if (jas_io_vu22_knapp_syst == 1) then
		
		sys_test_counter = sys_test_counter +sim_FRP
		time1 = math.floor(sys_test_counter)
		if (time1 == 0) then
			sim_jas_lamps_mkv = 1
		end
		if (time1 == 1) then
			sim_jas_lamps_mkv = 0
		end
		
		if (time1 >= 2) then
			sys_test_counter = 0
		end
	end
end

heartbeat = 0
function before_physics() 
    sim_mkv_heartbeat = 300
	
	blink1sFunc()
	mkv()
	--systest()
	--vu22()
	sim_mkv_heartbeat = heartbeat
    heartbeat = heartbeat + 1
end

function flight_start() 
	sim_mkv_heartbeat = 200
end

function aircraft_unload()

end

function do_on_exit()

end
sim_mkv_heartbeat = 199
