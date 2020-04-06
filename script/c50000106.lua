-- The Strong Ally - Walui-Mole !

function c50000106.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000106,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,500001061)
	e1:SetTarget(c50000106.target)
	e1:SetOperation(c50000106.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,500001062)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c50000106.drcost)
	e2:SetTarget(c50000106.thtg)
	e2:SetOperation(c50000106.thop)
	c:RegisterEffect(e2)
end

function c50000106.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x704) and not c:IsCode(50000106) and c:IsAbleToGrave()
end
function c50000106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000106.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c50000106.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c50000106.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function c50000106.drcfilter(c)
	return c:IsSetCard(0x704) and c:IsDiscardable()
end
function c50000106.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),69832741) or not c:IsType(TYPE_MONSTER)
		or not c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c50000106.drcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c50000106.drcfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c50000106.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50000106.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end