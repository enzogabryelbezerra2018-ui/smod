-- SMOD Player Controller
-- Movimento básico estilo Garry's Mod / Source Engine

local player = {
    pos = {x = 0, y = 1.8, z = 0}, -- ALTURA HUMANA
    vel = {x = 0, y = 0, z = 0},
    yaw = 0,
    pitch = 0,
    walk_speed = 6,
    jump_force = 6,
    gravity = -9.8,
    grounded = false
}

local input = {
    forward = false,
    backward = false,
    left = false,
    right = false,
    jump = false
}

function set_input(key, state)
    if key == "w" then input.forward = state end
    if key == "s" then input.backward = state end
    if key == "a" then input.left = state end
    if key == "d" then input.right = state end
    if key == "space" then input.jump = state end
end

-- Atualizar física do jogador
function player_update(dt)
    local moveX, moveZ = 0, 0

    if input.forward  then moveZ = moveZ + 1 end
    if input.backward then moveZ = moveZ - 1 end
    if input.left     then moveX = moveX - 1 end
    if input.right    then moveX = moveX + 1 end

    local speed = player.walk_speed

    player.vel.x = moveX * speed
    player.vel.z = moveZ * speed

    -- Gravidade
    if not player.grounded then
        player.vel.y = player.vel.y + player.gravity * dt
    end

    -- Pulo
    if input.jump and player.grounded then
        player.vel.y = player.jump_force
        player.grounded = false
    end

    -- Atualiza posição
    player.pos.x = player.pos.x + player.vel.x * dt
    player.pos.y = player.pos.y + player.vel.y * dt
    player.pos.z = player.pos.z + player.vel.z * dt

    -- Chão (simplificado)
    if player.pos.y <= 1.8 then
        player.pos.y = 1.8
        player.vel.y = 0
        player.grounded = true
    end
end

-- Rotação da câmera
function player_look(dx, dy)
    player.yaw = player.yaw + dx
    player.pitch = math.max(-89, math.min(89, player.pitch + dy))
end

function debug_player()
    print(string.format(
        "Pos: (%.2f, %.2f, %.2f)  Vel: (%.2f, %.2f, %.2f)  Grounded: %s",
        player.pos.x, player.pos.y, player.pos.z,
        player.vel.x, player.vel.y, player.vel.z,
        tostring(player.grounded)
    ))
end

return {
    set_input = set_input,
    update = player_update,
    look = player_look,
    debug = debug_player,
    player = player
}
