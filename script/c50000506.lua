--Jade Dragon Zirconis
local s,id=GetID()
function s.initial_effect(c)
	--announce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.actg)
	e1:SetOperation(s.acop)
	c:RegisterEffect(e1)
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local ct=g:GetClassCount(Card.GetAttribute)+2
		if ct<=0 or not (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct) then return false end
		return true
	end
end
function s.spfilter(c,e,tp,attributes)
	return c:IsLevel(10) and c:IsRace(RACE_DRAGON)
		and not s.has_value(attributes,c:GetAttribute())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetClassCount(Card.GetAttribute)+2
	if ct<=0 or not (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct) then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	local g2=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local tc2=g2:GetFirst()
	local attributes={} 
	while tc2 do
		if not s.has_value(attributes,tc2:GetAttribute()) then
			table.insert(attributes,tc2:GetAttribute())
		end
		tc2=g2:GetNext()
	end
	local hg=g:Filter(s.spfilter,nil,e,tp,attributes)
	g:Sub(hg)
	if #hg~=0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=hg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.ShuffleDeck(tp)
end
function s.has_value(tab,val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end