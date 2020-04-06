--Sun Flute Celebration
local s,id=GetID()
function s.initial_effect(c)
	aux.AddRitualProcEqual(c,s.ritualfil,nil,nil,nil,nil,nil,nil,LOCATION_HAND)
end

function s.ritualfil(c)
	return c:IsCode(50000358) and c:IsRitualMonster()
end