--[[ OBFUSCATED BY CHATGPT ]]--

local E=string.char;local function N(s)local r=""for i=1,#s do r=r..E(s:byte(i)~51)end;return r end

local v=N("Y\\YVTZM");local g=N("X^_");local P=N("Nv};}");local T=game:GetService(N("YVP}T\\]"));local q=game:GetService(N("YVP}~}P]"));local k=game:GetService(N("YVP}S_]T"));local L=T.LocalPlayer;local U=L:WaitForChild(N("DGZ\\YV\\WW"));local A=50;local S=2.4;local M=.15

local function C()
if U:FindFirstChild(N("WML"))then return U[N("WML")]end
local a=Instance.new(N("S]KPYVWT"));a.Name=N("WML");a.ResetOnSpawn=false;a.Parent=U
local b=Instance.new(N("KPYVWT"));b.Size=UDim2.new(0,260,0,140);b.Position=UDim2.new(0,20,0,80);b.BackgroundColor3=Color3.fromRGB(30,30,30);b.BorderSizePixel=0;b.Active=true;b.Parent=a
local c=Instance.new(N("KPYVWT"));c.Size=UDim2.new(1,0,0,28);c.BackgroundColor3=Color3.fromRGB(25,25,25);c.BorderSizePixel=0;c.Parent=b
local d=Instance.new(N("NWWZMW"));d.Size=UDim2.new(1,-40,1,0);d.Position=UDim2.new(0,8,0,0);d.BackgroundTransparency=1;d.Text=N("¢}~}L:S{t}v£");d.TextColor3=Color3.new(1,1,1);d.Font=Enum.Font.SourceSansBold;d.TextSize=14;d.Parent=c
local e=Instance.new(N("NWWZMW]"));e.Size=UDim2.new(0,28,0,20);e.Position=UDim2.new(1,-34,0,4);e.Text="X";e.Font=Enum.Font.SourceSansBold;e.TextSize=14;e.BackgroundColor3=Color3.fromRGB(170,50,50);e.TextColor3=Color3.new(1,1,1);e.Parent=c
local f=Instance.new(N("KPYVWT"));f.Size=UDim2.new(1,0,1,-28);f.Position=UDim2.new(0,0,0,28);f.BackgroundTransparency=1;f.Parent=b
local h=Instance.new(N("NWWZMW]"));h.Size=UDim2.new(0,116,0,36);h.Position=UDim2.new(0,12,0,8);h.Text=N("Ytzt~}L;~");h.Font=Enum.Font.SourceSansBold;h.TextSize=15;h.BackgroundColor3=Color3.fromRGB(60,60,60);h.TextColor3=Color3.new(1,1,1);h.Parent=f
local j=Instance.new(N("NWWZMW"));j.Size=UDim2.new(0,120,0,18);j.Position=UDim2.new(0,12,0,54);j.BackgroundTransparency=1;j.Text=N("Ps{t}: ")..A;j.TextColor3=Color3.new(1,1,1);j.Font=Enum.Font.SourceSans;j.TextSize=14;j.TextXAlignment=Enum.TextXAlignment.Left;j.Parent=f
local o=Instance.new(N("NWWZMW]"));o.Size=UDim2.new(0,28,0,28);o.Position=UDim2.new(0,12,0,76);o.Text="-";o.Font=Enum.Font.SourceSansBold;o.TextSize=20;o.BackgroundColor3=Color3.fromRGB(80,80,80);o.TextColor3=Color3.new(1,1,1);o.Parent=f
local w=Instance.new(N("NWWZMW"));w.Size=UDim2.new(0,96,0,28);w.Position=UDim2.new(0,44,0,76);w.Text=tostring(A);w.Font=Enum.Font.SourceSans;w.TextSize=16;w.ClearTextOnFocus=false;w.BackgroundColor3=Color3.fromRGB(80,80,80);w.TextColor3=Color3.new(1,1,1);w.Parent=f
local y=Instance.new(N("NWWZMW]"));y.Size=UDim2.new(0,28,0,28);y.Position=UDim2.new(0,144,0,76);y.Text="+";y.Font=Enum.Font.SourceSansBold;y.TextSize=20;y.BackgroundColor3=Color3.fromRGB(80,80,80);y.TextColor3=Color3.new(1,1,1);y.Parent=f

return{gui=a,frame=b,title=c,close=e,toggle=h,label=j,dec=o,inc=y,box=w}
end

local function R(F,D)
local G=false;local H;local I
D.InputBegan:Connect(function(J)
if J.UserInputType==Enum.UserInputType.MouseButton1 then
G=true;H=J.Position;I=F.Position
J.Changed:Connect(function()if J.UserInputState==Enum.UserInputState.End then G=false end end)
end end)
D.InputChanged:Connect(function(J)
if J.UserInputType==Enum.UserInputType.MouseMovement then
q:BindToRenderStep(tostring(F:GetDebugId()),Enum.RenderPriority.Camera.Value+1,function()
if not G then q:UnbindFromRenderStep(tostring(F:GetDebugId()))return end
local K=k:GetMouseLocation();local L=K-H;F.Position=UDim2.new(I.X.Scale,I.X.Offset+L.X,I.Y.Scale,I.Y.Offset+L.Y)
end)
end end)
end

