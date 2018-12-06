Class Api.v1 Extends (%CSP.REST, %iKnow.REST.Utils)
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Entities -->
<Route Url="/validate" Method="GET" Call="IsValidUser"/>
<Route Url="/restaurants" Method="GET" Call="GetRestaurants"/>
<Route Url="/restaurants/:id" Method="GET" Call="GetRestaurant"/>
<Route Url="/restaurants/:id" Method="DELETE" Call="DeleteRestaurant"/>
<Route Url="/restaurants/:id/menu" Method="GET" Call="GetRestaurantMenu"/>
<Route Url="/restaurants/:id/reviews" Method="GET" Call="GetRestaurantReviews"/>
<Route Url="/restaurants/:id/status/:code" Method="PUT" Call="UpdateStatusRestaurant"/>
<Route Url="/orders" Method="POST" Call="CheckOrder"/>
<Route Url="/doc" Method="GET" Call="GetSwagger" />

</Routes>
}

ClassMethod IsValidUser() As %Status
{
	#Dim tSC As %Status = $$$OK
    #Dim tEx As %Exception.AbstractException    
    //h 10
    Try {    	
    	Set t =##class(%SYS.OAuth2.AccessToken).GetAccessTokenFromRequest(.sc) //%request.Data("token",1)
    	If $$$ISERR(sc) {
			$$$ThrowStatus(sc)			
		}
		
		Set $namespace = "%SYS" 
		Set token = ##class(OAuth2.Server.AccessToken).OpenByToken(t,.sc)
		Set $namespace = "API"
			
		Set r = {}
			
    } Catch (tEx) {
    	Set tSC = tEx.AsStatus()
    	
    }	
	
	QUIT $$$OK
}

/// <example language="swagger">
///       summary: |
///         Retorna os restaurantes. É possível passar o parâmetro "q" na URL que pesquisa por nome ou categoria 
///       tags: ["restaurant"]
///       parameters:
///         - $ref: '?q=doces'
///       responses:
///         200:
///           description: Successful response
///           schema:
///             $ref: '#/restaurants'
/// </example>
ClassMethod GetRestaurants() As %Status
{
	
	Set tQueryParam = $Get(%request.Data("q", 1))
	Set:$Length(tQueryParam)=0 tQueryParam = "NULL"
	
	
	&sql(DECLARE REST CURSOR FOR 
       		SELECT ID1, About, Category, DeliveryEstimate, Hours, Id, ImagePath, Name, Rating
       		INTO :tID1, :tAbout, :tCategory, :tDeliveryEstimate, :tHours, :tId, :tImagePath, :tName, :tRating
       		FROM Data.Restaurant
       		WHERE (:tQueryParam <> 'NULL' AND (Name %STARTSWITH :tQueryParam OR Category %STARTSWITH :tQueryParam)) OR (:tQueryParam = 'NULL')
       		ORDER BY Name)
  	&sql(OPEN REST)
  	
  	&sql(FETCH REST)
  	
  	Set tArr = ##class(%DynamicArray).%New()

  	
  	WHILE (SQLCODE = 0) 
  	{	  	
	  	Set tObj = ##class(%DynamicObject).%New()
	  	Set tObj.id = tId 
	  	Set tObj.name = tName
	  	Set tObj.category = tCategory
	  	Set tObj.deliveryEstimate = tDeliveryEstimate 
	  	Set tObj.rating = tRating 
	  	Set tObj.imagePath = tImagePath 
	  	Set tObj.about = tAbout
	  	Set tObj.hours = tHours
	  	
		Do tArr.%Push(tObj)
		
    	&sql(FETCH REST) 
    }
    
    Set %response.ContentType = ..#CONTENTTYPE
    Write tArr.%ToJSON()
    
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
    	//h 12
    	If $IsObject(%request.Content) {
			//Set tContent = %request.Content.Read($$$MaxStringLength)
			set tObj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content)
			Set ^CacheTemp("CheckOrder","Name")=tObj.name
			Set ^CacheTemp("CheckOrder","E-Mail")=tObj.name
			Set ^CacheTemp("CheckOrder","emailConfirmation")=tObj.emailConfirmation
		}
		//set obj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content)
    
      	//Set tProxy = ##class(%ZEN.proxyObject).%New()        
      	Set tObj.id = 1
      	Set tObj.orderId = 1
      	
      	Write tObj.%ToJSON()        
      	//Write tContent
        	
    } Catch (tEx) {
    	Set tSC = tEx.AsStatus()
    }
    
    Quit tSC
}

ClassMethod UpdateStatusRestaurant(pRestaurant As %String, pStatusCode As %String) As %Status
{

	Set ^CacheTemp("UpdateStatusRestaurant") = pRestaurant_"^"_pStatusCode
	Quit $$$OK
}

}

