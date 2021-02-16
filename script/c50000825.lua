--Dark Counterpart Showdown
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup,location=LOCATION_HAND+LOCATION_GRAVE})
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function s.ritualfil(c)
	return c:IsCode(50000824)
end
function s.exfilter0(c)
	return c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		return Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_DECK,0,nil)
	end
end
function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.forcedgroup(c,e,tp)
	return (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)) or (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_DECK))
end
