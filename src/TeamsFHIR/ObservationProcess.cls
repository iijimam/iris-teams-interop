Class TeamsFHIR.ObservationProcess Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Property TargetConfigName As Ens.DataType.ConfigName;

/// FHIR Endpoint
Property FHIREndpoint As %String(MAXLEN = 512);

Parameter SETTINGS = "FHIREndpoint:Basic:selector?context={HS.FHIRServer.Util.ContextSearch/FHIRServerEndpoints},TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Property ObservationTemplate As %Stream.GlobalBinary;

Method OnRequest(pRequest As TeamsFHIR.Request, Output pResponse As TeamsFHIR.Response) As %Status
{
	#dim ex As %Exception.AbstractException
	#dim fhirresponse As HS.FHIRServer.Interop.Response
	set status=$$$OK
	try {

		set obsJson={}.%FromJSON(..ObservationTemplate)
		// PatientリソースIDセット（正確なリソースIDが渡される予定）
 		set obsJson.subject.reference="Patient/"_pRequest.PatientResourceID
		// パルスオキシメータ値セット
		set obsJson.valueQuantity.value=pRequest.O2
  		
  		set fhirrequest=##class(HS.FHIRServer.Interop.Request).%New()
 		set tmpStream=##class(%Stream.TmpBinary).%New()
 		set status=obsJson.%ToJSON(tmpStream)
 		set quickstream=##class(HS.SDA3.QuickStream).%New()
 		set status=quickstream.CopyFromAndSave(tmpStream)
 		set fhirrequest.QuickStreamId=quickstream.%Id()
		set fhirrequest.Request.RequestPath="Observation"
		set fhirrequest.Request.RequestMethod="POST"
		set fhirrequest.Request.RequestFormatCode="JSON"
		set fhirrequest.Request.ResponseFormatCode="JSON"
		set fhirrequest.Request.SessionApplication=..FHIREndpoint
		set fhirrequest.Request.BaseURL=..FHIREndpoint

		$$$ThrowOnError(..SendRequestSync(..TargetConfigName,fhirrequest,.fhirresponse))
		
		set pResponse=##class(TeamsFHIR.Response).%New()

		if fhirresponse.Response.Status=201 {
			set pResponse.Status="OK"
		}
		else {
			set pResponse.Status="NG"
			//QuickStreamに結果が格納されているので取得する			
			set qs=##class(HS.SDA3.QuickStream).%OpenId(fhirresponse.QuickStreamId)
			set pResponse.Message="FHIRリポジトリでエラー発生："_fhirresponse.Response.Status_" Payload = "_qs.Read()
		}
	}
	catch ex {
		set status=ex.AsStatus()
	}
	return status
}

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	//Observationリソースのテンプレートを取得
	set template=##class(TeamsFHIR.TemplateTBL).ResourceNameIdxOpen("Observation")
	if $isobject(template)=0 {
		quit $system.Status.Error(5001,"Observationリソースのテンプレートが存在しません")
	}
	set ..ObservationTemplate=template.Template

	Quit $$$OK
}

Storage Default
{
<Data name="ObservationProcessDefaultData">
<Subscript>"ObservationProcess"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
<Value name="2">
<Value>ObservationTemplate</Value>
</Value>
<Value name="3">
<Value>FHIREndpoint</Value>
</Value>
</Data>
<DefaultData>ObservationProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
