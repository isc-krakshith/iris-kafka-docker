Class Kafka.TraderProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Kafka.Trader" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="EnsLib.Kafka.Service" Category="" ClassName="EnsLib.Kafka.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">Kafka.TraderProcess</Setting>
    <Setting Target="Adapter" Name="Topic">bidsAsks</Setting>
    <Setting Target="Adapter" Name="GroupID">G1</Setting>
  </Item>
  <Item Name="Kafka.TraderProcess" Category="" ClassName="Kafka.TraderProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">EnsLib.Kafka.Operation</Setting>
    <Setting Target="Host" Name="Topic">trades</Setting>
  </Item>
  <Item Name="EnsLib.Kafka.Operation" Category="" ClassName="EnsLib.Kafka.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
