@isTest
public class CaseCreationControllerTest {
/*
    @isTest
    public static void unitTestMethod(){
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'LastName';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        insert acc;
        
               
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'test oppty';
        opp.CloseDate = Date.today() + 10;
        opp.LoanNumber__c = '123456';
        opp.StageName = 'Open';
        insert opp;
        
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = [Select Id, PersonContactId from Account where Id =: acc.Id].personContactId;
        ocr.OpportunityId = opp.Id;
        Insert ocr;
        
        case ocase = new case();
        oCase.Type = 'Complaint';
        oCase.Origin = 'Coded MSP';
        oCase.Description = 'test';
        
        list<Reason__c> lstReason = new list<Reason__c>();
        Reason__c oReason = new Reason__c();
        oReason.Reason__c = 'Documentation';
        oReason.SubReason__c = 'Appraisal Report';
        oReason.Type__c = 'Complaint';        
        oReason.Case__c = oCase.Id;
        lstReason.add(oReason);
       
        test.startTest(); 
        
        // fetch loan number 
        list<Opportunity> lstOpp = CaseCreationController.getLoanNumbers(acc.Id);
        system.assert(lstOpp.size() > 0);
        
        List<Account> lstAcc = CaseCreationController.getPersonAccountDetails(opp.Id);
        system.assert(lstAcc.size() > 0);
        
        List <String> lstOrigin = CaseCreationController.getSelectOptions(new Case(),'Origin');
        system.assert(lstOrigin.size() > 0);
        
        Map<String, List<String>> mapDepData = CaseCreationController.getDependentMap(new Reason__c(),'Type__c','Reason__c');
        //system.assert(mapDepData.values().size() > 0 );
        
        List<CaseCreationController.holidayWrapper> lstHoliDay = CaseCreationController.fetchHolidays();
        //system.assert(lstHoliDay.size() > 0 );
        
        case newCase = CaseCreationController.createNewCase(ocase,acc.Id,opp.LoanNumber__c,lstReason,'Account',ocase.AccountId);
       //system.assertNotEquals(null, newCase);
        
        List<Reason__c> lstNewReason = [select id,Name from Reason__c where case__c =: newCase.Id];
        //system.assert(lstNewReason.size() == 1);
        
        test.stopTest(); 
        } 
    
  */
}