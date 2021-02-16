--Knight's Face-off
local s,id=GetID()
function s.initial_effect(c)
	Ritual.AddProcGreater(c,s.ritual_filter)
	--Place 1 pendulum monster from deck into pendulum zone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.pctg)
	e1:SetOperation(s.pcop)
	c:RegisterEffect(e1)
end
function s.ritual_filter(c)
	return c:IsRitualMonster() and c:IsLevel(3)
end
function s.pcfilter(c)
	return c:IsFaceup() and c:IsLevel(3) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(s.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function s.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end