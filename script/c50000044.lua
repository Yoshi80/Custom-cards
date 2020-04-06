-- Harmony Element of Honesty

function c50000044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,500000441)
	e1:SetCondition(c50000044.notcon)
	e1:SetTarget(c50000044.target)
	e1:SetOperation(c50000044.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetCondition(c50000044.con)
	e2:SetTarget(c50000044.destg)
	e2:SetOperation(c50000044.desop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,500000442)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c50000044.cost)
	e3:SetOperation(c50000044.tdop)
	c:RegisterEffect(e3)
end

function c50000044.notcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)<5
end

function c50000044.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=5
end

function c50000044.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000044.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000044.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c50000044.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c50000044.filter,tp,LOCATION_PZONE,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c50000044.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c50000044.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(50000043) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end

function c50000044.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		local g2=Duel.GetMatchingGroup(c50000044.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50000044,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c50000044.cfilter(c)
	return c:IsSetCard(0x701) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end

function c50000044.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if ct<5 then return end
	Duel.BreakEffect()
	local g=Duel.GetDecktopGroup(1-tp,5)
	Duel.ConfirmCards(tp,g)
	Duel.SortDecktop(tp,1-tp,5)
end

function c50000044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c50000044.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
		and (not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),69832741) or not c:IsType(TYPE_MONSTER)
		or not c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemoveAsCost()
	 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	local g=Duel.SelectMatchingCard(tp,c50000044.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end