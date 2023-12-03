Class TeamsFHIR.TemplateTBL Extends %Persistent
{

Property ResourceName As %String;

Index ResourceNameIdx On ResourceName [ Unique ];

Property Template As %Stream.GlobalBinary;

Storage Default
{
<Data name="TemplateTBLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResourceName</Value>
</Value>
<Value name="3">
<Value>Template</Value>
</Value>
</Data>
<DataLocation>^TeamsFHIR.TemplateTBLD</DataLocation>
<DefaultData>TemplateTBLDefaultData</DefaultData>
<IdLocation>^TeamsFHIR.TemplateTBLD</IdLocation>
<IndexLocation>^TeamsFHIR.TemplateTBLI</IndexLocation>
<StreamLocation>^TeamsFHIR.TemplateTBLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
