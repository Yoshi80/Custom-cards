-- Dragonair

function c50000122.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c50000122.spcon)
	c:RegisterEffect(e1)
end

function c50000122.cfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(3) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c50000122.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50000122.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end