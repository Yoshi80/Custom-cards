-- Omni-Hero : Grey Matter

function c50000154.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_AQUA),4,2)
	c:EnableReviveLimit()
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c50000154.atktg)
	c:RegisterEffect(e1)
	--to deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000154,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c50000154.cost)
	e2:SetTarget(c50000154.target2)
	e2:SetOperation(c50000154.operation2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50000154,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,50000154+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c50000154.poscon)
	e3:SetTarget(c50000154.target)
	e3:SetOperation(c50000154.operation)
	c:RegisterEffect(e3)
end

function c50000154.atktg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_AQUA)
end

function c50000154.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c50000154.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>1 end
end

function c50000154.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50000154,3))
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if g1:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g1)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_DECK,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(1-tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(1-tp,1)
	end
end

function c50000154.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x707)
end
function c50000154.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50000154.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c50000154.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c50000154.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
