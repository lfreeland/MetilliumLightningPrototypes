({
    init: function(cmp, event, helper) {
        var recordId = cmp.get('v.recordId');
        var videoField = cmp.get('v.videoField');

        if (!recordId || !videoField) {
        	console.log('The record id or video field is missing.');
        	return;
        }

        var getVideoURLAction = cmp.get('c.getVideoURL');

        getVideoURLAction.setParams({
            recordId: recordId,
            videoField: videoField
        });

        getVideoURLAction.setCallback(this, 
            function(response) {
            	var state = response.getState();
            	console.log('RecordVideoViewer getVideoURL callback');
            	console.log("callback state: " + state);
            
            	if (cmp.isValid() && state === "SUCCESS") {
	                var videoSrcUrl = response.getReturnValue();
	                cmp.set('v.videoSrcUrl', videoSrcUrl);
                }
            }
        );

        $A.enqueueAction(getVideoURLAction);
    }
})