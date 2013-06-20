/**
 * A library of components.
 */

'use strict'

var ds = ds || {};

ds.ComponentTypeLib = function() {
	this.children = [];
}

ds.ComponentTypeLib.prototype.getInfo = function() {
	return 'ComponentTypeLib(' + this.children + ')';
};

ds.ComponentTypeLib.prototype.loadRegistry = function() {
	var component;

	// Headline
	component = new ds.ComponentType('headline', 'Headline', ds.ComponentTypeLib.createSimpleComponent);
	ds.ComponentTypeLib.addSimplePropertyDescriptors(component);
	this.add(component);

	// Standfirst
	component = new ds.ComponentType('standfirst', 'Standfirst', ds.ComponentTypeLib.createSimpleComponent);
	ds.ComponentTypeLib.addSimplePropertyDescriptors(component);
	this.add(component);

	// Image
	component = new ds.ComponentType('body', 'Body', ds.ComponentTypeLib.createSimpleComponent);
	ds.ComponentTypeLib.addSimplePropertyDescriptors(component);
	this.add(component);

	// Body
	component = new ds.ComponentType('image', 'Main image', ds.ComponentTypeLib.createSimpleComponent);
	ds.ComponentTypeLib.addSimplePropertyDescriptors(component);
	component.addPropertyDescriptor("crop", "Crop");
	this.add(component);

	// Flow
	component = new ds.ComponentType('flow', 'Flow', ds.ComponentTypeLib.createCompositeComponent);
	component.addPropertyDescriptor("scroll", "Scroll", ds.ComponentType.PROPERTY_BOOLEAN);
	this.add(component);

	// Grid
	component = new ds.ComponentType('grid', 'Grid', ds.ComponentTypeLib.createCompositeComponent);
	component.addPropertyDescriptor("rows", "Rows");
	component.addPropertyDescriptor("columns", "Columns");
	component.addPropertyDescriptor("rowGutter", "Row Gutter");
	component.addPropertyDescriptor("columnGutter", "Column Gutter");
	this.add(component);
};

ds.ComponentTypeLib.idCount = new Date().getTime();

ds.ComponentTypeLib.createSimpleComponent = function(type) {
	return {
		componentType: type,
		dataPath: "children",
		dataIndex: 0,
		uniqueID: "cmp" + (++ds.ComponentTypeLib.idCount)
	};
};

ds.ComponentTypeLib.createCompositeComponent = function(type) {
	var result = ds.ComponentTypeLib.createSimpleComponent(type);
	result.children = [];
	return result;
};

ds.ComponentTypeLib.addSimplePropertyDescriptors = function(type) {
	type.addPropertyDescriptor("dataPath", "Data path");
	type.addPropertyDescriptor("dataIndex", "Data index");
	type.addPropertyDescriptor("style", "Style (font-size:20px;)");
	type.addPropertyDescriptor("link", "Link", ds.ComponentType.PROPERTY_BOOLEAN);
};

ds.ComponentTypeLib.prototype.add = function(child) {
	if (!(child instanceof ds.ComponentType))
		throw 'Child must be instance of ds.ComponentType' + child;
	this.children.push(child); 
};

ds.ComponentTypeLib.prototype.length = function() {
	return this.children.length; 
};

ds.ComponentTypeLib.prototype.componentAt = function(index) {
	return this.children[index]; 
};

ds.ComponentTypeLib.prototype.componentNamed = function(name) {
	var length = this.children.length;
	for (var i = 0; i < length; i ++) {
		var child = this.children[i];
		if (name == child.getName())
			return child;
	}
	return null;
};

ds.ComponentTypeLib.prototype.getChildren = function() {
	return this.children;
};


