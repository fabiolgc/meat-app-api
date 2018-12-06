Class Api.Base Extends (%CSP.REST, Ens.BusinessService, %iKnow.REST.Utils)
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest As %Integer = 1;

ClassMethod CreateBusinessService() As %Status
{
	set tSC = $$$OK
	
	Try {
		Set tOutputStream = ""
		Set %response.Status = ..#HTTP200OK
		
		Set tSC = ##class(Ens.Director).CreateBusinessService("PMML REST Service",.tService) 
		
		If ($IsObject(tService)) {
			Set tSC = tService.ProcessInput(%request.Content,.tOutputStream)
		}	
		
		If $IsObject(tOutputStream) {
			Write tOutputStream.Read()
		}
		
	} Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

}

