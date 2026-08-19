-- HM Anywhere v1.2.2 (Ported for Gen2Recomp)
--
-- Owning an HM item in your Bag allows field usage, provided a party member can learn it.

local PATCH_KEY = "__hm_anywhere_gen2_dispatch_v1"

local HM_BADGES = {
  CUT        = "HIVEBADGE",
  FLY        = "STORMBADGE",
  SURF       = "FOGBADGE",
  STRENGTH   = "PLAINBADGE",
  FLASH      = "ZEPHYRBADGE",
  WHIRLPOOL  = "GLACIERBADGE",
  WATERFALL  = "RISINGBADGE",
}

local FIELD_HMS = {
  CUT        = true,
  FLY        = true,
  SURF       = true,
  STRENGTH   = true,
  FLASH      = true,
  WHIRLPOOL  = true,
  WATERFALL  = true,
}

local HM_TO_MACHINE = {
  CUT        = { "HM01" },
  FLY        = { "HM02" },
  SURF       = { "HM03" },
  STRENGTH   = { "HM04" },
  FLASH      = { "HM05" },
  WHIRLPOOL  = { "HM06" },
  WATERFALL  = { "HM07" },
}

local HM_ORDER = { "CUT", "FLY", "SURF", "STRENGTH", "FLASH", "WHIRLPOOL", "WATERFALL" }

local HM_LABEL = {
  CUT        = "CUT",
  FLY        = "FLY",
  SURF       = "SURF",
  STRENGTH   = "STR",
  FLASH      = "FLSH",
  WHIRLPOOL  = "WHRL",
  WATERFALL  = "WTFL",
}

