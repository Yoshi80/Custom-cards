-- Dragon Slayer - Wendy
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.filter,2,nil,s.spcheck)
	--halve damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(s.dcon)
	e2:SetOperation(s.dop)
	c:RegisterEffect(e2)
	--lvchange
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.lvtg)
	e3:SetOperation(s.lvop)
	c:RegisterEffect(e3)
	--negate attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.natg)
	e4:SetOperation(s.naop)
	c:RegisterEffect(e4)
end
function s.filter(c,lc,sumtype,tp)
	return not c:IsType(TYPE_TOKEN,lc,sumtype,tp)
end
function s.spcheck(g,lc,tp)
	return g:CheckSameProperty(Card.GetRace,lc,SUMMON_TYPE_LINK,tp)
end
function s.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		return dam/2
	else return dam end
end
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.HalfBattleDamage(ep)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLinkedGroup():Filter(Card.IsLevelAbove,0,0):GetCount()>0 end
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup():Filter(Card.IsLevelAbove,0,0)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function s.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.naop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if Duel.NegateAttack() and c:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)
	end
end