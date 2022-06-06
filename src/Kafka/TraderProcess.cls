Class Kafka.TraderProcess Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Property TargetConfigName As Ens.DataType.ConfigName;

Property Topic As %String;

Parameter SETTINGS = "TargetConfigName:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},Topic:Basic";

Method OnRequest(pRequest As EnsLib.Kafka.Message, Output pResponse As Ens.Response) As %Status
{
	// Change topic and send it to target
	set bidAskMsg = ##class(%DynamicAbstractObject).%FromJSON(pRequest.value)
	set bid = bidAskMsg.bid
	set ask = bidAskMsg.ask
	set vol = bidAskMsg.vol

	set buy = 1 //assume its a bid message
	set price = bid
	set type = "Bid"
	set security = bidAskMsg.security
	if (ask > 0) { //process it as an ask message
		set buy = 0
		set price = ask
		set type = "Ask"
	}
	#dim matchingbidsAsks As %SQL.StatementResult
	set matchingbidsAsks = ##class(Kafka.Data.Orders).Match(buy,security,vol,price)
	if (matchingbidsAsks.%SQLCODE = 0) {
		// successful %Execute

		// for testing using Terminal
		while matchingbidsAsks.%Next() {
			Set tMsg = ##class(EnsLib.Kafka.Message).%New()
			Set tMsg.topic = ..Topic
			Set tMsg.key = pRequest.key
			Set tMsg.value = "{""ref"":"_bidAskMsg.ref_","_type_"DateTime"":"_bidAskMsg.dateTime_",""OrderId"":"_matchingbidsAsks.orderId_","_type_",""OrderDateTime"":"_matchingbidsAsks.dateTime_",""Available"":"_matchingbidsAsks.vol_",""Fulfill"":"_vol_",""OfferPrice"":"_matchingbidsAsks.bidAsk_","_type_"Price"":"_price_"}"
			do ..SendRequestAsync(..TargetConfigName, tMsg, 0)
		}
	}
	else {
		// error during %Execute
		set %sqlcontext.%SQLCODE = matchingbidsAsks.%SQLCODE
		set %sqlcontext.%Message = matchingbidsAsks.%Message
	}
	Quit $$$OK
}

Storage Default
{
<Data name="TraderProcessDefaultData">
<Subscript>"TraderProcess"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
<Value name="2">
<Value>Topic</Value>
</Value>
</Data>
<DefaultData>TraderProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
