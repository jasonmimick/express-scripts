class exp.ClinicalAlerts.OmissionEmailOperation extends Ens.BusinessOperation 
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter as EnsLib.EMail.OutboundAdapter;


Method OnMessage(email as exp.ClinicalAlerts.OmissionEmail, 
	response as exp.ClinicalAlerts.OmissionEmailResponse) As %Status
{
	set response = ##class(exp.ClinicalAlerts.OmissionEmailResponse).%New()
	set response.Email = email
	set sc = ..Adapter.SendMail(email.Email,.failedRecipients)
	quit:$$$ISERR(sc) sc
	for i=1:1:failedRecipients.Count() {
		do response.FailedRecipients.Insert( failerRecipients.GetAt(i) )
	}
	quit $$$OK
}


}
