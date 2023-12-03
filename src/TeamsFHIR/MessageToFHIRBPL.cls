/// 
Class TeamsFHIR.MessageToFHIRBPL Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='TeamsFHIR.Request' response='TeamsFHIR.Response' height='2000' width='2000' >
<context>
<property name='PatientResourceId' type='%Integer' instantiate='0' />
<property name='FHIRRequest' type='HS.FHIRServer.Interop.Request' instantiate='0' />
<property name='FHIRResponse' type='HS.FHIRServer.Interop.Response' instantiate='0' />
<property name='PatientName' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='1200' >
<code name='患者検索データ準備' xpos='200' ypos='250' >
<annotation><![CDATA[FHIRへ指定の患者番号が存在するか確認するための要求メッセージ作成
]]></annotation>
<![CDATA[ set preq=##class(HS.FHIRServer.Interop.Request).%New()
 set preq.Request.RequestMethod="GET"
 set preq.Request.RequestPath="Patient"
 set preq.Request.QueryString="identifier=|"_request.MRN
 set preq.Request.RequestFormatCode="JSON"
 set preq.Request.ResponseFormatCode="JSON"
 
 set preq.Request.SessionApplication="/csp/healthshare/test/fhir/r4"
 set context.FHIRRequest=preq]]>
</code>
<call name='患者検索' target='HS.FHIRServer.Interop.Operation' async='0' xpos='200' ypos='350' >
<request type='HS.FHIRServer.Interop.Request' >
<assign property="callrequest" value="context.FHIRRequest" action="set" />
</request>
<response type='HS.FHIRServer.Interop.Response' >
<assign property="context.FHIRResponse" value="callresponse" action="set" />
</response>
</call>
<code name='PatientリソースID確認' xpos='200' ypos='450' >
<annotation><![CDATA[context.PatientResponseからPatientリソースのIDを取得し、context.PatientResourceIdに設定します。]]></annotation>
<![CDATA[ set response.Status="OK"
 if context.FHIRResponse.Response.Status=200 {

  // QuickStreamに結果が格納されているので取得
  set qs=##class(HS.SDA3.QuickStream).%OpenId(context.FHIRResponse.QuickStreamId)
  
  // JSONのダイナミックオブジェクトに変換
  set json={}.%FromJSON(qs)
 
  // 応答のresouceの数をチェック。json.total=1でない場合、複数のPatientリソースが存在するため一意に特定できない
  if json.total>1 {
   set response.Status="NG"
   set response.Message="患者ID="_request.MRN_"に対して複数のPatientリソースが存在するため特定できません。処理を中断します"
  }
  elseif json.total'=0 {
   set context.PatientResourceId=json.entry.%Get(0).resource.id
   // 患者名も取得
   set context.PatientName=json.entry.%Get(0).resource.name.%Get(0).text
  }
  else {
   set response.Status="NG"
   set response.Message="患者ID="_request.MRN_"はFHIRリポジトリに存在しません。"
  }
 }
 else {
  set response.Status="NG"
  set response.Message="FHIR Resource Status = "_context.FHIRResponse.Response.Status
 }]]>
</code>
<if name='Status="OK"' condition='response.Status="OK"' xpos='200' ypos='650' xend='200' yend='1100' >
<true>
<code name='Observationリソース作成' xpos='440' ypos='775' >
<![CDATA[ // テンプレート用のJSONが書かれたファイルからダイナミックオブジェクトを作成
 set status=##class(TeamsFHIR.Utils).getObservationTemplate(,.obsJson)
 // PatientリソースIDセット
 set obsJson.subject.reference="Patient/"_context.PatientResourceId
 // パルスオキシメータ値セット
 set obsJson.valueQuantity.value=request.O2
  
 set context.FHIRRequest=##class(HS.FHIRServer.Interop.Request).%New()
 set tmpStream=##class(%Stream.TmpBinary).%New()
 set status=obsJson.%ToJSON(tmpStream)
 set quickstream=##class(HS.SDA3.QuickStream).%New()
 set status=quickstream.CopyFromAndSave(tmpStream)
 set context.FHIRRequest.QuickStreamId=quickstream.%Id()
 set context.FHIRRequest.Request.RequestPath="Observation"
 set context.FHIRRequest.Request.RequestMethod="POST"
 set context.FHIRRequest.Request.RequestFormatCode="JSON"
 set context.FHIRRequest.Request.ResponseFormatCode="JSON"
 set context.FHIRRequest.Request.SessionApplication="/csp/healthshare/test/fhir/r4"]]>
</code>
<call name='Observation登録' target='HS.FHIRServer.Interop.Operation' async='0' xpos='355' ypos='895' >
<request type='HS.FHIRServer.Interop.Request' >
<assign property="callrequest" value="context.FHIRRequest" action="set" />
</request>
<response type='HS.FHIRServer.Interop.Response' >
<assign property="context.FHIRResponse" value="callresponse" action="set" />
</response>
</call>
<code name='ステータス登録' xpos='335' ypos='1000' >
<![CDATA[ if context.FHIRResponse.Response.Status=201 {
  set response.Status="OK"
 }
 else {
  set response.Status="NG"
  set stream=##class(HS.SDA3.QuickStream).%OpenId(context.FHIRResponse.QuickStreamId)
  set response.Message="FHIRリポジトリでエラー発生："_context.FHIRResponse.Response.Status_" Payload = "_stream.Read()
 }]]>
</code>
<if name='通知対象？' condition='(response.Status="OK") &amp;&amp; (request.O2&lt;90)' xpos='706' ypos='1109' xend='263' yend='1153' >
<annotation><![CDATA[Observationが正常登録できたが、飽和酸素度が90%を下回る場合に通知]]></annotation>
<true>
<call name='Line通知' target='TeamsFHIR.SendLineOperation' async='1' xpos='763' ypos='1240' >
<request type='TeamsFHIR.LineRequest' >
<assign property="callrequest.O2" value="request.O2" action="set" />
<assign property="callrequest.PatientName" value="context.PatientName" action="set" />
<assign property="callrequest.MRN" value="request.MRN" action="set" />
</request>
<response type='Ens.Response' />
</call>
</true>
</if>
</true>
</if>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
