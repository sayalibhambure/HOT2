public with sharing class TriggerOnEmailInfoHandler {
    public static void queryStringPassing(List<EmailInfo__c> emailList){
        for(EmailInfo__c email :emailList ){
            restCall(email.MailBody__c);
        }
    }
    
    @future (callout=true)
    public static void restCall(String query){
        system.debug('$$$$$$$$$$$$$$$$$$$$inside restCall&$$$$$$$$$$$$$$$$$$$$$');
        system.debug('https://www.google.com/#q='+query);
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint('https://www.google.com/#q='+query);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET');
        Http h = new http();
        HttpResponse response = h.send(req);
        system.debug('Status code:****************************'+response.getStatusCode());
        system.debug('requestBody: ****************************'+response.getBody());
          
    }

}