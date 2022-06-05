/// Tests for EnsLib.Kafka
Class Kafka.Tests Extends %RegisteredObject
{

ClassMethod OutboundAdapter()
{
	Set tSC = $$$OK

	Set adapter = ""
	Try {
		Set adapter = ##class(EnsLib.Kafka.OutboundAdapter).%New()
		Set adapter.Servers = "localhost:9092"
				
		Set tSC = adapter.OnInit()
		Quit:$$$ISERR(tSC)
		
		#Dim message As EnsLib.Kafka.Message = ##class(EnsLib.Kafka.Message).%New()
		Set message.topic = "quickstart-events"
		Set message.value = "test value"
		Set message.key = "test key"
		W "Send Message...", !
		W "Message: ", message.ToJSON(), !
		Set tSC = adapter.SendMessage(message)
		Quit:$$$ISERR(tSC)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Do:adapter'="" adapter.OnTearDown()
	Do $system.OBJ.DisplayError(tSC)
	W "Done", !
}

ClassMethod Service()
{
	Set tSC = $$$OK
	Try {
		Set ^Ens.Runtime("ConfigItem","Kafka.Service","IsEnabled") = 1
  		Set ^Ens.Runtime("DispatchName",0) = "Kafka.Service"
   		Set service = ##class(Ens.Host).GetShadowInstance("class||EnsLib.Kafka.Service", .tSC)
   		Quit:$$$ISERR(tSC)
   		
   		Set service.Adapter.Servers = "localhost:9092"
   		Set service.Adapter.Topic = "quickstart-events"
		Set service.Adapter.GroupID = "G1"
   		Set tSC = service.OnInit()
		Quit:$$$ISERR(tSC)
		
   		Set tSC = service.Adapter.OnInit()
   		Quit:$$$ISERR(tSC)
   		
   		Set tSC = service.OnTask()
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	
	Kill ^Ens.Runtime
	Do $system.OBJ.DisplayError(tSC)
	W "Done", !
}

}
