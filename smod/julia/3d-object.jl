# smod/julia/3d-object.jl
# Sistema base de objetos 3D do Smod em Julia
# Autor: Você

module Smod3DObject

export SObject3D, update!, translate!, rotate!, scale!, apply_gravity!

using LinearAlgebra

# Estrutura do objeto 3D
mutable struct SObject3D
    name::String
    position::Vector{Float64}
    rotation::Vector{Float64}
    scale::Vector{Float64}
    velocity::Vector{Float64}
    gravity::Bool
end

# Criar objeto padrão
function SObject3D(name::String; pos=[0.0,0.0,0.0], rot=[0.0,0.0,0.0], scale=[1.0,1.0,1.0], gravity=false)
    return SObject3D(
        name,
        convert(Vector{Float64}, pos),
        convert(Vector{Float64}, rot),
        convert(Vector{Float64}, scale),
        [0.0,0.0,0.0],
        gravity
    )
end

# Atualizar física/frame
function update!(obj::SObject3D, dt::Float64)
    obj.position .+= obj.velocity .* dt
end

# Adicionar gravidade
function apply_gravity!(obj::SObject3D, dt::Float64)
    if obj.gravity
        obj.velocity[3] -= 9.81 * dt  # eixo Z como vertical
    end
end

# Movimentar
translate!(obj::SObject3D, dx, dy, dz) = obj.position .+= [dx,dy,dz]

# Rotacionar
rotate!(obj::SObject3D, rx, ry, rz) = obj.rotation .+= [rx,ry,rz]

# Escalar
scale!(obj::SObject3D, sx, sy, sz) = obj.scale .*= [sx,sy,sz]

# String debug
Base.show(io::IO, obj::SObject3D) = print(io,
    "SObject3D(\"$(obj.name)\", pos=$(obj.position), rot=$(obj.rotation), scale=$(obj.scale))"
)

end # module
