local playerSteamIDs = {} -- [playerid] = steamid

local ESXs = exports['fq_callbacks']:getServerObject()

local CFG = getCFG()
local mCFG = CFG.msg.pl

local _fq = nil

local chat = {
    gangColors = { 6, 2, 3, 1, 0 },
    -- rankColors = { 8, 1, 4, 0, 5 },
    
    isStopped = false,
    stopTime = nil,
    resetChatStopTime = 2.5, -- in minutes
    mutedList = {}, -- [login] = {czas, reason}

    cooldownBetweenMessages = 5, -- in seconds
    lastMessages = {}, -- [player_id] == last_msg_time

    cmdsBlocked = false
}

Citizen.CreateThread(function()
    Citizen.Wait(50)
    _fq = exports['fq_essentials']:get_fq_object()
end)

RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('fq:setPlayerSteamID')
RegisterNetEvent('fq:print')
RegisterNetEvent('fq:kickMe')
RegisterNetEvent('fq:mutePlayer')
RegisterNetEvent('fq:clearChatCmd')
RegisterNetEvent('fq:stopChat')
RegisterNetEvent('fq:kickPlayer')
RegisterNetEvent('fq:banPlayer')
RegisterNetEvent('fq:unbanPlayer')
RegisterNetEvent('fq:setChatCooldown')
RegisterNetEvent('fq:blockSvCmds')
RegisterNetEvent('fq:getBanInfo')
RegisterNetEvent('fq:blacklistPlayer')
RegisterNetEvent('fq:unblacklistPlayer')

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    -- print('^3[fq_ess] Loading files...^7\n')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    -- print('^3[fq_ess] Saving ...^7\n')
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
end)

AddEventHandler('playerDropped', function()
    if playerSteamIDs[source] then
        playerSteamIDs[source] = nil
    end

    if chat.mutedList[_fq.GetPlayerLogin(source)] then
        chat.mutedList[_fq.GetPlayerLogin(source)] = nil
    end

    if chat.lastMessages[source] then
        chat.lastMessages[source] = nil
    end

    -- DropPlayer(source)
end)

AddEventHandler('_chat:messageEntered', function(author, color, message)
    local source = source 
    if not message or not author then
        return
    end

    if not _fq.IsPlayerLoggedIn(source) then return end

    local rank = getPlayerGroupName(_fq.GetPlayerAccID(source))
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.chat.unlimited')
    if rank then
        -- if rank == 'Default' then
        if not hasPermission then
            if chat.isStopped then
                -- TriggerClientEvent('chatMessage', source, '',  { 255, 255, 255 }, mCFG.CHAT.turned_off)
                TriggerClientEvent('fq:printTranslated', source, 'CHAT', 'turned_off')
                return
            end
            
            local playerLogin = _fq.GetPlayerLogin(source)
            if not processMute(playerLogin) then
                -- TriggerClientEvent('chatMessage', source, '',  { 255, 255, 255 }, string.format(mCFG.CHAT.muted, chat.mutedList[playerLogin][2], os.date("%H:%M:%S %d-%m-%Y", chat.mutedList[playerLogin][1])))
                TriggerClientEvent('fq:printTranslated', source, 'CHAT', 'muted', {chat.mutedList[playerLogin][2], os.date("%H:%M:%S %d-%m-%Y", chat.mutedList[playerLogin][1])})
                return
            end

            -- chat slowmode system
            if not chat.lastMessages[source] then
                chat.lastMessages[source] = os.time()
            else
                local diff = os.difftime(os.time(), chat.lastMessages[source])

                if diff <= chat.cooldownBetweenMessages then
                    -- TriggerClientEvent('chatMessage', source, '',  { 255, 255, 255 }, '^1Slowmode left: '..chat.cooldownBetweenMessages - diff..' seconds.')
                    -- TriggerClientEvent('chatMessage', source, '',  { 255, 255, 255 }, mCFG.CHAT.cd_left:format(chat.cooldownBetweenMessages - diff))
                    TriggerClientEvent('fq:printTranslated', source, 'CHAT', 'cd_left', {chat.cooldownBetweenMessages - diff})
                    return
                else
                    chat.lastMessages[source] = os.time()
                end
            end
        end
    end
                                        --    ///// FREKU0 DOESNT GET HEADADMIN PREFIX, ONLY DEFAULT. FIX IT ////
    if not WasEventCanceled() then
        local groupName = getPlayerPrefix(getPlayerGroupName(_fq.GetPlayerAccID(source)))
        message = parseChatMessage(source, groupName, author, message)

        TriggerClientEvent('chatMessage', -1, '',  { 255, 255, 255 }, message)
    end
end)

