local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variáveis do Key System
local keyScreen = nil
local keyBox = nil
local keyInput = nil
local keyLabel = nil
local statusLabel = nil
local correctKey = "apolloemici"
local rayfieldLoaded = false

-- Função para criar Key System
local function createKeySystem()
    -- ScreenGui Principal
    keyScreen = Instance.new("ScreenGui")
    keyScreen.Name = "PiggyKeySystem"
    keyScreen.ResetOnSpawn = false
    keyScreen.IgnoreGuiInset = true
    keyScreen.Parent = playerGui
    
    -- Fundo escuro
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0
    background.Parent = keyScreen
    
    -- Caixa principal
    keyBox = Instance.new("Frame")
    keyBox.Name = "KeyBox"
    keyBox.Size = UDim2.new(0, 400, 0, 250)
    keyBox.Position = UDim2.new(0.5, -200, 0.5, -125)
    keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    keyBox.BorderSizePixel = 0
    keyBox.Parent = keyScreen
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = keyBox
    
    -- Sombra
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, 5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.ZIndex = keyBox.ZIndex - 1
    shadow.Parent = keyBox
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 15)
    shadowCorner.Parent = shadow
    
    -- Título
    keyLabel = Instance.new("TextLabel")
    keyLabel.Name = "Title"
    keyLabel.Size = UDim2.new(1, 0, 0, 60)
    keyLabel.Position = UDim2.new(0, 0, 0, 20)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "🔒 Piggy Tools - Key System"
    keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLabel.TextScaled = true
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.Parent = keyBox
    
    -- Label de instrução
    local instructionLabel = Instance.new("TextLabel")
    instructionLabel.Size = UDim2.new(1, -40, 0, 30)
    instructionLabel.Position = UDim2.new(0, 20, 0, 90)
    instructionLabel.BackgroundTransparency = 1
    instructionLabel.Text = "Digite a key para acessar o menu:"
    instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    instructionLabel.TextScaled = true
    instructionLabel.Font = Enum.Font.Gotham
    instructionLabel.Parent = keyBox
    
    -- Campo de input
    keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(1, -60, 0, 50)
    keyInput.Position = UDim2.new(0, 30, 0, 130)
    keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    keyInput.BorderSizePixel = 0
    keyInput.Text = ""
    keyInput.PlaceholderText = "Digite aqui..."
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    keyInput.TextScaled = true
    keyInput.Font = Enum.Font.Gotham
    keyInput.Parent = keyBox
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = keyInput
    
    -- Status label
    statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.Position = UDim2.new(0, 20, 0, 195)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Pressione Enter para confirmar"
    statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = keyBox
    
    -- Animação de entrada
    keyBox.Size = UDim2.new(0, 0, 0, 0)
    keyBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    local tween = TweenService:Create(keyBox, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 250),
        Position = UDim2.new(0.5, -200, 0.5, -125)
    })
    tween:Play()
end

