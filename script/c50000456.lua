--Pocky
local s,id=GetID()
function s.initial_effect(c)
	--Non-tuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetValue(s.ntval)
	c:RegisterEffect(e1)
end
function s.ntval(c,sc,tp)
	return sc and sc:IsRace(RACE_BEAST)
end