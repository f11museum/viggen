-------------------------------------------------------
----
---- F11 Museum 2021 Bengt
-------------------------------------------------------



-- Plugin funktioner

function flight_start() 
	XLuaSetNumber(XLuaFindDataRef("sim/joystick/eq_pfc_yoke"), 1) -- ta bort krysset som dyker upp om man inte har joystick
	
end

function aircraft_unload()

end

function do_on_exit()

end



function before_physics() 

end

function after_physics() 	

end
