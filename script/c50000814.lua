--Javelin Knight
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(s.dmtg)
	e1:SetOperation(s.dmop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.damcon2)
	e2:SetTarget(s.damtg2)
	e2:SetOperation(s.damop2)
	c:RegisterEffect(e2)
end
function s.dmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsLevel(3)
end
function s.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.dmfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g0=Duel.GetMatchingGroup(s.dmfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g0:GetClassCount(Card.GetCode)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function s.dmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g0=Duel.GetMatchingGroup(s.dmfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g0:GetClassCount(Card.GetCode)
	Duel.Damage(p,ct*200,REASON_EFFECT)
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return r&0x41==0x41 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function s.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function s.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
