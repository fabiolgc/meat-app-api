Class Data.MenuItem Extends %Persistent
{

Property Id As %String(MAXLEN = "");

Property Name As %String(MAXLEN = "");

Property ImagePath As %String(MAXLEN = "");

Property Description As %String(MAXLEN = "");

Property Price As %String(MAXLEN = "");

Relationship Restaurant As Data.Restaurant [ Cardinality = one, Inverse = MenuItems ];

Index RestaurantIndex On (Restaurant);

Storage Default
{
<Data name="MenuItemDefaultData">
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
<Value>ImagePath</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>Price</Value>
</Value>
<Value name="7">
<Value>Restaurant</Value>
</Value>
</Data>
<DataLocation>^Data.MenuItemD</DataLocation>
<DefaultData>MenuItemDefaultData</DefaultData>
<IdLocation>^Data.MenuItemD</IdLocation>
<IndexLocation>^Data.MenuItemI</IndexLocation>
<StreamLocation>^Data.MenuItemS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

