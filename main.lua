--[[

  Be sure to run the script linked on the README or the init.lua, not this one.
  This code is terrible and months old, please don't judge! :sob:
]]--

if (not apikey) then 
    game.Players.LocalPlayer:Kick("API Key not detected! Did you follow instructions correctly?") 
end

-- Tables

local requests = {
    ["CurrentlyPlaying"] = {
        Url = "https://api.spotify.com/v1/me/player/currently-playing",
        Method = "GET",
        Headers = {
            ["Accept"] = "application/json",
            ["Authorization"] = "Bearer " .. apikey,
            ["Content-Type"] = "application/json"
        }
    },
    ["NextSong"] = {
        Url = "https://api.spotify.com/v1/me/player/next",
        Method = "POST",
        Headers = {
            ["Accept"] = "application/json",
            ["Authorization"] = "Bearer " .. apikey,
            ["Content-Type"] = "application/json"
        }
    },
    ["LastSong"] = {
        Url = "https://api.spotify.com/v1/me/player/previous",
        Method = "POST",
        Headers = {
            ["Accept"] = "application/json",
            ["Authorization"] = "Bearer " .. apikey,
            ["Content-Type"] = "application/json"
        }
    },
    ["Pause"] = {
        Url = "https://api.spotify.com/v1/me/player/pause",
        Method = "PUT",
        Headers = {
            ["Accept"] = "application/json",
            ["Authorization"] = "Bearer " .. apikey,
            ["Content-Type"] = "application/json"
        }
    },
    ["Play"] = {
        Url = "https://api.spotify.com/v1/me/player/play",
        Method = "PUT",
        Headers = {
            ["Accept"] = "application/json",
            ["Authorization"] = "Bearer " .. apikey,
            ["Content-Type"] = "application/json"
        }
    },
}

-- Services

local http = game:GetService("HttpService")
local uis = game:GetService("UserInputService")
local startergui = game:GetService("StarterGui")
local repStorage = game:GetService("ReplicatedStorage")

-- Misc

local CurrentAlbumCover = Drawing.new("Image")
local Result_Uri = Instance.new("StringValue")

-- Functions

local plrChat = function(...) 
	repStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(..., "All")
end

local notify = function(title, message, duration)
    startergui:SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration,
        Button1 = "OK"
    })
end

local char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
end

local urlencode = function(url)
    if (url == nil) then
        return
    end

    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w _%%%-%.~])", char_to_hex)
    url = url:gsub(" ", "+")
    return url
end

local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end

local urldecode = function(url)
    if (url == nil) then
        return
    end

    url = url:gsub("+", " ")
    url = url:gsub("%%(%x%x)", hex_to_char)
    return url
end

local searchSongs = function(query, limit)
    local resp =
        syn.request(
        {
            Url = "https://api.spotify.com/v1/search?q=" .. urlencode(query) .. "&type=track&limit=" .. limit,
            Method = "GET",
            Headers = {
                ["Accept"] = "application/json",
                ["Authorization"] = "Bearer " .. apikey,
                ["Content-Type"] = "application/json"
            }
        }
    )

    return http:JSONDecode(resp.Body)
end

local addSong = function(uri)
    local resp = syn.request({
        Url = "https://api.spotify.com/v1/me/player/queue?uri=" .. urlencode(uri),
        Method = "POST",
        Headers = {
            ["Accept"] = "application/json",
            ["Authorization"] = "Bearer " .. apikey,
            ["Content-Type"] = "application/json"
        }
    })
end

-- Loader

notify("ROBLOX Spotify", "Successfully loaded!\nPress insert to open and close!", 5)

-- Start Gui2Lua
-- Version: 3.2

-- Instances:

local Spotify = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Bottom = Instance.new("Frame")
local CurrentlyPlaying = Instance.new("Frame")
local Cover = Instance.new("ImageLabel")
local Title = Instance.new("TextLabel")
local Artist = Instance.new("TextLabel")
local Timestamps = Instance.new("Frame")
local PausePlay = Instance.new("ImageButton")
local Pause = Instance.new("ImageLabel")
local Play = Instance.new("ImageLabel")
local SkipNext = Instance.new("ImageButton")
local SkipPrevious = Instance.new("ImageButton")
local Search = Instance.new("Frame")
local SearchBox = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextBox = Instance.new("TextBox")
local Search_2 = Instance.new("ImageLabel")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIGridLayout = Instance.new("UIGridLayout")
local ExampleResult = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Result_Artist = Instance.new("TextLabel")
local Result_Title = Instance.new("TextLabel")
local Result_Clicked = Instance.new("ImageButton")
local Sidebar = Instance.new("Frame")
local Logo = Instance.new("ImageLabel")

--Properties:

Spotify.Name = "Spotify"
Spotify.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Spotify.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Spotify.ResetOnSpawn = false

