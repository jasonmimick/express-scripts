class exp.ClinicalAlerts.EmailOperation extends Ens.BusinessOperation 
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter as EnsLib.EMail.OutboundAdapter;


Method OnMessage(email as exp.ClinicalAlerts.EmailRequest, 
	response as exp.ClinicalAlerts.EmailResponse) As %Status
{
	set response = ##class(exp.ClinicalAlerts.EmailResponse).%New( )
	set response.Email = email.Email
	set sc = ..Adapter.SendMail(email.Email,.failedRecipients)
	//quit:$$$ISERR(sc) sc
	for i=1:1:failedRecipients.Count() {
		do response.FailedRecipients.Insert( failerRecipients.GetAt(i) )
	}
	quit $$$OK
}


}