AddEventHandler('fq:setPlayerSteamID', function(src, steamid)
    if source ~= '' or not src or not steamid then
        return        
    end

    playerSteamIDs[src] = steamid
end)

AddEventHandler('fq:print', function(msg) -- remove it later
    print(msg)
end)

AddEventHandler('fq:vanishPlayer', function(args) -- p: essentials.command.vanish
    -- local hasPermission = isAllowed(source, 2)
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.vanish')

    if not hasPermission and not isCallerConsole(source) then
        -- TriggerClientEvent('fq:sendLocalMsg', source, mCFG.ESS.no_perm)
        TriggerClientEvent('fq:printTranslated', source, 'ESS', 'no_perm')
        return
    end

    local switch = args[1] == 'on' and true or (args[1] == 'off' and false or nil)

    if switch then
        exports['fq_player']:updateStats(source, 4, 'set', switch)
        correctOutput(source, '^4Vanish mode: ' .. switch and 'on' or 'off')
    else
        correctOutput(source, mCFG.ESS.vanish_usage)
    end
end)

-- update it for DB bans
AddEventHandler('fq:getBanInfo', function(src, args) -- p: essentials.command.baninfo
    if not isCallerConsole(source) then return end
    
    local source = src
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.baninfo')

    if not hasPermission and not isCallerConsole(source) then
        correctOutput(source, mCFG.ESS.no_perm)
        return
    end

    local login = args[1] or nil
    local query = "SELECT login,id_ban,id_banning,id_banned,banning_nick,banned_nick,reason,UNIX_TIMESTAMP(ban_time)+3600 AS ban_time,UNIX_TIMESTAMP(unban_time)+3600 AS unban_time,is_perm,is_unbanned,is_all_banned FROM tbl_bans AS b INNER JOIN tbl_accounts AS a ON b.id_banned=a.id_account WHERE a.login=@login AND b.is_unbanned=0"

    if login then
        MySQL.Async.fetchAll(
            query, {
                ['@login'] = login
            }, function(res)
                if not next(res) then
                    correctOutput(source, mCFG.ESS.binfo_not_banned)
                else
                    local a = res[1]
                    local msg = string.format("^1INFO: ^3Player ^2%s^3:^2%s^3(^2%s^3) banned by ^2%s^3(^2%s^3) for ^4%s ^1| ^3Date: ^2%s ^3Unbun: ^2%s^7",
                        a.login, a.banned_nick, a.id_banned, a.banning_nick, a.id_banning, a.reason, os.date("%Y-%m-%d %H:%M:%S", a.ban_time),
                        os.date("%Y-%m-%d %H:%M:%S", a.unban_time))
                    correctOutput(source, msg)
                end
            end
        )
    else
        correctOutput(source, mCFG.ESS.binfo_pass_login)
    end
end)

AddEventHandler('fq:blockSvCmds', function()
    if isCallerConsole(source) then
        chat.cmdsBlocked = not chat.cmdsBlocked
        print(chat.cmdsBlocked and '^1SV COMMANDS BLOCKED^7\n' or '^5SV COMMANDS UNBLOCKED^7\n')
    end
end)

AddEventHandler('fq:setChatCooldown', function(src, args) -- p: essentials.command.setcd
    if not isCallerConsole(source) then return end

    local source = src
    
    if areCmdsBlocked() then return end
    
    -- local hasPermission = isAllowed(source, 2)
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.setcd')

    if not hasPermission and not isCallerConsole(source) then
        TriggerClientEvent('fq:sendLocalMsg', source, mCFG.ESS.no_perm)
        return
    end

    local new_cd = tonumber(args[1]) or nil

    if new_cd then
        if new_cd < 20 then
            chat.cooldownBetweenMessages = new_cd
        else
            correctOutput(source, mCFG.ESS.set_cd_too_long_time)
        end
    else
        correctOutput(source, mCFG.ESS.setcd_usage)
    end
end)

