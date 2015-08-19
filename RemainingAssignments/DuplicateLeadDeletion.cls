global with sharing class DuplicateLeadDeletion implements Database.Batchable<sObject>{
    
    public  Map<String,Lead> mapEmail_lead;
    public List<Lead> lstduplicateLeads;
    
    public DuplicateLeadDeletion()
    {
         mapEmail_lead = new  Map<String,Lead>();
         lstduplicateLeads = new List<Lead>(); 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator([SELECT Id,Name,Email FROM Lead WHERE Email <> NULL ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> lstLead)
    {
        System.debug('lstLead################'+lstLead);
       for(Lead ld : lstLead) 
       {
          if(!mapEmail_lead.containskey(ld.Email))
          {
              
              mapEmail_lead.put(ld.Email,ld);
          } 
          else
          {
              lstduplicateLeads.add(ld);
              
          }
       }
       System.debug('mapEmail_lead%%%%%%%%%%%%%%%%%%%%%%'+mapEmail_lead);
       delete lstduplicateLeads;
    }
    
    global void finish(Database.BatchableContext bc)
    {
        System.debug('Finish called!!!');
        System.debug('Map of Unique Leads :'+mapEmail_lead);
    }

}