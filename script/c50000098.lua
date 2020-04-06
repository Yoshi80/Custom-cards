-- Fairy Spirit - Cancer

function c50000098.initial_effect(c)
	c:EnableReviveLimit()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c50000098.aclimit1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c50000098.aclimit2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c50000098.econ)
	e3:SetValue(c50000098.elimit)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50000098,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,50000098)
	e4:SetTarget(c50000098.drtg)
	e4:SetOperation(c50000098.drop)
	c:RegisterEffect(e4)
end

function c50000098.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:GetHandler():IsType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(50000098,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c50000098.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:GetHandler():IsType(TYPE_MONSTER) then return end
	e:GetHandler():ResetFlagEffect(50000098)
end
function c50000098.econ(e)
	return e:GetHandler():GetFlagEffect(50000098)~=0
end
function c50000098.elimit(e,te,tp)
	return te:GetHandler():IsType(TYPE_MONSTER)
end

function c50000098.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50000098.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end