AddEventHandler('fq:mutePlayer', function(src, args) -- p: essentials.command.mute
    if not isCallerConsole(source) then return end
    
    local source = src
    
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.mute')

    if not hasPermission and not isCallerConsole(source) then
        TriggerClientEvent('fq:sendLocalMsg', source, mCFG.ESS.no_perm)
        return
    end

    if #args < 2 then
        correctOutput(source, mCFG.ESS.mute_usage)
        return
    end

    -- local playerToMuteID = tonumber(args[1]) or nil
    -- _fq.GetPlayerByLogin(loginToBan).svID
    local playerToMuteLogin = args[1] or nil
    local playerData = _fq.GetPlayerByLogin(playerToMuteLogin)
    local time = parseTimeForBan(args[2]) or nil

    local adminName = not isCallerConsole(source) and GetPlayerName(source) or 'CONSOLE'
    
    table.remove(args, 1)
    table.remove(args, 1)

    local reason = table.concat(args, ' ')
    reason = #args > 0 and reason or '*not set*'

    if playerToMuteLogin then
        if not playerData then
            if time then
                chat.mutedList[playerToMuteLogin] = {time, reason} -- change key every where
                -- correctOutput(source, '^3You muted player '..GetPlayerName(playerData.svID)..'!')
                correctOutput(source, mCFG.ESS.admin_mute_msg:format(GetPlayerName(playerData.svID)))
                -- TriggerClientEvent('chatMessage', playerData.svID, '',  { 255, 255, 255 }, '^3You/ve been muted by '..adminName..'!')
                -- TriggerClientEvent('chatMessage', playerData.svID, '',  { 255, 255, 255 }, mCFG.ESS.muted_by_msg:format(adminName))
                TriggerClientEvent('fq:printTranslated', playerData.svID, 'ESS', 'muted_by_msg', {adminName})
            else
                correctOutput(source, mCFG.ESS.parser_error)
                return
            end
        else
            correctOutput(source, mCFG.ESS.mute_player_not_online)
            return
        end
    else
        correctOutput(source, mCFG.ESS.mute_usage)
        return
    end
end)

AddEventHandler('fq:clearChatCmd', function(src, args) -- p: essentials.command.clearchat
    if not isCallerConsole(source) then return end
    
    local source = src
    
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.clearchat')

    if not hasPermission and not isCallerConsole(source) then
        TriggerClientEvent('fq:sendLocalMsg', source, mCFG.ESS.no_perm)
        return
    end

    TriggerClientEvent('chatMessage', -1, '',  { 255, 255, 255 }, '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n')
    -- TriggerClientEvent('chatMessage', -1, '',  { 255, 255, 255 }, mCFG.ESS.clear_chat_msg)
    TriggerClientEvent('fq:printTranslated', -1, 'ESS', 'clear_chat_msg')    
end)

AddEventHandler('fq:stopChat', function(src, args) -- p: essentials.command.stopchat
    if not isCallerConsole(source) then return end
    local source = src
    
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.stopchat')

    if not hasPermission and not isCallerConsole(source) then
        TriggerClientEvent('fq:sendLocalMsg', source, mCFG.ESS.no_perm)
        return
    end

    if chat.isStopped then
        -- TriggerClientEvent('chatMessage', -1, '',  { 255, 255, 255 }, mCFG.ESS.stopchat_wlaczony)
        TriggerClientEvent('fq:printTranslated', -1, 'ESS', 'stopchat_wlaczony')
        chat.stopTime = nil
    else
        -- TriggerClientEvent('chatMessage', -1, '',  { 255, 255, 255 }, mCFG.ESS.stopchat_wylaczony)
        TriggerClientEvent('fq:printTranslated', -1, 'ESS', 'stopchat_wylaczony')
        chat.stopTime = os.time()

        -- if nobody cancels stopped chat, it automatically does after x minutes

        --           /// ZMIENIC TO LUB USUNAC /// MOZLIWE ZE DZIALA NIEPRAWIDLOWO
        Citizen.SetTimeout(chat.resetChatStopTime * 1000 * 60, function()
            if chat.stopTime then
                chat.isStopped = false
                chat.stopTime = nil
                -- TriggerClientEvent('chatMessage', -1, '',  { 255, 255, 255 }, '^3^*Czat zostal wlaczony!')
                TriggerClientEvent('fq:printTranslated', -1, 'ESS', 'stopchat_wlaczony')
            end
        end)
    end
    chat.isStopped = not chat.isStopped
end)

