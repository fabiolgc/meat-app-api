Class Data.Restaurant Extends %Persistent
{

Property Id As %String(MAXLEN = "");

Property Name As %String(MAXLEN = "");

Property Category As %String(MAXLEN = "");

Property DeliveryEstimate As %String(MAXLEN = "");

Property Rating As %String(MAXLEN = "");

Property ImagePath As %String(MAXLEN = "");

Property About As %String(MAXLEN = "");

Property Hours As %String(MAXLEN = "");

Property Status As %String(MAXLEN = "");

Relationship MenuItems As Data.MenuItem [ Cardinality = many, Inverse = Restaurant ];

Relationship Reviews As Data.Review [ Cardinality = many, Inverse = Restaurant ];

Index IdIdx On (Id);

Index NameIdx On (Name);

Index CategoryIdx On (Category);

Storage Default
{
<Data name="RestaurantDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Id</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Category</Value>
</Value>
<Value name="5">
<Value>DeliveryEstimate</Value>
</Value>
<Value name="6">
<Value>Rating</Value>
</Value>
<Value name="7">
<Value>ImagePath</Value>
</Value>
<Value name="8">
<Value>About</Value>
</Value>
<Value name="9">
<Value>Hours</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^Data.RestaurantD</DataLocation>
<DefaultData>RestaurantDefaultData</DefaultData>
<IdLocation>^Data.RestaurantD</IdLocation>
<IndexLocation>^Data.RestaurantI</IndexLocation>
<StreamLocation>^Data.RestaurantS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

