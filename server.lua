_print = print
function print(message)
    if not message or type(message) ~= "string" then
        _print("^7[^5FRF^7] ^4- ^7Invalid message^7")
        return
    end
    _print("^7[^5FRF^7] ^4- ^7" .. message .. "^7")
end

-- [//[In/Un-stallers]\\] --
local function isResourceAScript(resourceName)
    return true -- Check if the resource has client_scripts or client_script
end

local function installResource(resourceName)
    if isResourceAScript(resourceName) then
        local currentResource = "@" .. GetCurrentResourceName() .. "/init.lua"
        local currentResourceMatch = currentResource:gsub("-", "%%-")
        local resourcePath = GetResourcePath(resourceName)
        if resourcePath ~= nil then
            local fxmanifestFile = LoadResourceFile(resourceName, "fxmanifest.lua")
            if fxmanifestFile then
                fxmanifestFile = tostring(fxmanifestFile)
                local sharedScript = fxmanifestFile:match("shared_script '" .. currentResourceMatch .. "'\n")
                if not sharedScript then
                    fxmanifestFile = "shared_script '" .. currentResource .. "'\n" .. fxmanifestFile
                    SaveResourceFile(resourceName, "fxmanifest.lua", fxmanifestFile, -1)
                    return true
                end
            else
                local __resourceFile = LoadResourceFile(resourceName, "__resource.lua")
                if __resourceFile then
                    __resourceFile = tostring(__resourceFile)
                    local sharedScript = __resourceFile:match("shared_script '" .. currentResourceMatch .. "'\n")
                    if not sharedScript then
                        __resourceFile = "shared_script '" .. currentResource .. "'\n" .. __resourceFile
                        SaveResourceFile(resourceName, "__resource.lua", __resourceFile, -1)
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function uninstallResource(resourceName)
    local currentResource = "@" .. GetCurrentResourceName() .. "/init.lua"
    local currentResourceMatch = currentResource:gsub("-", "%%-")
    local resourcePath = GetResourcePath(resourceName)
    if resourcePath ~= nil then
        local fxmanifestFile = LoadResourceFile(resourceName, "fxmanifest.lua")
        if fxmanifestFile then
            fxmanifestFile = tostring(fxmanifestFile)
            local sharedScript = fxmanifestFile:match("shared_script '" .. currentResourceMatch .. "'\n")
            if sharedScript then
                fxmanifestFile = fxmanifestFile:gsub("shared_script '" .. currentResourceMatch .. "'\n", "")
                SaveResourceFile(resourceName, "fxmanifest.lua", fxmanifestFile, -1)
                return true
            end
        else
            local __resourceFile = LoadResourceFile(resourceName, "__resource.lua")
            if __resourceFile then
                __resourceFile = tostring(__resourceFile)
                local sharedScript = __resourceFile:match("shared_script '" .. currentResourceMatch .. "'\n")
                if sharedScript then
                    __resourceFile = __resourceFile:gsub("shared_script '" .. currentResourceMatch .. "'\n", "")
                    SaveResourceFile(resourceName, "__resource.lua", __resourceFile, -1)
                    return true
                end
            end
        end
    end

    return false
end

RegisterCommand("frf:install", function(source, args)
    if source ~= 0 then
        return
    end

    if args[1] then
        if GetResourceState(args[1]) == "missing" then
            print("^1Resource: ^3" .. args[1] .. " ^1Dont exists or cant be found!^0")
            return
        end
        if Config.BlacklistedResources[args[1]] then
            print("^1Resource: ^3" .. args[1] .. " ^1is Blacklisted and cannot be installed.^0")
            return
        end
        if args[1] == GetCurrentResourceName() then
            print("^1Resource: ^3" .. args[1] .. " ^1is the current resource and cannot be installed.^0")
            return
        end
        if installResource(args[1]) then
            print("^2installed Resource: ^3" .. args[1] .. " ^2successfully!^0")
        else
            print("^1Resource: ^3" .. args[1] .. " ^1is already installed.^0")
        end
        return
    end

    local resCount = GetNumResources()
    for i = 0, resCount - 1 do
        local resource = GetResourceByFindIndex(i)
        if not Config.BlacklistedResources[resource] and resource ~= GetCurrentResourceName() then
            if installResource(resource) then
                print("^2Installed Resource: ^3" .. resource .. " ^2successfully!^0")
            end
        end
    end
    print("^2Please restart the server to complete the installation.^0")
end, false)

RegisterCommand("frf:uninstall", function(source, args)
    if source ~= 0 then
        return
    end
    if args[1] then
        if GetResourceState(args[1]) == "missing" then
            print("^1Resource: ^3" .. args[1] .. " ^1Dont exists or cant be found!^0")
            return
        end

        if args[1] == GetCurrentResourceName() then
            print("^1Resource: ^3" .. args[1] .. " ^1is the current resource and cannot be uninstalled.^0")
            return
        end
        if uninstallResource(args[1]) then
            print("^2Uninstalled Resource: ^3" .. args[1] .. " ^2successfully!^0")
        else
            print("^1Resource: ^3" .. args[1] .. " ^1is already uninstalled.^0")
        end
        return
    end

    local resCount = GetNumResources()
    for i = 0, resCount - 1 do
        local resource = GetResourceByFindIndex(i)
        if uninstallResource(resource) then
            print("^1Uninstalled Resource: ^3" .. resource .. " ^1successfully!^0")
        end
    end
    print("^1Please restart the server to complete the uninstallation.^0")
end, false)

-- [//[ Functions ]\\] --
function exports(exportName, exportFunc)
    AddEventHandler(('__cfx_export_FiveM-ReqeustFilter_%s'):format(exportName), function(setCB)
        setCB(exportFunc)
    end)
end

-- [//[ Exports ]\\] --
exports("getConfig", function()
    return Config
end)

exports("WarnURL", function(url)
    local res = (GetInvokingResource() or "unkown")

    print("URL was been blocked ( ^1".. url .." ^7) from ^5".. res)
end)

exports("WarnURLData", function(urlData)
    local res = (GetInvokingResource() or "unkown")

    print("URL was been blocked ( ^1".. urlData.url .." ^7) from ^5".. res .. " ^7with data: ^1".. json.encode(urlData.data, { indent = true }) .. " ^7 | Method: ^1".. urlData.method)
end)
