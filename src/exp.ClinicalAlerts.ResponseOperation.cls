class exp.ClinicalAlerts.ResponseOperation extends Ens.BusinessOperation
{

XData MessageMap
{
<MapItems>
	<MapItem MessageType="EnsLib.HTTP.GenericMessage"> 
		<Method>ProcessResponse</Method>
	</MapItem>
</MapItems>
}

/// Read json from request stream
/// persist the response, catch any errors and write
/// back on the HTTP response
ClassMethod ProcessResponse(request as EnsLib.HTTP.GenericMessage, 
							response as EnsLib.HTTP.GenericMessage) As %Status
{
	set sc=$$$OK
	set responseBody = ##class(%ZEN.proxyObject).%New()
	try {
		set url = request.HTTPHeaders.GetAt("URL")
		$$$TRACE("url="_url)
		if ( url'="/alertResponse" ) {
			set stream = ##class(%GlobalCharacterStream).%New()
			do stream.WriteLine("Unknown Request")
			set stream.Attributes("statusline")="404 Not Found"
			set response = ##class(EnsLib.HTTP.GenericMessage).%New(stream,,stream)
			return $$$OK
		}
		set method = request.HTTPHeaders.GetAt("HttpRequest")
		if ( method = "GET" ) {
			set object = ##class(%ZEN.proxyObject).%New()
			for i=1:1:request.HTTPHeaders.GetAt("IParams") {
				set p=$listfromstring(request.HTTPHeaders.GetAt("IParams_"_i),"=")
				set name=$list(p,1),value=$list(p,2)
				set $property(object,name)=value
			}
		} elseif ( method = "POST" ) {			
			do request.Stream.Rewind()
			set json=""
			while ( 'request.Stream.AtEnd ) { set json = json _ request.Stream.Read() }	
			$$$THROWONERROR(sc, ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(json,, .object))
		}
		set alertResponse = ##class(exp.ClinicalAlerts.Response).%New()
		do object.%CopyToArray(.array)
		set alertResponse.TimeStamp = $ZDT($system.Util.LocalWithZTIMEZONEtoUTC($H),3) //$znow	//$ZTS
		set alertResponse.Response = array("value")
		set emailId = array("originalAlertID")
		set email = ##class(exp.ClinicalAlerts.OmissionEmailRequest).%OpenId(emailId)
		if ( '$isobject(email) ) {
			throw ##class(%Exception.GeneralException).%New("Unable to find alert email with id = " _ emailId)
		} 
		set alertResponse.OriginalEmailRequestID = email.%Id()
		set sentTo = $listbuild()
		for i=1:1:email.Email.To.Count() { set $list(sentTo,i) = email.Email.To.GetAt(i) }
		set alertResponse.SentTo = $listToString(sentTo)
		$$$THROWONERROR(sc,alertResponse.%Save())
		set responseBody.Status = "OK"
		set responseBody.ResponseID = alertResponse.%Id()
	} catch (error) {
		set responseBody.Status = "ERROR"
		set responseBody.Description = error.DisplayString()
		set response = ##class(EnsUtils.HTTP.Utils).CreateHTTPRequestWithJSONBody(responseBody)
		set sc=error.AsStatus()
		return sc
	}
	//set response = ##class(EnsUtils.HTTP.Utils).CreateHTTPRequestWithJSONBody(responseBody)
	set stream=##class(%GlobalCharacterStream).%New()
	set cdef=##class(%Dictionary.ClassDefinition).%OpenId(..%ClassName(1))
	for i=1:1:cdef.XDatas.Count() {
		if ( cdef.XDatas.GetAt(i).Name = "SuccessResponse" ) {
			set xdata = cdef.XDatas.GetAt(i)
		}
	}
	set sc=stream.CopyFrom(xdata.Data)
	set response=##class(EnsLib.HTTP.GenericMessage).%New(stream,,stream)	
	return sc
}

XData SuccessResponse 
{
<html>
	<head>
		<title>ESI Alert Response Capture</title>
	</head>
	<body>
		<h2>Thank you for your response. It was successfully processed.</h2>
		<h4>Have a wonderful day!</h4>
	</body>
</html>
}

XData ErrorResponse
{
}
}
