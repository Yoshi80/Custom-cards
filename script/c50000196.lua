-- Yoyo Dino Egg Laying
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetAttackTarget()==nil
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsPlayerCanSpecialSummonMonster(tp,50000193,0x70a,0x4011,0,0,1,RACE_DINOSAUR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.NegateAttack() and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,50000193,0x70a,0x4011,0,0,1,RACE_DINOSAUR,ATTRIBUTE_EARTH) then
		for i=1,3 do
			local token=Duel.CreateToken(tp,50000193)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		return ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,50000193,0x70a,0x4011,0,0,1,RACE_DINOSAUR,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,50000193,0x70a,0x4011,0,0,1,RACE_DINOSAUR,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,50000193)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
