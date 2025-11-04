-- smod/liquid-mod.lua
-- Sistema simples de líquidos físicos para o Smod

if SERVER then
    util.AddNetworkString("Smod_LiquidSplash")

    SMOD_LIQUIDS = {}

    local LIQUID_TYPES = {
        water = { color = Color(80,150,255,200), damage = 0, buoyancy = 1.2, sound = "ambient/water/water_splash1.wav" },
        acid  = { color = Color(80,255,80,200),  damage = 5, buoyancy = 1.1, sound = "ambient/water/water_splash2.wav" }
    }

    function SmodCreateLiquid(pos, size, liquidType)
        if not LIQUID_TYPES[liquidType] then
            print("[Smod Liquid] Tipo inválido:", liquidType)
            return
        end

        local t = {
            pos = pos,
            size = size,
            type = liquidType,
            bounds = {
                min = pos - size / 2,
                max = pos + size / 2
            }
        }

        table.insert(SMOD_LIQUIDS, t)
        print("[Smod Liquid] Criado líquido:", liquidType, pos, size)
    end

    hook.Add("Think", "SmodLiquidPhysics", function()
        for _, ply in ipairs(player.GetAll()) do
            if not ply:Alive() then continue end

            local p = ply:GetPos()
            for _, liquid in ipairs(SMOD_LIQUIDS) do
                if p.x > liquid.bounds.min.x and p.x < liquid.bounds.max.x and
                   p.y > liquid.bounds.min.y and p.y < liquid.bounds.max.y and
                   p.z > liquid.bounds.min.z and p.z < liquid.bounds.max.z then
                    
                    local data = LIQUID_TYPES[liquid.type]

                    -- Dano se for ácido
                    if data.damage > 0 then
                        ply:TakeDamage(data.damage, game.GetWorld(), game.GetWorld())
                    end

                    -- Flutuação
                    local phys = ply:GetPhysicsObject()
                    if IsValid(phys) then
                        phys:ApplyForceCenter(Vector(0,0,80 * data.buoyancy))
                    end
                end
            end
        end
    end)

    -- Comando para criar líquido manualmente
    concommand.Add("smod_makeliquid", function(ply, cmd, args)
        if not ply:IsAdmin() then
            ply:ChatPrint("[Smod] Só admin cria líquido.")
            return
        end

        local type = args[1] or "water"
        local size = Vector(200,200,80)
        local tr = ply:GetEyeTrace()

        SmodCreateLiquid(tr.HitPos, size, type)
        ply:ChatPrint("[Smod] Líquido criado: " .. type)
    end)
end


-- CLIENTE: desenhar volume e splash
if CLIENT then
    hook.Add("PostDrawOpaqueRenderables", "SmodDrawLiquids", function()
        if not SMOD_LIQUIDS then return end

        for _, l in ipairs(SMOD_LIQUIDS) do
            local data = {
                water = Color(80,150,255,80),
                acid  = Color(80,255,80,80)
            }

            local col = data[l.type] or Color(255,0,0,80)
            render.SetColorMaterial()
            render.DrawBox(l.pos, Angle(0,0,0), l.bounds.min - l.pos, l.bounds.max - l.pos, col)
        end
    end)
end
