local groups = {} -- [nazwa_grupy] = true
local groupPermissions = {} -- [nazwa_grupy] = {[nazwa_permisji] = true,...}
local groupPowerLevel = {} -- [nazwa_grupy] = level:int(1 highest, 2, 3, ...)
local groupPrefixes = {} -- [nazwa_grupy] = 'parsed_prefix'

local groupAssigned = {} -- [account_id] = "nazwa_grupy"
local groupAssignedExpires = {} -- [acc_id] == when_expires
local groupDefault

RegisterNetEvent('fq:checkExpireTimeRank')

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    init()
end)

AddEventHandler('fq:checkExpireTimeRank', function(src, acc_id)
    if not isCallerConsole(source) then return end
    
    if groupAssignedExpires[acc_id] then
        local dif = os.difftime(groupAssignedExpires[acc_id], os.time())

        if dif <= 0 then
            local usersFile = LoadResourceFile(GetCurrentResourceName(), 'data/permissions/users.json') or ""

            groupAssigned[acc_id] = nil
            groupAssignedExpires[acc_id] = nil

            if usersFile ~= '' then
                local data = json.decode(usersFile)
                data[acc_id] = nil
                SaveResourceFile(GetCurrentResourceName(), 'data/permissions/users.json', json.encode(data), -1)
            end
        end
    end
end)

RegisterCommand('perm_reload', function(source, args)
    if not isCallerConsole(source) then return end

    groupDefault = nil
    groupAssigned = {}
    groupAssignedExpires = {}
    groups = {}
    groupPermissions = {}
    groupPowerLevel = {}
    groupPrefixes = {}
    
    init()
    printGood('Permission files reloaded correctly!')
end, false)

function init()
    printGood('Loading groups...')
    
    if parseGroupFile('data/permissions/groups.json') then
        printGood('Groups and permissions loaded correctly')
    else
        printError('Error occurred while parsing data!')
    end

    printGood('Loading users...')

    if parseUsersFile('data/permissions/users.json') then
        printGood('Groups assigned to users correctly!')
    else
        printError('Error occurred while parsing users!')
    end
end

function parseUsersFile(fileName)
    local usersFile = LoadResourceFile(GetCurrentResourceName(), fileName) or ""

    if usersFile ~= "" then
        local data = json.decode(usersFile)

        for k, v in pairs(data) do
            if tonumber(k) then
                if groupExists(v[1]) then
                    groupAssigned[k] = v[1]

                    if v[2] then
                        groupAssignedExpires[k] = v[2]
                    end
                else
                    printError('Error in user file parsing: no such group!')
                    return false
                end
            else
                printError('Error in user file parsing: not a account id!')
                return false
            end
        end
    else
        return false
    end

    return true
end

function parseGroupFile(fileName)
    local groupsFile = LoadResourceFile(GetCurrentResourceName(), fileName) or ""

    if groupsFile ~= "" then
        local data = json.decode(groupsFile)

        for k, v in pairs(data.Groups) do
            groups[k] = true
        end

        for k, v in pairs(data.Groups) do
            -- default group set
            if v.isDefault and v.isDefault == true then
                if not groupDefault then
                    groupDefault = k
                    printGood('Default group set to: ^2' .. k)
                else
                    printError('There is more than 1 default group!')
                    return false
                end
            end
            -- power level set
            if v.powerLevel and tonumber(v.powerLevel) then
                groupPowerLevel[k] = v.powerLevel
            else
                printError('Power level option is not a number or doesn\'t exist!')
                return false
            end

            if v.prefix then
                groupPrefixes[k] = v.prefix
            else
                printError('Group has no prefix set!')
                return false
            end

            -- permissions set
            groupPermissions[k] = {}
            setPermissionsForGroup(k, v.permissions)
            
            if v.inherits then
                if not inheritPermissions(data, k, v.inherits) then
                    return false
                end
            end
        end
    else
        printError('Wrong file name!')
        return false
    end
    
    return true
end

function inheritPermissions(data, inheritingGroup, groupList)
    if not type(groupList) == 'table' or not groupList then
        printError('Inheriting permissions for group error: 3rd argument!')
        return false
    end

    if not type(inheritingGroup) == 'string' or not inheritingGroup then
        printError('Inheriting permissions for group error: 2nd argument!')
        return false
    end

    for i, v in ipairs(groupList) do
        if groupExists(v) then
            setPermissionsForGroup(inheritingGroup, data.Groups[v].permissions)
        else
            printError('Inheriting error: no such a group: ' .. v)
            return false
        end
    end

    return true
end

function setPermissionsForGroup(group, permissions)
    if not type(permissions) == 'table' or not permissions then
        printError('Setting permissions for group error: 2nd argument!')
        return false
    end

    if not type(group) == 'string' or not group then
        printError('Setting permissions for group error: 1st argument!')
        return false
    end

    if not groupExists(group) then
        printError('Setting permissions for group error: no such group')
        return false
    end

    for i, v in ipairs(permissions) do
        groupPermissions[group][v] = true
    end

    return true
end

function hasPermission(acc_id, permission_name) -- using permissions with '*'' in the name will brake tihs function
    local base = permission_name
    local parts = {}
    local groupName
    acc_id = tostring(acc_id)

    if not groupAssigned[acc_id] then
        groupName = groupDefault
    else
        groupName = groupAssigned[acc_id]
    end

    if groupPermissions[groupName]['*'] or groupPermissions[groupName][permission_name] then
        return true
    end

    for k, v in string.gmatch(base, "(%w*)") do
        if k:len() > 0 then
            table.insert(parts, k)
        end
    end

    for i=1, #parts-1 do
        local str = ''

        for j=1, i do
            str = str .. parts[j]..'.'
        end

        str = str .. '*'

        if groupPermissions[groupName][str] then
            return true
        end
    end

    return false
end
exports('hasPermission', hasPermission)

function getPlayerGroupName(acc_id)
    acc_id = tostring(acc_id)
    if groupAssigned[acc_id] then
        return groupAssigned[acc_id]
    else
        return groupDefault
    end
    -- return false
end

function getPlayerPrefix(group)
    return groupPrefixes[group]
end

function isGroupPowerHigher(g1, g2) -- najmniejszy najpotezniejszy
    if groupPowerLevel[g1] <= groupPowerLevel[g2] then
        return true
    end

    return false
end

function groupExists(group)
    return groups[group]
end

function printError(msg)
    print('^9[^8Permissions^9] ^1' .. msg .. '^7')
end

function printGood(msg)
    print('^5[^4Permissions^5] ^3' .. msg .. '^7')
end