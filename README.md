# ROBLOX Spotify

A Lua script designed to fully wrap the Spotify console API from a GUI in ROBLOX.

## Usage

You'll need to make sure your executor has the designated functions needed to run this script.

Currently, only [Synapse X](https://x.synapse.to) is supported.

Follow the instructions below to obtain your Spotify API key. After that, Paste it into the script where it's designated.

## API Key

To start, Click [here](https://developer.spotify.com/console/get-users-currently-playing-track) and click "Get Token".

Tick the boxes shown below, and press "Request Token"

- user-read-currently-playing
- user-read-playback-position
- user-modify-playback-state

## Script

```lua
getgenv().apikey = "Your API Key" -- Replace with your key

loadstring(game:HttpGet("https://raw.githubusercontent.com/SigmaGamer/ROBLOX-Spotify/main/main.lua"))()
```

## Contributing

If you would like to contribute to this script, open a pull request!
