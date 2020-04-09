--Twilight Parasite Diababa
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH),2,3,s.lcheck)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--extra attacks
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.atkcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_LINK)
end
function s.thfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp~=tp))
		and c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function s.filter(c,e,tp,zone1,zone2)
	return c:IsRace(RACE_PLANT)	and (
		c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp,zone1)
		or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp,zone2)
	)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone1=c:GetLinkedZone(tp)
	local zone2=c:GetLinkedZone(1-tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,e,tp,zone1,zone2) end
	if chk==0 then return c:GetLinkedZone()~=0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone1,zone2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone1,zone2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:GetLinkedZone()~=0 and tc:IsRelateToEffect(e) then
		local zone1=c:GetLinkedZone(tp)
		local zone2=c:GetLinkedZone(1-tp)
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp,zone1)
			and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp,zone2) or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone1)
		else
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK,zone2)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e2)
	end
end