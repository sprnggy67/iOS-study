/**
 A publication.
 */

'use strict';

var ds = ds || {};

ds.Publication = function() {
}

/**
 Loads the default publication data from a server.
 In the initial implementation the publication data is hardcoded in this instance.  
 */
ds.Publication.prototype.loadFromServer = function(callback) {
	// Load the data.
	this.name = "The National";
	this.defaultTemplate = defaultTemplates.empty; // Use empty, emptyResponsive or front3

	// Invoke the callback.
	callback();
};

/**
 Returns the publication name.
 */
ds.Publication.prototype.getName = function() {
	return this.name;
};

/**
 Returns the default template.
 */
ds.Publication.prototype.getDefaultTemplate = function() {
	return this.defaultTemplate;
};
