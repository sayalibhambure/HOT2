global with sharing class CollectionOfClosedWonOpportunities implements Database.Batchable<sObject>,Database.stateful{
    
    //String query;
    public Map<String,MyWrapper> mapPrimaryEmail_wrapper = new Map<String,MyWrapper>();
    global Database.QueryLocator start(Database.batchableContext bc)
    {
        //query='SELECT id,name FROM Opportunity WHERE StageName = :'Closed Won' And Account.Primary_contact__c <> NULL AND AccountId <> NULL';
        return Database.getQueryLocator([SELECT id,name,Account.Primary_contact__c,Amount 
        FROM Opportunity WHERE StageName = :'Closed Won' 
        And Account.Primary_contact__c <> NULL 
        AND AccountId <> NULL]);
        
    } 
    
    global void execute(Database.batchableContext bc,List<Opportunity> lstopportunity)
    {
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+lstopportunity);
       
       for(Opportunity opp : lstopportunity)
       {
           if(!mapPrimaryEmail_wrapper.containskey(opp.Account.Primary_contact__c))
           {
              MyWrapper wrap = new MyWrapper();
              wrap.oppList.add(opp);
              wrap.primaryEmail=opp.Account.Primary_contact__c;
              system.debug('OPP Instance AMOUNt$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+opp.Amount);
              wrap.Amt = opp.Amount;
              system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+wrap.Amt);
              mapPrimaryEmail_wrapper.put(opp.Account.Primary_contact__c,wrap); 
           }
           else
           {
            MyWrapper wrap1= mapPrimaryEmail_wrapper.get(opp.Account.Primary_contact__c);
            wrap1.oppList.add(opp);
            system.debug('OPP Instance AMOUNt$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+opp.Amount);
            wrap1.Amt = wrap1.Amt + opp.Amount;
           
            
            system.debug('Wrapper Amount$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+wrap1.Amt);
            mapPrimaryEmail_wrapper.put(opp.Account.Primary_contact__c,wrap1);
           }
           //System.debug('**************************************************'+mapPrimaryEmail_wrapper);
           System.debug('**************************************************'+mapPrimaryEmail_wrapper.values());
       }
       
    }
    
    global void finish(Database.batchableContext bc)
    {
     // System.debug('Finish**************************************************'+mapPrimaryEmail_wrapper);
     
     //Step 0 : Create a master list to hold all the emails.
      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      for(String priEmail : mapPrimaryEmail_wrapper.keySet())
      {
           // Step 1: Create a new Email
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          MyWrapper wrapInstance=mapPrimaryEmail_wrapper.get(priEmail);
          
          // Step 2: Set list of people who should get the email
          List<String> mailRecievers = new List<String>();
          mailRecievers.add(priEmail);
          mail.setToAddresses(mailRecievers);
          
          // Step 3: Set who the email is sent from
          mail.setReplyTo('sayali.bhambure2@gmail.com');
          mail.setSenderDisplayName('SalesForce.com');
          
          // Step 4. Set email contents
          mail.setSubject('CLOSED WON OPPORTUNITIES LIST AND AMOUNT');
          String body = '\n\nDear '+priEmail;
          body += '\n\nBelow are the opportunities associated to your Account<table border = "1">';
          body += '<tr><th><b>Opportunity Name</b></th><th><b>Amount</b></th></tr>';
          for(Opportunity opp : wrapInstance.oppList)
          {
              body += '\n<tr>'+ '<td>'+opp.Name +  '</td><td>' + opp.Amount + '</td></tr>';
              
          }
          body += '<td><i>Sum of Amount:<i></td><td>' + wrapInstance.Amt + '</td></table>';
           mail.setHtmlBody(body);
           mails.add(mail);
           Messaging.sendEmail(mails);
          
          
      }
       
    }
    
     
   @testvisible public class MyWrapper
    {
        public List<Opportunity> oppList;
        public String primaryEmail;
        public Decimal Amt;
	        public MyWrapper()
	        {
	           oppList = new List<Opportunity>();
	           Amt=0; 
	        }
    }

}