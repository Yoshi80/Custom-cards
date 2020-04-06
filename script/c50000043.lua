-- Harmony Wielder of Honesty

function c50000043.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--mill
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000043,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,500000431)
	e1:SetCost(c50000043.cost)
	e1:SetCondition(c50000043.condition)
	e1:SetTarget(c50000043.target)
	e1:SetOperation(c50000043.operation)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c50000043.damcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c50000043.damcon)
	e3:SetValue(c50000043.indval)
	c:RegisterEffect(e3)
	--move
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50000043,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,500000432)
	e4:SetTarget(c50000043.mvtg)
	e4:SetOperation(c50000043.mvop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(50000043,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,500000433)
	e5:SetCondition(c50000043.condition2)
	e5:SetTarget(c50000043.target2)
	e5:SetOperation(c50000043.operation2)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(50000043,ACTIVITY_SPSUMMON,c50000043.counterfilter)
end

function c50000043.counterfilter(c)
	return c:IsSetCard(0x701) or c:IsCode(50000040)
end

function c50000043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(50000043,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c50000043.splimit)
	Duel.RegisterEffect(e1,tp)
end

function c50000043.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x701) and not c:IsCode(50000040)
end

function c50000043.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end

function c50000043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
end

function c50000043.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end

function c50000043.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c50000043.filter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c50000043.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end

function c50000043.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end

function c50000043.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end

function c50000043.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x701)
end

function c50000043.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50000043.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000043.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50000043,1))
	Duel.SelectTarget(tp,c50000043.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c50000043.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end

function c50000043.condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end

function c50000043.filter2(c)
	return c:IsSetCard(0x701) and c:IsType(TYPE_SPELL) and not c:IsCode(50000044) and c:IsAbleToHand()
end

function c50000043.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000043.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c50000043.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50000043.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end