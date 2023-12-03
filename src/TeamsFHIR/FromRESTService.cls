Class TeamsFHIR.FromRESTService Extends Ens.BusinessService
{

Method OnProcessInput(pInput As TeamsFHIR.Request, Output pOutput As TeamsFHIR.Response) As %Status
{
	#dim response As TeamsFHIR.Response
	set pOutput=##class(TeamsFHIR.Response).%New()
	if pInput.O2="" {
		set status=..SendRequestSync("TeamsFHIR.PatientSearchProcess",pInput,.pOutput)
	}
	else {
		set status=..SendRequestSync("TeamsFHIR.PostAndNotifyProcessBPL",pInput,.pOutput)
	}
	return status
}

}
