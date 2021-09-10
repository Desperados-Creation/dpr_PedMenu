ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Menu --
local open = false
local MenuPed = RageUI.CreateMenu("Ped", "INTERACTION")
MenuPed.Display.Header = true
MenuPed.Closed = function()
    open = false
end

function OpenMenuPed() 
    if open then 
        open = false
        RageUI.Visible(MenuPed, false)
        return
    else
        open = true
        RageUI.Visible(MenuPed, true)
        CreateThread(function() 
            while open do 
                RageUI.IsVisible(MenuPed, function()
                    RageUI.Separator("↓     ~p~Apparence     ~s~↓")
                    RageUI.Button("Récupérer mon apparence", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function()
                            getBaseSkin()
                        end
                    })
                    RageUI.Separator("↓     ~p~Ped     ~s~↓")
                    for k,v in pairs(Config.Ped) do
                        RageUI.Button(""..v[1].."", nil, {RightLabel = "~y~→"}, true, {
                            onSelected = function()
                                local model = GetHashKey(v[2])
                                RequestModel(model)
                                while not HasModelLoaded(model) do Wait(1) end
                                SetPlayerModel(PlayerId(), model)
                                SetModelAsNoLongerNeeded(model)
                            end
                        })
                    end
                end)
            Wait(0)
            end
        end)
    end
end

RegisterCommand("ped", function(source, args)
    OpenMenuPed()
end)

-- Function --
function getBaseSkin()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local isMale = skin.sex == 0
        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
            end)
        end)

    end)
end