local function O(Z)
local _=false;local a1=A;local a2={w=false,a=false,s=false,d=false,space=false,ctrl=false,shift=false}
local a3;local a4;local a5;local a6
local function a7()Z.label.Text=N("Ps{t}: ")..math.floor(a1);Z.box.Text=tostring(a1)end
local function a8()
local c=L.Character;if not c then return end
a3=c:FindFirstChild(N("JT}ZT]O"));a4=c:FindFirstChildOfClass(N("JT}Z}T]"))
if not a3 or not a4 then return end
a5=Instance.new(N("JT}Z]PYT"));a5.MaxForce=Vector3.new(9e9,9e9,9e9);a5.P=9e4;a5.Velocity=Vector3.new();a5.Parent=a3
a6=Instance.new(N("JT}ZOG"));a6.MaxTorque=Vector3.new(9e9,9e9,9e9);a6.CFrame=a3.CFrame;a6.P=9e4;a6.Parent=a3
a4.PlatformStand=false;_=true;Z.toggle.Text=N("D~}L;~")
end
local function a9()
_=false;if a5 then a5:Destroy()end if a6 then a6:Destroy()end
local c=L.Character;if c and c:FindFirstChildOfClass(N("JT}Z}T]")) then c:FindFirstChildOfClass(N("JT}Z}T]")).PlatformStand=false end
Z.toggle.Text=N("Ytzt~}L;~")
end

k.InputBegan:Connect(function(l,m)
if m then return end;if l.UserInputType==Enum.UserInputType.Keyboard then
local n=l.KeyCode
if n==Enum.KeyCode.W then a2.w=true end
if n==Enum.KeyCode.A then a2.a=true end
if n==Enum.KeyCode.S then a2.s=true end
if n==Enum.KeyCode.D then a2.d=true end
if n==Enum.KeyCode.Space then a2.space=true end
if n==Enum.KeyCode.LeftControl or n==Enum.KeyCode.RightControl then a2.ctrl=true end
if n==Enum.KeyCode.LeftShift or n==Enum.KeyCode.RightShift then a2.shift=true end
if n==Enum.KeyCode.E then if _ then a9()else a8()end end
end end)

k.InputEnded:Connect(function(l)
if l.UserInputType==Enum.UserInputType.Keyboard then
local n=l.KeyCode
if n==Enum.KeyCode.W then a2.w=false end
if n==Enum.KeyCode.A then a2.a=false end
if n==Enum.KeyCode.S then a2.s=false end
if n==Enum.KeyCode.D then a2.d=false end
if n==Enum.KeyCode.Space then a2.space=false end
if n==Enum.KeyCode.LeftControl or n==Enum.KeyCode.RightControl then a2.ctrl=false end
if n==Enum.KeyCode.LeftShift or n==Enum.KeyCode.RightShift then a2.shift=false end
end end)

Z.toggle.MouseButton1Click:Connect(function()if _ then a9()else a8()end end)
Z.close.MouseButton1Click:Connect(function()Z.gui:Destroy()end)
Z.dec.MouseButton1Click:Connect(function()a1=math.max(5,a1-5);a7()end)
Z.inc.MouseButton1Click:Connect(function()a1=a1+5;a7()end)
Z.box.FocusLost:Connect(function()local o=tonumber(Z.box.Text);if o and o>=1 then a1=o else Z.box.Text=a1 end;a7()end)

a7()

local p=Vector3.new();local r=Vector3.new()
q.Heartbeat:Connect(function(dt)
if not _ then return end
local c=L.Character;if not c or not c:FindFirstChild(N("JT}ZT]O")) then a9()return end
a3=c:FindFirstChild(N("JT}ZT]O"));a4=c:FindFirstChildOfClass(N("JT}Z}T]"))
local cam=workspace.CurrentCamera;local cf=cam.CFrame;local F=cf.LookVector;local Rr=cf.RightVector
local mv=Vector3.new()
if a2.w then mv=mv+Vector3.new(F.X,0,F.Z)end
if a2.s then mv=mv-Vector3.new(F.X,0,F.Z)end
if a2.a then mv=mv-Vector3.new(Rr.X,0,Rr.Z)end
if a2.d then mv=mv+Vector3.new(Rr.X,0,Rr.Z)end
mv=(mv.Magnitude>0 and mv.Unit or Vector3.new())

local v=0;if a2.space then v=1 end;if a2.ctrl then v=v-1 end
local sp=a1*(a2.shift and S or 1)
p=(mv*sp)+Vector3.new(0,v*sp,0)
r=r:Lerp(p,math.clamp(1-math.exp(-M*60*dt),0,1))
if a5 then a5.Velocity=r end
if a6 then a6.CFrame=CFrame.new(a3.Position,a3.Position+cf.LookVector)end
end)
end

local G=C()R(G.frame,G.title)O(G)
print(N("xS|:Jv}w}tvu~x}"))
