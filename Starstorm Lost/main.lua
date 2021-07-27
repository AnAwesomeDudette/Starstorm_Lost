
------ main.lua
---- This file is automatically loaded by RoRML

-- Load the other Lua scripts

-- functions and such from Neik's Library
require("resources")

-- mod content

-- survivors (Nek)
local survivors = "Survivors/"
require(survivors.."artillerist")
require(survivors.."brawler")
require(survivors.."duke")
require(survivors.."scout")

-- variants
local variants = "Variants/"
require(variants.."bombardier")
