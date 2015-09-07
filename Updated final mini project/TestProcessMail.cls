@istest
public class TestProcessMail {
    static testmethod void testMailIfPart(){
        Test.setMock(HttpCalloutMock.class,new SingleRequestMock());
        Test.startTest();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Test.stopTest();
        
        email.fromname = 'Gooble Test';
        email.plainTextBody ='[Titanic Ship]';
        env.fromaddress = 'test@gooble.com';
        
        ProcessMail mailInstance = new ProcessMail();
        mailInstance.handleInboundEmail(email,env);
        
        Contact conInstance=[SELECT FirstName,LastName,Email FROM Contact WHERE FirstName ='Gooble' AND LastName='Test'];
        system.assertEquals('Gooble',conInstance.FirstName);
        system.assertEquals('Test',conInstance.LastName);
        system.assertEquals('test@gooble.com',conInstance.Email);
        
        EmailInfo__c emailInfoInstance = [SELECT id,Name,Contact__c,UserEmail__c FROM EmailInfo__c WHERE Name='Titanic Ship'];
        system.assertEquals('Titanic Ship',emailInfoInstance.Name);
        system.assertEquals(conInstance.Id,emailInfoInstance.Contact__c);
    }
    static testmethod void testMailElsePart(){
        Contact contactInstance = new Contact(FirstName='Test',LastName='Negative',Email='test@gmail.com');
        insert contactInstance;
        
        Test.setMock(HttpCalloutMock.class,new SingleRequestMock());
        Test.startTest();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Test.stopTest();

        email.fromname = 'Test Negative';
        email.plainTextBody ='[Aliens]';
        env.fromaddress = 'test@gmail.com';
        
        ProcessMail mailInstance = new ProcessMail();
        Messaging.InboundEmailResult result =mailInstance.handleInboundEmail(email,env);
        
        List<Contact> contactList = [SELECT id FROM Contact WHERE Name='Test Negative' AND Email='test@gmail.com'];
        system.assertEquals(1,contactList.size());
        
        List<EmailInfo__c> emailList = [SELECT id,Contact__c,Name FROM EmailInfo__c WHERE Name='Aliens'];
        system.assertEquals(1,emailList.size());
        system.assertEquals('Aliens',emailList[0].Name);
        system.assertEquals(contactList[0].Id,emailList[0].Contact__c);
        system.assertEquals(true,result.success);
        //system.assertEquals('sssss',contactList[0].Name);
        
    }
    
    static testMethod void testWithoutSubject(){
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.fromname = 'Gooble Test';
        email.plainTextBody ='';
        env.fromaddress = 'test@gooble.com';
        
        ProcessMail mailInstance = new ProcessMail();
        Messaging.InboundEmailResult result = mailInstance.handleInboundEmail(email,env);
        
        system.assertEquals(false,result.success);
    }
}