Class TeamsFHIR.Utils
{

ClassMethod getObservationTemplate(in As %String, Output json As %DynamicObject) As %Status
{
	#dim ex As %Exception.AbstractException
	set status=$$$OK
	try {
		if ##class(%File).Exists($get(in)) {
			set json={}.%FromJSON(in)
		}
		else {
			set json={}.%FromJSON("observationTemplate.json")
		}
	}
	catch ex {
		set status=ex.AsStatus()
	}
	return status
}

ClassMethod templateTableCreate() As %Status
{
	set obj=##class(TeamsFHIR.TemplateTBL).%New()
	set obj.ResourceName="Observation"
	//DBDir直下に事前に以下ファイルが用意されている前提で実行
	set file=##class(%Stream.FileBinary).%New()
	do file.LinkToFile("observationTemplate.json")
	do obj.Template.CopyFrom(file)
	return obj.%Save()
}

}
