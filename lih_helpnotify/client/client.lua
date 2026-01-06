function showHelpNotification(msg)
	message = msg
	if message == nil then
		message = "Interagieren"
	end
	triggering = true
end

function hideHelpNotification()
    SendNUIMessage({
        action = 'hideHelpNotification'
    })
end

CreateThread(function()
	while true do
		Wait(20)
		local inMenu = IsPauseMenuActive()
		if triggering and inMenu == false then
			SendNUIMessage({
				text = message,
				action = 'showHelpNotification',
			})
			triggering = false
			Wait(100)
		else
			SendNUIMessage({
				action = 'hideHelpNotification'
			})
			Wait(100)
		end
	end
end)