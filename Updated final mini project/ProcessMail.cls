global class ProcessMail implements Messaging.InboundEmailHandler{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope){
        system.debug('**************Inside mail body*****************');
        
     Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
     String body = email.plainTextBody;
     body = body.substringbetween('[',']');
     if (String.isNotBlank(body)){
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
         emailInstance.Contact__c = contactInstance.Id;
         emailInstance.UserEmail__c = email.fromAddress;
         //emailInstance.MailBody__c = email.plainTextBody;
         emailInstance.Name = body;
         insert emailInstance;
         system.debug('******************If part emailInstance%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+emailInstance);

       } else {
         EmailInfo__c emailInstance = new EmailInfo__c();
         Contact conInstance = [SELECT Id FROM Contact WHERE Name = :email.fromname];
         emailInstance.Contact__c = conInstance.Id;
         emailInstance.UserEmail__c = email.fromAddress;
         //emailInstance.MailBody__c = email.plainTextBody;
         emailInstance.Name = body;
         insert emailInstance;
         system.debug('******************Else part emailInstance%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+emailInstance);
       }
        
     }
     else{
         result.message='Oops incorrect format!!\nPlease Send Your Query In The Mail Body Within [ ].\nExample : [How to Drive]\n\nThank you!!!\nGoobleForce.com\nSayali';
         result.success = false;
     }
     return result;
     }

}