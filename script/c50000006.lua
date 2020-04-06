--- Ultra Instinct Battle

function c50000006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c50000006.condition)
	e1:SetOperation(c50000006.activate)
	c:RegisterEffect(e1)
end

function c50000006.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsFaceup() and tc:IsControler(tp) and tc:IsRace(RACE_BEASTWARRIOR) and tp~=Duel.GetTurnPlayer()
end

function c50000006.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local gc=Group.CreateGroup()
	gc:AddCard(tc)
	gc:AddCard(e:GetHandler())
	if Duel.NegateAttack() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,gc)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end