-- Função para carregar Rayfield
local function loadRayfield()
    local Window = Rayfield:CreateWindow({
       Name = "Piggy Tools",
       LoadingTitle = "Carregando Piggy Tools...",
       LoadingSubtitle = "by HackerAI",
       ConfigurationSaving = {
          Enabled = true,
          FolderName = "PiggyConfig",
          FileName = "PiggyTools"
       },
       Discord = {
          Enabled = false,
          Invite = "",
          RememberJoins = true
       },
       KeySystem = false
    })
    
    local PiggyTab = Window:CreateTab("Piggy", 4483362458)
    
    local ESPToggle = false
    local ESPConnections = {}
    
    local PiggyNPCs = {
       "MotherBot", "SheepyBot", "BearyBot", "ZompiggyBot",
       "ClownyBot", "EllyBot", "RobbyBot", "TorcherBot", "BadgyBot"
    }
    
    local function findClosestPiggy()
       local character = player.Character
       if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
       
       local playerPos = character.HumanoidRootPart.Position
       local closestPiggy = nil
       local closestDistance = math.huge
       
       for _, npcName in ipairs(PiggyNPCs) do
          local npc = workspace:FindFirstChild("PiggyNPC", true):FindFirstChild(npcName)
          if npc and npc:FindFirstChild("HumanoidRootPart") then
             local distance = (npc.HumanoidRootPart.Position - playerPos).Magnitude
             if distance < closestDistance then
                closestDistance = distance
                closestPiggy = npc
             end
          end
       end
       
       return closestPiggy
    end
    
    local function createESP(piggy)
       if ESPConnections[piggy] then return end
       
       local esp = Drawing.new("Square")
       esp.Color = Color3.fromRGB(255, 0, 0)
       esp.Thickness = 2
       esp.Filled = false
       esp.Transparency = 1
       esp.Visible = false
       
       local nameLabel = Drawing.new("Text")
       nameLabel.Color = Color3.fromRGB(255, 255, 255)
       nameLabel.Size = 16
       nameLabel.Center = true
       nameLabel.Outline = true
       nameLabel.Font = 2
       nameLabel.Visible = false
       
       ESPConnections[piggy] = {
          esp = esp,
          nameLabel = nameLabel,
          connection = game:GetService("RunService").RenderStepped:Connect(function()
             if not piggy.Parent or not piggy:FindFirstChild("HumanoidRootPart") then
                esp:Remove()
                nameLabel:Remove()
                ESPConnections[piggy].connection:Disconnect()
                ESPConnections[piggy] = nil
                return
             end
             
             local humanoidRootPart = piggy.HumanoidRootPart
             local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
             
             if onScreen then
                local size = (workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0)) - 
                             workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, 6, 0))).Magnitude
                esp.Size = Vector2.new(size, size * 2)
                esp.Position = Vector2.new(screenPos.X - esp.Size.X / 2, screenPos.Y - esp.Size.Y / 2)
                esp.Visible = true
                
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                   local distance = math.floor((humanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude)
                   nameLabel.Text = piggy.Name .. " [" .. distance .. " studs]"
                else
                   nameLabel.Text = piggy.Name
                end
                nameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - esp.Size.Y / 2 - 20)
                nameLabel.Visible = true
             else
                esp.Visible = false
                nameLabel.Visible = false
             end
          end)
       }
    end
    
    local function clearAllESP()
       for piggy, data in pairs(ESPConnections) do
          if data.esp then data.esp:Remove() end
          if data.nameLabel then data.nameLabel:Remove() end
          if data.connection then data.connection:Disconnect() end
       end
       ESPConnections = {}
    end
    
    local function removePiggy()
       local piggyFolder = workspace:FindFirstChild("PiggyNPC")
       if piggyFolder then
          for _, npcName in ipairs(PiggyNPCs) do
             local npc = piggyFolder:FindFirstChild(npcName)
             if npc then npc:Destroy() end
          end
          Rayfield:Notify({
             Title = "✅ Piggy Removido!",
             Content = "Todos os Piggy NPCs foram removidos!",
             Duration = 3,
             Image = 4483362458,
          })
       end
    end
    
    PiggyTab:CreateButton({
       Name = "🗑️ Remove Piggy",
       Callback = function() removePiggy() end,
    })
    
    PiggyTab:CreateToggle({
       Name = "👁️ ESP Piggy (Mais Próximo)",
       CurrentValue = false,
       Flag = "PiggyESP",
       Callback = function(Value)
          ESPToggle = Value
          if Value then
             clearAllESP()
             local closest = findClosestPiggy()
             if closest then
                createESP(closest)
                Rayfield:Notify({
                   Title = "✅ ESP Ativado!",
                   Content = "ESP no Piggy mais próximo: " .. closest.Name,
                   Duration = 3,
                   Image = 4483362458,
                })
             else
                Rayfield:Notify({
                   Title = "❌ Nenhum Piggy",
                   Content = "Nenhum Piggy encontrado no mapa.",
                   Duration = 3,
                   Image = 4483362458,
                })
                ESPToggle = false
             end
          else
             clearAllESP()
             Rayfield:Notify({
                Title = "✅ ESP Desativado",
                Duration = 2,
                Image = 4483362458,
             })
          end
       end,
    })
    
    Rayfield:LoadConfiguration()
end

-- Criar Key System
createKeySystem()

-- Evento do input
keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputKey = keyInput.Text:lower()
        if inputKey == correctKey then
            -- Key correta - animação de saída
            local tweenOut = TweenService:Create(keyBox, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                keyScreen:Destroy()
                loadRayfield()
            end)
            
            statusLabel.Text = "✅ Key correta! Carregando..."
            statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        else
            -- Key errada
            statusLabel.Text = "❌ Key incorreta! Tente: apolloemici"
            statusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
            keyInput.Text = ""
            keyInput:CaptureFocus()
        end
    end
end)

-- Foco automático no input
keyInput.MouseEnter:Connect(function()
    keyInput:CaptureFocus()
end)

spawn(function()
    wait(0.5)
    keyInput:CaptureFocus()
end)
