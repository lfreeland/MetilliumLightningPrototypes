({
	init : function(component, event, helper) {
		helper.retrievePageLayout(component, helper);
	},

	onsuccess : function(component, event, helper) {
		helper.onsuccess(component, event, helper);
	}
})