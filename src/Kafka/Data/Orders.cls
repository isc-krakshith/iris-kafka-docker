Class Kafka.Data.Orders Extends (%Library.Persistent, %Populate) [ Not Abstract, DdlAllowed, Not LegacyInstanceContext, ProcedureBlock ]
{

Property orderId As %Library.Integer(MAXVAL = 1800, MINVAL = 1) [ SqlColumnNumber = 2 ];

Property dateTime As %Library.PosixTime [ SqlColumnNumber = 3 ];

Property security As %Library.String(VALUELIST = "-SECA-SECB-SECC-SECD") [ SqlColumnNumber = 4 ];

Property vol As %Library.Integer(MAXVAL = 1500, MINVAL = 1) [ SqlColumnNumber = 5 ];

Property buy As %Library.Boolean [ SqlColumnNumber = 6 ];

Property bidAsk As %Library.Double(MAXVAL = 99, MINVAL = 25) [ Required, SqlColumnNumber = 7 ];

/// Return set of orders which can be fullfilled
ClassMethod Match(buy As %Boolean, tickerName As %String, volume As %Numeric, price As %Numeric) As %SQL.StatementResult [ ReturnResultsets, SqlProc ]
{
	#dim %sqlcontext as %ProcedureContext
	#dim resultSet as %SQL.StatementResult
	set resultSet = $$$NULLOREF
	#dim statement as %SQL.Statement
	set statement = ##class(%SQL.Statement).%New(1) // ODBC mode
    set comparisonOperator = ">="
    if buy   = 1 {
        set comparisonOperator = "<="
    }
    set sql = "SELECT * FROM KAFKA_DATA.ORDERS"
    set sql = sql _ " WHERE BUY = ? AND security = ? AND VOL >= ? AND BIDASK " _comparisonOperator_" ?" 

	set status = statement.%Prepare(sql)
	if $$$ISOK(status) {
		set resultSet = statement.%Execute(buy, tickerName, volume, price)
		if (resultSet.%SQLCODE = 0) {
			// successful %Execute

			// for testing using Terminal
			//while resultSet.%Next() {
			//	write !!, resultSet.id, ?5, resultSet.dateTime, ?35, resultSet.vol, ?40, resultSet.bidAsk
			//}

			// for xDBC
			// do %sqlcontext.AddResultSet(resultSet)
		}
		else {
			// error during %Execute
			set %sqlcontext.%SQLCODE = resultSet.%SQLCODE
			set %sqlcontext.%Message = resultSet.%Message
		} 
	}
	else {
		// error during %Prepare: bad SQL
		#dim ex as %Exception.StatusException
		set ex = ##class(%Exception.StatusException).CreateFromStatus(status)
		set %sqlcontext.%SQLCODE = ex.AsSQLCODE()
		// 4th ":" piece contains %msg value
		set %sqlcontext.%Message = $piece(ex.AsSQLMessage(), ":", 4)
	}
	return resultSet  // return results to other server-side code
}

Storage Default
{
<Data name="OrdersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>id</Value>
</Value>
<Value name="3">
<Value>dateTime</Value>
</Value>
<Value name="4">
<Value>security</Value>
</Value>
<Value name="5">
<Value>vol</Value>
</Value>
<Value name="6">
<Value>buy</Value>
</Value>
<Value name="7">
<Value>bidAsk</Value>
</Value>
<Value name="8">
<Value>orderId</Value>
</Value>
</Data>
<DataLocation>^Kafka.Data.OrdersD</DataLocation>
<DefaultData>OrdersDefaultData</DefaultData>
<ExtentSize>440</ExtentSize>
<IdLocation>^Kafka.Data.OrdersD</IdLocation>
<IndexLocation>^Kafka.Data.OrdersI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3.46</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb("1","30","61","92","123","155","186","218","252","287","319","356","390","426","463","500"),$lb(0,0,0,0,1,1,0,1,1,0,1,1,0,1,0),$lb(822083584,822083584,858783744,858783744,909180928,909180928,959578112,959578112,825373440,842203136,892665856,892665856,943063040,825767424,842086400,825753600,892469248,892469248,943128576,842544896,858863872,825819136,892731392,892731392,959447040,859385856,875705856,842399744,909312000,875967232,892350464,892350464))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="bidAsk">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="buy">
<AverageFieldSize>2.52</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),$lb(1,1,1,1,1,1,1,0,1,1,1,1,1,1,1),$lb(805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,822083584,0,0,0,0,0,0,0,0,0,0,0,0,0,0,822083584))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="dateTime">
<AverageFieldSize>10</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(-6919720237402840670,-6919507522977800507,-6919194880461289741,-6918905688160443779,-6918684178763312989,-6918426966714480789,-6918099066318164360,-6917885711021235383,-6917618363109490009,1153038900190517029,1153288920732445204,1153652570337281951,1153917937959684033,1154145962510257418,1154343626700157315,1154557462144373327),$lb(5,5,4,5,5,5,4,5,0,4,4,4,3,4,4),$lb(758528305,926036018,892352309,892352309,825832504,959527220,943271989,959460662,909653041,909653041,875705913,875705913,809056560,942684473,926431285,943207735,909195315,758528305,825308467,808663097,842545209,842545209,909455925,909455925,959526713,859386167,875639861,825505081,859058998,859058998,892679988,825308468))</Histogram>
<Selectivity>0.2273%</Selectivity>
</Property>
<Property name="orderId">
<AverageFieldSize>3.86</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="security">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" SECA"," SECA"," SECA"," SECA"," SECB"," SECB"," SECB"," SECB"," SECC"," SECC"," SECC"," SECD"," SECD"," SECD"," SECD"," SECD"),$lb(6,6,6,4,6,6,6,4,6,6,4,6,6,6,6),$lb(542328131,0,0,0,0,0,0,1090519040,1107296256,0,0,0,0,0,0,1107296256,1124073472,0,0,0,0,1124073472,1140850688,0,0,0,0,0,0,0,0,542328131))</Histogram>
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="vol">
<AverageFieldSize>3.84</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(4,99,228,317,400,477,572,654,743,852,932,1051,1174,1274,1400,1494),$lb(0,0,0,0,1,0,0,0,0,0,0,1,1,1,2),$lb(872415232,872415232,960036864,960036864,842151936,842151936,858863360,858863360,875573248,808452096,926351360,876033792,892809728,892809728,909456384,909456384,926167808,926167808,943010304,943010304,959656448,959656448,825242929,808792320,825701376,825701376,842478592,842478592,875573248,808452096,959709184,825506100))</Histogram>
<Selectivity>0.2646%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-12</BlockCount>
</SQLMap>
<SQLMap name="orderIdIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^Kafka.Data.OrdersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
