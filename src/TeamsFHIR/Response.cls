Class TeamsFHIR.Response Extends Ens.Response
{

Property Status As %String;

Property Message As %String(MAXLEN = 1000);

Property PatientResourceID As %Integer;

Property PatientName As %String;

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>Status</Value>
</Value>
<Value name="2">
<Value>Message</Value>
</Value>
<Value name="3">
<Value>PatientResourceID</Value>
</Value>
<Value name="4">
<Value>PatientName</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
