--Archanean Sword - Falchion
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	aux.AddEquipProcedure(c,nil,s.filter)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.macon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.bancon)
	e3:SetTarget(s.bantg)
	e3:SetOperation(s.banop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsLevelAbove(8) and c:IsRace(RACE_WARRIOR)
end
function s.macon(e)
	local c=e:GetHandler():GetEquipTarget()
	return c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_RITUAL)
end
function s.bancon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp) and (c:GetColumnGroup():IsContains(bc) or e:GetHandler():GetColumnGroup():IsContains(bc))
end
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetEquipTarget():GetBattleTarget(),1,0,0)
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetEquipTarget():GetBattleTarget()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end