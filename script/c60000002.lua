-- Blutz Wave Overload

function c60000002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c60000002.cost)
	e1:SetCondition(c60000002.spcon)
	e1:SetTarget(c60000002.target)
	e1:SetOperation(c60000002.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(60000002,ACTIVITY_CHAIN,c60000002.chainfilter)
end

function c60000002.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c60000002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(60000002,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c60000002.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60000002.cfilter(c)
	return c:IsFaceup() and c:IsCode(60000001)
end
function c60000002.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c60000002.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c60000002.filter2(c,e,tp,mc)
	return c:IsRank(7) and c:IsRace(RACE_BEASTWARRIOR) and mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c60000002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	if chk==0 then return Duel.IsExistingMatchingCard(c60000002.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60000002.activate(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g2:GetFirst()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if not tc or tc:IsFacedown() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60000002.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end