AddEventHandler('fq:kickPlayer', function(src, args) -- p: essentials.command.kick
    if not isCallerConsole(source) then return end
    local source = src
    if areCmdsBlocked() then return end
    
    local isAllowed = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.kick') 

    if not isAllowed and not isCallerConsole(source) then
        correctOutput(source, mCFG.ESS.no_perm)
        return
    end

    local playerToKickID = tonumber(args[1]) or nil
    
    local Nargs = removeNFirstElements(args, 1)
    
    local reason = #Nargs > 0 and table.concat(Nargs, ' ') or 'Has not been set'
    local kicker = isCallerConsole(source) and 'CONSOLE' or GetPlayerName(source)
    reason = "Kicked by: " .. kicker .. "\nReason: " .. reason

    local kickingGroup = kicker ~= 'CONSOLE' and getPlayerGroupName(_fq.GetPlayerAccID(src)) or 'HeadAdmin'
    local kickedGroup = playerSteamIDs[playerToKickID] and getPlayerGroupName(_fq.GetPlayerAccID(playerToKickID)) or 'Default'

    if playerToKickID then
        if playerSteamIDs[playerToKickID] then
            -- if higherRankCheck(source) then return end
            if not isGroupPowerHigher(kickingGroup, kickedGroup) and not isCallerConsole(source) then return end

            DropPlayer(playerToKickID, reason)
            -- TriggerClientEvent('chat:addMessage', -1, {
            --     args = {string.format(mCFG.ESS.kick_all_msg, playerToKickID, reason)}
            -- })
            TriggerClientEvent('fq:printTranslated', -1, 'ESS', 'kick_all_msg', {playerToKickID, reason})
        else
            correctOutput(source, mCFG.ESS.kick_player_offline)
        end
    else
        correctOutput(source, mCFG.ESS.kick_pass_player_id) 
    end
end)

