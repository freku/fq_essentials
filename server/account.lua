_fq = {}
local accounts = {} -- [player_sv_id] = { data }
local logginInPlayers = {} -- [player_sv_id] = true/nil limits calls per minute(--30 seconds!)
local loggedPlayerAccIDs = {} -- [id_account] = player_sv_id
local maxCallsPerMinute = 5
local sessions = {} -- [player_sv_id] = join_time
local logins = {} -- [login] = {svID=sv_id, accID=acc_id}
local online = {} -- [sv_id] = true
 
function doesLoginExists(login, email, existsCB, doesntExistCB)
    local query

    if email ~= -1 then
        query = 'SELECT id_account,upgrades,login,password,email,money,kills,deaths,spent_time,first_time_join,last_time_leave FROM tbl_accounts WHERE login = @login OR email = @email'
    else
        query = 'SELECT id_account,upgrades,login,password,email,money,kills,deaths,spent_time,DATE_FORMAT(first_time_join, \'%Y-%m-%d %H.%i.%s\') AS first_time_join,last_time_leave FROM tbl_accounts WHERE login = @login'
    end

    MySQL.Async.fetchAll(
        query, {
            ['@login'] = login, ['@email'] = email
        }, function(res)
            if not next(res) then
                doesntExistCB()
            else
                existsCB(res)
            end
        end
    )
end

_fq.IsPlayerLoggedIn = function(src)
    return not (accounts[src] == nil)
end

_fq.GetPlayerData = function(src)
    return accounts[src]
end

_fq.GetPlayerLogin = function(src)
    if not accounts[src] then
        return false
    end

    if not accounts[src].login then
        return false
    end

    return accounts[src].login
end

_fq.GetPlayerAccID = function(src)
    if accounts[src] then
        return accounts[src].id_account
    else
        return nil
    end
end

_fq.GetPlayerServerIdByAccID = function(accID)
    return loggedPlayerAccIDs[accID]
end

_fq.GetPlayerByLogin = function(login)
    return logins[login]
end

function get_fq_object()
    return _fq
end
exports('get_fq_object', get_fq_object)

RegisterNetEvent('fq:Auth')
RegisterNetEvent('fq:changePassword')
RegisterNetEvent('fq:registerAccount')
RegisterNetEvent('fq:playerConnected')
RegisterNetEvent('fq:addMetadataRecord')
RegisterNetEvent('fq:onPlayerLogin')
RegisterNetEvent('fq:addSessionRecord')
RegisterNetEvent('fq:playerLeftEss')

AddEventHandler('playerDropped', function()
    -- DropPlayer(source)
end)

AddEventHandler('fq:playerLeftEss', function(src)
    if not isCallerConsole(source) then return end
    
    local source = src

    if sessions[source] then
        TriggerEvent('fq:addSessionRecord', source, accounts[source].id_account)
        sessions[source] = nil
    end

    if _fq.GetPlayerData(source) then
        if logins[_fq.GetPlayerData(source).login] then
            logins[_fq.GetPlayerData(source).login] = nil
        end
    end
    
    if loggedPlayerAccIDs[_fq.GetPlayerAccID(source)] then
        loggedPlayerAccIDs[_fq.GetPlayerAccID(source)] = nil
    end

    if accounts[source] then
        accounts[source] = nil
    end

    if logginInPlayers[source] then
        logginInPlayers[source] = nil
    end
end)

AddEventHandler('fq:playerConnected', function(src)
    if not isCallerConsole(source) then
        return
    end

    logginInPlayers[src] = 1
end)

