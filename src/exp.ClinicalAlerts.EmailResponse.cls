class exp.ClinicalAlerts.EmailResponse extends Ens.Response
{
Property FailedRecipients as %ListOfDataTypes;
Property Email as %Net.MailMessage;

Method %OnNew() As %Status {
	set ..FailedRecipients = ##class(%ListOfDataTypes).%New()
	quit $$$OK
}

}
