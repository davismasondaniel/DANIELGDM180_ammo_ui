CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local wait = 500 -- Slow check when not armed

        if IsPedArmed(ped, 4) then -- Only check if holding a firearm
            wait = 100 -- Faster check when aiming/shooting
            local hash = GetSelectedPedWeapon(ped)
            local _, clipAmmo = GetAmmoInClip(ped, hash)
            local totalAmmo = GetAmmoInPedWeapon(ped, hash) - clipAmmo

            SendNUIMessage({
                show = true,
                clip = clipAmmo,
                total = totalAmmo
            })
        else
            SendNUIMessage({ show = false })
        end
        
        Wait(wait)
    end
end)