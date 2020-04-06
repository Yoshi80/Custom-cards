-- Hakaishin - Liquir

function c50000079.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c50000079.atktg)
	e1:SetValue(800)
	c:RegisterEffect(e1)
	--ayk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c50000079.atkcon)
	e2:SetValue(800)
	c:RegisterEffect(e2)
end

function c50000079.atktg(e,c)
	return c:IsSetCard(0x702) and c:IsLevelBelow(7)
end

function c50000079.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x702) and c:IsLevelBelow(7) and c:IsAttackPos()
end
function c50000079.atkcon(e)
	return Duel.IsExistingMatchingCard(c50000079.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end