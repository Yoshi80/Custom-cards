--Yoyo Dino Energetic Yellow

function c50000202.initial_effect(c)
	aux.EnableDualAttribute(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetCondition(aux.IsDualState)
	e1:SetValue(50000191)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetCondition(aux.IsDualState)
	e2:SetValue(c50000202.valcon)
	c:RegisterEffect(e2)
end

function c50000202.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end