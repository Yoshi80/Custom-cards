-- Hakaishin - Champa

function c50000085.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c50000085.destg)
	e1:SetOperation(c50000085.desop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000085,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,500000851)
	e2:SetCondition(c50000085.drcon)
	e2:SetTarget(c50000085.drtg)
	e2:SetOperation(c50000085.drop)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c50000085.sdcon)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50000085,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,500000852)
	e4:SetCost(c50000085.drcost2)
	e4:SetTarget(c50000085.drtg2)
	e4:SetOperation(c50000085.drop2)
	c:RegisterEffect(e4)
end

function c50000085.filter(c)
	return c:IsSetCard(0x702)
end
function c50000085.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c50000085.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000085.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c50000085.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c50000085.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c50000085.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
end
function c50000085.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50000085.cfilter,1,nil,tp)
end
function c50000085.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50000085.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c50000085.sdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x702) and c:IsLevelAbove(7)
end
function c50000085.sdcon(e)
	return Duel.IsExistingMatchingCard(c50000085.sdfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function c50000085.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x702) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c50000085.drcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c50000085.cfilter2,1,false,nil,nil,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,c50000085.cfilter2,1,1,false,nil,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c50000085.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c50000085.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
