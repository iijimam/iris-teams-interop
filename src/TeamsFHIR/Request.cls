Class TeamsFHIR.Request Extends Ens.Request
{

Property MRN As %String;

Property O2 As %Integer;

Property PatientResourceID As %Integer;

Property PatientName As %String;

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>MRN</Value>
</Value>
<Value name="2">
<Value>O2</Value>
</Value>
<Value name="3">
<Value>PatientResourceID</Value>
</Value>
<Value name="4">
<Value>PatientName</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
