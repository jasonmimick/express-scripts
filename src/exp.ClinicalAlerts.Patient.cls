class exp.ClinicalAlerts.Patient extends (Ens.Request)
{

Property PatientFirstName as %String;
Property PatientLastName As %String;
Property DateOfBirth as %String;
Property Clinician as %String;
Property Gender as %String;
Property Conditions as list of %String;
Property Medications as list of %String;
Property Results as list of exp.ClinicalAlerts.Result;

}
