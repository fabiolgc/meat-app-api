Class Data.Utils Extends %Persistent
{

ClassMethod Load(pKill = 0)
{
	Do:pKill=1 ..KillAll()
 	Do ..LoadRestaurants()
 	Do ..LoadMenuItem()
 	Do ..LoadReviews()
}

ClassMethod LoadRestaurants()
{
	
	Try {		
		Set tRequest = ##class(%Net.HttpRequest).%New()
		Set tRequest.Server = "localhost"
		Set tRequest.Port = 3000
		
		Set location = "/restaurants"
		
		Set tSC = tRequest.Get(location)
		
		If $$$ISOK(tSC) {			
			Set tResponse = tRequest.HttpResponse
			
			Do tResponse.Data.Rewind()
			Set tObj = ##class(%DynamicAbstractObject).%FromJSON(tResponse.Data)			
						
			Set tKey = ""
			Set tValue = ""
			
			Set tIterator = tObj.%GetIterator()
	   		while tIterator.%GetNext(.tKey , .tValue ) {
	      		Write "key = "_tKey_" , value = "_tValue,!
	      		Set tSC = ..InsertRestaurant(tValue)
	   		}
		}
	} Catch(ex) {
		Set tSC = ex.AsStatus()
		Do $System.Status.DisplayError(tSC)
	}
}

ClassMethod LoadMenuItem()
{
	
	Try {		
		
		Set tRequest = ##class(%Net.HttpRequest).%New()
		Set tRequest.Server = "localhost"
		Set tRequest.Port = 3000
		
		Set location = "/menu"
		
		Set tSC = tRequest.Get(location)
		
		If $$$ISOK(tSC) {			
			Set tResponse = tRequest.HttpResponse
			
			Do tResponse.Data.Rewind()
			Set tObj = ##class(%DynamicAbstractObject).%FromJSON(tResponse.Data)			
						
			Set tKey = ""
			Set tValue = ""
			
			Set tIterator = tObj.%GetIterator()
	   		while tIterator.%GetNext(.tKey , .tValue ) {
	      		Write "key = "_tKey_" , value = "_tValue,!
	      		Set tSC = ..InsertMenuItem(tValue)
	   		}
		}
	} Catch(ex) {
		Set tSC = ex.AsStatus()
		Do $System.Status.DisplayError(tSC)
	}
}

ClassMethod LoadReviews()
{
	
	Try {		
		
		Set tRequest = ##class(%Net.HttpRequest).%New()
		Set tRequest.Server = "localhost"
		Set tRequest.Port = 3000
		
		Set location = "/reviews"
		
		Set tSC = tRequest.Get(location)
		
		If $$$ISOK(tSC) {			
			Set tResponse = tRequest.HttpResponse
			
			Do tResponse.Data.Rewind()
			Set tObj = ##class(%DynamicAbstractObject).%FromJSON(tResponse.Data)			
						
			Set tKey = ""
			Set tValue = ""
			
			Set tIterator = tObj.%GetIterator()
	   		while tIterator.%GetNext(.tKey , .tValue ) {
	      		Write "key = "_tKey_" , value = "_tValue,!
	      		Set tSC = ..InsertReview(tValue)
	   		}
		}
	} Catch(ex) {
		Set tSC = ex.AsStatus()
		Do $System.Status.DisplayError(tSC)
	}
}

ClassMethod InsertRestaurant(pObj) As %Status
{
	Try {
		
		Set tObj = ##class(Data.Restaurant).%New()
		
		Set tObj.Id = pObj.id
		Set tObj.Name = pObj.name
		Set tObj.Category = pObj.category
		Set tObj.DeliveryEstimate = pObj.deliveryEstimate
		Set tObj.Rating = pObj.rating
		Set tObj.ImagePath = pObj.imagePath
		Set tObj.About = pObj.about 
		Set tObj.Hours = pObj.hour	
		Set tSC = tObj.%Save()
		
		If $$$ISERR(tSC) $$$ThrowStatus(tSC)
		
		Kill tObj
		
	} Catch (tEx) {
		Set tSC = tEx.AsStatus()	
	}
	Quit tSC
}

ClassMethod InsertMenuItem(pObj) As %Status
{
	Try {
		
		Set tSC = ##class(Data.Restaurant).IdIdxExists(pObj.restaurantId, .tId)	
		If $$$ISERR(tSC) $$$ThrowStatus(tSC)
		
		//Set tRestaurant = ##class(Data.Restaurant).%OpenId(tId)
		
		Set tObj = ##class(Data.MenuItem).%New()
		
		Set tObj.Id = pObj.id
		Set tObj.Name = pObj.name
		Set tObj.ImagePath = pObj.imagePath
		Set tObj.Description = pObj.description 
		Set tObj.Price = pObj.price	
		Do tObj.RestaurantSetObjectId(tId)
		Set tSC = tObj.%Save()
		
		If $$$ISERR(tSC) $$$ThrowStatus(tSC)
		
		Kill tObj
		
	} Catch (tEx) {
		Set tSC = tEx.AsStatus()	
	}
	Quit tSC
}

ClassMethod InsertReview(pObj) As %Status
{
	Try {
		
		Set tSC = ##class(Data.Restaurant).IdIdxExists(pObj.restaurantId, .tId)	
		If $$$ISERR(tSC) $$$ThrowStatus(tSC)
		
		//Set tRestaurant = ##class(Data.Restaurant).%OpenId(tId)
		
		Set tObj = ##class(Data.Review).%New()
				
		Set tObj.Name = pObj.name
		Set tObj.Date = pObj.date
		Set tObj.Rating = pObj.rating 
		Set tObj.Comments = pObj.comments	
		Do tObj.RestaurantSetObjectId(tId)
		Set tSC = tObj.%Save()
		
		If $$$ISERR(tSC) $$$ThrowStatus(tSC)
		
		Kill tObj
		
	} Catch (tEx) {
		Set tSC = tEx.AsStatus()	
	}
	Quit tSC
}

ClassMethod KillAll()
{
	Do ##class(Data.Restaurant).%KillExtent()
	Do ##class(Data.MenuItem).%KillExtent()
	Do ##class(Data.Review).%KillExtent()
}

Storage Default
{
<Data name="UtilsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Data.UtilsD</DataLocation>
<DefaultData>UtilsDefaultData</DefaultData>
<IdLocation>^Data.UtilsD</IdLocation>
<IndexLocation>^Data.UtilsI</IndexLocation>
<StreamLocation>^Data.UtilsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

