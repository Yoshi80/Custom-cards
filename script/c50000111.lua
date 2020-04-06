-- The Best Friend : Walui-Oh !

function c50000111.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x704),2)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c50000111.atktg)
	c:RegisterEffect(e1)
	--return hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000111,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c50000111.retcon)
	e2:SetTarget(c50000111.rettg)
	e2:SetOperation(c50000111.retop)
	c:RegisterEffect(e2)
end

function c50000111.atktg(e,c)
	return c:IsFaceup() and c:GetCode()~=50000111 and c:IsSetCard(0x704)
end

function c50000111.retcon(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	e:SetLabelObject(t)
	return t and t:IsRelateToBattle()
end
function c50000111.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetLabelObject(),1,0,0)
end
function c50000111.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():IsRelateToBattle() then
		Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
	end
end