Main.Name = "Main"
Main.Parent = Spotify
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0, 261, 0, 109)
Main.Size = UDim2.new(0, 725, 0, 375)

Bottom.Name = "Bottom"
Bottom.Parent = Main
Bottom.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Bottom.BorderSizePixel = 0
Bottom.Position = UDim2.new(0, 0, 0.866339624, 0)
Bottom.Size = UDim2.new(0, 725, 0, 50)

CurrentlyPlaying.Name = "CurrentlyPlaying"
CurrentlyPlaying.Parent = Bottom
CurrentlyPlaying.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CurrentlyPlaying.BackgroundTransparency = 1.000
CurrentlyPlaying.BorderSizePixel = 0
CurrentlyPlaying.Size = UDim2.new(0, 175, 0, 50)

Cover.Name = "Cover"
Cover.Parent = CurrentlyPlaying
Cover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Cover.BackgroundTransparency = 1.000
Cover.BorderSizePixel = 0
Cover.Position = UDim2.new(0.0780295506, 0, 0.144062459, 0)
Cover.Size = UDim2.new(0, 35, 0, 35)
Cover.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

Title.Name = "Title"
Title.Parent = CurrentlyPlaying
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0.327290654, 0, 0.133749962, 0)
Title.Size = UDim2.new(0, 220, 0, 20)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Title"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14.000
Title.TextXAlignment = Enum.TextXAlignment.Left

Artist.Name = "Artist"
Artist.Parent = CurrentlyPlaying
Artist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Artist.BackgroundTransparency = 1.000
Artist.BorderSizePixel = 0
Artist.Position = UDim2.new(0.327290654, 0, 0.427187502, 0)
Artist.Size = UDim2.new(0, 220, 0, 20)
Artist.Font = Enum.Font.SourceSans
Artist.Text = "Artist"
Artist.TextColor3 = Color3.fromRGB(179, 179, 179)
Artist.TextSize = 14.000
Artist.TextXAlignment = Enum.TextXAlignment.Left

Timestamps.Name = "Timestamps"
Timestamps.Parent = Bottom
Timestamps.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Timestamps.BackgroundTransparency = 1.000
Timestamps.BorderSizePixel = 0
Timestamps.Position = UDim2.new(0.326896548, 0, 0, 0)
Timestamps.Size = UDim2.new(0, 250, 0, 50)

PausePlay.Name = "Pause-Play"
PausePlay.Parent = Timestamps
PausePlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PausePlay.BackgroundTransparency = 1.000
PausePlay.BorderSizePixel = 0
PausePlay.Position = UDim2.new(0.440000027, 0, 0.159999967, 0)
PausePlay.Size = UDim2.new(0, 30, 0, 30)
PausePlay.ZIndex = 2

Pause.Name = "Pause"
Pause.Parent = PausePlay
Pause.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pause.BackgroundTransparency = 1.000
Pause.BorderSizePixel = 0
Pause.Size = UDim2.new(0, 30, 0, 30)
Pause.Image = "http://www.roblox.com/asset/?id=6281820238"

Play.Name = "Play"
Play.Parent = PausePlay
Play.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Play.BackgroundTransparency = 1.000
Play.BorderSizePixel = 0
Play.Size = UDim2.new(0, 30, 0, 30)
Play.Visible = false
Play.Image = "http://www.roblox.com/asset/?id=6281955356"
Play.ScaleType = Enum.ScaleType.Fit

SkipNext.Name = "Skip-Next"
SkipNext.Parent = Timestamps
SkipNext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SkipNext.BackgroundTransparency = 1.000
SkipNext.BorderSizePixel = 0
SkipNext.Position = UDim2.new(0.612000048, 0, 0.200000018, 0)
SkipNext.Size = UDim2.new(0, 27, 0, 27)
SkipNext.Image = "http://www.roblox.com/asset/?id=6281822129"
SkipNext.ScaleType = Enum.ScaleType.Fit

SkipPrevious.Name = "Skip Previous"
SkipPrevious.Parent = Timestamps
SkipPrevious.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SkipPrevious.BackgroundTransparency = 1.000
SkipPrevious.BorderSizePixel = 0
SkipPrevious.Position = UDim2.new(0.280000031, 0, 0.200000018, 0)
SkipPrevious.Size = UDim2.new(0, 27, 0, 27)
SkipPrevious.Image = "http://www.roblox.com/asset/?id=6281822901"
SkipPrevious.ScaleType = Enum.ScaleType.Fit

Search.Name = "Search"
Search.Parent = Main
Search.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Search.BackgroundTransparency = 1.000
Search.BorderSizePixel = 0
Search.Position = UDim2.new(0.172413796, 0, 0, 0)
Search.Size = UDim2.new(0, 600, 0, 324)

