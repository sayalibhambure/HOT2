@isTest
public class TestEmailHelper {
    static testMethod void sendMail(){
        
      Contact contactInstance = new Contact(LastName='DummyContact',Email='dummy@dummy.com');
      insert contactInstance;
        
      Test.setMock(HttpCalloutMock.class,new SingleRequestMock());
      Test.startTest();
      EmailInfo__c emailInstance = new EmailInfo__c(Name='DummyEmail',Contact__c=contactInstance.Id);
      insert emailInstance;
      Test.stopTest();
      
      EmailHelper.sendEmail(contactInstance.Id,emailInstance.Id);
      EmailHelper.onlySend();
    }

}