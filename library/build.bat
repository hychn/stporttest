cl /D_USRDLL /D_WINDLL SteamworksPy.cpp steam_api64.lib /link /DLL /OUT:SteamworksPy64.dll
copy SteamworksPy64.dll ..