-- Comprehensive Gen II Learner Fallback Maps (Supports both IDs and Names)
local HARDCODED_HM_LEARNERS = {
  CUT = {
    1, 2, 3, 4, 5, 6, 10, 11, 12, 15, 17, 18, 19, 20, 27, 28, 29, 30, 31, 32, 33, 34, 43, 44, 45, 46, 47,
    52, 53, 69, 70, 71, 72, 73, 83, 84, 85, 98, 99, 102, 103, 108, 114, 115, 123, 127, 137, 151, 152, 153,
    154, 158, 159, 160, 161, 162, 177, 178, 191, 192, 193, 207, 208, 212, 214, 215, 227, 233, 235, 251,
    "BULBASAUR", "IVYSAUR", "VENUSAUR", "CHARMANDER", "CHARMELEON", "CHARIZARD", "CATERPIE", "METAPOD",
    "BUTTERFREE", "BEEDRILL", "PIDGEOTTO", "PIDGEOT", "RATTATA", "RATICATE", "SANDSHREW", "SANDSLASH",
    "NIDORAN_F", "NIDORINA", "NIDOQUEEN", "NIDORAN_M", "NIDORINO", "NIDOKING", "ODDISH", "GLOOM", "VILEPLUME",
    "PARAS", "PARASECT", "MEOWTH", "PERSIAN", "BELLSPROUT", "WEEPINBELL", "VICTREEBEL", "TENTACOOL", "TENTACRUEL",
    "FARFETCHD", "DODUO", "DODRIO", "KRABBY", "KINGLER", "EXEGGCUTE", "EXEGGUTOR", "LICKITUNG", "TANGELA",
    "KANGASKHAN", "SCYTHER", "PINSIR", "PORYGON", "MEW", "CHIKORITA", "BAYLEEF", "MEGANIUM", "TOTODILE",
    "CROCONAW", "FERALIGATR", "SENTRET", "FURRET", "NATU", "XATU", "SUNKERN", "SUNFLORA", "YANMA", "GLIGAR",
    "STEELIX", "SCIZOR", "HERACROSS", "SNEASEL", "SKARMORY", "PORYGON2", "SMEARGLE", "CELEBI"
  },
  FLY = {
    6, 16, 17, 18, 21, 22, 41, 42, 83, 84, 85, 142, 144, 145, 146, 149, 151, 163, 164, 169, 177, 178, 198,
    225, 227, 235, 249, 250,
    "CHARIZARD", "PIDGEY", "PIDGEOTTO", "PIDGEOT", "SPEAROW", "FEAROW", "ZUBAT", "GOLBAT", "FARFETCHD",
    "DODUO", "DODRIO", "AERODACTYL", "ARTICUNO", "ZAPDOS", "MOLTRES", "DRAGONITE", "MEW", "HOOTHOOT",
    "NOCTOWL", "CROBAT", "NATU", "XATU", "MURKROW", "DELIBIRD", "SKARMORY", "SMEARGLE", "LUGIA", "HO_OH"
  },
  SURF = {
    7, 8, 9, 26, 31, 34, 54, 55, 60, 61, 62, 72, 73, 79, 80, 86, 87, 90, 91, 98, 99, 108, 111, 112, 115,
    116, 117, 118, 119, 120, 121, 130, 131, 134, 138, 139, 140, 141, 143, 147, 148, 149, 151, 158, 159, 160,
    161, 162, 170, 171, 183, 184, 194, 195, 199, 211, 222, 223, 224, 226, 230, 235, 243, 245, 246, 247, 248, 249,
    "SQUIRTLE", "WARTORTLE", "BLASTOISE", "RAICHU", "NIDOQUEEN", "NIDOKING", "PSYDUCK", "GOLDUCK", "POLIWAG",
    "POLIWHIRL", "POLIWRATH", "TENTACOOL", "TENTACRUEL", "SLOWPOKE", "SLOWBRO", "SEEL", "DEWGONG", "SHELLDER",
    "CLOYSTER", "KRABBY", "KINGLER", "LICKITUNG", "RHYHORN", "RHYDON", "KANGASKHAN", "HORSEA", "SEADRA",
    "GOLDEEN", "SEAKING", "STARYU", "STARMIE", "GYARADOS", "LAPRAS", "VAPOREON", "OMANYTE", "OMASTAR",
    "KABUTO", "KABUTOPS", "SNORLAX", "DRATINI", "DRAGONAIR", "DRAGONITE", "MEW", "TOTODILE", "CROCONAW",
    "FERALIGATR", "SENTRET", "FURRET", "CHINCHOU", "LANTURN", "MARILL", "AZUMARILL", "WOOPER", "QUAGSIRE",
    "SLOWKING", "QWILFISH", "CORSOLA", "REMORAID", "OCTILLERY", "MANTINE", "KINGDRA", "SMEARGLE", "RAIKOU",
    "SUICUNE", "LARVITAR", "PUPITAR", "TYRANITAR", "LUGIA"
  },
  STRENGTH = {
    3, 6, 9, 28, 31, 34, 56, 57, 62, 66, 67, 68, 74, 75, 76, 80, 88, 89, 95, 99, 105, 106, 107, 108, 111,
    112, 113, 115, 121, 125, 126, 127, 128, 130, 131, 143, 149, 150, 151, 154, 157, 160, 162, 181, 184, 185,
    190, 195, 199, 208, 209, 210, 212, 214, 215, 217, 221, 222, 229, 232, 233, 235, 241, 242, 243, 244, 245,
    248, 249, 250,
    "VENUSAUR", "CHARIZARD", "BLASTOISE", "SANDSLASH", "NIDOQUEEN", "NIDOKING", "MANKEY", "PRIMEAPE", "POLIWRATH",
    "MACHOP", "MACHOKE", "MACHAMP", "GEODUDE", "GRAVELER", "GOLEM", "SLOWBRO", "GRIMER", "MUK", "ONIX",
    "KINGLER", "MAROWAK", "HITMONLEE", "HITMONCHAN", "LICKITUNG", "RHYHORN", "RHYDON", "CHANSEY", "KANGASKHAN",
    "STARMIE", "ELECTABUZZ", "MAGMAR", "PINSIR", "TAUROS", "GYARADOS", "LAPRAS", "SNORLAX", "DRAGONITE",
    "MEWTWO", "MEW", "MEGANIUM", "TYPHLOSION", "FERALIGATR", "FURRET", "AMPHAROS", "AZUMARILL", "SUDOWOODO",
    "AIPOM", "QUAGSIRE", "SLOWKING", "STEELIX", "SNUBBULL", "GRANBULL", "SCIZOR", "HERACROSS", "SNEASEL",
    "URSARING", "PILOSWINE", "CORSOLA", "HOUNDOOM", "DONPHAN", "PORYGON2", "SMEARGLE", "MILTANK", "BLISSEY",
    "RAIKOU", "ENTEI", "SUICUNE", "TYRANITAR", "LUGIA", "HO_OH"
  },
  FLASH = {
    25, 26, 35, 36, 39, 40, 46, 47, 48, 49, 52, 53, 54, 55, 63, 64, 65, 79, 80, 81, 82, 96, 97, 100, 101,
    102, 103, 113, 120, 121, 122, 124, 125, 126, 137, 150, 151, 152, 153, 154, 172, 173, 174, 175, 176, 179,
    180, 181, 182, 183, 184, 191, 192, 194, 195, 196, 197, 199, 203, 206, 209, 210, 223, 224, 233, 234, 235,
    239, 240, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251,
    "PIKACHU", "RAICHU", "CLEFAIRY", "CLEFABLE", "JIGGLYPUFF", "WIGGLYTUFF", "PARAS", "PARASECT", "VENONAT",
    "VENOMOTH", "MEOWTH", "PERSIAN", "PSYDUCK", "GOLDUCK", "ABRA", "KADABRA", "ALAKAZAM", "SLOWPOKE", "SLOWBRO",
    "MAGNEMITE", "MAGNETON", "DROWZEE", "HYPNO", "VOLTORB", "ELECTRODE", "EXEGGCUTE", "EXEGGUTOR", "CHANSEY",
    "STARYU", "STARMIE", "MR_MIME", "JYNX", "ELECTABUZZ", "MAGMAR", "PORYGON", "MEWTWO", "MEW", "CHIKORITA",
    "BAYLEEF", "MEGANIUM", "PICHU", "CLEFFA", "IGGLYBUFF", "TOGEPI", "TOGETIC", "MAREEP", "FLAAFFY", "AMPHAROS",
    "BELLOSSOM", "MARILL", "AZUMARILL", "SUNKERN", "SUNFLORA", "WOOPER", "QUAGSIRE", "ESPEON", "UMBREON", "SLOWKING",
    "GIRAFARIG", "DUNSPARCE", "SNUBBULL", "GRANBULL", "REMORAID", "OCTILLERY", "PORYGON2", "STANTLER", "SMEARGLE",
    "ELEKID", "MAGBY", "BLISSEY", "RAIKOU", "ENTEI", "SUICUNE", "LARVITAR", "PUPITAR", "TYRANITAR", "LUGIA",
    "HO_OH", "CELEBI"
  },
  WHIRLPOOL = {
    7, 8, 9, 54, 55, 60, 61, 62, 72, 73, 86, 87, 90, 91, 98, 99, 116, 117, 118, 119, 120, 121, 130, 131,
    138, 139, 140, 141, 151, 158, 159, 160, 170, 171, 183, 184, 194, 195, 211, 222, 223, 224, 226, 230, 235, 245, 249,
    "SQUIRTLE", "WARTORTLE", "BLASTOISE", "PSYDUCK", "GOLDUCK", "POLIWAG", "POLIWHIRL", "POLIWRATH", "TENTACOOL",
    "TENTACRUEL", "SEEL", "DEWGONG", "SHELLDER", "CLOYSTER", "KRABBY", "KINGLER", "HORSEA", "SEADRA", "GOLDEEN",
    "SEAKING", "STARYU", "STARMIE", "GYARADOS", "LAPRAS", "OMANYTE", "OMASTAR", "KABUTO", "KABUTOPS", "MEW",
    "TOTODILE", "CROCONAW", "FERALIGATR", "CHINCHOU", "LANTURN", "MARILL", "AZUMARILL", "WOOPER", "QUAGSIRE",
    "QWILFISH", "CORSOLA", "REMORAID", "OCTILLERY", "MANTINE", "KINGDRA", "SMEARGLE", "SUICUNE", "LUGIA"
  },
  WATERFALL = {
    7, 8, 9, 54, 55, 60, 61, 62, 72, 73, 86, 87, 116, 117, 118, 119, 120, 121, 130, 131, 147, 148, 149,
    151, 158, 159, 160, 170, 171, 183, 184, 194, 195, 211, 222, 223, 224, 226, 230, 235, 245, 249,
    "SQUIRTLE", "WARTORTLE", "BLASTOISE", "PSYDUCK", "GOLDUCK", "POLIWAG", "POLIWHIRL", "POLIWRATH", "TENTACOOL",
    "TENTACRUEL", "SEEL", "DEWGONG", "HORSEA", "SEADRA", "GOLDEEN", "SEAKING", "STARYU", "STARMIE", "GYARADOS",
    "LAPRAS", "DRATINI", "DRAGONAIR", "DRAGONITE", "MEW", "TOTODILE", "CROCONAW", "FERALIGATR", "CHINCHOU",
    "LANTURN", "MARILL", "AZUMARILL", "WOOPER", "QUAGSIRE", "QWILFISH", "CORSOLA", "REMORAID", "OCTILLERY",
    "MANTINE", "KINGDRA", "SMEARGLE", "SUICUNE", "LUGIA"
  }
}

