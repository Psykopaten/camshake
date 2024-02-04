local playerMoving = false
local carMoving = false
local limit = 90

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()

        if not IsPedInAnyVehicle(playerPed, false) then
            local isPlayerMoving = IsPedRunning(playerPed) or IsPedSprinting(playerPed)

            if isPlayerMoving ~= playerMoving then
                playerMoving = isPlayerMoving

                if playerMoving then
                    ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 1.75)
                else
                    StopGameplayCamShaking(false)
                end
            end
        else
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 2.23

            if speed >= 0.5 ~= carMoving then
                carMoving = speed >= 0.5

                if carMoving then
                    ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 0.75)
                else
                    StopGameplayCamShaking(false)
                end
            end
        end

        Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        if DoesEntityExist(vehicle) then
            local currentSpeed = GetEntitySpeed(vehicle) * 2.23
            local overspeed = currentSpeed - limit

            while currentSpeed > limit do
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', overspeed / 500)
                Citizen.Wait(500)
                currentSpeed = GetEntitySpeed(vehicle) * 2.23
                overspeed = currentSpeed - limit
            end
        end
    end
end)
