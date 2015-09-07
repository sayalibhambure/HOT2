global with sharing class MailToUser implements Database.Batchable<sObject>{

     Set<String> sendToList = new Set<String>();
     Map<String,List<Response__c>> mapSendTo_respList = new Map<String,List<Response__c>>();
     
     global Database.QueryLocator start(Database.batchableContext bc){
         system.debug('Inside start****************************');
         return Database.getqueryLocator([Select Name,Contact__c, (Select Title__c, Description__c, Link__c From Responses__r) From EmailInfo__c WHERE CreatedDate = TODAY]);
     }
     
     global void execute(Database.BatchableContext bc, List<EmailInfo__c> responseList){
         system.debug('responseList*******************'+responseList);
         for(EmailInfo__c resp : responseList){
             EmailHelper.sendEmail(resp.Contact__c,resp.Id);
         }
         EmailHelper.onlySend();
     }
    
     global void finish(Database.BatchableContext bc){
         system.debug('INSide finish***********************************************');
         
     }
}