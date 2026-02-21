-- gamedata.lua
local data = {}

-- Store all your level configurations here!
data.levels = {
    [1] = {
        floor_color = {0, 0, 1, 1}, -- Blue
        enemies = {
            {type = "scout", x = 1500},
            {type = "brute", x = 2200}
        }
    },
    [2] = {
        floor_color = {0, 0.5, 0, 1}, -- Green
        enemies = {
            {type = "brute", x = 1000},
            {type = "scout", x = 1500},
            {type = "brute", x = 2500}
        }
    }
}

-- Store your massive story text here!
data.signText = "My Greatest Love, my Dearest Eden. \nI write to you in regret and shame. I am shameful for what I have done. I thought maybe expressing my excellence to you would suffice in overcoming your ennui. \nIt did not work. My limerence has turned me into a fool, and for this I pay. Even now, after knowing the consequences of my deeds, I can still only envision the beauty in your eyes. \n\nI picture the darkness and twinkle in your irises like the clear midnight sky. Even just imagining it, it’s almost enough to disperse my ignominy. \nYou are so powerful, it’s truly infatuating. Somewhere in this power, I thought that slaying the Preserver could let you see what I was capable of. \n\nI yearned only to cure your malaise, to capture your favor by proving my absolute excellence through a feat so impossible it would echo through Eternity. \nThe prospect of your recognition fueled me for years and now the hubris granted by your thought has shifted into downcast. \nIf I could’ve spent a single moment thinking rationally then maybe there’s a fiction out there where I stopped my crusade and saved you. \n\nKnowing there’s no possibility to rescue you from erasure is crushing and it leaves me to think if there’s any purpose in continuing my journey on this heavenly body. \nI have been left with nothing but myself and the fractures of mind that I must gather. \n\nEven without your recognition, I feel your presence. Thank you for being there for me in my darkest times ~ I will continue to seek you for strength. \nEven in this loss, I thank you for making this disaster feel like a victory. \n\nI praise and love you My Eden.\n\n- Hylo Dupru"

return data