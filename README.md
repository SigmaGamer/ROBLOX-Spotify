# ROBLOX Spotify

A Lua script designed to fully wrap the Spotify console API from a GUI in ROBLOX.

## Usage

You'll need to make sure your executor has the designated functions needed to run this script.
Currently, it only support Synapse X.

## API Key

To start, Click [this](https://developer.spotify.com/console/get-users-currently-playing-track) link and click "Get Token"
Tick the boxes shown below, and press "Request Token"

![example](https://cdn.soren.cool/53f1c5a9-4922-4133-aba9-afdc61756517/fe9be7f.png)

## Script
```lua
getgenv().apikey = "Your API Key" -- Replace with your key

loadstring(game:HttpGet("https://raw.githubusercontent.com/SigmaGamer/ROBLOX-Spotify/main/main.lua"))()
```

## Other Info

This will most likely not be maintained other than small bug-fixes here and there.
