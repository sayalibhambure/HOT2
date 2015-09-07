public class SearchHistoryPageController {
    public Id idOfQuery;
    public boolean rendSection2 {get; set;}
    public boolean rendSection3 {get; set;}
    public boolean rendSection4 {get; set;}
    public List<EmailInfo__c> QueryList;
    public List<Response__c> respList {get; set;}
    public Integer counter=0;
    public Integer totalSize;
    public Integer size {get; set;}
    public boolean rendClear {get; set;}
    public boolean rendSelectList {get; set;}
    public boolean rendText {get; set;}
    public String selectedSearch {get ; set;}
    public boolean beginningDisabled {get; set;}
    public boolean previousDisabled {get; set;}
    public boolean nextDisabled {get; set;}
    public boolean enddDisabled {get; set;}
    
    public SearchHistoryPageController(){
        rendSection2 = false;
        rendSection3 = false;
        rendSection4 = false;
        rendClear = false;
        rendSelectList = false;
        totalSize = [SELECT count() FROM EmailInfo__c];
    }
    
    public void showHistory(){
        rendSection2 = true;
        rendSection4 = true;
        rendClear = true;
        rendSelectList = true;
    }

   public List<EmailInfo__c> getQueryList(){
       QueryList = [SELECT Name FROM EmailInfo__c LIMIT :size OFFSET :counter];
       return QueryList;
   }
   
   public void showResults(){
       rendSection3 = true;
       idOfQuery = ApexPages.currentPage().getParameters().get('queryId');
       EmailInfo__c emailInstance = [SELECT Name FROM EmailInfo__c WHERE id =:idOfQuery];
       selectedSearch = 'Results for '+emailInstance.name;
       //List<>[Select Id, (Select Title__c, Description__c, Link__c From Responses__r) From EmailInfo__c WHERE id =:idOfQuery];
       respList = [SELECT Title__c, Description__c, Link__c FROM Response__c WHERE Query__c =:idOfQuery]; 
   }
   
   public void clear(){
       rendSection2 = false;
       rendSection3 = false;
       rendSection4 = false;
   }
   
   public void beginning(){
       counter = 0;
       beginningDisabled = true;
       previousDisabled = true;
       enddDisabled = false;
       nextDisabled = false;
   } 
   
   public void previous(){
       enddDisabled = false;
       beginningDisabled = false;
       nextDisabled = false;
     if(counter == 0)
       ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NO PREVIOUS SEARCHES'));
     else
       counter -= size;
   }
   
   public void next(){
      enddDisabled = false;
      beginningDisabled = false;
      previousDisabled = false; 
      if(counter > totalSize)
	       ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NO FURTHER SEARCHES'));
      else
       counter += size;
   }
   
   public void endd(){
       counter = totalSize - math.mod(totalSize, size);
       enddDisabled = true;
       nextDisabled = true;
       beginningDisabled = false;
       previousDisabled = false;
       
   }
}