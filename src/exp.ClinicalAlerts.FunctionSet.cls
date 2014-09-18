class exp.ClinicalAlerts.FunctionSet extends Ens.Rule.FunctionSet
{

ClassMethod CollectionHasValue(vdoc as EnsLib.EDI.XML.Document,
			collectionProperty as %String, property as %String, targetValue as %String)
	As %Boolean
{
	$$$TRACE("collectionProperty="_collectionProperty_" targetValue="_targetValue)
	
	set numberOfItems = vdoc.GetValueAt(collectionProperty_"(*)")
	for i=1:1:numberOfItems {
		set value = vdoc.GetValueAt(collectionProperty_"("_i_")."_property)
		$$$TRACE("value="_value)
		if ( value = targetValue ) {
			return 1
		}
	} 
	return 0
}
ClassMethod CollectionContainsByPropertyValue(collection as %ListOfObjects, property as %String, value as %String)
	As %Boolean
{
	$$$TRACE(collection)
	for i=1:1:collection.Count() {
		set item = collection.GetAt(i)
		if ($property(item,propery)=value) {
			return 1
		}
	}
	return 0
}
}
