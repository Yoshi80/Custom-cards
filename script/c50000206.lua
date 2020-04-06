--Yoyo Dino Glorious Pink

function c50000206.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x70a),9,3)
	c:EnableReviveLimit()
	--skip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000206,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c50000206.atkcon)
	e1:SetOperation(c50000206.atkop)
	c:RegisterEffect(e1)
	--cannot activate effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000206,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c50000206.conopp)
	e2:SetValue(c50000206.aclimit)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50000206,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,50000206)
	e3:SetCondition(c50000206.condition)
	e3:SetCost(c50000206.negcost)
	e3:SetTarget(c50000206.target)
	e3:SetOperation(c50000206.operation)
	c:RegisterEffect(e3)
end

function c50000206.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c50000206.atkop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
end

function c50000206.conopp(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c50000206.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end

function c50000206.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50000206.filter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x70a)
end
function c50000206.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c50000206.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev)
end
function c50000206.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c50000206.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end