Include Ensemble

/// Convert HL7 into SDA
Class exp.ClinicalAlerts.HL7ToSDAProcess Extends Ens.BusinessProcess [ ClassType = persistent ]
{

/// The name of an operation to send the SDA to
Property TargetConfigName As Ens.DataType.ConfigName;

Parameter SETTINGS As %String = "TargetConfigName";

/// Will send an Ens.StreamContainer with the SDA from this HL7 to TargetConfigName
Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	set pResponse = ##class(Ens.StringContainer).%New()
	set sc=##class(HS.Gateway.HL7.HL7ToSDA3).GetSDA(pRequest,.sdaStream)
	set sdaMessage = ##class(Ens.StreamContainer).%New()
	set sdaMessage.Stream = sdaStream
	quit:$$$ISERR(sc) sc
	if ( ..TargetConfigName '= "" ) {
		quit ..SendRequestAsync(..TargetConfigName,sdaMessage,0)
	} else {
		// return response as XML Vdoc.
		set xdoc = ##class(EnsLib.EDI.XML.Document).ImportFromLibraryStream(sdaStream,.sc)
		set xdoc.DocType="HS.SDA3.Container:Container"
		if $$$ISERR(sc) return sc
		set pResponse = xdoc


	}
	quit $$$OK
}

<Storage name="Default">
<Data name="SDAGeneratorDefaultData">
<Subscript>"SDAGenerator"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
</Data>
<DefaultData>SDAGeneratorDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
</Storage>
}

