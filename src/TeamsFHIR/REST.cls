Class TeamsFHIR.REST Extends %CSP.REST
{

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!--
<Route Url="/class/:namespace/:classname" Method="GET" Call="GetClass" Cors="true"/>
<Map Prefix="/docserver" Forward="%Api.v1.DocServer"/>
-->
<Route Url="/request/:mrn" Method="GET" Call="PatientSearch" Cors="true"/>
<Route Url="/request" Method="POST" Call="ObservationPost" Cors="true"/>
</Routes>
}

ClassMethod PatientSearch(mrn As %String) As %Status [ Language = objectscript ]
{
	#dim ex As %Exception.AbstractException
	#dim response As TeamsFHIR.Response
	#dim %response As %CSP.Response
	#dim %request As %CSP.Request
	set status=$$$OK
	try {
		$$$ThrowOnError(##class(Ens.Director).CreateBusinessService("TeamsFHIR.FromRESTService",.bs))
		//ビジネスサービスに渡す要求メッセージを作成
		set request=##class(TeamsFHIR.Request).%New()
		set request.MRN=mrn
		//引数に要求メッセージを指定し、ビジネスサービスのProcessInput()を呼び出す
		$$$ThrowOnError(bs.ProcessInput(request,.response))
		set json={}
		set json.Status=response.Status
		if response.Status="OK" {
			set json.PatientName=response.PatientName
			set json.PatientResourceID=response.PatientResourceID
		}
		else {
			set json.Message=response.Message
		}
		do json.%ToJSON()
	}
	catch ex {
		set status=ex.AsStatus()
	}
	return status
}

ClassMethod ObservationPost() As %Status [ Language = objectscript ]
{
	#dim ex As %Exception.AbstractException
	#dim response As TeamsFHIR.Response
	#dim %response As %CSP.Response
	#dim %request As %CSP.Request
	set status=$$$OK
	try {
		$$$ThrowOnError(##class(Ens.Director).CreateBusinessService("TeamsFHIR.FromRESTService",.bs))
		//ビジネスサービスに渡す要求メッセージを作成
		set request=##class(TeamsFHIR.Request).%New()
		set data={}.%FromJSON(%request.Content.Read())
		set request.MRN=data.MRN
		set request.PatientName=data.PatientName
		set request.PatientResourceID=data.PatientResourceID
		set request.O2=data.O2

		//引数に要求メッセージを指定し、ビジネスサービスのProcessInput()を呼び出す
		$$$ThrowOnError(bs.ProcessInput(request,.response))
		set json={}
		set json.Status=response.Status
		set json.Message=response.Message

		do json.%ToJSON()
	}
	catch ex {
		set status=ex.AsStatus()
	}
	return status
}

}
