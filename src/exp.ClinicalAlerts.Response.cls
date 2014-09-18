class exp.ClinicalAlerts.Response extends %Persistent
{

Property TimeStamp as %TimeStamp;

/// Pointer to original message id exp.ClinicalAlerts.OmissionEmailRequest
Property OriginalEmailRequestID As %String;

Property Response as %String(MAXLEN = 10000);

Property SentTo As %String(MAXLEN = 1000);

}
