Class TeamsFHIR.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="TeamsFHIR.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIRServer.Interop.Operation" Category="" ClassName="HS.FHIRServer.Interop.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="TeamsFHIR.MessageToFHIRBPL" Category="" ClassName="TeamsFHIR.MessageToFHIRBPL" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="TeamsFHIR.SendLineOperation" Category="" ClassName="TeamsFHIR.SendLineOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPServer">api.line.me</Setting>
    <Setting Target="Adapter" Name="SSLConfig">line</Setting>
    <Setting Target="Adapter" Name="URL">/v2/bot/message/broadcast</Setting>
    <Setting Target="Host" Name="token">eZPpfv7rQty1oZhVGW+S2VMoKUMeK9sNv8Aev/5jkrtEUvfsg7NrdYGBJxc2mi45K9SQX4AjPYbe1TuyRhIyG2Gmne5GPw1NxiIQH+P8gnP1KAaI0M+n71/p3nGgMYArrXlN77TqJ6GtYbtOUgRu2AdB04t89/1O/w1cDnyilFU=</Setting>
  </Item>
  <Item Name="TeamsFHIR.PatientSearchProcess" Category="" ClassName="TeamsFHIR.PatientSearchProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.Operation</Setting>
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/test/fhir/r4</Setting>
  </Item>
  <Item Name="TeamsFHIR.ObservationProcess" Category="" ClassName="TeamsFHIR.ObservationProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.Operation</Setting>
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/test/fhir/r4</Setting>
  </Item>
  <Item Name="TeamsFHIR.PostAndNotifyProcessBPL" Category="" ClassName="TeamsFHIR.PostAndNotifyProcessBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="TeamsFHIR.FromRESTService" Category="" ClassName="TeamsFHIR.FromRESTService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
