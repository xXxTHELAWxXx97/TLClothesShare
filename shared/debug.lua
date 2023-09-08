function Debug(etype, msg)
    if config.debug then
        if config.debugmethod == 'TLdevtools' then
            local rstate = GetResourceState('TLdevtools')
            if rstate == 'started' then
                exports['TLdevtools']:NewLog(etype, msg)
            elseif rstate == 'missing' then
                print('TLdevtools is missing, please install it or change debug to false in config.lua')
            else
                print('Starting TLdevtools')
                StartResource('TLdevtools')
                local t = GetGameTimer()
                while true do
                    Citizen.Wait(0)
                    if GetGameTimer() - t > 10000 then
                        print('TLdevtools failed to start, please install it or change debug to false in config.lua')
                        break
                    elseif GetResourceState('TLdevtools') == 'started' then
                        exports['TLdevtools']:NewLog(etype, msg)
                        break
                    end
                end
            end
        elseif config.debugmethod == 'print' then
            print(etype .. ': ' .. msg)
        end
    end
end