local function hasCount(value)
  if type(value) == "number" then return value > 0 end
  return value == true
end

local function ownedHM(game, moveId)
  local inventory = game and game.save and game.save.inventory or {}
  local items = game and game.data and game.data.items or {}
  
  local targetHM = HM_TO_MACHINE[moveId] and HM_TO_MACHINE[moveId][1]

  for itemId, count in pairs(inventory) do
    if hasCount(count) then
      if itemId == targetHM or (items[itemId] and items[itemId].machine and items[itemId].machine.move == moveId) then
        return itemId, items[itemId]
      end
    end
  end
  return nil
end

local function hasAnyHM(game)
  for _, moveId in ipairs(HM_ORDER) do
    if ownedHM(game, moveId) then return true end
  end
  return false
end

local function hasBadge(game, moveId)
  local badge = HM_BADGES[moveId]
  if not badge then return true end
  
  local flags = game and game.save and (game.save.flags or game.save.badges)
  if flags then
    if flags["ENGINE_" .. badge] or flags[badge] or flags[badge:lower()] then
      return true
    end
  end

  local inventory = game and game.save and game.save.inventory or {}
  return hasCount(inventory[badge])
end

-- -------------------------------------------------------------------------
-- Ultra-Robust Multi-Key Compatibility Checker
-- -------------------------------------------------------------------------

