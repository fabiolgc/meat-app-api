Class Api.v2 Extends (%CSP.REST, Api.Base)
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

/// Configuration item(s) to which to send file stream messages
Property TargetConfigName As Ens.DataType.ConfigName;

Parameter SETTINGS = "TargetConfigName:Basic:selector?multiSelect=0&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Entities -->
<Route Url="/validate" Method="GET" Call="IsValidUser"/>
<Route Url="/doc" Method="GET" Call="GetSwagger" />

</Routes>
}

ClassMethod IsValidUser() As %Status
{
	#Dim tSC As %Status = $$$OK
    #Dim tEx As %Exception.AbstractException    
    //h 10
    Try {    	
    	Set tBusinessService = ""
    	Set tBusinessServiceName = ..%ConfigName
    	Set tSC = ..CreateBusinessService(tBusinessServiceName, .tBusinessService)
    	If $$$ISERR(sc) {
			$$$ThrowStatus(sc)			
		}
		
		Set tSC = tBusinessService.ProcessInput()
		If $$$ISERR(sc) {
			$$$ThrowStatus(sc)			
		}
			
    } Catch (tEx) {
    	Set tSC = tEx.AsStatus()
    	
    }	
	
	QUIT $$$OK
}

Method OnProcessInput(pInput As %Stream.GlobalCharacter, pOutput As %Stream.GlobalCharacter) As %Status
{
	
	Set tSC = $$$OK
	
	Try {	
		Set tRequest = ""		
		Set tSC = ..SendRequestSync(..TargetConfigName,tRequest,.tResponse) 
		If $$$ISERR(tSC) $$$ThrowStatus(tSC)
		
		
	} catch (tException) {
		Set tSC = tException.AsStatus() 
	}	
	
	Quit tSC
}

}