AddEventHandler('fq:banPlayer', function(_src, args) -- p: essentials.command.ban
    if areCmdsBlocked() then return end

    if not isCallerConsole(source) then return end 

    local source = _src
    local hasPermission = hasPermission(_fq.GetPlayerAccID(_src), 'essentials.command.ban') 

    if not hasPermission and not isCallerConsole(source) then
        correctOutput(source, mCFG.ESS.no_perm)
        return
    end
    
    if #args < 3 then
        correctOutput(source, mCFG.ESS.ban_usage)
        return
    end
    
    local loginToBan = args[1] or nil -- account login to ban
    local time = parseTimeForBan(args[2]) or nil
    
    local banningID = _fq.GetPlayerAccID(source) or -1
    local bannedID

    local banningNick = not isCallerConsole(source) and GetPlayerName(source) or 'CONSOLE'
    -- local bannedNick = _fq.GetPlayerAccID(_fq.GetPlayerByLogin(loginToBan).svID) and GetPlayerName() or 'OFFLINE'
    local bannedNick
    
    if _fq.GetPlayerByLogin(loginToBan) then
        bannedNick = GetPlayerName(_fq.GetPlayerByLogin(loginToBan).svID)
    else
        bannedNick = 'OFFLINE'
    end

    local Nargs = removeNFirstElements(args, 2)

    local _reason = (#Nargs > 0 and table.concat(Nargs, ' ') or 'reason not given')

    local kickingGroup = banningNick ~= 'CONSOLE' and getPlayerGroupName(_fq.GetPlayerAccID(source)) or 'HeadAdmin'
    local kickedGroup = bannedNick ~= 'OFFLINE' and getPlayerGroupName(_fq.GetPlayerByLogin(loginToBan).accID) or 'Default'

    local data

    if loginToBan then
        if time then
            if not isGroupPowerHigher(kickingGroup, kickedGroup) and not isCallerConsole(source) then
                correctOutput(source, mCFG.ESS.too_low_rank)
                return
            end

            -- local hasBanned = nil
            MySQL.Async.fetchAll(
                "SELECT id_account, login FROM tbl_accounts WHERE login=@login", {
                    ['@login'] = loginToBan
                }, function(res1)
                    if not next(res1) then
                        correctOutput(source, mCFG.ESS.ban_no_such_login)
                    else
                        bannedID = res1[1].id_account

                        MySQL.Async.fetchAll(
                            "SELECT id_banned, unban_time, is_unbanned FROM tbl_bans AS b INNER JOIN tbl_accounts AS a ON b.id_banned=a.id_account WHERE a.login=@login AND b.is_unbanned=0", {
                                ['@login'] = loginToBan
                            }, function(res)
                                if not next(res) then
                                    -- zbanuj
                                    MySQL.Async.execute(
                                        'INSERT INTO tbl_bans(id_banning, id_banned, banning_nick, banned_nick, reason, ban_time, unban_time, is_perm, is_all_banned) VALUES(@banningID,@bannedID,@banningNick,@bannedNick,@reason,@bTime,@ubTime,@isPerm,@isAllBanned)', {
                                            ['@banningID'] = banningID, ['@bannedID'] = bannedID, ['@banningNick'] = banningNick,
                                            ['@bannedNick'] = bannedNick, ['@reason'] = _reason, ['@bTime'] = os.date("%Y-%m-%d %H:%M:%S", os.time()),
                                            ['@ubTime'] = os.date("%Y-%m-%d %H:%M:%S", time), ['@isPerm'] = 0, ['@isAllBanned'] = 1
                                        }, function(res)
                                            -- hasBanned = true

                                            if bannedNick ~= 'OFFLINE' then
                                                if _fq.GetPlayerByLogin(loginToBan) then
                                                    print('id: ' .. _fq.GetPlayerByLogin(loginToBan).svID)
                                                    DropPlayer(_fq.GetPlayerByLogin(loginToBan).svID, mCFG.ESS.ban_droplayer_msg)
                                                else
                                                    print('null')
                                                end
                                            else
                                                correctOutput(source, '^3* Offline player banned properly! *^7')
                                            end
                            
                                            -- TriggerClientEvent('fq:sendLocalMsg', -1, string.format(mCFG.ESS.ban_all_msg, banningNick, bannedNick, _reason))
                                            TriggerClientEvent('fq:printTranslated', -1, 'ESS', 'ban_all_msg', {banningNick, bannedNick, _reason})
                                        end
                                    )
                                else
                                    correctOutput(source, mCFG.ESS.ban_already_banned)
                                    -- error, jest juz zbanowany
                                end
                            end
                        )
                    end
                end
            )
            correctOutput(source, mCFG.ESS.parser_error)
        end
    else
        correctOutput(source, mCFG.ESS.ban_pass_id)
    end
end)

AddEventHandler('fq:unbanPlayer', function(src, steamid) -- p: essentials.command.unban
    if not isCallerConsole(source) then return end

    local source = src

    if areCmdsBlocked() then return end
    
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.unban') 

    if not hasPermission and not isCallerConsole(source) then
        TriggerClientEvent('fq:sendLocalMsg', source, mCFG.ESS.no_perm)
        return
    end

    if not steamid then
        correctOutput(source, mCFG.ESS.unban_pass_login)
        return
    end

    local loginToBan = steamid

    local unbanningNick = isCallerConsole(source) and 'CONSOLE' or GetPlayerName(source)
    
    MySQL.Async.fetchAll(
        "SELECT login, is_unbanned, id_banned FROM tbl_bans AS b INNER JOIN tbl_accounts AS a ON b.id_banned=a.id_account WHERE b.is_unbanned=0 AND a.login=@login", {
            -- ['@banid'] = playerToBanID,
            ['@login'] = loginToBan,
        }, function(res)
            if not next(res) then
                -- nie jest zbanowany
                correctOutput(source, mCFG.ESS.unban_not_banned)
            else
                -- odbanuj
                unban(res[1].login)
                correctOutput(source, mCFG.ESS.unban_msg_to_admin)
            end
        end
    )
end)

AddEventHandler('fq:blacklistPlayer', function(_src, args) -- p: essentials.command.blacklist
    if not isCallerConsole(source) then return end
    
    local source = _src

    if areCmdsBlocked() then return end
    
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.blacklist') 

    if not hasPermission and not isCallerConsole(source) then
        correctOutput( source, mCFG.ESS.no_perm)
        return
    end

    if #args < 1 then
        correctOutput(source, mCFG.ESS.bl_usage)
        return
    end

    local svID = tonumber(args[1]) or nil

    local adminID = _fq.GetPlayerAccID(source) or -1

    if svID then
        local isOnline = playerSteamIDs[svID]

        if isOnline then
            local data = _getPlayerIdentifiers(svID)

            MySQL.Async.execute(
                'INSERT INTO tbl_blacklist(id_admin, `when`, ip, steamid, license) VALUES(@adminID, NOW(), @ip, @steamid, @license)', {
                    ['@adminID'] = adminID, ['@steamid'] = data.steamid, ['@license'] = data.license, ['@ip'] = data.ip
                }, function(res)
                end
            )

            correctOutput(source, mCFG.ESS.bl_admin_msg:format(svID))
            DropPlayer(svID, mCFG.ESS.bl_dropplayer_msg)
        else
            correctOutput(source, mCFG.ESS.bl_not_online)
        end
    else
        correctOutput(source, mCFG.ESS.bl_pass_player_id)
    end
end)

AddEventHandler('fq:unblacklistPlayer', function(src, args) -- p: essentials.command.unblacklist
    if not isCallerConsole(source) then return end
    
    local source = src

    if areCmdsBlocked() then return end
    
    local hasPermission = hasPermission(_fq.GetPlayerAccID(source), 'essentials.command.unblacklist') 

    if not hasPermission and not isCallerConsole(source) then
        correctOutput( source, mCFG.ESS.no_perm)
        return
    end

    if #args < 1 then
        correctOutput(source, mCFG.ESS.unbl_usage)
        return
    end

    local blID = tonumber(args[1]) or nil

    if blID then
        local isUnlisted
        
        MySQL.Async.fetchAll(
            "SELECT * FROM tbl_blacklist WHERE id_blacklist=@id AND is_canceled=0", {
                ['@id'] = blID
            }, function(res)
                if not next(res) then
                    correctOutput(source, mCFG.ESS.unbl_not_bled)
                else
                    MySQL.Async.execute(
                        'UPDATE tbl_blacklist SET is_canceled=1 WHERE id_blacklist=@ass', {
                            ['@ass'] = blID
                        }, function(res)
                            isUnlisted = true
                            correctOutput(source, mCFG.ESS.unbl_ubled_correctly) 
                        end
                    )
                end
            end
        )
    else
        correctOutput(source, mCFG.ESS.unbl_pass_id)
    end
end)

AddEventHandler('fq:kickMe', function(reason)
    DropPlayer(source, reason and reason or ':)')
end)

ESXs.RegisterServerCallback('fq:checkPermission', function(source, cb, permission)
    local canDoThat = hasPermission(_fq.GetPlayerAccID(source), permission) 
    local isLoggedIn = _fq.IsPlayerLoggedIn(source) 

    cb(canDoThat and isLoggedIn)
end)

function parseChatMessage(src, prefix, name, msg)
    local gid = exports['fq_gangs']:getPlayerGangID(src) or 5

    local str = prefix:gsub('{gangColor}', chat.gangColors[gid])
    str = str:gsub('{groupName}', getPlayerGroupName(_fq.GetPlayerAccID(src))) 
    str = str:gsub('{name}', name)
    str = str:gsub('{msg}', msg)

    return str
end

function removeNFirstElements(tab, n)
    for i = 1, n do
        table.remove(tab, 1)
    end
    return tab
end

function correctOutput(source, msg)
    if isCallerConsole(source) then
        print(msg)
    else    
        TriggerClientEvent('fq:sendLocalMsg', source, msg)
    end
end

function isCallerConsole(source)
    return (type(source) == 'string' and not tonumber(source)) or (type(source) == 'number' and source == 0)
end
exports('isCallerConsole', isCallerConsole)

function parseTimeForBan(str)
    if not str then return false end
    
    local allowed = { sec=true,min=true,hour=true,day=true,month=true,year=true }
    local currentTime = os.date('*t')
    local foundAtLeastOne

    for k, v in string.gmatch(str, "(%w+)+(%w+)") do
        foundAtLeastOne = true
        if allowed[k] and tonumber(v) then
            currentTime[k] = currentTime[k] + math.abs(tonumber(v))
        else
            return false
        end
    end
    
    return (foundAtLeastOne and os.time(currentTime) or false)
end

function isBannedCore(accID, notbannedCB, bannedCB) -- by account id
    local query2 = "SELECT login,id_ban,id_banning,id_banned,banning_nick,banned_nick,reason,UNIX_TIMESTAMP(ban_time)+3600 AS ban_time,UNIX_TIMESTAMP(unban_time)+3600 AS unban_time,is_perm,is_unbanned,is_all_banned FROM tbl_bans AS b INNER JOIN tbl_accounts AS a ON b.id_banned = a.id_account WHERE id_banned=@banid AND is_unbanned=0"

    MySQL.Async.fetchAll(
        query2, {
            ['@banid'] = accID
        }, function(res_)
            if not next(res_) then
                -- can join
                if notbannedCB then notbannedCB(res_) end
            else
                -- banned cant join
                local timeDifferance = os.difftime(res_[1].unban_time, os.time()+3600) -- z jakigos powodu gogdzine do tylu jest os.time()
                
                if timeDifferance < 0 then -- time passed, not banned anymore
                    unban(res_[1].login)

                    if notbannedCB then notbannedCB(res_) end
                else -- still banned
                    if bannedCB then bannedCB(res_) end
                end
            end
        end
    )
end

-- function isBanned(src, notbannedCB, bannedCB)
--     local ids = _getPlayerIdentifiers(src)
function isBanned(ids, notbannedCB, bannedCB)
    -- local ids = _getPlayerIdentifiers(src)
    local query = "SELECT * FROM tbl_metadata WHERE steamid=@sid OR license=@lic OR ip=@ip"

    MySQL.Async.fetchAll(
        query, {
            ['@sid'] = ids.steamid, ['@lic'] = ids.license, ['@ip'] = ids.ip
        }, function(res)
            if not next(res) then
                -- all good
                if notbannedCB then notbannedCB() end
            else
                isBannedCore(res[1].id_account, notbannedCB, bannedCB)
            end
        end
    )
end
exports('isBanned', isBanned)

function unban(login)
    MySQL.Async.execute(
        "UPDATE tbl_bans AS b INNER JOIN tbl_accounts AS a ON b.id_banned = a.id_account SET b.is_unbanned=1 WHERE a.login=@login AND b.is_unbanned=0", {
            ['@login'] = login
        }, function(rowsChanged)
            if rowsChanged > 0 then
                print('^6Player ^3'..login..' ^6is unbanned!^7')
            else
                print('^8unban error^7')
            end
        end
    )
end
exports('unban', unban)

function isBlacklisted(src, notbannedCB, bannedCB)
    local ids = _getPlayerIdentifiers(src)
    local query = "SELECT * FROM tbl_blacklist WHERE steamid=@sid AND license=@lic AND ip=@ip AND is_canceled=0"

    MySQL.Async.fetchAll(
        query, {
            ['@sid'] = ids.steamid, ['@lic'] = ids.license, ['@ip'] = ids.ip
        }, function(res)
            if not next(res) then
                -- all good
                if notbannedCB then notbannedCB() end
            else
                if bannedCB then bannedCB(res[1].id_blacklist) end
            end
        end
    )
end
exports('isBlacklisted', isBlacklisted)

function areCmdsBlocked()
    return chat.cmdsBlocked
end

function processMute(login)
    if not login then return false end

    local currentTime = os.date('*t')

    if chat.mutedList[login] then
        if os.difftime(chat.mutedList[login][1], os.time()) <= 0 then
            chat.mutedList[login] = nil
            return true
        else
            return false
        end
    else
        return true
    end
end

function _getPlayerIdentifiers(source)
    local tab = {}

    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            tab.steamid = v:sub(7)
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            tab.license = v:sub(9)
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            tab.xbl  = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            tab.ip = v:sub(4)
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            tab.discord = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            tab.liveid = v
        end
    end

    return tab
end
exports('_getPlayerIdentifiers', _getPlayerIdentifiers)

function kickPlayerBySteamID(steamid)
    for k, v in pairs(playerSteamIDs) do 
        if v == steamid then
            DropPlayer(k, '')
            return true
        end
    end

    return false
end