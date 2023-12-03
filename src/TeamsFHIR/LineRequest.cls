Class TeamsFHIR.LineRequest Extends Ens.Request
{

Property MRN As %String;

Property O2 As %Integer;

Property PatientName As %String;

Storage Default
{
<Data name="LineRequestDefaultData">
<Subscript>"LineRequest"</Subscript>
<Value name="1">
<Value>MRN</Value>
</Value>
<Value name="2">
<Value>O2</Value>
</Value>
<Value name="3">
<Value>PatientName</Value>
</Value>
</Data>
<DefaultData>LineRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
