-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variáveis Globais de Estado
_G.HitboxEnabled = false
_G.HitboxSize = 2
_G.HitboxTransparency = 0
_G.HeadEnabled = false
_G.HeadSize = 2
_G.HeadTransparency = 0.5
_G.ESPEnabled = false
_G.AimbotEnabled = false
_G.AimbotFOV = 100

-- Variáveis de Serviço
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ESPObjects = {}
local FOVCircle = Drawing.new("Circle")

-- Configuração Visual do FOV
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Radius = _G.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

-- Funções Utilitárias
local function createESP(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    ESPObjects[player] = box
end

local function IsVisible(targetPart)
    local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000)
    local hit, position = game:GetService("Workspace"):FindPartOnRay(ray, LocalPlayer.Character)
    return hit and hit:IsDescendantOf(targetPart.Parent)
end

-- Criação da Janela
local Window = Rayfield:CreateWindow({
    Name = "All-In-One | Pro Edition",
    LoadingTitle = "Carregando Módulos...",
    LoadingSubtitle = "by SecurityTest",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local TabHitbox = Window:CreateTab("Hitbox & Head", 4483362458)
local TabESP = Window:CreateTab("ESP", 4483362458)
local TabAimbot = Window:CreateTab("Aimbot", 4483362458)
local TabMisc = Window:CreateTab("Misc", 4483362458)

-- Tab Hitbox
TabHitbox:CreateSection("Hitbox (Corpo)")
TabHitbox:CreateToggle({Name = "Ativar Hitbox Expander", Callback = function(v) _G.HitboxEnabled = v end})
TabHitbox:CreateSlider({Name = "Tamanho Hitbox", Range = {1, 50}, Increment = 1, CurrentValue = 2, Callback = function(v) _G.HitboxSize = v end})
TabHitbox:CreateSlider({Name = "Transparência Hitbox", Range = {0, 1}, Increment = 0.1, CurrentValue = 0, Callback = function(v) _G.HitboxTransparency = v end})

TabHitbox:CreateSection("Head (Tiro na Cabeça)")
TabHitbox:CreateToggle({Name = "Ativar Head Expander", Callback = function(v) _G.HeadEnabled = v end})
TabHitbox:CreateSlider({Name = "Tamanho Cabeça", Range = {1, 30}, Increment = 1, CurrentValue = 2, Callback = function(v) _G.HeadSize = v end})
TabHitbox:CreateSlider({Name = "Transparência Cabeça", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) _G.HeadTransparency = v end})

-- Tab ESP
TabESP:CreateToggle({Name = "Ativar ESP Box", Callback = function(v) _G.ESPEnabled = v end})

-- Tab Aimbot
TabAimbot:CreateToggle({Name = "Ativar Aimbot", Callback = function(v) _G.AimbotEnabled = v end})
TabAimbot:CreateSlider({Name = "Tamanho do FOV", Range = {50, 500}, Increment = 10, CurrentValue = 100, Callback = function(v) _G.AimbotFOV = v FOVCircle.Radius = v end})
TabAimbot:CreateToggle({Name = "Mostrar Círculo FOV", Callback = function(v) FOVCircle.Visible = v end})

-- Tab Misc (Corrigida para evitar erro)
TabMisc:CreateLabel("Credits: Hello, my name is Theylor, this script was written on March 4, 2026, I made it for fun, and I decided to post it on YouTube.")
TabMisc:CreateDropdown({
    Name = "Cor da Interface",
    Options = {"Verde", "Preto", "Branco", "Azul", "Vermelho", "Amarelo", "Rosa"},
    Callback = function(Option)
        Rayfield:Notify({Title = "Seleção de Cor", Content = "Você selecionou a cor: " .. Option .. ". (Nota: A mudança visual exige reiniciar o script).", Duration = 5})
    end
})
TabMisc:CreateButton({
    Name = "Copiar Link do Discord",
    Callback = function() 
        setclipboard("https://discord.gg/aNQ7KCjKY") 
        Rayfield:Notify({Title = "Copiado", Content = "Link do Discord copiado!", Duration = 3}) 
    end
})

-- Loop Geral de Execução
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    local closestPlayer = nil
    local shortestDistance = _G.AimbotFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then continue end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        local head = player.Character:FindFirstChild("Head")

        if hrp and _G.HitboxEnabled then
            hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
            hrp.Transparency = _G.HitboxTransparency
            hrp.CanCollide = false
            hrp.Material = Enum.Material.Neon
            hrp.Color = Color3.fromRGB(255, 0, 0)
        end

        if head and _G.HeadEnabled then
            head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
            head.Transparency = _G.HeadTransparency
            head.CanCollide = false
            head.Massless = true
        end

        if hrp and _G.ESPEnabled then
            if not ESPObjects[player] then createESP(player) end
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local box = ESPObjects[player]
                box.Visible = true
                box.Size = Vector2.new(1000 / vector.Z, 1200 / vector.Z)
                box.Position = Vector2.new(vector.X - box.Size.X / 2, vector.Y - box.Size.Y / 2)
            else
                ESPObjects[player].Visible = false
            end
        elseif ESPObjects[player] then
            ESPObjects[player].Visible = false
        end

        if _G.AimbotEnabled and head and IsVisible(head) then
            local vector, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(vector.X, vector.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortestDistance then
                    closestPlayer = head
                    shortestDistance = dist
                end
            end
        end
    end

    if _G.AimbotEnabled and closestPlayer then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Position)
    end
end)
