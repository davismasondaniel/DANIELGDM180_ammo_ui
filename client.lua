local THROWN_GROUP = 1548507267 -- GROUP_THROWN (grenades, sticky, molotov, flares, etc.)
local last = {}

local function send(data)
    -- only message NUI when something changed
    if last.show == data.show and last.clip == data.clip
       and last.total == data.total and last.throwable == data.throwable then
        return
    end
    last = data
    SendNUIMessage(data)
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local wait = 500

        if IsPedArmed(ped, 6) then -- 2 = thrown/projectile, 4 = firearms
            wait = 100
            local hash = GetSelectedPedWeapon(ped)

            if GetWeapontypeGroup(hash) == THROWN_GROUP then
                send({
                    show = true,
                    throwable = true,
                    clip = 0,
                    total = GetAmmoInPedWeapon(ped, hash)
                })
            else
                local _, clipAmmo = GetAmmoInClip(ped, hash)
                send({
                    show = true,
                    throwable = false,
                    clip = clipAmmo,
                    total = math.max(GetAmmoInPedWeapon(ped, hash) - clipAmmo, 0)
                })
            end
        else
            send({ show = false })
        end

        Wait(wait)
    end
end)