class exp.ClinicalAlerts.DiabetesAlertRuleRequest extends Ens.Request
{
/// Pointer to exp.ClinicalAlerts.Patient primary key
Property PatientID as %String;
///
Property LDL as %String;

Property IsOnStatin as %Boolean;
Property IsDiabetic as %Boolean;

ClassMethod CreateFromPatient(patient as exp.ClinicalAlerts.Patient)
{
	set req=..%New()
	set req.PatientID = patient.%Id()
	for i=1:1:patient.Medications.Count() {
		if ( patient.Medications.GetAt(i) = "STATIN" ) {
			set req.IsOnStatin = 1
		}
	}
	for i=1:1:patient.Conditions.Count() {
		if ( patient.Conditions.GetAt(i) = "DIABETES" ) {
			set req.IsDiabetic = 1
		}
	}
	set req.LDL="X"
	for i=1:1:patient.Results.Count() {
		set result = patient.Results.GetAt(i)
		if ( result.Type = "LDL" ) {
			set req.LDL = result.Value
		}
	}
	return req
}
}
