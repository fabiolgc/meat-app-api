Class Controller.Restaurant Extends %RegisteredObject
{

ClassMethod GetRestaurants(pQueryParam As %String, Output pList As %ListOfObjects) As %Status
{
	
	Set pList = ##class(%ListOfObjects).%New()
	
	&sql(DECLARE REST CURSOR FOR 
       		SELECT ID1, About, Category, DeliveryEstimate, Hours, Id, ImagePath, Name, Rating
       		INTO :tID1, :tAbout, :tCategory, :tDeliveryEstimate, :tHours, :tId, :tImagePath, :tName, :tRating
       		FROM Data.Restaurant
       		WHERE (:pQueryParam <> 'NULL' AND (Name %STARTSWITH :pQueryParam OR Category %STARTSWITH :pQueryParam)) OR (:tQueryParam = 'NULL')
       		ORDER BY Name)
  	&sql(OPEN REST)
  	
  	&sql(FETCH REST)  	
  	
  	WHILE (SQLCODE = 0) 
  	{	  	
	 	Set tOBJ = ##class(Data.Restaurant).%OpenId(tID1)
	 	Do pList.Insert(tOBJ)
    }   
    
  	&sql(CLOSE REST)
	
	QUIT $$$OK
}

/// <example language="swagger">
///       summary: |
///         Retorna o restaurantes de acordo com o ID que deve ser passado como parâmetro 
///       tags: ["restaurant"]
///       parameters:
///         - $ref: ''#/parameters/id''
///       responses:
///         200:
///           description: Successful response
///           schema:
///             $ref: '#/restaurants'
/// </example>
ClassMethod GetRestaurant(pId As %Integer) As %Status
{
	Set tRestaurantId = ""
	Set tSC = ##class(Data.Restaurant).IdIdxExists(pId, .tRestaurantId)
	
	If tRestaurantId {
		
		Set tRestaurant = ##class(Data.Restaurant).%OpenId(tRestaurantId)
      		
  	  	Set tObj = ##class(%DynamicObject).%New()
	  	Set tObj.id = tRestaurant.Id 
	  	Set tObj.name = tRestaurant.Name 
	  	Set tObj.category = tRestaurant.Category
	  	Set tObj.deliveryEstimate = tRestaurant.DeliveryEstimate 
	  	Set tObj.rating = tRestaurant.Rating 
	  	Set tObj.imagePath = tRestaurant.ImagePath 
	  	Set tObj.about = tRestaurant.About
	  	Set tObj.hours = tRestaurant.Hours		
	  	Write tObj.%ToJSON()
    }    
    
	QUIT $$$OK
}

ClassMethod GetRestaurantMenu(pId As %Integer) As %Status
{
	Set tRestaurantId = ""
	Set tSC = ##class(Data.Restaurant).IdIdxExists(pId, .tRestaurantId)
	
	If tRestaurantId {
		
		Set tRestaurant = ##class(Data.Restaurant).%OpenId(tRestaurantId)
      	
      	Set tArr = ##class(%DynamicArray).%New()
      	
      	For i=1:1:tRestaurant.MenuItems.Count()
      	{      		
      		#Dim tMenuItem As Data.MenuItem
      		Set tMenuItem = tRestaurant.MenuItems.GetAt(i)
      	
	  	  	Set tObj = ##class(%DynamicObject).%New()
		  	Set tObj.id = tMenuItem.Id 
		  	Set tObj.imagePath = tMenuItem.ImagePath 
		  	Set tObj.name = tMenuItem.Name
		  	Set tObj.description = tMenuItem.Description 
		  	Set tObj.price = tMenuItem.Price 
		  	Set tObj.restaurantId = pId
		  	
		  	Do tArr.%Push(tObj)
      	}
      	
      	Write tArr.%ToJSON()
    }    
    
	QUIT $$$OK
}

ClassMethod GetRestaurantReviews(pId As %Integer) As %Status
{
	Set tRestaurantId = ""
	Set tSC = ##class(Data.Restaurant).IdIdxExists(pId, .tRestaurantId)
	
	If tRestaurantId {
		
		Set tRestaurant = ##class(Data.Restaurant).%OpenId(tRestaurantId)
      	
      	Set tArr = ##class(%DynamicArray).%New()
      	
      	For i=1:1:tRestaurant.Reviews.Count()
      	{      		
      		#Dim tReview As Data.Review
      		Set tReview = tRestaurant.Reviews.GetAt(i)
      	
	  	  	Set tObj = ##class(%DynamicObject).%New()
		  	Set tObj.name = tReview.Name
		  	Set tObj.date = tReview.Date 
		  	Set tObj.rating = tReview.Rating
		  	Set tObj.comments = tReview.Comments		  	 
		  	Set tObj.restaurantId = pId
		  	
		  	Do tArr.%Push(tObj)
      	}
      	
      	Write tArr.%ToJSON()
    }    
    
	QUIT $$$OK
}

ClassMethod CheckOrder() As %Status
{
    #Dim tSC As %Status = $$$OK
    #Dim tEx As %Exception.AbstractException
    
    Try {
    	
    	If $IsObject(%request.Content) {
			Set tContent = %request.Content.Read($$$MaxStringLength)
			Set ^zfabio(0)=tContent
		}
    
      	Set tProxy = ##class(%ZEN.proxyObject).%New()        
      	Set tProxy.orderId = 1
      	
      	//Write tProxy.%ToJSON()        
      	Write tContent
        	
    } Catch (tEx) {
    	Set tSC = tEx.AsStatus()
    }
    
    Quit tSC
}

}

