Class Api.Service Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

XData UrlMap
{
<Routes>
 <Map Prefix="/v1" Forward="Api.v1"/>
 <Map Prefix="/v2" Forward="Api.v2"/>
 <Map Prefix="/v3" Forward="Api.v3"/>
</Routes>
}

/// This method Gets called prior to dispatch of the request. Put any common code here
/// that you want to be executed for EVERY request. If pContinue is set to 0, the
/// request will NOT be dispatched according to the UrlMap. If this case it's the
/// responsibility of the user to return a response.
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tOrigin = $Get(%request.CgiEnvs("HTTP_ORIGIN"))
    	Do ..HandleDefaultCorsRequest(tOrigin)
    
		#; metadata and OPTIONS are two ways of requesting the Conformance statement.
		#; Conformance holds the authorization end point and token end point.
		If (%request.PageName="metadata")&&(%request.CgiEnvs("REQUEST_METHOD")="GET") Quit
		If %request.CgiEnvs("REQUEST_METHOD")="OPTIONS" Quit
				
		Set tAccessToken = ##class(%SYS.OAuth2.AccessToken).GetAccessTokenFromRequest(.tStatus)
		If $$$ISERR(tStatus) {		
			Set pContinue = 0	
			If ..ReportHttpStatusCode(..#HTTP401UNAUTHORIZED, tStatus)
			Quit
		}
	    //h 11
		Set tSC = $$$OK
		Set tStatus = $$$OK
		Set tReturn = ##class(%SYS.OAuth2.Validation).ValidateJWT("meatapp", tAccessToken, "", "", .tJWTObj, .tSecurityParams, .tSC)
		If tReturn=0 {
			If ($$$ISERR(tSC))&&((","_$system.Status.GetErrorCodes(tSC)_",")'[",8873,") {
				#; Is not a JWT, try GetIntrospection.
				Set tStatus = ##class(%SYS.OAuth2.AccessToken).GetIntrospection("meatapp", tAccessToken, .tJWTObj)
			} Else {								
				#; Is a JWT, but not valid.				
				Set tErrorCode = $system.Status.GetErrorCodes(tSC)
				Set tErrorMessage = $system.Status.GetErrorText(tSC)
				Set tSC = $$$ERROR($$$OAuth2JWTNotValid, tErrorMessage)				
				Set tStatus = tSC				
			}
		}		
		
		If $$$ISERR(tStatus) {
			Set pContinue = 0												
			If ..ReportHttpStatusCode(..#HTTP401UNAUTHORIZED, tStatus)
			Quit
		}		

		// Insist that the first piece of the url is a version
		Set tVersion = $Piece(pUrl,"/",2)
		If ("v1"'[tVersion) && ("v2"'[tVersion) {
			Set pContinue = 0
			Set tSC = $$$ERROR($$$GeneralError,"Version is not supported by the /api/deepsee/ REST application:" _ tVersion)
			$$$ThrowStatus(tSC)
		}
				
		If ('..AcceptsContentType(..#CONTENTTYPEJSON)) {
			Set tSC=..ReportHttpStatusCode(..#HTTP406NOTACCEPTABLE),pContinue=0
			$$$ThrowStatus(tSC) 
        } 
        Else {   
			// This always returns json
			Set %response.ContentType=..#CONTENTTYPEJSON
        }
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	If $$$ISERR(tSC) {
		Set pContinue = 0		    	
		Do ##class(Api.Error).ErrorToJSON(tSC)
	}

	Quit $$$OK
}

}

