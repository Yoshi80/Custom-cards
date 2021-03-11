--Prehisto Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,nil,aux.FALSE,s.fextra,Fusion.BanishMaterial)
	c:RegisterEffect(e1)
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
end
function s.matfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsLevelBelow(4)
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,nil):Filter(s.matfilter,nil)
	end
	return nil
end