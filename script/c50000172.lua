-- Splat Gear - Slosher

function c50000172.initial_effect(c)
	aux.AddEquipProcedure(c)
	--equip effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetValue(c50000172.efilter1)
	c:RegisterEffect(e1)
	--destroy sub
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50000172,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c50000172.targ)
	e4:SetOperation(c50000172.op)
	c:RegisterEffect(e4)
end

function c50000172.efilter1(e,re,rp)
	return rp==e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL) and re:IsActiveType(TYPE_EQUIP) and re:GetHandler():IsSetCard(0x709)
end

function c50000172.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk==0 then	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget() and t~=nil end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,t,1,0,0)
end
function c50000172.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() then
		Duel.Remove(t,POS_FACEUP,REASON_EFFECT)
	end
end
