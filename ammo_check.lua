local PLUGIN = PLUGIN

PLUGIN.name = "Ammo chek"
PLUGIN.description = "Check ammo"
PLUGIN.schema = "Any"
PLUGIN.author = "boblikut"

function PLUGIN:CanDrawAmmoHUD(weapon)
	return false
end

local lastUse = 0

local function checkDelay()

    if CurTime() > lastUse then

        return true
    else

        return false
    end
end

local function setDelay(delay)
    lastUse = CurTime() + delay
end 

BanWeapons = {'ix_keys', 'ix_hands'} -- melee weapon and other weapons withot clips

local function IsBanWeapon(bw, ply) 

local ShouldBanWeapon = false

for k, v in ipairs(bw) do
if v == ply:GetActiveWeapon():GetClass() then
ShouldBanWeapon = true
end
end

return ShouldBanWeapon

end


-------------------------------------------------------------------------------------------------------------------- Begining of general hook
hook.Add("PlayerButtonDown", "PressCheckButtun", function(ply, button) 
pcall(function()
if !IsBanWeapon(BanWeapons,ply) and checkDelay() and button == KEY_O then
setDelay(3)
ply.ShouldBreak = false

hook.Add( "PlayerSwitchWeapon", "StopSwitchWeapon", function( ply, oldWeapon, newWeapon ) -- Player can't swintch weapon
	return true
end )


ply:SetFOV(85,2)
ply:EmitSound("weapons/ar2/npc_ar2_reload.wav", 75, 90, 0.5)
ply:Say('/me проверяет кол - во патронов в магазине')

ply:SetAction('ПРОВЕРЯЮ КОЛ - ВО ПАТРОНОВ В МАГАЗИНЕ...', 2, function()

if not ply.ShouldBreak then
ply:SetFOV(0,0.5)
ply:ChatPrint(string.format('В магазине %d/%d патронов', ply:GetActiveWeapon():Clip1(), ply:GetActiveWeapon():GetMaxClip1()))
ply:Say('/me закончил проверку кол - ва патронов в магазине')
hook.Remove( "PlayerSwitchWeapon", "StopSwitchWeapon" )
end

end)


end

if !IsBanWeapon(BanWeapons,ply) and checkDelay() and button == KEY_I then
setDelay(3)
ply.ShouldBreak = false

hook.Add( "PlayerSwitchWeapon", "StopSwitchWeapon", function( ply, oldWeapon, newWeapon ) -- Player can't swintch weapon
	return true
end )


ply:SetFOV(85,2)
ply:EmitSound("weapons/ar2/npc_ar2_reload.wav", 75, 90, 0.5)
ply:Say('/me проверяет кол - во патрон с собой')

ply:SetAction('ПРОВЕРЯЮ КОЛ - ВО ПАТРОН В РЮКЗАКЕ...', 2, function()

if not ply.ShouldBreak then 
ply:SetFOV(0,0.5)
ply:ChatPrint(string.format('Вы сможете полностью зарядить оружие ещё %d раз(а)', math.floor(ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType())/ply:GetActiveWeapon():GetMaxClip1())))
ply:Say('/me закончил проверку кол - ва патронов с собой')
hook.Remove( "PlayerSwitchWeapon", "StopSwitchWeapon" )
end

end)


end


end)
end)
-------------------------------------------------------------------------------------------------------------------- Ending of general hook

hook.Add( "EntityFireBullets", "Stop Checking", function( entity, data ) -- Shoot to stop checking
	
	local ply = data.Attacker
	ply:StopSound("weapons/ar2/npc_ar2_reload.wav")
	ply.ShouldBreak = true
	ply:SetFOV(0,0.01)
	hook.Remove( "PlayerSwitchWeapon", "StopSwitchWeapon" )
	pcall(function() ply:SetAction() end)



	
end )
