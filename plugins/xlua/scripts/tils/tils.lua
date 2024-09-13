-------------------------------------------------------
----
---- F11 Museum 2024 Bengt
-------------------------------------------------------

sim_heartbeat = create_dataref("AJ37/heartbeat/tils", "number")
sim_heartbeat = 100


jas_ti_menu_currentmenu = find_dataref("JAS/ti/menu/menu")

-- Knappar
io_aj37_knapp_tils_on = find_dataref("JAS/io/aj37/knapp/tils_on")
io_aj37_knapp_tils_off = find_dataref("JAS/io/aj37/knapp/tils_off")

-- Lampor 
io_aj37_lamp_tils_on = find_dataref("JAS/io/aj37/lamp/tils_on")
io_aj37_lamp_tils_off = find_dataref("JAS/io/aj37/lamp/tils_off")

-- Plugin funktioner

aj37_tils_mode = create_dataref("AJ37/tils/mode", "number")

function flight_start() 

end

function aircraft_unload()

end

function do_on_exit()

end

function checkButtons()
  
  if io_aj37_knapp_tils_on == 1 then
    aj37_tils_mode = 1
  end

  if io_aj37_knapp_tils_off == 1 then    
    aj37_tils_mode = 0
  end
  
  if aj37_tils_mode == 1 then
    io_aj37_lamp_tils_on = 1
    io_aj37_lamp_tils_off = 0
    jas_ti_menu_currentmenu = 3
  else
    io_aj37_lamp_tils_on = 0
    io_aj37_lamp_tils_off = 1
    
    jas_ti_menu_currentmenu = 0
  end
end


sim_heartbeat = 300
heartbeat = 0
function before_physics() 

  sim_heartbeat = 301
  checkButtons()
  
  sim_heartbeat = 399
  sim_heartbeat = heartbeat
  heartbeat = heartbeat + 1
end

function after_physics() 	

end
