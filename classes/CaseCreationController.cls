/**	
 * @File Name          : CaseCreationController.cls	
 * @Description        : Apex Class For handling Case Creation Lightning Component	
 * @Author             : Rahul and Sandeep	
**/
public class CaseCreationController {
    
    @AuraEnabled
    // Method to query LoanNumbers based on OCR (Only for Account detail Page).
    public static List<Opportunity> getLoanNumbers(String accID){
        
        List<Opportunity> lstOppty = new List<Opportunity>();
        
        for(OpportunityContactRole ocr : new OpportunityContactRolesSelector().getRecordsByAccountId(accID)){
            if(ocr.OpportunityId != null){
                Opportunity opp = new Opportunity();
                opp.id = ocr.OpportunityId;
                opp.LoanNumber__c = ocr.Opportunity.LoanNumber__c;
               lstOppty.add(opp);
            }
        }
        return lstOppty;
    }
    
    
    @AuraEnabled
    // Method to query Related Person Accounts based on OCR (Only for Opportunity Page detail Page).
    public static List<Account> getPersonAccountDetails(String oppId){
        List<account> lstAcc = new list<account>();
        for(OpportunityContactRole ocr : OpportunityContactRolesSelector.getRecordsByOpportunityId(oppId)){
            if(ocr.contact.AccountId != null){
                Account acc = new Account();
                acc.Id = ocr.contact.AccountId;
                acc.Name = ocr.contact.Account.Name; 
                lstAcc.add(acc);
            }   
        }
        return lstAcc;
        
    }

    @AuraEnabled
    //Get independent picklist options dynamic from the form.
    //Reusable method to accomodate any stand alone field like Case Origin
    public static List <String> getSelectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry PickListVal: values) {
           allOpts.add(PickListVal.getValue());
        }
        return allOpts;//returns Single Picklist value
    }
    
    @AuraEnabled 
    // method to get picklist dependency map.
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //check for current object
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        //negative case - If controller or dependent field is not present in the map; then exit out
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            // To handle validfor bitwise char format of dependent fields in the wrapper.
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                //condition check to match the true scenario for matching bits for validFor
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    
    @AuraEnabled
    public static List<holidayWrapper> fetchHolidays() {
        List<holidayWrapper> lstHolidays = new List<holidayWrapper>();
        for(Holiday QLH :[SELECT id , Name, ActivityDate From Holiday]){
            holiDayWrapper objHoliday = new holidayWrapper();
            objHoliday.iDate =  QLH.ActivityDate.day();
            objHoliday.iMonth =  QLH.ActivityDate.month();
            
            lstHolidays.add(objHoliday);
        }
        return lstHolidays;
    }
    @AuraEnabled
    public static case createNewCase(case oCase , string currentRecordId, string Loan , list<Reason__c> lstReason,string sObjName,string selectedAccId,string ownerId,String SelectedObject){
       Case oCases;
        String commentNotes;
        try{
        If(sObjName == 'Account'){
            Account acc = [Select Id,PreferredLanguage__pc
                           From Account WHERE Id = : currentRecordId];
            oCase.AccountId = acc.Id;  
            
            If(acc.PreferredLanguage__pc == 'Spanish'){
                oCase.StellaLanguage__c = 'es';
            }else{
                oCase.StellaLanguage__c = 'en';
            }
            commentNotes = oCase.Comments;
            If(Loan != '' && Loan != 'undefined' ){
                Opportunity Opp = OpportunitiesSelector.selectByLoanNumber(Loan);
                oCase.Opportunity__c = Opp.id; 
            }   
        }
        If(sObjName == 'Opportunity'){
            oCase.Opportunity__c = currentRecordId;  
            if(selectedAccId != ''){
              oCase.AccountId = selectedAccId;    
            }
            
        }
  
       
      
        if(oCase.NeedToFollowUp__c == false){
            oCase.WhatClientisAskingFor__c = 'Nothing';
            oCase.Status = 'In Progress'; // only for insert
            oCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Closed Support Case').getRecordTypeId();            
            if(oCase.Type == 'Complaint'){
              oCase.Resolution__c = 'Resolved Without Compensation';
                oCase.AreWeAtFault__c = 'No';
                
            }
        }
        else{
            oCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId();            
        }
    
        INSERT oCase;

        List<Reason__c> lstReasonToInsert = new List<Reason__c>();
        
        for(Reason__c oRes : lstReason){
            oRes.Type__c = oCase.Type;
            oRes.Case__c = oCase.Id;
          	lstReasonToInsert.add(oRes);
        }
        
        if(lstReasonToInsert.size() > 0){
            
            INSERT lstReasonToInsert;
        }
            
            oCases = [select Id,Origin,FollowUpDate__c,StellaLanguage__c,Type,CaseNumber From Case Where Id =:oCase.Id Limit 1];
           
            if(oCase.Status != 'Closed'){  
                
                
                if(oCase.NeedToFollowUp__c){
                    oCase.OwnerId = ownerId;
                    If(SelectedObject == 'User'){
                    oCase.Status = 'In Progress';
                    }
                }
                
            }
            else{
                oCase.OwnerId = userinfo.getUserId();   
            }
            oCase.Comments = null;
            if(oCase.NeedToFollowUp__c == false){
                oCase.status = 'Closed';
            }
   
       update oCase;       
        
        }
       catch(DMLException dex){    
            system.debug('DmMessage' + dex.getDmlMessage(0));
           
            throw new AuraHandledException(dex.getDmlMessage(0));       
        }
 catch(exception ex){    
            throw new AuraHandledException(ex.getMessage());       
        }
       
        return oCases;  
        
    }  
    //Divide by 2 repeatedly until 0. At each step note the remainder (0 or 1).
    // These, in reverse order, are the binary.
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    //Used for picklist Dependency Method
    //base64ToBits - Store the base64Chars bits, contains encoded string.
    //Converts a base64 token into a binary/bits representation
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';     
        
        String validForBits = '';       
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    // base64Chars hold the base 64 chars.Convert decimal to binary representation(Remainder (0 or 1)).
	// result is printed in reverse order of binary
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        //Wrapper class to store the actual Picklist state.
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        // To handle bitwise char format of dependent fields.
        public String validFor {get;set;}
  
    }
    public class holidayWrapper{
        @AuraEnabled public Integer iDate{get;set;}
        @AuraEnabled public Integer iMonth{get;set;}
    }
}