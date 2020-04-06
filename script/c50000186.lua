-- Akhos the Brother Blade

function c50000186.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),2,2,c50000186.lcheck)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_LEAVE_GRAVE)
	e2:SetDescription(aux.Stringid(50000186,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,66809921)
	e2:SetCondition(c50000186.rmcon)
	e2:SetTarget(c50000186.rmtg)
	e2:SetOperation(c50000186.rmop)
	c:RegisterEffect(e2)
end

function c50000186.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end

function c50000186.imfilter(c)
	return c:IsFaceup() and c:GetMutualLinkedGroupCount()>0
end
function c50000186.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():FilterCount(c50000186.imfilter,1,nil)==2
end
function c50000186.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c50000186.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c50000186.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end