local function isFainted(mon)
  if not mon then return true end
  if type(mon.hp) == "number" then return mon.hp <= 0 end
  if type(mon.currentHp) == "number" then return mon.currentHp <= 0 end
  if type(mon.current_hp) == "number" then return mon.current_hp <= 0 end
  return false
end

local function canLearnHM(game, mon, moveId)
  if isFainted(mon) then return false end

  -- 1. Check actively equipped moveset
  if mon.moves then
    for _, m in ipairs(mon.moves) do
      local mid = type(m) == "table" and (m.id or m.move or m.name) or m
      if mid == moveId or (type(mid) == "string" and mid:upper() == moveId) then 
        return true 
      end
    end
  end

  -- Extract all possible key forms for species identifier
  local rawSpecies = mon.species or mon.speciesId or mon.def or mon.id or mon.name or mon.species_id
  local candidateKeys = {}

  if type(rawSpecies) == "table" then
    if rawSpecies.id then table.insert(candidateKeys, rawSpecies.id) end
    if rawSpecies.name then table.insert(candidateKeys, rawSpecies.name) end
    if rawSpecies.species then table.insert(candidateKeys, rawSpecies.species) end
    if rawSpecies.nationalPokedexNumber then table.insert(candidateKeys, rawSpecies.nationalPokedexNumber) end
    if rawSpecies.dexNo then table.insert(candidateKeys, rawSpecies.dexNo) end
  elseif rawSpecies then
    table.insert(candidateKeys, rawSpecies)
  end

  local searchMap = {}
  for _, k in ipairs(candidateKeys) do
    searchMap[k] = true
    local s = tostring(k):upper()
    searchMap[s] = true
    searchMap[s:lower()] = true
    
    -- Strip common enum prefixes if present (e.g., SPECIES_BAYLEEF -> BAYLEEF)
    if s:find("^SPECIES_") then
      local clean = s:gsub("^SPECIES_", "")
      searchMap[clean] = true
      searchMap[clean:lower()] = true
    end

    local n = tonumber(k)
    if n then searchMap[n] = true end
  end

  -- Move Targets (FLASH, HM05, etc.)
  local moveTargets = { [moveId] = true, [moveId:lower()] = true }
  if HM_TO_MACHINE[moveId] then
    for _, mCode in ipairs(HM_TO_MACHINE[moveId]) do
      moveTargets[mCode] = true
      moveTargets[mCode:lower()] = true
    end
  end

  -- 2. Engine Pokedex Dynamic Inspection
  local pokedex = game and game.data and game.data.pokedex
  if type(pokedex) == "table" then
    for targetKey in pairs(searchMap) do
      local entry = pokedex[targetKey]
      if entry then
        local tmhmTable = entry.tmhm or entry.tms or entry.machines or entry.learnable_tms
        if type(tmhmTable) == "table" then
          for tKey in pairs(moveTargets) do
            if tmhmTable[tKey] == true or tmhmTable[tKey] == 1 then
              return true
            end
          end
          -- Array check if engine stores learnable moves as a list of strings
          for _, val in ipairs(tmhmTable) do
            local sVal = tostring(val):upper()
            if moveTargets[sVal] or sVal == moveId then
              return true
            end
          end
        end
      end
    end
  end

  -- 3. Hardcoded Learners Fallback Check
  local fallbackList = HARDCODED_HM_LEARNERS[moveId]
  if fallbackList then
    for _, learnerKey in ipairs(fallbackList) do
      if searchMap[learnerKey] or searchMap[tostring(learnerKey):upper()] then
        return true
      end
    end
  end

  return false
