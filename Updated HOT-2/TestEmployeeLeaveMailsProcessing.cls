@isTest
public class TestEmployeeLeaveMailsProcessing {
   static testMethod void testProcessMailPositiveCase(){
     Messaging.InboundEmail email  = new Messaging.InboundEmail();
     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
     
     email.plainTextBody = '[2015-11-02,2015-11-05]\nReason{Test Reason}';
     email.subject='Vaishali';
     email.fromAddress = 'vaishalivarma11@gmail.com';
     
     EmployeeLeaveMailsProcessing emailInstance = new EmployeeLeaveMailsProcessing();
     Test.startTest();
     Messaging.InboundEmailResult result = emailInstance.handleInboundEmail(email,env);
     Test.stopTest();
     List<Leave__c> lvList = [SELECT Id FROM Leave__c WHERE Leave_Reason__c = 'Test Reason'];
     system.assertEquals(1,lvList.size());
     system.assertEquals(true,result.success);
    }
    
   static testMethod void testProcessMailWithoutSubject(){
     Messaging.InboundEmail email  = new Messaging.InboundEmail();
     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
     
     email.plainTextBody = '[2015-11-02,2015-11-05]\nReason{Test Reason}';
     email.fromAddress = 'vaishalivarma11@gmail.com';
     
     EmployeeLeaveMailsProcessing emailInstance = new EmployeeLeaveMailsProcessing();
     Test.startTest();
     Messaging.InboundEmailResult result = emailInstance.handleInboundEmail(email,env);
     Test.stopTest();
     
     system.assertEquals(false,result.success);
     
   }
   
   static testMethod void testProcessMailWithoutReason(){
     Messaging.InboundEmail email  = new Messaging.InboundEmail();
     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
     
     email.plainTextBody = '[2015-11-02,2015-11-05]';
     email.fromAddress = 'vaishalivarma11@gmail.com';
     
     EmployeeLeaveMailsProcessing emailInstance = new EmployeeLeaveMailsProcessing();
     Test.startTest();
     Messaging.InboundEmailResult result = emailInstance.handleInboundEmail(email,env);
     Test.stopTest();
     
     system.assertEquals(false,result.success);
     
   }
   
   static testMethod void testProcessMailWithStartDateGreater(){
     Messaging.InboundEmail email  = new Messaging.InboundEmail();
     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
     
     email.plainTextBody = '[2015-11-15,2015-11-02]\nReason{Test Reason}';
     email.fromAddress = 'vaishalivarma11@gmail.com';
     
     EmployeeLeaveMailsProcessing emailInstance = new EmployeeLeaveMailsProcessing();
     Test.startTest();
     Messaging.InboundEmailResult result = emailInstance.handleInboundEmail(email,env);
     Test.stopTest();
     
     system.assertEquals(false,result.success);

   }
}