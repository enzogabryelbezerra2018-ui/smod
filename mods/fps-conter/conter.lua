-- mods/fps-conter/conter.lua
-- Mostra FPS verde no canto da tela

local fpsCounter = {
    lastTime = os.clock(),
    frameCount = 0,
    fps = 0
}

function fpsCounter.update()
    fpsCounter.frameCount = fpsCounter.frameCount + 1
    local currentTime = os.clock()
    local delta = currentTime - fpsCounter.lastTime

    if delta >= 1 then
        fpsCounter.fps = fpsCounter.frameCount
        fpsCounter.frameCount = 0
        fpsCounter.lastTime = currentTime
    end
end

function fpsCounter.draw()
    -- Aqui você coloca sua função de render texto do motor SMOD
    -- Exemplo: drawText("FPS: " .. fpsCounter.fps, x, y, R, G, B)

    drawText("FPS: " .. fpsCounter.fps, 10, 10, 0, 255, 0)  
    -- x = 10, y = 10, cor = verde RGB
end

return fpsCounter
