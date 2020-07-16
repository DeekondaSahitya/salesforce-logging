/*
* Query opportunities 
*/
public with sharing class OpportunitiesSelector implements IOpportunitiesSelector{
    public List<Opportunity> selectWithOCRByLoanNumber(set<string> loanNumbers){
        List<Opportunity> opportunityList = new List<Opportunity>();
        if(!loanNumbers.isEmpty()){

            opportunityList = [SELECT ID, LoanNumber__c, 
                                    (SELECT ID, ContactID, Contact.Account.PersonEntityID__c,
                                    Contact.ContactPersonEntityID__c, Role, IsPrimary, GCID__c FROM OpportunityContactRoles)
                                    FROM Opportunity WHERE LoanNumber__c IN :loanNumbers];
        }
        return opportunityList;
    }

    
	// Get Opportunities that are in RRM pipeline
    public static List<Opportunity> selectOpportunitiesWithRRMs(List<Opportunity> oppRecords) {
        // Using LCR
        //return [Select Id, RecordTypeId, RecordType.DeveloperName, LoanStatusCode__c, LeadTypeCode__c, LoanChannel__c FROM Opportunity WHERE Id IN:oppRecords AND Id IN (Select Opportunity__c FROM LoanContactRole__c WHERE Opportunity__c IN:oppRecords AND Contact__r.RecordType.DeveloperName = 'AgencyContact' AND Contact__r.RelationshipManager__c != Null)];
        // Using OCR
        return [Select Id, RecordTypeId, RecordType.DeveloperName, LoanStatusCode__c, LeadTypeCode__c, LoanChannel__c FROM Opportunity WHERE Id IN:oppRecords AND Id IN (Select OpportunityId FROM OpportunityContactRole WHERE OpportunityId IN:oppRecords AND Contact.RecordType.DeveloperName = 'AgencyContact' AND Contact.RelationshipManager__c != Null)];
    }

    // Get Opportunities With RRMs from LCR
    // public static List<Opportunity> selectOpportunitiesWithRRMsFromLCR(List<LoanContactRole__c> lcr) {
    //     return [Select Id, RecordTypeId, RecordType.DeveloperName, LoanStatusCode__c, LeadTypeCode__c, LoanChannel__c FROM Opportunity WHERE Id IN (Select Opportunity__c FROM LoanContactRole__c WHERE Id IN:lcr AND Contact__r.RelationshipManager__c != Null AND Contact__r.RecordType.DeveloperName = 'AgencyContact')];
    // }

    // Get Opportunities With RRMs from OCR
    public static List<Opportunity> selectOpportunitiesWithRRMsFromOCR(List<OpportunityContactRole> ocr) {
        return [Select Id, RecordTypeId, RecordType.DeveloperName, LoanStatusCode__c, LeadTypeCode__c, LoanChannel__c FROM Opportunity WHERE Id IN (Select OpportunityId FROM OpportunityContactRole WHERE Id IN:ocr AND Contact.RelationshipManager__c != Null AND Contact.RecordType.DeveloperName = 'AgencyContact')];
    }    
    public List<Opportunity> selectByID(set<id> ids){
        List<Opportunity> opportunityList = new List<Opportunity>();
        if(!ids.isEmpty()){
            opportunityList = [select id, LoanNumber__c, AccountId,IsTeamMemberLoan__c
                                from Opportunity
                                where ID IN : ids];
        }
        return opportunityList;
    }    
    
    public static Opportunity selectByLoanNumber(string Loan){
        Opportunity Oppty = [select id, Name , LoanNumber__c  from Opportunity where LoanNumber__c = :Loan LIMIT 1];        
        return Oppty;
    }
    public static Map<Id,Opportunity> getAssociatedOpportunities(set<id>  oppId){
        Map<Id,Opportunity> CaseOppMap = New Map<Id,Opportunity>(); 
		
       for(Opportunity  opp:  [select id, IsTeamMemberLoan__c from Opportunity where Id IN :oppId]){
           CaseOppMap.put(opp.id,opp );
       }
       return CaseOppMap;
    }    
    
   
    


    Public Static Map<Id,Id> getopportunitymap(List<Id> oppids){
        Map<Id,Id> oppmap = new Map<Id,Id>();
        for(Opportunity o: [select id, coclient__c from opportunity where id in:oppids]){
            if(o.coclient__c != null)
                oppmap.put(o.Id,o.coclient__c);
        }
        return oppmap;
    }
    
   
    
}