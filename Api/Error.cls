Class Api.Error Extends %Library.RegisteredObject
{

ClassMethod ErrorToJSON(pStatus As %Status) As %Status
{
	#dim tProvider As %ZEN.Auxiliary.jsonProvider
	Set tSC = $$$OK
	Try {
		Set tProvider = ##class(%ZEN.Auxiliary.jsonProvider).%New()
		
		Set tInfoBranch = tProvider.%ConstructNewDynamicObject()
		Set tInfoBranch.Error = tProvider.%StatusToDynamicObject(pStatus)
		
		Set tResultOBJ = tProvider.%ConstructNewDynamicObject()
		Set tResultOBJ.Info = tInfoBranch
	
		Set tSC = tProvider.%ObjectToJSON(tResultOBJ)
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}