end

local function getEligibleMon(game, moveId)
  local party = game and game.save and game.save.party or {}
  for _, mon in ipairs(party) do
    if canLearnHM(game, mon, moveId) then
      return mon
    end
  end
  return nil
end

local function contextualEnabled(mod)
  return mod.save:get("contextualActions", true) ~= false
end

local function setContextual(mod, enabled)
  mod.save:set("contextualActions", enabled and true or false)
end

local function pushText(game, text, onDone)
  local TextBox = require("src.render.TextBox")
  game.stack:push(TextBox.new(game, text, onDone))
end

local function textOr(game, key, fallback)
  local text = game and game.data and game.data.text
  return (text and text[key]) or fallback
end

local function badgeRequired(game)
  return textOr(game, "_NewBadgeRequiredText", "A new BADGE is\nrequired.")
end

local function noLandingText(game)
  return textOr(game, "_SurfingNoPlaceToGetOffText", "There's no place\nto get off!")
end

local function fieldUnavailable(game, moveId, reopen)
  pushText(game, moveId .. " can't be\nused right now.", reopen)
end

-- -------------------------------------------------------------------------
-- Contextual A-button actions
-- -------------------------------------------------------------------------

local function tryStrength(game, ow)
  if not ownedHM(game, "STRENGTH") then return false end
  local Map = require("src.world.Map")
  local player = ow.player
  local fx, fy = player:facingCell()
  local npc = ow:npcAtCell(fx, fy)
  if not (npc and npc.def and Map.isPushable(npc.def)) then return false end

  if not hasBadge(game, "STRENGTH") then
    pushText(game, badgeRequired(game))
    return true
  end

  if not getEligibleMon(game, "STRENGTH") then return false end

  local function pushNow()
    if not (ow.map and ow.player) then return end
    ow.strengthActive = true
    ow.boulderTried = nil
    ow:checkBoulderPush(player.facing)
    ow:checkBoulderPush(player.facing)
  end

  if not ow.strengthActive then
    ow.strengthActive = true
    pushText(game, "The HM device used\nSTRENGTH!\fBoulders can now\nbe moved.", pushNow)
  else
    pushNow()
  end
  return true
end

local function tryCut(game, ow)
  if not ownedHM(game, "CUT") then return false end
  local reason = ow:useCutFieldMove()
  if reason ~= "ok" then return false end

  if not hasBadge(game, "CUT") then
    pushText(game, badgeRequired(game))
    return true
  end

  if not getEligibleMon(game, "CUT") then return false end

  local fx, fy = ow.player:facingCell()
  ow:tryCut(fx, fy)
  return true
end

local function tryWhirlpool(game, ow)
  if not ownedHM(game, "WHIRLPOOL") or not ow.useWhirlpoolFieldMove then return false end
  local reason = ow:useWhirlpoolFieldMove()
  if reason ~= "ok" then return false end

  if not hasBadge(game, "WHIRLPOOL") then
    pushText(game, badgeRequired(game))
    return true
  end

  if not getEligibleMon(game, "WHIRLPOOL") then return false end

  local fx, fy = ow.player:facingCell()
  ow:tryWhirlpool(fx, fy)
  return true
end

