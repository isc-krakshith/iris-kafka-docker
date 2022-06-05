Class Kafka.TradeDecision
{

ClassMethod Approve(message As %String) As %Numeric
{
        set JSONobj = ##class(%DynamicAbstractObject).%FromJSON(message)
        set bid = JSONobj.bid
        set ask = JSONobj.ask
        if ($DOUBLE(bid) >= $DOUBLE(ask))
        {
            return 1
        }
        elseif ($DOUBLE(bid)/($DOUBLE(ask)-$DOUBLE(bid))>=10)
        {
            return 1
        }
        return 0
}

}
