public with sharing class StudentRegistrationFormController {
    
    
    public String selectLang {get; set;}
   // public List<SelectOption> languageOptionList {set;}
   
    public Stud__c studInstance {get; set;}
    public String selectedLanguage;
    
    public StudentRegistrationFormController()
    {
       
       studInstance = new Stud__c();
       //selectLang ='fr';
    } 
    
    public Pagereference MySave()
    {
       //sc.save();
       Stud__c studInsertInstance = new Stud__c();
       studInsertInstance.Name = studInstance.Name;
       studInsertInstance.Roll_No__c = studInstance.Roll_No__c;
       studInsertInstance.Gender__c = studInstance.Gender__c;
       studInsertInstance.Course__c = studInstance.Course__c;
       studInsertInstance.HSC__c = studInstance.HSC__c;
       studInsertInstance.SSC__c = studInstance.SSC__c;
       studInsertInstance.Country__c = studInstance.Country__c;
       studInsertInstance.State__c = studInstance.State__c;
       studInsertInstance.City__c = studInstance.City__c;
       insert studInsertInstance; 
       PageReference formPage = new PageReference('/apex/StudentRegistrationForm');
       ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your admission application has been submitted successfully'));
       studInstance.clear(); 
      
       return formPage;
    }
    
   public List<SelectOption> getlanguageOptionList()
   {
       
       List<SelectOption> languageOptionList = new List<SelectOption>();
       languageOptionList.add(new SelectOption('en-US','English'));
       languageOptionList.add(new SelectOption('fr','French'));
       languageOptionList.add(new SelectOption('es','Spanish'));
       
       return languageOptionList;
   }
   
   
    
    

}