/// 
Class TeamsFHIR.PostAndNotifyProcessBPL Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='TeamsFHIR.Request' response='TeamsFHIR.Response' height='2000' width='2000' >
<sequence xend='200' yend='700' >
<call name='ObservationPOST要求' target='TeamsFHIR.ObservationProcess' async='0' xpos='200' ypos='250' >
<request type='TeamsFHIR.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='TeamsFHIR.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<if name='Line通知対象？' condition='(request.O2&lt;90) &amp;&amp; (response.Status="OK")' xpos='200' ypos='350' xend='200' yend='600' disabled="true">
<true>
<call name='LINE通知（O2&lt;90）' target='TeamsFHIR.SendLineOperation' async='1' xpos='335' ypos='500' >
<request type='TeamsFHIR.LineRequest' >
<assign property="callrequest.PatientName" value="request.PatientName" action="set" />
<assign property="callrequest.O2" value="request.O2" action="set" />
<assign property="callrequest.MRN" value="request.MRN" action="set" />
</request>
<response type='Ens.Response' />
</call>
</true>
</if>
</sequence>
</process>
}

}
