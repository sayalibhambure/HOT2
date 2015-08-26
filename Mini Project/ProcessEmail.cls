global class ProcessEmail implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope){
        system.debug('**************Inside mail body*****************');
     Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
     List<Contact> contactList = [SELECT Id,Name FROM Contact WHERE Email = :envelope.fromAddress LIMIT 1];
     system.debug('contactList&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'+contactList);
     if(contactList.size() == 0){
         Contact contactInstance = new Contact();
         contactInstance.Email = envelope.fromAddress;
         contactInstance.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
         contactInstance.LastName = email.fromname.substring(email.fromname.indexOf(' '));
         insert contactInstance;
         system.debug('contactInstance########################'+contactInstance);
         EmailInfo__c emailInstance = new  EmailInfo__c();
         emailInstance.MailBody__c = email.plainTextBody;
         emailInstance.MailSubject__c = email.subject;
         insert emailInstance;
         system.debug('******************If part emailInstance%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+emailInstance);

       } else {
         EmailInfo__c emailInstance = new  EmailInfo__c();
         emailInstance.MailBody__c = email.plainTextBody;
         emailInstance.MailSubject__c = email.subject;
         insert emailInstance;
         system.debug('******************Else part emailInstance%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+emailInstance);
       }
        return result;
     }
}