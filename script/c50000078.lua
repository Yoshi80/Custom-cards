-- Hakaishin - Iwne

function c50000078.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000078,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,500000781)
	e1:SetTarget(c50000078.target)
	e1:SetOperation(c50000078.operation)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000078,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,500000782)
	e2:SetCost(c50000078.pfuscost)
	e2:SetCondition(c50000078.tgcon)
	e2:SetOperation(c50000078.tgop)
	c:RegisterEffect(e2)
end

function c50000078.filter(c)
	return c:IsSetCard(0x702) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function c50000078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000078.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c50000078.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50000078.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c50000078.pfuscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable(e) end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c50000078.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c50000078.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,math.floor(ev/2),REASON_EFFECT)
	Duel.Recover(1-tp,math.floor(ev/2),REASON_EFFECT)
end