local function tryWaterfall(game, ow)
  if not ownedHM(game, "WATERFALL") or not ow.useWaterfallFieldMove then return false end
  local reason = ow:useWaterfallFieldMove()
  if reason ~= "ok" then return false end

  if not hasBadge(game, "WATERFALL") then
    pushText(game, badgeRequired(game))
    return true
  end

  if not getEligibleMon(game, "WATERFALL") then return false end

  ow:tryWaterfall()
  return true
end

local function dismountSurf(game, ow)
  local player = ow.player
  player.surfing = false
  require("src.core.Music").setSurfing(game.data, false)
  local Transition = require("src.render.Transition")
  game.stack:push(Transition.whiteFlash(game, nil, function()
    ow:stepForwardOrCrossEdge(player.facing)
  end))
end

local function trySurf(game, ow)
  if not ownedHM(game, "SURF") then return false end
  local reason = ow:useSurfFieldMove()
  if reason == "no_water" or reason == "forced_bike" or reason == "current" then
    return false
  end

  if not hasBadge(game, "SURF") then
    if reason == "ok" then
      pushText(game, badgeRequired(game))
      return true
    end
    return false
  end

  if not getEligibleMon(game, "SURF") then return false end

  if reason == "ok" then
    local fx, fy = ow.player:facingCell()
    ow:trySurf(fx, fy)
    return true
  elseif reason == "dismount" then
    dismountSurf(game, ow)
    return true
  elseif reason == "no_place" then
    pushText(game, noLandingText(game))
    return true
  end
  return false
end

local function directNpcAhead(ow)
  local player = ow and ow.player
  if not (player and ow.npcAtCell) then return nil end
  local fx, fy = player:facingCell()
  return ow:npcAtCell(fx, fy)
end

local function contextualInteract(game, mod, baseInteract, ow, ...)
  if not (ow and ow.player and ow.map) then return baseInteract(ow, ...) end

  if not contextualEnabled(mod) then
    return baseInteract(ow, ...)
  end

  if tryStrength(game, ow) then return end

  if directNpcAhead(ow) then
    return baseInteract(ow, ...)
  end

  if tryCut(game, ow) then return end
  if tryWhirlpool(game, ow) then return end
  if tryWaterfall(game, ow) then return end
  if trySurf(game, ow) then return end

  return baseInteract(ow, ...)
end

-- -------------------------------------------------------------------------
-- Manual Start -> HM actions
-- -------------------------------------------------------------------------

local function isOutside(game, ow)
  if not (ow and ow.map and ow.map.def) then return false end
  local Map = require("src.world.Map")
  local FieldDefaults = require("src.world.FieldDefaults")
  return Map.isOutside(ow.map.def, FieldDefaults.field(game.data, "outsideTilesets"))
end

