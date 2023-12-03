Class TeamsFHIR.SendLineOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

/// LINEの通知用トークン
Property token As %String(MAXLEN = 1000);

Parameter SETTINGS = "token:LINE用設定";

Parameter INVOCATION = "Queue";

/// LINE通知用サーバ： https://api.line.me/v2/bot/message/broadcast
Method SendMessage(pRequest As TeamsFHIR.LineRequest, Output pResponse As Ens.Response) As %Status
{
	#dim ex As %Exception.AbstractException
	set status=$$$OK
	try {
		set message="低い酸素飽和度が検出されました"_$$$NL
		set message=message_"患者番号："_pRequest.MRN_$$$NL
		set message=message_"患者名："_pRequest.PatientName_$$$NL
		set message=message_"酸素飽和度："_pRequest.O2_$$$NL
		set message=message_"注意が必要です"
		
		set jobj={}
		set jobj.type="text"
		set jobj.text=message
		set jarray=[]
		do jarray.%Push(jobj)
		set linejson={}
		set linejson.messages=jarray
		$$$TRACE(linejson.%ToJSON())
		//LINE通知はBearer Tokenなのでヘッダ追加必要
		set httprequest=##class(%Net.HttpRequest).%New()
		do httprequest.SetHeader("Authorization","Bearer "_..token)
		set httprequest.ContentCharset="utf-8"
		set httprequest.ContentType="application/json"
		do httprequest.EntityBody.Write($ZCVT(linejson.%ToJSON(),"O","UTF8"))
		set status=..Adapter.SendFormData(.pHttpResponse,"POST",httprequest)
		if pHttpResponse.StatusCode'=200 {
			set status=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(status)_":"_pHttpResponse.Data.Read())
		}
		$$$ThrowOnError(status)
	}
	catch ex {
		set status=ex.AsStatus()
	}
	return status
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="TeamsFHIR.LineRequest"> 
		<Method>SendMessage</Method>
	</MapItem>
</MapItems>
}

}
