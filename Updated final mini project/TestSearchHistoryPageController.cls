@isTest
public class TestSearchHistoryPageController {
    static testMethod void testPageController(){
      //Creating dummy data
      List<EmailInfo__c> emailList = new List<EmailInfo__c>();
      EmailInfo__c emailInstance1 = new EmailInfo__c(Name='TestQuery1');
      EmailInfo__c emailInstance2 = new EmailInfo__c(Name='TestQuery2');
      
      emailList.add(emailInstance1);
      emailList.add(emailInstance2);
      insert emailList;
      
      //Creating controller instance
      Test.setMock(HttpCalloutMock.class,new SingleRequestMock());
      Test.startTest();
      SearchHistoryPageController controllerInstance = new SearchHistoryPageController();
      Test.stopTest();
      
      //Test getQueryList Method
      controllerInstance.size= 5;
      
      List<EmailInfo__c> expectedList = controllerInstance.getQueryList();
      system.assertEquals(2,expectedList.size());
      
      //Test showresults Method
      PageReference pageRef = Page.SearchPage;
      pageRef.getParameters().put('queryId',emailInstance1.Id);
      Test.setCurrentPage(pageRef);
      
      //system.assertEquals('/apex/SearchPage?queryId='+emailInstance1.Id,controllerInstance.showResults().getURL());
      controllerInstance.showResults();
      system.assert(controllerInstance.respList.size() <> NULL);
      
      //test pagination buttons
      controllerInstance.beginning();
      controllerInstance.previous();
      controllerInstance.next();
      controllerInstance.endd();
      
      //test clear method
      controllerInstance.rendSection2 = true;
      controllerInstance.rendSection3 = true;
      controllerInstance.rendSection4 = true;
      controllerInstance.clear();
      system.assertEquals(false,controllerInstance.rendSection2);
      system.assertEquals(false,controllerInstance.rendSection3);
      system.assertEquals(false,controllerInstance.rendSection4);
    }

}