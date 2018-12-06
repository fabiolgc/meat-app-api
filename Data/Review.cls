Class Data.Review Extends %Persistent
{

Property Name As %String(MAXLEN = "");

Property Date As %String(MAXLEN = "");

Property Rating As %String(MAXLEN = "");

Property Comments As %String(MAXLEN = "");

Relationship Restaurant As Data.Restaurant [ Cardinality = one, Inverse = Reviews ];

Index RestaurantIndex On (Restaurant);

Storage Default
{
<Data name="ReviewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Date</Value>
</Value>
<Value name="4">
<Value>Rating</Value>
</Value>
<Value name="5">
<Value>Comments</Value>
</Value>
<Value name="6">
<Value>Restaurant</Value>
</Value>
</Data>
<DataLocation>^Data.ReviewD</DataLocation>
<DefaultData>ReviewDefaultData</DefaultData>
<IdLocation>^Data.ReviewD</IdLocation>
<IndexLocation>^Data.ReviewI</IndexLocation>
<StreamLocation>^Data.ReviewS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

