--- Red-Eyes Flame Swordsman

function c35200010.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35200010,2))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c35200010.atkcost)
	e1:SetTarget(c35200010.atktg)
	e1:SetOperation(c35200010.atkop)
	c:RegisterEffect(e1)
	--roll dice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35200010,0))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE+CATEGORY_DRAW+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c35200010.descost)
	e2:SetTarget(c35200010.target)
	e2:SetOperation(c35200010.operation)
	c:RegisterEffect(e2)
end

c35200010.pendulum_level=5

function c35200010.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,1800)/100)
	local t={}
	for i=1,m do
		t[i]=i*100
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
	e:GetHandler():RegisterFlagEffect(35200010,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c35200010.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b)
end
function c35200010.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c35200010.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c35200010.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c35200010.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end

function c35200010.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c35200010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
end
function c35200010.dicefilter2(c)
	return c:IsFaceup()
end
function c35200010.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local previousResult=nil
	local check = false
	local has3 = false
	local has6 = false
	local diceroll=nil
	while (not check) do
		diceroll = {Duel.TossDice(tp,2)}
		for _,i in ipairs(diceroll) do
			if i==3 then
				has3 = true
			end
			if i==6 then
				has6 = true
			end
		end
		if has3 and has6 then
			check = true
		else
			has3 = false
			has6 = false
		end
	end
	for _,i in ipairs(diceroll) do
		if previousResult==nil or previousResult~=i then
			if i==1 then
				Duel.Damage(1-tp,800,REASON_EFFECT)
			elseif i==2 then
				local tc=Duel.SelectTarget(tp,c35200010.dicefilter2,tp,LOCATION_MZONE,0,1,1,nil)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(tc:GetFirst():GetBaseAttack()*2)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:GetFirst():RegisterEffect(e1)
			elseif i==3 then
				Duel.Draw(tp,2,REASON_EFFECT)
			elseif i==4 then
				local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
				if g:GetCount()==0 then return end
				local rg=g:RandomSelect(tp,1)
				local tc=rg:GetFirst()
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			elseif i==5 then
				local tc=Duel.SelectTarget(tp,c35200010.dicefilter2,tp,LOCATION_MZONE,0,1,1,nil)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_EXTRA_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e2:SetValue(1)
				tc:GetFirst():RegisterEffect(e2)
			elseif i==6 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(35200010,1)) then
				Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
			previousResult=i
		end
	end
end