class exp.ClinicalAlerts.EmailRequest extends Ens.Request
{
Property Email as %Net.MailMessage;

ClassMethod DrugDiseaseEmail(sda as HS.SDA3.Container) as exp.ClinicalAlerts.EmailRequest
{
	return ..CreateFromSDA(sda,"DrugDiseaseFax")
}
ClassMethod OmissionEmail(sda as HS.SDA3.Container) as exp.ClinicalAlerts.EmailRequest
{

	return ..CreateFromSDA(sda,"OmissionOfTherapy")
}


ClassMethod CreateFromSDA(sda as HS.SDA3.Container,type As %String) as exp.ClinicalAlerts.EmailRequest
{
	set email = ##class(%Net.MailMessage).%New()
	do email.To.Insert("jmimick@intersystems.com")	
	//do email.To.Insert("jmimick@gmail.com")	
	set email.Subject =type_ " Alert!"
	set email.From = "ESIClinicialAlerts@esi.com"
	set email.ContentType = "text/html"

	if ( sda.%Extends("HS.SDA3.Container") ) {

		set pt = sda.Patient.Name.GivenName_"."_sda.Patient.Name.FamilyName_"."_sda.Patient.MPIID
		if ( sda.Documents.Count() >= 1 ) {
			set document = sda.Documents.GetAt(1).Stream
			$$$TRACE(document)
			if ( $isobject(document) ) {
			set sc=email.AttachStream( document ,type_"Alert."_pt_".pdf")
			}
		}	
	} elseif ( sda.%Extends("EnsLib.EDI.XML.Document") ) {
		set pt = sda.GetValueAt("Patient.Name.GivenName")
		set pt = pt _ "." _ sda.GetValueAt("Patient.Name.FamilyName")
		set pt = pt _ "." _ sda.GetValueAt("Patient.MPIID")

	}

	// todo - load document for DrugDisease into email
	
	if ( type = "DrugDiseaseFax" ) {
		set stream=##class(%Stream.FileBinary).%New()
		set stream.Filename="/Users/jmimick/caches/pluto/Data/DrugDiseaseFax.pdf"
		set sc=email.AttachStream(stream,"Drug Disease Alert."_pt_".pdf")
	}
	
	set req=..%New()
	set sc=req.%Save()

	set body = ..BuildEmailBody(type,req.%Id())
	do email.TextData.WriteLine(body)
	
	set req.Email = email
	$$$TRACE(req)
	return req

}

ClassMethod BuildEmailBody(type As %String,id) as %String
{
	set me=##class(%Dictionary.ClassDefinition).%OpenId(..%ClassName(1))
	for i=1:1:me.XDatas.Count() {
		set xdata = me.XDatas.GetAt(i)
		set xdataCache(xdata.Name)=xdata
	}
	set htmlParts=..parseXData(xdataCache("EmailAlertHtml"),"___BODY___")
	set bodyParts = ..parseXData(xdataCache(type_"EmailHtmlBody"),"___RESPONSE_FORM___")
	set formParts = ..parseXData(xdataCache("AlertEmailResponseForm"),"___EMAIL_ID___")
	set form = $list(formParts,1)
	for i=2:1:$listlength(formParts) {
		set form = form _ id _ $list(formParts,i)
	}
	set body = $list(bodyParts,1)_form_$list(bodyParts,2)
	set html = $list(htmlParts,1)_body_$list(htmlParts,2)
	return html
}

ClassMethod parseXData(xdata as %Dictionary.XDataDefinition,token as %String = "") as %String
{
	set data = ""
	do xdata.Data.Rewind()
	while ( 'xdata.Data.AtEnd ) {
		set data = data _ xdata.Data.Read()
	}
	if ( token = "" ) { return data }
	return $listfromstring(data,token)
}

XData EmailAlertHtml
{
	<html>
	<head>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
		<style>
		table.responseForm {
			border: 1px, solid, black;
			margin: 5px;
			padding: 8px;
		}
	    span.bold {
            font-weight : bold;
        }
		.footer {
			font-style : italic;
			font-size: 75%;
		}
		</style>
	</head>

	<body>

		___BODY___

	</body>
	</html>
}

XData AlertEmailResponseForm
{
	<h3>Plan: (Please click one.)</h3>
		<table class="responseForm">
		<tr><td>
		<a href="http://localhost:9989/alertResponse?originalAlertID=___EMAIL_ID___&value=I will change the therapy">
			I will change the therapy
		</a>
		</td></tr>
		<tr><td>
		<a href="http://localhost:9989/alertResponse?originalAlertID=___EMAIL_ID___&value=I will discuss with the patient and make my recommendation at a later time.">
		I will discuss with the patient and make my recommendation at a later time.
		</a>
		</td></tr>
		<tr><td>
		<a href="http://localhost:9989/alertResponse?originalAlertID=___EMAIL_ID___&value=I will not change the patient's therapy">
			I will not change the patient's therapy
		</a>
		</td></tr>
		</table>
}

XData DrugDiseaseFaxEmailHtmlBody
{
	<div id='drugDiseaseFaxEmailHtmlBody'>
	<p>Dear Dr. PHYSICIAN:

	<p>Express Scripts works with Company ABC to provide you with the 
	<span class="bold">enclosed RationalMed&reg safety consideration(s) for the patient(s) in your practice.</p>

	<p>These records:
	<ul>
		<li>Highlight <bold>highly significant safety considerations</bold></li>
		<li>Assemble the <bold>prescription claim information related to the patient’s
			safety consideration</bold>
			<span class='italics'>
			(claims information may include treatment provided by other healthcare providers)
			</span>
		</li>
		<li>Cite relevant clinical references</li>
	</ul>

	<p>Please review the information attached, which you may have previously reviewed with an Express Scripts representative, and make any changes in therapy that you believe are appropriate. Please note that there could be multiple patients included in this package. These records include available claims information related to the safety considerations above and may not represent your patient's complete history. You were identified by a dispensing pharmacy as a "prescriber of record" for prescriptions filled under this patient’s prescription drug benefit. If you were incorrectly identified as a "prescriber of record", please contact the dispensing pharmacy at the phone number provided.
	<p>We understand that these considerations may not be applicable to every patient's therapy. We welcome your comments on how we may provide better support in your care of these patients. If you have any questions or comments, please contact us at 1 800 xxx-xxxx and reference the patient-specific Control Number(s). Your feedback is kept confidential.

	___RESPONSE_FORM___
	
	<p>Thank you for your time and consideration.



	Peter F. Hoffman, M.D., PhD Medical Director<br/>
	Personal Health Solutions
	</div>

}

XData OmissionOfTherapyEmailHtmlBody
{
	<div id='omissionOfTherabyBody'>
	Dear Dr. PHYSICIAN:<br/>
	<p>Express Scripts works with Company ABC to provide you with the
		<span class='bold'>enclosed RationalMed&reg; safety and health considerations 
		for patients in your practice.*
		</span>
	</p>

	<p>Please review the health information attached and
	   <span class='bold'>
	   make any changes in therapy that you believe are appropriate. 
	   </span>
	   These records include available information related to the safety
	   and health considerations, and may not represent your patient's
		complete medical or pharmacy history.

	___RESPONSE_FORM___

	<p>Thank you for your time and attention.</p>

	Peter F. Hoffman, M.D., PhD<br/>
	Medical Directory, Personal Health Solutions<br/>

	<div class="footer">
*You were identified as a prescriber of record by a pharmacy dispensing medication for the patient listed.
	</div>
	</div>

}
}
