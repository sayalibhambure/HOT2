public with sharing class TriggerOnEmailHandler {
    public static String res;
    public static void queryStringPassing(List<EmailInfo__c> emailList){
        for(EmailInfo__c email :emailList ){
            restCall(email.Name,email.Id,email.UserEmail__c,email.Contact__c);
        }
    }
    
    @future (callout=true)
    public static void restCall(String query,Id queryId,String sendTo,Id contactId){
      system.debug('$$$$$$$$$$$$$$$$$$$$inside restCall&$$$$$$$$$$$$$$$$$$$$$');
      system.debug('https://www.google.com/search?q='+query);
      HttpRequest req = new HttpRequest(); 
      req.setEndpoint('https://www.google.com/search?q='+ EncodingUtil.urlEncode(query, 'UTF-8'));
      req.setHeader('Content-Type', 'application/json');
      req.setMethod('GET');
      Http h = new http();
      HttpResponse response = h.send(req);
      system.debug('String Between,Images Link:*************************'+response.getBody().substringBetween('href="','">'));
      system.debug('Status code:****************************'+response.getStatusCode());
      system.debug('ResponseBody: ****************************'+response.getBody());
      system.debug('ResponseBody strip HTML: ****************************'+response.getBody().stripHtmlTags());
      
      res = response.getBody();
      ParseResponse.responseParsing(res,query,queryId,sendTo,contactId);
    }
        
    }