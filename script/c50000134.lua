-- Cat Partner - Carla

function c50000134.initial_effect(c)
	-- Xyz Summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,2,2)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c50000134.tgcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50000134,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1)
	e3:SetCondition(c50000134.negcon)
	e3:SetTarget(c50000134.negtg)
	e3:SetOperation(c50000134.negop)
	c:RegisterEffect(e3)
	--to deck top
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50000134,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCost(c50000134.cost)
	e4:SetTarget(c50000134.target2)
	e4:SetOperation(c50000134.operation2)
	c:RegisterEffect(e4,false,1)
end

function c50000134.tgcon(e)
	return e:GetHandler():IsLinkState()
end

function c50000134.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()
		and re:IsActiveType(TYPE_MONSTER) and re:IsActiveType(TYPE_LINK) and re:GetHandler():IsRace(RACE_DRAGON) and Duel.IsChainNegatable(ev)
end
function c50000134.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 end
	
end
function c50000134.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.GetFieldGroup(tp,0,LOCATION_HAND):Select(tp,1,1,nil):GetFirst()
	Duel.ConfirmCards(tp,tc)
	if Duel.SelectYesNo(tp,aux.Stringid(50000134,0)) then
		if Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(1-tp)
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
	Duel.ShuffleHand(1-tp)
end

function c50000134.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50000134.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c50000134.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end