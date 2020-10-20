[![HitCount](http://hits.dwyl.com/SigmaGamer/ROBLOX-Spotify.svg)](http://hits.dwyl.com/SigmaGamer/ROBLOX-Spotify)

# ROBLOX Spotify
A Lua script designed to fully wrap the Spotify console API from a GUI in ROBLOX.

## Usage

To start, You'll need to make sure your executor has the designated functions needed to run this script.
Currently we only support Synapse X.

To get an API key, you'll need to go [here](https://developer.spotify.com/console/get-users-currently-playing-track/), click "Get Token", and tick every box

```lua
getgenv().apikey = "Your API Key" -- Replace with your key

loadstring(game:HttpGet("https://raw.githubusercontent.com/SigmaGamer/ROBLOX-Spotify/main/main.lua"))()
```

## Other Info

This will most likely not be maintained other than small bug-fixes here and there.
