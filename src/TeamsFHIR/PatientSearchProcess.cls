Class TeamsFHIR.PatientSearchProcess Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Property TargetConfigName As Ens.DataType.ConfigName;

/// FHIR Endpoint
Property FHIREndpoint As %String(MAXLEN = 512);

Parameter SETTINGS = "FHIREndpoint:Basic:selector?context={HS.FHIRServer.Util.ContextSearch/FHIRServerEndpoints},TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnRequest(pRequest As TeamsFHIR.Request, Output pResponse As TeamsFHIR.Response) As %Status
{
	#dim ex As %Exception.AbstractException
	#dim fhirresponse As HS.FHIRServer.Interop.Response
	set status=$$$OK
	
	try {
		
	// FHIRリポジトリに検索要求を行うためのメッセージ作成
	set preq=##class(HS.FHIRServer.Interop.Request).%New()
	set preq.Request.RequestMethod="GET"
	set preq.Request.RequestPath="Patient"
	set preq.Request.QueryString="identifier=|"_pRequest.MRN
	set preq.Request.RequestFormatCode="JSON"
	set preq.Request.ResponseFormatCode="JSON"
 
	set preq.Request.SessionApplication=..FHIREndpoint
	set preq.Request.BaseURL=..FHIREndpoint	
	$$$ThrowOnError(..SendRequestSync(..TargetConfigName,preq,.fhirresponse))
	
	set pResponse=##class(TeamsFHIR.Response).%New()

	if fhirresponse.Response.Status=200 {
		//QuickStreamに結果が格納されているので取得する
		set qs=##class(HS.SDA3.QuickStream).%OpenId(fhirresponse.QuickStreamId)

		//JSONのダイナミックオブジェクトに変換
		set json={}.%FromJSON(qs)

		//応答のresource数をチェック。json.total=1　以外はエラー
		//json.total>1の場合は複数のリソースが存在するため一意に得できない
		if json.total>1 {
			set pResponse.Status="NG"
			set pResponse.Message="患者ID="_pRequest.MRN_"に対して複数のPatientリソースが存在するため特定できません。処理を中断します"
		}

		//json.total=1の場合
		elseif json.total=1 {
			set pResponse.Status="OK"
   			
   			//患者のリソースID取得
   			set pResponse.PatientResourceID=json.entry.%Get(0).resource.id
   			// 患者名取得
   			set pResponse.PatientName=json.entry.%Get(0).resource.name.%Get(0).text
		}
		else {
			set pResponse.Status="NG"
			set pResponse.Message="患者ID="_pRequest.MRN_"はFHIRリポジトリに存在しません。"
		}
	}
	else {
		set pResponse.Status="NG"
		set pResponse.Message="FHIR Response Status : "_fhirresponse.Response.Status
	}
	
	}
	catch ex {
		set status=ex.AsStatus()
	}
	return status
}

Storage Default
{
<Data name="PatientSearchProcessDefaultData">
<Subscript>"PatientSearchProcess"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
<Value name="2">
<Value>FHIREndpoint</Value>
</Value>
</Data>
<DefaultData>PatientSearchProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