SearchBox.Name = "SearchBox"
SearchBox.Parent = Search
SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.BorderSizePixel = 0
SearchBox.Position = UDim2.new(0.0329999812, 0, 0.0308641978, 0)
SearchBox.Size = UDim2.new(0, 547, 0, 30)

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = SearchBox

TextBox.Parent = SearchBox
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundTransparency = 1.000
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0.0738968402, 0, 0, 0)
TextBox.Size = UDim2.new(0, 490, 0, 30)
TextBox.Font = Enum.Font.SourceSansSemibold
TextBox.PlaceholderColor3 = Color3.fromRGB(179, 179, 179)
TextBox.PlaceholderText = "Search for any artist, or song!"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox.TextSize = 14.000
TextBox.TextXAlignment = Enum.TextXAlignment.Left

Search_2.Name = "Search"
Search_2.Parent = SearchBox
Search_2.BackgroundTransparency = 1.000
Search_2.BorderSizePixel = 0
Search_2.Position = UDim2.new(0.0199700855, 0, 0.100000009, 0)
Search_2.Rotation = 90.000
Search_2.Size = UDim2.new(0, 23, 0, 23)
Search_2.Image = "rbxassetid://3605509925"
Search_2.ImageColor3 = Color3.fromRGB(179, 179, 179)
Search_2.ScaleType = Enum.ScaleType.Fit

ScrollingFrame.Parent = Search
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.BackgroundTransparency = 1.000
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.0329999998, 0, 0.166999996, 0)
ScrollingFrame.Size = UDim2.new(0, 550, 0, 250)
ScrollingFrame.ScrollBarThickness = 0

UIGridLayout.Parent = ScrollingFrame
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellPadding = UDim2.new(0, 5, 0, 10)
UIGridLayout.CellSize = UDim2.new(0, 547, 0, 40)

ExampleResult.Name = "ExampleResult"
ExampleResult.Parent = ScrollingFrame
ExampleResult.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
ExampleResult.BorderSizePixel = 0
ExampleResult.Size = UDim2.new(0, 100, 0, 100)

UICorner_2.CornerRadius = UDim.new(0, 10)
UICorner_2.Parent = ExampleResult

Result_Artist.Name = "Result_Artist"
Result_Artist.Parent = ExampleResult
Result_Artist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Result_Artist.BackgroundTransparency = 1.000
Result_Artist.BorderSizePixel = 0
Result_Artist.Position = UDim2.new(0.0217351839, 0, 0.467083365, 0)
Result_Artist.Size = UDim2.new(0, 400, 0, 20)
Result_Artist.Font = Enum.Font.SourceSans
Result_Artist.Text = "Artist"
Result_Artist.TextColor3 = Color3.fromRGB(168, 168, 168)
Result_Artist.TextSize = 14.000
Result_Artist.TextXAlignment = Enum.TextXAlignment.Left

Result_Title.Name = "Result_Title"
Result_Title.Parent = ExampleResult
Result_Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Result_Title.BackgroundTransparency = 1.000
Result_Title.BorderSizePixel = 0
Result_Title.Position = UDim2.new(0.0217351839, 0, 0, 0)
Result_Title.Size = UDim2.new(0, 400, 0, 20)
Result_Title.Font = Enum.Font.SourceSansBold
Result_Title.Text = "Title"
Result_Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Result_Title.TextSize = 14.000
Result_Title.TextXAlignment = Enum.TextXAlignment.Left
Result_Title.TextYAlignment = Enum.TextYAlignment.Bottom

Result_Clicked.Name = "Result_Clicked"
Result_Clicked.Parent = ExampleResult
Result_Clicked.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Result_Clicked.BackgroundTransparency = 1.000
Result_Clicked.BorderSizePixel = 0
Result_Clicked.Size = UDim2.new(0, 547, 0, 40)
Result_Clicked.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Result_Clicked.ImageTransparency = 1.000

Sidebar.Name = "Sidebar"
Sidebar.Parent = Main
Sidebar.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 125, 0, 325)

Logo.Name = "Logo"
Logo.Parent = Sidebar
Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Logo.BackgroundTransparency = 1.000
Logo.BorderSizePixel = 0
Logo.Position = UDim2.new(0.0960000008, 0, 0.0153846154, 0)
Logo.Size = UDim2.new(0, 100, 0, 40)
Logo.Image = "http://www.roblox.com/asset/?id=6318887798"
Logo.ScaleType = Enum.ScaleType.Fit

-- End Gui2Lua
-- Properties that gui2lua doesnt fucking work on so i have to exclude them and do manually

CurrentAlbumCover.Visible = true
CurrentAlbumCover.Size = Vector2.new(36, 36)
CurrentAlbumCover.Position = Vector2.new(Main.AbsolutePosition.X + 13, Main.AbsolutePosition.Y + 367)

