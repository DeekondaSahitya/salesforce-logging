public with sharing class OpportunityContactRolesSelector {

    public List<OpportunityContactRole> getRecordsByAccountId(string accID){
        List<OpportunityContactRole> ocrRecords = new List<OpportunityContactRole>();
        if(!string.IsBlank(accId)){
            ocrRecords = [Select Id,OpportunityId,Opportunity.LoanNumber__c
                          From OpportunityContactRole
                          WHERE Contact.AccountID =:accID
                          AND Opportunity.LoanNumber__c != null];
        }
        return ocrRecords;
    }
    public static List<OpportunityContactRole> getRecordsByOpportunityId(string oppId){
        List<OpportunityContactRole> lstOCR = new List<OpportunityContactRole>();
        lstOCR = [Select Id,OpportunityId,contactId,contact.AccountId,contact.Account.Name
                                           From OpportunityContactRole 
                                           WHERE Opportunity.Id = :oppId];
                               
   	 return lstOCR;
    }
    
    public static  Map<string,opportunityContactRole> getOCRbyPEID(List<Opportunity> oppList) {
        String OppConStr = ''; 
        //oppConRoleMap to store the contactrole w.r.t opp.Id.
        
        Map<string,opportunityContactRole> oppConRoleMap = new Map<string,opportunityContactRole>();      
        for(opportunityContactRole oppRole : [select Id,OpportunityId,contactId from OpportunityContactRole where OpportunityId in: oppList and Role = 'Buyer\'s Agent']){
            if(oppRole.opportunityId !=null && oppRole.contactId !=null){
                oppConRoleMap.put(oppRole.OpportunityId,oppRole);
            }
        } 
        return oppConRoleMap;
    }

}