local function removeVanillaHMRows(items)
  local out = {}
  for _, item in ipairs(items or {}) do
    local label = tostring(item.label or ""):upper()
    if not FIELD_HMS[label] then out[#out + 1] = item end
  end
  return out
end

local function cutFromMenu(game, reopen)
  local ow = game.overworld
  if not (ow and ow.map and ow.player) then fieldUnavailable(game, "CUT", reopen); return end
  if not hasBadge(game, "CUT") then pushText(game, badgeRequired(game), reopen); return end
  if not getEligibleMon(game, "CUT") then pushText(game, "No Pokémon can\nuse CUT.", reopen); return end

  local reason = ow:useCutFieldMove()
  if reason == "ok" then
    local fx, fy = ow.player:facingCell()
    ow:tryCut(fx, fy)
  else
    pushText(game, textOr(game, "_NothingToCutText", "Nothing to CUT!"), reopen)
  end
end

local function surfFromMenu(game, reopen)
  local ow = game.overworld
  if not (ow and ow.map and ow.player) then fieldUnavailable(game, "SURF", reopen); return end
  if not hasBadge(game, "SURF") then pushText(game, badgeRequired(game), reopen); return end
  if not getEligibleMon(game, "SURF") then pushText(game, "No Pokémon can\nuse SURF.", reopen); return end

  local reason = ow:useSurfFieldMove()
  if reason == "ok" then
    local fx, fy = ow.player:facingCell()
    ow:trySurf(fx, fy)
  elseif reason == "dismount" then
    dismountSurf(game, ow)
  elseif reason == "no_place" then
    pushText(game, noLandingText(game), reopen)
  else
    pushText(game, textOr(game, "_NoSurfingHereText", "No SURFing here!"), reopen)
  end
end

local function strengthFromMenu(game, reopen)
  local ow = game.overworld
  if not (ow and ow.map and ow.player) then fieldUnavailable(game, "STR", reopen); return end
  if not hasBadge(game, "STRENGTH") then pushText(game, badgeRequired(game), reopen); return end
  if not getEligibleMon(game, "STRENGTH") then pushText(game, "No Pokémon can\nuse STRENGTH.", reopen); return end

  if ow.strengthActive then
    pushText(game, "STRENGTH is already\nbeing used.", reopen)
    return
  end

  ow.strengthActive = true
  pushText(game, "The HM device used\nSTRENGTH!\fBoulders can now\nbe moved.")
end

local function flashFromMenu(game, reopen)
  local ow = game.overworld
  if not (ow and ow.map and ow.player) then fieldUnavailable(game, "FLASH", reopen); return end
  if not hasBadge(game, "FLASH") then pushText(game, badgeRequired(game), reopen); return end
  if not getEligibleMon(game, "FLASH") then pushText(game, "No Pokémon can\nuse FLASH.", reopen); return end
  if not ow.dark then
    pushText(game, "It is already\nbright here.", reopen)
    return
  end

  game.save.flashLit = true
  pushText(game, textOr(game, "_FlashLightsAreaText", "A blinding FLASH\nlights the area!"), function()
    local Transition = require("src.render.Transition")
    game.stack:push(Transition.whiteFlash(game, nil, function()
      if ow.setDark then ow:setDark(false) else ow.dark = false end
    end))
  end)
end

local function flyFromMenu(game, mod, reopen)
  local ow = game.overworld
  if not (ow and ow.map and ow.player) then fieldUnavailable(game, "FLY", reopen); return end
  if not hasBadge(game, "FLY") then pushText(game, badgeRequired(game), reopen); return end
  if not getEligibleMon(game, "FLY") then pushText(game, "No Pokémon can\nuse FLY.", reopen); return end
  if not isOutside(game, ow) then
    pushText(game, "FLY can't be used\nhere.", reopen)
    return
  end

  local current = ow
  mod.ui.push(game, "TownMap", {
    fly = true,
    onFly = function(mapId)
      if current and current.flyTo then current:flyTo(mapId) end
    end,
  })
end

local function whirlpoolFromMenu(game, reopen)
  local ow = game.overworld
  if not (ow and ow.map and ow.player) then fieldUnavailable(game, "WHRL", reopen); return end
  if not hasBadge(game, "WHIRLPOOL") then pushText(game, badgeRequired(game), reopen); return end
  if not getEligibleMon(game, "WHIRLPOOL") then pushText(game, "No Pokémon can\nuse WHIRLPOOL.", reopen); return end
  
  if ow.useWhirlpoolFieldMove and ow:useWhirlpoolFieldMove() == "ok" then
    local fx, fy = ow.player:facingCell()
    ow:tryWhirlpool(fx, fy)
  else
    pushText(game, "It's a vicious\nwhirlpool!", reopen)
  end
end

local function waterfallFromMenu(game, reopen)
  local ow = game.overworld
  if not (ow and ow.map and ow.player) then fieldUnavailable(game, "WTFL", reopen); return end
  if not hasBadge(game, "WATERFALL") then pushText(game, badgeRequired(game), reopen); return end
  if not getEligibleMon(game, "WATERFALL") then pushText(game, "No Pokémon can\nuse WATERFALL.", reopen); return end

  if ow.useWaterfallFieldMove and ow:useWaterfallFieldMove() == "ok" then
    ow:tryWaterfall()
  else
    pushText(game, "A wall of water is\ntumbling down.", reopen)
  end
end

local function openHMMenu(game, mod)
  local Menu = require("src.ui.Menu")
  local Screens = require("src.ui.Screens")

  local function reopen()
    openHMMenu(game, mod)
  end

  local items = {}

  for _, moveId in ipairs(HM_ORDER) do
    if ownedHM(game, moveId) then
      local label = HM_LABEL[moveId]
      if moveId == "CUT" then
        items[#items + 1] = { label = label, onSelect = function() cutFromMenu(game, reopen) end }
      elseif moveId == "FLY" then
        items[#items + 1] = { label = label, onSelect = function() flyFromMenu(game, mod, reopen) end }
      elseif moveId == "SURF" then
        items[#items + 1] = { label = label, onSelect = function() surfFromMenu(game, reopen) end }
      elseif moveId == "STRENGTH" then
        items[#items + 1] = { label = label, onSelect = function() strengthFromMenu(game, reopen) end }
      elseif moveId == "FLASH" then
        items[#items + 1] = { label = label, onSelect = function() flashFromMenu(game, reopen) end }
      elseif moveId == "WHIRLPOOL" then
        items[#items + 1] = { label = label, onSelect = function() whirlpoolFromMenu(game, reopen) end }
      elseif moveId == "WATERFALL" then
        items[#items + 1] = { label = label, onSelect = function() waterfallFromMenu(game, reopen) end }
      end
    end
  end

  if #items == 0 then
    pushText(game, "No usable HM is\nin the BAG.", function()
      Screens.push(game, "StartMenu")
    end)
    return
  end

  local contextItem
  contextItem = {
    label = contextualEnabled(mod) and "CTX ON" or "CTX OFF",
    keepOpen = true,
    onSelect = function()
      local enabled = not contextualEnabled(mod)
      setContextual(mod, enabled)
      contextItem.label = enabled and "CTX ON" or "CTX OFF"
      mod.log:info("HM Anywhere contextual actions: %s", enabled and "ON" or "OFF")
    end,
  }
  items[#items + 1] = contextItem

  game.stack:push(Menu.new(game, items, {
    tx = 10,
    ty = 0,
    tw = 10,
    onCancel = function()
      Screens.push(game, "StartMenu")
    end,
  }))
end

return function(mod)
  mod.events:on("game.ready", function(event)
    local game = event and event.game
    local OverworldState = game and game.overworld
    if not (game and type(OverworldState) == "table") then
      mod.log:warn("HM Anywhere could not install: game.ready had no overworld")
      return
    end

    local dispatch = rawget(_G, PATCH_KEY)
    if not dispatch then
      dispatch = {
        baseInteract = OverworldState.interact,
        basePartyKnows = OverworldState.partyKnows,
      }
      rawset(_G, PATCH_KEY, dispatch)

      OverworldState.interact = function(self, ...)
        local handler = dispatch.interact
        if handler then return handler(self, ...) end
        return dispatch.baseInteract(self, ...)
      end

      OverworldState.partyKnows = function(self, moveId, ...)
        local handler = dispatch.partyKnows
        if handler then
          local mon = handler(self, moveId, ...)
          if mon then return mon end
        end
        return dispatch.basePartyKnows(self, moveId, ...)
      end
    end

    dispatch.interact = function(ow, ...)
      return contextualInteract(game, mod, dispatch.baseInteract, ow, ...)
    end

    -- Require Item Ownership + Badge + Party Species Compatibility
    dispatch.partyKnows = function(_, moveId)
      if FIELD_HMS[moveId] and ownedHM(game, moveId) and hasBadge(game, moveId) then
        local mon = getEligibleMon(game, moveId)
        if mon then return mon end
      end
      return nil
    end

    mod.log:info("HM Anywhere installed for Gen2Recomped.")
  end)

  mod.hooks:wrap("ui.party.submenu", function(next_, game, items, mon, ctx)
    local out = next_(game, items, mon, ctx)
    if type(out) ~= "table" or (ctx and ctx.battle) then return out end
    return removeVanillaHMRows(out)
  end)

  mod.hooks:wrap("ui.start_menu.items", function(next_, game, items)
    local out = next_(game, items)
    if type(out) ~= "table" then return out end
    if not hasAnyHM(game) then return out end
    for _, item in ipairs(out) do
      if tostring(item.label):upper() == "HM" then return out end
    end
    return mod.ui.insertBefore(out, "SAVE", {
      label = "HM",
      onSelect = function()
        openHMMenu(game, mod)
      end,
    })
  end)

  mod.exports.ownedHM = function(game, moveId)
    return ownedHM(game, moveId) ~= nil
  end
  mod.exports.hasBadge = hasBadge
  mod.exports.contextualEnabled = function()
    return contextualEnabled(mod)
  end
  mod.exports.setContextual = function(enabled)
    setContextual(mod, enabled)
  end
end
