public with sharing class ParseResponse {
    public static void responseParsing(String res, String query, Id queryId,String sendTo,Id contactId){
      res = res.replace('<a href="/url?q=','{{{');
      res = res.replace('&amp;sa','}}}');
      res = res.replace('<cite>',' StartingLink[ ');
      res = res.replace('</cite>',' ]EndingLink StartingDescrip[ '); 
      res = res.replace('</div></li>', ' ]EndingDescrip ');
       
      System.debug('With replacement**********************'+res);
             
      String s2 = res.stripHtmlTags();
      System.debug('With replacement,without tags*********************'+s2);
      s2=s2.replace('Cached','');
      List<String> blocksList = new List<String>();
      List<String> strListUpdated = new List<String>();
      blocksList = s2.split('EndingDescrip');
      blocksList.remove(0);
      blocksList.remove(blocksList.size()-1);
      system.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^'+s2);
        
      System.debug('Blocks*********************'+blocksList);
      List<Response__c> responseList = new List<Response__c>();
         for(String block : blocksList){
           String finaldescription;
           //String title = block.substringBefore('{{{');
           String title = block.substringBetween('">','StartingLink[');
           if(title != NULL){
	           if(title.contains('{{{')){
	              title = title.substringBefore('{{{'); 
	           }
	           
	           else{
	               title = title;
	           }
           }
           String link = block.substringBetween('{{{', '}}}');
           //String link = block.substringBetween('StartingLink[', ']EndingLink');
           String description = block.substringBetween('StartingDescrip[ ', ']');
           //String description = block.substringBetween('StartingDescrip[ ', '{{{');
           if(description != NULL){
	           if(description.contains('{{{'))
	           {
	              description = description.substringBefore('{{{'); 
	           }
	           else {
	               description = description;
	           }
           }
           system.debug('Each block Title**************'+title);
           system.debug('Each block Link**************'+link);
           system.debug('Each block Description**************'+description);
           
           Response__c responseInstance = new Response__c();
           responseInstance.User__c = contactId;
           responseInstance.Query__c = queryId;
           responseInstance.Title__c = title;
           responseInstance.Link__c = link;
           responseInstance.Description__c = description;
           responseInstance.SendTo__c = sendTo;
           responseList.add(responseInstance);
         }
         insert responseList;
    }
    
   

}