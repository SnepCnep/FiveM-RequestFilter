if GetResourceState("FiveM-ReqeustFilter") == "started" or GetResourceState("ReqeustFilter") == "started" then
    local Config = exports["FiveM-ReqeustFilter"]:getConfig()

    function IsURLWhitelisted(url)
        return (Config.AllowedUrl[url] or false)
    end

    local _PerformHttpRequestInternalEx = PerformHttpRequestInternalEx
    function PerformHttpRequestInternalEx(t)
        if not IsURLWhitelisted(t.url) then
            exports["FiveM-ReqeustFilter"]:WarnURL(t.url)
            return -1
        end

        return _PerformHttpRequestInternalEx(t)
    end

end