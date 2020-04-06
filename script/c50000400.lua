--Korok
local s,id=GetID()
function s.initial_effect(c)
	--To grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.gvcost)
	e1:SetTarget(s.gvtg)
	e1:SetOperation(s.gvop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end

function s.counterfilter(c)
	return c:IsRace(RACE_PLANT) or (c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_EARTH))
end
function s.gvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsRace(RACE_PLANT) or (c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_EARTH)))
end
function s.gvfilter(c,ft)
	return c:IsFaceup() and c:IsLinkAbove(2)
end
function s.gvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.gvfilter(chkc,ft) end
	if chk==0 then return Duel.IsExistingTarget(s.gvfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	local g=Duel.SelectTarget(tp,s.gvfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(g:GetFirst():GetLink()-1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetFirst():GetLink()-1)
end
function s.gvop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local tc=Duel.GetFirstTarget()
	local ct=tc:GetLink()-1
	Duel.Draw(p,ct,REASON_EFFECT)
end
