-- smod/spawn_object.lua
-- Sistema simples para spawnar objetos no Smod

if SERVER then
    util.AddNetworkString("Smod_SpawnObject")

    local allowedModels = {
        ["models/props_c17/oildrum001.mdl"] = true,
        ["models/props_junk/wood_crate001a.mdl"] = true,
        ["models/props_c17/FurnitureChair001a.mdl"] = true,
        ["models/props_c17/bench01a.mdl"] = true
    }

    local function SpawnObject(ply, model)
        if not IsValid(ply) or not ply:IsPlayer() then return end
        if not allowedModels[model] then 
            ply:ChatPrint("[Smod] Modelo não permitido.")
            return 
        end

        local tr = ply:GetEyeTrace()

        local ent = ents.Create("prop_physics")
        if not IsValid(ent) then return end

        ent:SetModel(model)
        ent:SetPos(tr.HitPos + tr.HitNormal * 10)
        ent:Spawn()
        ent:Activate()

        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then phys:Wake() end

        ply:ChatPrint("[Smod] Objeto spawnado com sucesso.")
    end

    -- Comando de console para teste
    concommand.Add("smod_spawn", function(ply, cmd, args)
        local model = args[1]
        if not model then
            ply:ChatPrint("Uso: smod_spawn <modelo>")
            return
        end
        SpawnObject(ply, model)
    end)

    -- Suporte a spawn via NET (para menus futuramente)
    net.Receive("Smod_SpawnObject", function(len, ply)
        local model = net.ReadString()
        SpawnObject(ply, model)
    end)
end


-- CLIENTE (vai ser útil mais tarde para menus)
if CLIENT then
    function SmodSpawnObject(model)
        net.Start("Smod_SpawnObject")
        net.WriteString(model)
        net.SendToServer()
    end
end