Result_Uri.Parent = ExampleResult
Result_Uri.Name = "Result_Uri"
Result_Uri.Value = ""

Result_Artist.TextTruncate = 1
Result_Title.TextTruncate = 1

Artist.TextTruncate = 1
Title.TextTruncate = 1

ExampleResult.Visible = false

-- User Inputs

uis.InputBegan:Connect(
    function(input, bruh)
        if (input.KeyCode == Enum.KeyCode.Insert) then
            if (Main.Visible == true) then
                Main.Visible = false

                if (CurrentAlbumCover.Visible == true) then
                    CurrentAlbumCover.Visible = false
                end
            elseif (Main.Visible == false) then
                Main.Visible = true

                if (CurrentAlbumCover.Visible == false) then
                    CurrentAlbumCover.Visible = true
                end
            end
        end
    end
)

SkipNext.MouseButton1Down:Connect(
    function()
        syn.request(requests["NextSong"])
    end
)

SkipPrevious.MouseButton1Down:Connect(
    function()
        syn.request(requests["LastSong"])
    end
)

SearchBox.TextBox.FocusLost:Connect(
    function(enterPressed, bruh)
        if (not enterPressed) then
            return
        end

        for _, v in next, Search.ScrollingFrame:GetChildren() do
            if (not v:IsA("Frame") or v.Name == "ExampleResult") then
                continue
            end

            v:Destroy()
        end

        local songs = searchSongs(SearchBox.TextBox.Text, 20)
        if (songs.error) then
            notify("Oh no! An error occurred!", songs.error.message, 5)
            return
        end

        for i, v in next, songs.tracks.items do
            local artists = v.artists
            local artistString = artists[1].name
    
            for i, v in next, artists do
                if (v.name == artists[1].name) then
                    continue
                end
    
                artistString = artistString .. ", " .. v.name
            end

            local newItem = ExampleResult:Clone()
            newItem.Parent = Search.ScrollingFrame
            newItem.Name = v.name
            newItem.Visible = true
            newItem.Result_Artist.Text = artistString
            newItem.Result_Title.Text = v.name
            newItem.Result_Uri.Value = v.uri

            newItem.Result_Clicked.MouseButton1Click:Connect(function() 
                addSong(newItem.Result_Uri.Value)
                syn.request(requests["NextSong"])
            end)
        end
    end
)

PausePlay.MouseButton1Down:Connect(
    function()
        if (currentSong == nil) then 
            return 
        end

        if currentSong.is_playing == true then
            syn.request(requests["Pause"])

            PausePlay.Pause.Visible = false
            PausePlay.Play.Visible = true
        elseif currentSong.is_playing == false then
            syn.request(requests["Play"])
            PausePlay.Pause.Visible = true
            PausePlay.Play.Visible = false
        end
    end
)

local function GTZVDOE_fake_script() -- CurrentlyPlaying.LocalScript
    local script = Instance.new("LocalScript", CurrentlyPlaying)

    local artistLabel = script.Parent.Artist
    local titleLabel = script.Parent.Title
    local previousSong = nil

    -- this code sucks im not rewriting it bye
    while wait() do
        local resp = syn.request(requests["CurrentlyPlaying"])

        if (resp.Body == "") then
            artistLabel.Text = "N/A"
            titleLabel.Text = "Nothing is currently playing!"
            CurrentAlbumCover.Data = ""
            print(resp.Body)

            continue
        end
        
        currentSong = http:JSONDecode(resp.Body)

        if (currentSong.error) then
            notify("Oh no! An error occurred!", currentSong.error.message, 5)
            wait(3)
            continue
        elseif ((currentSong.item == nil) or (previousSong and previousSong == currentSong.item.name)) then
            continue
        elseif (previousSong ~= currentSong.item.name) then
            notify("Now Playing!", currentSong.item.name .. "\nBy " .. currentSong.item.artists[1].name, 5)
            --plrChat("Now Playing " .. currentSong.item.name .. " By " .. currentSong.item.artists[1].name .. "!")

            previousSong = currentSong.item.name
        end

        local artists = currentSong.item.artists
        local artistString = artists[1].name

        for i, v in next, artists do
            if (v.name == artists[1].name) then
                continue
            end

            artistString = artistString .. ", " .. v.name
        end

        CurrentAlbumCover.Data = game:HttpGet(tostring(currentSong.item.album.images[3].url))
        artistLabel.Text = artistString
        titleLabel.Text = currentSong.item.name

        print("playing " .. currentSong.item.name)
    end

    artistLabel.Text = "N/A"
    titleLabel.Text = "Nothing is currently playing!"
    CurrentAlbumCover.Data = ""
    print(resp.Body)
end

coroutine.wrap(GTZVDOE_fake_script)()
