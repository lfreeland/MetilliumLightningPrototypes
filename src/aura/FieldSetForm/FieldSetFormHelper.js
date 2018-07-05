({
    /*
     *  Map the Field to the desired component config, including specific attribute values
     *  Source: https://www.salesforce.com/us/developer/docs/apexcode/index_Left.htm#CSHID=apex_class_Schema_FieldSetMember.htm|StartTopic=Content%2Fapex_class_Schema_FieldSetMember.htm|SkinName=webhelp
     *
     *  Change the componentDef and attributes as needed for other components
     */
    configMap: {
        'anytype': { componentDef: 'ui:inputText', attributes: {} },
        'base64': { componentDef: 'ui:inputText', attributes: {} },
        'boolean': {componentDef: 'ui:inputCheckbox', attributes: {} },
        'combobox': { componentDef: 'ui:inputText', attributes: {} },
        'currency': { componentDef: 'ui:inputText', attributes: {} },
        'datacategorygroupreference': { componentDef: 'ui:inputText', attributes: {} },
        'date': {
            componentDef: 'ui:inputDate',
            attributes: {
                displayDatePicker: true,
                format: 'MM/dd/yyyy'
            }
        },
        'datetime': { componentDef: 'ui:inputDateTime', attributes: {} },
        'double': { componentDef: 'ui:inputNumber', attributes: {} },
        'email': { componentDef: 'ui:inputEmail', attributes: {} },
        'encryptedstring': { componentDef: 'ui:inputText', attributes: {} },
        'id': { componentDef: 'ui:inputText', attributes: {} },
        'integer': { componentDef: 'ui:inputNumber', attributes: {} },
        'multipicklist': { componentDef: 'ui:inputText', attributes: {} },
        'percent': { componentDef: 'ui:inputNumber', attributes: {} },
        'phone': { componentDef: 'ui:inputPhone', attributes: {} },
        'picklist': { componentDef: 'ui:inputText', attributes: {} },
        'reference': { componentDef: 'ui:inputText', attributes: {} },
        'string': { componentDef: 'ui:inputText', attributes: {} },
        'textarea': { componentDef: 'ui:inputText', attributes: {} },
        'time': { componentDef: 'ui:inputDateTime', attributes: {} },
        'url': { componentDef: 'ui:inputText', attributes: {} }
    },

    createForm: function(cmp) {
        console.log('FieldSetFormHelper.createForm');
        var fields = cmp.get('v.fields');
        var record = cmp.get('v.record');
        var inputDesc = [];
        
        for (var i = 0; i < fields.length; i++) {
            var field = fields[i];
        	var type = field.Type.toLowerCase();
        
            var configTemplate = this.configMap[type];
            
            if (!configTemplate) {
            	console.log(`type ${ type } not supported`);
            	continue;
            }
            
            // Copy the config so that subsequent types don't overwrite a shared config for each type.
        	var config = JSON.parse(JSON.stringify(configTemplate));
            
            config.attributes.label = field.Label;
            config.attributes.required = field.Required;
            config.attributes.value = cmp.getReference(' v.record.' + field.APIName);
            config.attributes.fieldPath = field.APIName;
            
            if (!config.attributes['class']) {
            	config.attributes['class'] = 'slds-m-vertical_x-small';
            }

            inputDesc.push([
                config.componentDef,
                config.attributes
            ]);
        }

        $A.createComponents(inputDesc, function(cmps) {
            console.log('createComponents');

            cmp.set('v.body', cmps);
        });
    }
})