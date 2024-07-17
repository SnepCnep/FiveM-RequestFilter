if GetResourceState("FiveM-ReqeustFilter") == "started" or GetResourceState("ReqeustFilter") == "started" then
    local Config = exports["FiveM-ReqeustFilter"]:getConfig()

    function IsURLWhitelisted(url)
        if Config.AllowedDomains[string.match(url, "^https?://([^/]+)")] then
            return true
        elseif Config.AllowedUrls[url] then
            return true
        end

        return false
    end

    local _PerformHttpRequestInternalEx = PerformHttpRequestInternalEx
    function PerformHttpRequestInternalEx(t)
        if not IsURLWhitelisted(t.url) then
            if Config.ShowData then
                exports["FiveM-ReqeustFilter"]:WarnURLData(t)
            else
                exports["FiveM-ReqeustFilter"]:WarnURL(t.url)
            end
            return -1
        end

        return _PerformHttpRequestInternalEx(t)
    end

end