global class EmailHelper {
    public static List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    public static Id templateId = [SELECT name,Id FROM EmailTemplate WHERE name = 'GoobleForce.com'].Id;
  public static void sendEmail(Id receiver,Id result){
    system.debug('Inside email helper*****************');
    system.debug('Reciever Id*****************************'+receiver);
    system.debug('Response Id*****************************'+result);
    
    //New instance of a single email message
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
    //Who you are sending the email to
    mail.setTargetObjectId(receiver);
        
    //The email template ID used for the email
    mail.setTemplateId(templateId);
    
    mail.setWhatId(result);
    mail.setReplyTo('sayali.bhambure@eternussolutions.com');
    mail.setSenderDisplayName('GoobleForce.com');
    mail.setSaveAsActivity(false);
    system.debug('Reached End of mail***************************');
    mails.add(mail);
    }
    
    public static void onlySend(){
       Messaging.sendEmail(mails); 
    }

}