Class Kafka.TestKafkaMessagingClient Extends %RegisteredObject
{

ClassMethod KafkaClient()
{
	Set tSC = $$$OK
	#Dim client As %External.Messaging.KafkaClient = ""
	Try {
		Set settings = ##class(%External.Messaging.KafkaSettings).%New()
		Set settings.groupId = "G3"
		W "Settings: ", settings.ToJSON(), !

		Set client = ##class(%External.Messaging.Client).CreateClient(settings, .tSC)
		Quit:$$$ISERR(tSC)

		W "Update consumer...", !
		Set consumerSettings = "{""key.deserializer"":""org.apache.kafka.common.serialization.StringDeserializer""}"
		Set tSC = client.UpdateConsumerConfig(consumerSettings)
		Quit:$$$ISERR(tSC)

		W "Update producer...", !
		Set producerSettings = "{""key.serializer"":""org.apache.kafka.common.serialization.StringSerializer""}"
		Set tSC = client.UpdateProducerConfig(producerSettings)
		Quit:$$$ISERR(tSC)

		W "Update admin...", !
		Set adminSettings = ""
		Set tSC = client.UpdateAdminConfig(adminSettings)
		Quit:$$$ISERR(tSC)

		// Create topic
		W "Creating topic...", !
		Set topic = "test-Bids-Asks"
		#Dim queueSettings As %External.Messaging.KafkaTopicSettings = ##class(%External.Messaging.KafkaTopicSettings).%New()
		Set queueSettings.numberOfPartitions = 1, queueSettings.replicationFactor = 1
		W "Topic settings: ", queueSettings.ToJSON(), !
		//Set tSC = client.CreateQueueOrTopic(topic, queueSettings.ToJSON())
		//Set tSC = client.CreateTopic(topic, 1, 1)
		Quit:$$$ISERR(tSC)

		//Send message
		W "Sending message...", !
		Set value = "{""dateTime"":""2022-06-07T13:18:32.000"",""ref"":""OH77CBN3"", ""security"":""SECB"", ""bid"":0, ""ask"":50, ""vol"":400}", key = "testBidsAsksKey2"
		Set msg = ##class(%External.Messaging.KafkaMessage).%New()
		Set msg.topic = topic
		Set msg.value = value
		Set msg.key = key
		W "Message: ", msg.ToJSON(), !
		Set tSC = client.SendMessage(msg)
		Quit:$$$ISERR(tSC)
		
		// Receive message
		W "Receiving message...", !
		//KafkaReceiveSettings will be avialable InterSystems IRIS v 2022.2 onwards
		//until then we need to loop unitl the message is received back 
		//#Dim receiveSettings As %External.Messaging.KafkaReceiveSettings = ##class(%External.Messaging.KafkaReceiveSettings).%New()
		//Set receiveSettings.pollTimeout = 100000
		//W "Receive settings: ", receiveSettings.ToJSON(), !
		#Dim messages As %ListOfObjects
        set messages = ""
        set counter = 0
        while 1 {
		    Set tSC = client.ReceiveMessage(topic, .messages) // receiveSettings.ToJSON())
            set counter = counter + 1
            //w counter,!
            Quit:messages.Size>0
		    Quit:$$$ISERR(tSC)
        }

		For i=1:1:messages.Size {
			Set msg = messages.GetAt(i)
			W "Message: ", msg.ToJSON(), !
		}

		W "Deleting topic...", !
		Do client.DeleteQueueOrTopic(topic)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Do:client'="" client.Close()
	Do $system.OBJ.DisplayError(tSC)
	W "Done", !
}

}
