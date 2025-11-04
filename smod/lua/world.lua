-- smod/lua/world.lua
-- Sistema de mundo infinito estilo sandbox + stream LOD

local world = {
    chunk_size = 32,
    render_distance = 4, -- chunks ao redor
    loaded_chunks = {},
    textures = {
        grass = "textures/grass_pix.png",
        dirt  = "textures/dirt_pix.png",
        stone = "textures/stone_pix.png",
        water = "textures/water_pix.png"
    }
}

-- hashing posição do chunk
local function chunk_key(cx, cy, cz)
    return cx .. ":" .. cy .. ":" .. cz
end

-- Simula geração de chunk (replace com engine real depois)
local function generate_chunk(cx, cy, cz)
    return {
        id = chunk_key(cx, cy, cz),
        x = cx,
        y = cy,
        z = cz,
        blocks = "chunk data placeholder",
        texture = world.textures.grass,
        loaded = false,
        loading_progress = 0
    }
end

-- Simulação de render / load streaming
local function update_chunk(chunk, dt)
    if not chunk.loaded then
        chunk.loading_progress = chunk.loading_progress + dt * 0.5
        
        if chunk.loading_progress >= 1 then
            chunk.loaded = true
        end
    end
end

function world.update(player, dt)
    local pcx = math.floor(player.pos.x / world.chunk_size)
    local pcz = math.floor(player.pos.z / world.chunk_size)

    -- carregar vizinhança
    for x = -world.render_distance, world.render_distance do
        for z = -world.render_distance, world.render_distance do
            local cx = pcx + x
            local cz = pcz + z
            local key = chunk_key(cx, 0, cz)

            if not world.loaded_chunks[key] then
                world.loaded_chunks[key] = generate_chunk(cx, 0, cz)
            end

            update_chunk(world.loaded_chunks[key], dt)
        end
    end
end

function world.debug()
    print("Chunks carregados:")
    for k, chunk in pairs(world.loaded_chunks) do
        local status = chunk.loaded and "✔️" or ("⌛ " .. math.floor(chunk.loading_progress * 100) .. "%")
        print(k .. " [" .. status .. "]")
    end
end

return world
