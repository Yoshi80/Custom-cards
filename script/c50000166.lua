-- Splat Idol - Calie

function c50000166.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000166,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,500001661)
	e1:SetTarget(c50000166.thtg1)
	e1:SetOperation(c50000166.thop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon (single)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50000166,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,500001662)
	e3:SetCost(c50000166.cost)
	e3:SetTarget(c50000166.sptg1)
	e3:SetOperation(c50000166.spop1)
	c:RegisterEffect(e3)
end

function c50000166.thfilter(c)
	return c:IsSetCard(0x709) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c50000166.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000166.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50000166.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50000166.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c50000166.cfilter(c)
	return c:IsSetCard(0x709) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsDiscardable()
end
function c50000166.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000166.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c50000166.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c50000166.spfilter(c,e,tp,pos)
	return c:IsSetCard(0x708) and not c:IsCode(50000166) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,pos)
end
function c50000166.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50000166.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c50000166.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50000166.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,POS_FACEUP)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end