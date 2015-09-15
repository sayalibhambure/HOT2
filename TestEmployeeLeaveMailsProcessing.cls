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
     system.assertEquals('Please put Name in subject and use proper Date Format!!\nPlease use correct Date Format in the Mail Body\nExample : [2015-10-08,2015-10-15]',result.message);
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
     system.assertEquals('Incorrect Leave Format!!Please put your name in the subject;Leave Start date and End Date in the body comma seperated within [];Leave Reason within {} with keyword Reason.\nExample : [2015-10-08,2015-10-15]\nReason{Have to attend Wedding ceremony}',result.message);
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
     //system.assertEquals('Incorrect Start Date,End Date!!Start Date should not be greater than End Date!!',result.message);  
   }
}