AddEventHandler('fq:registerAccount', function(data)
    local source = source
    if accounts[source] or not logginInPlayers[source] or logginInPlayers[source] >= maxCallsPerMinute then
        return
    end
    
    logginInPlayers[source] = logginInPlayers[source] + 1

    local password = data._password
    local login = data._login
    local email = data._email
    local emailGiven = not email == -1
    print('\n')
    if password:len() >= 8 and password:len() <= 32 then
        if login:len() >= 6 and login:len() <= 15 and not login:match("%W") then
            if type(email) == 'string' then
                if not (email ~= -1 and email:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?") and email:len() > 0) then
                    print('email bad')
                    TriggerClientEvent('fq:getResponse', source, 'E-mail is incorrect!')
                    return
                end
            end

            doesLoginExists(login, email, function()
                print('account exists')
                TriggerClientEvent('fq:getResponse', source, 'Account with this login already exists!')
            end, 
            function() -- tworzymy konto
                MySQL.Async.execute(
                    'INSERT INTO tbl_accounts(login, password, email, upgrades) VALUES(@login, @pass, @email, @ups)', {
                        ['@login'] = login, ['@pass'] = password, ['@ups'] = '[[false,false],[false,false,false],[false,false],[false,false,false,false]]', ['@email'] = email ~= -1 and email or nil
                    }, function(res)
                        print('^3Account ^5' .. login .. ' ^3has been registered in database!^7')                        
                        TriggerClientEvent('fq:getResponse', source, 'Account registered properly, login now.')
                    end
                )
            end)
        else
            print('login bad')
            TriggerClientEvent('fq:getResponse', source, 'Login is incorrect!')
        end
    else
        print('password bad')
        TriggerClientEvent('fq:getResponse', source, 'Password is incorrect!')
    end
end)

AddEventHandler('fq:Auth', function(data)
    local source = source
    if isCallerConsole(source) or not logginInPlayers[source] or logginInPlayers[source] >= maxCallsPerMinute then 
        -- kick player
        print('false in 1st if')
        return
    end

    logginInPlayers[source] = logginInPlayers[source] + 1
    
    local password = data._password
    local login = data._login

    print('\n')
    doesLoginExists(login, -1, function(res)
        print('Got record!')

        if res[1].password == password then
            print('Password correct!')
            
            if not accounts[source] then
                accounts[source] = res[1]
                loggedPlayerAccIDs[res[1].id_account] = source
                
                if not accounts[source].email then
                    accounts[source].email = -1
                end

                logins[res[1].login] = {svID = source, accID = res[1].id_account}
                
                TriggerClientEvent('fq:getResponse', source, 'Dobrej zabawy!')
                TriggerClientEvent('fq:onAuth', source)
                TriggerEvent('fq:addMetadataRecord', source, accounts[source].id_account)
                TriggerEvent('fq:onPlayerLogin', source)
                TriggerEvent('fq:setPlayerDataSV', source) -- mozna wykorzystac event onPlayerLogin
                TriggerEvent('fq:checkExpireTimeRank', source, tostring(accounts[source].id_account))
                print('^Client ^3'..login..' ^2logged in!^7')

                logginInPlayers[source] = nil
            else
                DropPlayer(source, '')
            end
        else
            TriggerClientEvent('fq:getResponse', source, 'Login lub haslo jest niepoprawne!')
            print("Wrong password!")
        end
    end, function()
        TriggerClientEvent('fq:getResponse', source, 'Login lub haslo jest niepoprawne!')
        print('No record!')
    end)
end)

AddEventHandler('fq:changePassword', function(data)
    if accounts[source] or not logginInPlayers[source] or logginInPlayers[source] >= maxCallsPerMinute then
        return
    end

    logginInPlayers[source] = logginInPlayers[source] + 1
    
    local email = data._email

    if email:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?") and email:len() > 0 then
        PerformHttpRequest('http://localhost/ragekill/emailchange.php?new_email='..email, function(statusCode, response, headers)
        end)

        print('^Wyslano link na konto email: ^4'..email..'^7!')
    else
        print('email bad')
        TriggerClientEvent('fq:getResponse', source, 'Email is incorrect!')
    end
end)

AddEventHandler('fq:addMetadataRecord', function(src, acc_id)
    if not isCallerConsole(source) then
        return
    end

    local data = _getPlayerIdentifiers(src)
    local name = GetPlayerName(src)

    if name:len() >= 22 then
        name = name:sub(1, 22) .. '...'
    end

    MySQL.Async.fetchAll(
        "SELECT id_account, steamid, license, ip FROM tbl_metadata WHERE id_account=@acc AND steamid=@steam AND license=@lic AND ip=@ip", {
            ['@acc'] = acc_id, ['@steam'] = data.steamid, ['@lic'] = data.license, ['@ip'] = data.ip
        }, function(res)
            if not next(res) then
                MySQL.Async.execute(
                    'INSERT INTO tbl_metadata(id_account, steamid, license, ip, nick) VALUES(@acc, @sid, @license, @ip, @nick)', {
                        ['@acc'] = acc_id, ['@sid'] = data.steamid, ['@license'] = data.license, ['@ip'] = data.ip, ['@nick'] = name
                    }, function(res)
                    end
                )
            end
        end
    )
end)

AddEventHandler('fq:addSessionRecord', function(src, acc_id)
    if not isCallerConsole(source) then
        return
    end

    local diffInHours = os.difftime(os.time(), sessions[src]) / 3600.0
    diffInHours = math.floor(diffInHours * 100) / 100
    -- local left_time = os.date("%d-%m-%Y %H:%M:%S", os.time())
    local join_time = os.date("%Y-%m-%d %H:%M:%S", sessions[src])
    local left_time = os.date("%Y-%m-%d %H:%M:%S", os.time())

    MySQL.Async.execute(
        "INSERT INTO tbl_sessions(id_account, time_join, time_leave, play_time) VALUES(@acc, @time_j, @time_l, @play_time)", {
            ['@acc'] = acc_id, ['@time_j'] = join_time, ['@time_l'] = left_time, ['@play_time'] = diffInHours
        }, function(res)
        end
    )
end)

AddEventHandler('fq:onPlayerLogin', function(src)
    if not isCallerConsole(source) then
        return
    end

    sessions[src] = os.time()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000) -- every 30 seconds

        for k, v in pairs(logginInPlayers) do
            if v > 0 then
                logginInPlayers[k] = logginInPlayers[k] - 1
            end
        end
    end
end)

-- TriggerEvent('fq:registerAccount', {
--     _login = 'test06',
--     _password = 'yesyes123',
--     _email = 'kesae@gmail.com'
-- })
-- TriggerEvent('fq:Auth', {
--     _login = 'test04',
--     _password = 'yesyes123',
-- })