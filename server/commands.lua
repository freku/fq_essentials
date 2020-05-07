local _fq = nil

Citizen.CreateThread(function()
    Citizen.Wait(50)
    _fq = exports['fq_essentials']:get_fq_object()
end)

RegisterCommand('kick', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end
    
    if not areCmdsBlocked() then
        TriggerEvent('fq:kickPlayer', source, args)
    end
end, false)

RegisterCommand('ban', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end
    
    if not areCmdsBlocked() then
        TriggerEvent('fq:banPlayer', source, args)
    end
end, false)

RegisterCommand('baninfo', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end

    TriggerEvent('fq:getBanInfo', source, args)
end, false)

RegisterCommand('unban', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end

    if not areCmdsBlocked() then
        TriggerEvent('fq:unbanPlayer', source, args[1])
    end
end, false)

RegisterCommand('mute', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end

    TriggerEvent('fq:mutePlayer', source, args)
end, false)

RegisterCommand('clearchat', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end

    TriggerEvent('fq:clearChatCmd', source, args)
end, false)

RegisterCommand('stopchat', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end

    TriggerEvent('fq:stopChat', source)
end, false)

RegisterCommand('setcd', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end

    if not areCmdsBlocked() then
        TriggerEvent('fq:setChatCooldown', source, args)
    end
end, false)

RegisterCommand('blist', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end

    if not areCmdsBlocked() then
        TriggerEvent('fq:blacklistPlayer', source, args)
    end
end, false)

RegisterCommand('ublist', function(source, args)
    if not _fq.IsPlayerLoggedIn(source) and not isCallerConsole(source) then return end

    if not areCmdsBlocked() then
        TriggerEvent('fq:unblacklistPlayer', source, args)
    end
end, false)


RegisterCommand('blocksvcmds', function(source, args)
    TriggerEvent('fq:blockSvCmds')
end, false)


