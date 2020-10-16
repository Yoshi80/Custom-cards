--Merlin - Boar's Sin of Gluttony
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(s.atkcon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
function s.thfilter(c,e,tp)
	return c:IsLevel(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_PZONE,0,1,e:GetHandler(),e,tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sc,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_EXTRA) or c:IsPreviousLocation(LOCATION_PZONE)
end
function s.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(s.climit)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function s.climit(e,lp,tp)
	return lp==tp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end