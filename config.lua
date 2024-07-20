Config = {}
Config.ShowData = true
Config.AutoInstaller = false -- [ Not recommanded but it works! ]

-------------------------------------
-- [//[ Allowed URL ]\\] --
-------------------------------------
Config.AllowedUrls = {
    [""] = true
}

Config.AllowedDomains = { -- [ not recommanded to use ]
    [""] = true 
    --["raw.githubusercontent.com"] = true
}

-------------------------------------
-- [//[ Blacklisted Resources ]\\] -- [[ Resources that not will be checkt ]]
-------------------------------------
Config.BlacklistedResources = {
    ["test_resources"] = true,
}