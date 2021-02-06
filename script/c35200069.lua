--Comic Fusion
local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,nil,aux.FilterBoolFunction(Card.IsType,TYPE_TOON),s.fextra,s.extraop)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
end
s.listed_names={15259703}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function s.dirfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function s.fextra(e,tp,mg)
	if Duel.IsExistingMatchingCard(s.dirfilter1,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		local eg=Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		if #eg>0 then
			return eg
		end
	end
	return nil
end
function s.exfilter0(c)
	return c:IsAbleToRemove()
end
function s.extraop(e,tc,tp,sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg)
	end
end
