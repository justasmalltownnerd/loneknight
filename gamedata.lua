-- gamedata.lua
local data = {}

data.levels = {
    [1] = {
        musicPath = "Audio/Music/The_Lonely_Night_Rock_Beach.mp3",
        floor_color = {0, 0, 1, 1}, 
        end_x = 2800, -- The player triggers the end at 2800 pixels!
        enemies = {
            {type = "Forest Sprite", x = 1500},
            {type = "brute", x = 2200}
        },
        -- tile things
        tileName = "cliff",
        tileNum = 4,
        tileWid = 400,
        tileLen = 500,
        tileMap = {1, 0, 0, 2, 3, 4, 1, 0, 2, 1, 1, 0, 3, 2, 0, 1, 0, 3, 4, 2, 3, 0, 1, 2, 0, 0, 4, 2, 0, 3, 0, 1, 0},
        -- tile B things
        tileNameB = "cliff",
        tileNumB = 3,
        tileWidB = 400,
        tileLenB = 500,
        tileMapB = {0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
        --tile C things
        tileNameC = "cliff",
        tileNumC = 3,
        tileWidC = 400,
        tileLenC = 500,
        tileMapC = {0, 1, 2, 2, 3, 0, 1, 0, 2, 1, 1, 0, 3, 2, 0, 1, 0, 3, 0, 2, 3, 0, 1, 2, 0, 0, 0, 2, 0, 3, 0, 1, 0},
        -- background
        background = love.graphics.newImage("Sprites/Backgrounds/Level1Background.png"),
        hintA = love.graphics.newImage("Sprites/Puzzles/Hints/circle.png"),
        hintAX = 400,
        hintAY = 600,
        hintB = love.graphics.newImage("Sprites/Puzzles/Hints/circle.png"),
        hintBX = 1500,
        hintBY = 400,
        hintC = love.graphics.newImage("Sprites/Puzzles/Hints/circle.png"),
        hintCX = 3000,
        hintCY = 400,
        puzzleBoxX = 2600
    },
    [2] = {
        musicPath = "Audio/Music/The_Lonely_Night_Forest.mp3",
        floor_color = {0, 0.5, 0, 1}, 
        end_x = 3500,
        enemies = {
            {type = "brute", x = 1000},
            {type = "Forest Sprite", x = 1500},
            {type = "brute", x = 2500}
        },
        -- tile things
        tileName = "forest",
        tileNum = 3,
        tileWid = 400,
        tileLen = 500,
        tileMap = {1, 0, 0, 2, 3, 0, 1, 0, 2, 1, 1, 0, 3, 2, 0, 1, 0, 3, 0, 2, 3, 0, 1, 2, 0, 0, 0, 2, 0, 3, 0, 1, 0},
        -- tile B things
        tileNameB = "forest",
        tileNumB = 1,
        tileWidB = 400,
        tileLenB = 500,
        tileMapB = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        --tile C things
        tileNameC = "forest",
        tileNumC = 2,
        tileWidC = 400,
        tileLenC = 500,
        tileMapC = {1, 0, 2, 0, 2, 0, 1, 2, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 2, 2, 1, 0, 1, 0, 0, 0, 2, 1, 0, 0, 2, 1, 0},
        background = love.graphics.newImage("Sprites/Backgrounds/Level2Background.png"),
        hintA = love.graphics.newImage("Sprites/Puzzles/Hints/triangle.png"),
        hintAX = 0,
        hintAY = 0,
        hintB = love.graphics.newImage("Sprites/Puzzles/Hints/circle.png"),
        hintBX = 0,
        hintBY = 0,
        hintC = love.graphics.newImage("Sprites/Puzzles/Hints/square.png"),
        hintCX = 0,
        hintCY = 0,
        puzzleBoxX = 3200
    },
    [3] = {
        musicPath = "Audio/Music/The_Lonely_Night_Fields.mp3",
        floor_color = {0, 0.5, 0, 1}, 
        end_x = 3500, -- Level 2 is a bit longer!
        enemies = {
            {type = "brute", x = 1000},
            {type = "Forest Sprite", x = 1500},
            {type = "brute", x = 2500}
        },
        -- tile things
        tileName = "field",
        tileNum = 1,
        tileWid = 400,
        tileLen = 500,
        tileMap = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        -- tile B things
        tileNameB = "field",
        tileNumB = 1,
        tileWidB = 400,
        tileLenB = 500,
        tileMapB = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        -- tile C things
        tileNameC = "field",
        tileNumC = 1,
        tileWidC = 400,
        tileLenC = 500,
        tileMapC = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        background = love.graphics.newImage("Sprites/Backgrounds/Level3Background.png"),
        hintA = love.graphics.newImage("Sprites/Puzzles/Hints/square.png"),
        hintAX = 0,
        hintAY = 0,
        hintB = love.graphics.newImage("Sprites/Puzzles/Hints/square.png"),
        hintBX = 0,
        hintBY = 420,
        hintC = love.graphics.newImage("Sprites/Puzzles/Hints/triangle.png"),
        hintCX = 200,
        hintCY = 500,
        puzzleBoxX = 3200
    },
  [4] = {
        musicPath = "Audio/Music/The_Lonely_Night_Town.mp3",
        floor_color = {0, 0.5, 0, 1}, 
        end_x = 3500,
        enemies = {
            {type = "brute", x = 1000},
            {type = "Forest Sprite", x = 1500},
            {type = "brute", x = 2500}
        },
        -- tile things
        tileName = "town",
        tileNum = 3,
        tileWid = 400,
        tileLen = 500,
        tileMap = {1, 0, 0, 2, 3, 0, 1, 0, 2, 1, 1, 0, 3, 2, 0, 1, 0, 3, 0, 2, 3, 0, 1, 2, 0, 0, 0, 2, 0, 3, 0, 1, 0},
        -- tile B things
        tileNameB = "town",
        tileNumB = 1,
        tileWidB = 400,
        tileLenB = 500,
        tileMapB = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        -- tile C things
        tileNameC = "town",
        tileNumC = 3,
        tileWidC = 400,
        tileLenC = 500,
        tileMapC = {1, 0, 0, 2, 3, 0, 1, 0, 2, 1, 1, 0, 3, 2, 0, 1, 0, 3, 0, 2, 3, 0, 1, 2, 0, 0, 0, 2, 0, 3, 0, 1, 0},
        background = love.graphics.newImage("Sprites/Backgrounds/Level4Background.png"),
        hintA = love.graphics.newImage("Sprites/Puzzles/Hints/circle.png"),
        hintAX = 0,
        hintAY = 0,
        hintB = love.graphics.newImage("Sprites/Puzzles/Hints/triangle.png"),
        hintBX = 0,
        hintBY = 0,
        hintC = love.graphics.newImage("Sprites/Puzzles/Hints/square.png"),
        hintCX = 0,
        hintCY = 0,
        puzzleBoxX = 3200
  },
  [5] = {
        musicPath = "Audio/Music/The_Lonely_Night_Church_Areas.mp3",
        floor_color = {0, 0.5, 0, 1}, 
        end_x = 3500, -- Level 2 is a bit longer!
        enemies = {
            {type = "brute", x = 1000},
            {type = "Forest Sprite", x = 1500},
            {type = "brute", x = 2500}
        },
        -- tile things
        tileName = "path",
        tileNum = 1,
        tileWid = 0,
        tileLen = 0,
        tileMap = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        -- tile B things
        tileNameB = "path",
        tileNumB = 1,
        tileWidB = 0,
        tileLenB = 0,
        tileMapB = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        --tile C things
        tileNameC = "path",
        tileNumC = 1,
        tileWidC = 0,
        tileLenC = 0,
        tileMapC = {1, 0, 0, 2, 3, 0, 1, 0, 2, 1, 1, 0, 3, 2, 0, 1, 0, 3, 0, 2, 3, 0, 1, 2, 0, 0, 0, 2, 0, 3, 0, 1, 0},
        background = love.graphics.newImage("Sprites/Backgrounds/Level5Background.png"),
        hintA = love.graphics.newImage("Sprites/Puzzles/Hints/circle.png"),
        hintAX = 0,
        hintAY = 0,
        hintB = love.graphics.newImage("Sprites/Puzzles/Hints/triangle.png"),
        hintBX = 0,
        hintBY = 0,
        hintC = love.graphics.newImage("Sprites/Puzzles/Hints/square.png"),
        hintCX = 0,
        hintCY = 0,
        puzzleBoxX = 3200
  },
    [6] = {
        musicPath = "Audio/Music/The_Lonely_Night_Church_Areas.mp3",
        floor_color = {0, 0.5, 0, 1}, 
        end_x = 3500,
        enemies = {
            {type = "brute", x = 1000},
            {type = "Forest Sprite", x = 1500},
            {type = "brute", x = 2500}
        },
        -- tile things
        tileName = "church",
        tileNum = 1,
        tileWid = 0,
        tileLen = 0,
        tileMap = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        -- tile B things
        tileNameB = "church",
        tileNumB = 1,
        tileWidB = 400,
        tileLenB = 600,
        tileMapB = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        --tile C things
        tileNameC = "church",
        tileNumC = 1,
        tileWidC = 0,
        tileLenC = 0,
        tileMapC = {1, 0, 0, 2, 3, 0, 1, 0, 2, 1, 1, 0, 3, 2, 0, 1, 0, 3, 0, 2, 3, 0, 1, 2, 0, 0, 0, 2, 0, 3, 0, 1, 0},
        background = love.graphics.newImage("Sprites/Backgrounds/Level6Background.png"),
        hintA = love.graphics.newImage("Sprites/Puzzles/Hints/circle.png"),
        hintAX = 0,
        hintAY = 0,
        hintB = love.graphics.newImage("Sprites/Puzzles/Hints/triangle.png"),
        hintBX = 0,
        hintBY = 0,
        hintC = love.graphics.newImage("Sprites/Puzzles/Hints/square.png"),
        hintCX = 0,
        hintCY = 0,
        puzzleBoxX = 3200
  },
  [7] = {
        musicPath = "Audio/Music/The_Lonely_Night_Final_Boss_Fight.mp3",
        floor_color = {0, 0.5, 0, 1}, 
        end_x = 1920,
        enemies = {
            {type = "brute", x = 1000},
            {type = "Forest Sprite", x = 1500},
            {type = "brute", x = 2500}
        },
                -- tile things
        tileName = "end",
        tileNum = 1,
        tileWid = 0,
        tileLen = 0,
        tileMap = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        -- tile B things
        tileNameB = "end",
        tileNumB = 1,
        tileWidB = 0,
        tileLenB = 0,
        tileMapB = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        --tile C things
        tileNameC = "end",
        tileNumC = 1,
        tileWidC = 0,
        tileLenC = 0,
        tileMapC = {1, 0, 0, 2, 3, 0, 1, 0, 2, 1, 1, 0, 3, 2, 0, 1, 0, 3, 0, 2, 3, 0, 1, 2, 0, 0, 0, 2, 0, 3, 0, 1, 0},
        background = love.graphics.newImage("Sprites/Backgrounds/Level7Background.png"),
        hintA = love.graphics.newImage("Sprites/Puzzles/Hints/circle.png"),
        hintAX = 0,
        hintAY = 0,
        hintB = love.graphics.newImage("Sprites/Puzzles/Hints/triangle.png"),
        hintBX = 0,
        hintBY = 0,
        hintC = love.graphics.newImage("Sprites/Puzzles/Hints/square.png"),
        hintCX = 0,
        hintCY = 0,
        puzzleBoxX = 3200
  }
}

-- Store your massive story text here!
data.signText = "My Greatest Love, my Dearest Eden. \nI write to you in regret and shame. I am shameful for what I have done. I thought maybe expressing my excellence to you would suffice in overcoming your ennui. \nIt did not work. My limerence has turned me into a fool, and for this I pay. Even now, after knowing the consequences of my deeds, I can still only envision the beauty in your eyes. \n\nI picture the darkness and twinkle in your irises like the clear midnight sky. Even just imagining it, it’s almost enough to disperse my ignominy. \nYou are so powerful, it’s truly infatuating. Somewhere in this power, I thought that slaying the Preserver could let you see what I was capable of. \n\nI yearned only to cure your malaise, to capture your favor by proving my absolute excellence through a feat so impossible it would echo through Eternity. \nThe prospect of your recognition fueled me for years and now the hubris granted by your thought has shifted into downcast. \nIf I could’ve spent a single moment thinking rationally then maybe there’s a fiction out there where I stopped my crusade and saved you. \n\nKnowing there’s no possibility to rescue you from erasure is crushing and it leaves me to think if there’s any purpose in continuing my journey on this heavenly body. \nI have been left with nothing but myself and the fractures of mind that I must gather. \n\nEven without your recognition, I feel your presence. Thank you for being there for me in my darkest times ~ I will continue to seek you for strength. \nEven in this loss, I thank you for making this disaster feel like a victory. \n\nI praise and love you My Eden.\n\n- Hylo Dupru"

return data