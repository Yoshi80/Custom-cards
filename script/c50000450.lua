--The Midnight in Me
local s,id=GetID()
function s.initial_effect(c)
	c:RegisterEffect(Fusion.CreateSummonEff(c,aux.FilterBoolFunction(aux.IsMaterialListCode,50000439,50000445),nil,nil,nil,nil,s.stage2))
end
function s.stage2(e,tc,tp,sg,chk)
	if chk~=1 then return end
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and tp==e:GetHandlerPlayer() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
		--cannot activate
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--cannot attack
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e2,true)
	end
end