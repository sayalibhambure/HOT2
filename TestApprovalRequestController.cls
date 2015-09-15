@isTest
public class TestApprovalRequestController {
    
    static testMethod void testApprovalFunctionality(){
       List<Leave__c> leaveList = new List<Leave__c>();
       Leave__c leaveInstance1 = new Leave__c();
       leaveInstance1.Start_Date__c = Date.valueOf('2015-12-06');
       leaveInstance1.End_Date__c = Date.valueOf('2015-12-09');
       leaveInstance1.Leave_Status__c = 'Pending';
       leaveList.add(leaveInstance1);
       
       Leave__c leaveInstance2 = new Leave__c();
       leaveInstance2.Start_Date__c = Date.valueOf('2015-12-11');
       leaveInstance2.End_Date__c = Date.valueOf('2015-12-14');
       leaveInstance2.Leave_Status__c = 'Approved';
       leaveList.add(leaveInstance2);
       
       Leave__c leaveInstance3 = new Leave__c();
       leaveInstance3.Start_Date__c = Date.valueOf('2015-12-01');
       leaveInstance3.End_Date__c = Date.valueOf('2015-12-03');
       leaveInstance3.Leave_Status__c = 'Not Submitted';
       leaveList.add(leaveInstance3);
       
       Leave__c leaveInstance4 = new Leave__c();
       leaveInstance4.Start_Date__c = Date.valueOf('2015-12-15');
       leaveInstance4.End_Date__c = Date.valueOf('2015-12-18');
       leaveInstance4.Leave_Status__c = 'Rejected';
       leaveList.add(leaveInstance4);
       
       Test.startTest();
       insert leaveList;
       ApprovalRequestController controllerInstance = new ApprovalRequestController();
       controllerInstance.showPendingLeaves();
       controllerInstance.showApprovedLeaves();
       controllerInstance.showRejectedLeaves();
       Test.stopTest();
      
       system.assertEquals(2,controllerInstance.pendingLeaveList.size());
       system.assertEquals(1,controllerInstance.approvedLeaveList.size());
       system.assertEquals(1,controllerInstance.rejectedLeaveList.size());
       
       PageReference page1 = Page.ApprovalRequestSubmissionPage;
       page1.getParameters().put('leaveId', leaveInstance3.Id);
       Test.setCurrentPage(page1);
       controllerInstance.submitForApproval();
       List<Leave__c> actualPendingLeaves = [SELECT Id FROM Leave__c 
                                             WHERE Leave_Status__c = 'Pending'];
       system.assertequals(2,actualPendingLeaves.size());
       List<ApexPages.Message> msgList = ApexPages.getMessages();
       for(ApexPages.Message msg :msgList){
       system.assertEquals('Leave Request Submitted For Approval!!',msg.getSummary());
       }
    }
    
    static testMethod void testsaveLeaveRecord(){
       Leave__c leaveInstance4 = new Leave__c();
       leaveInstance4.Start_Date__c = Date.valueOf('2015-12-15');
       leaveInstance4.End_Date__c = Date.valueOf('2015-12-18');
       leaveInstance4.Leave_Status__c = 'Not Submitted';
       
       Test.startTest();
       ApprovalRequestController controllerInstance = new ApprovalRequestController();
       controllerInstance.leaveInstance = leaveInstance4;
       controllerInstance.saveLeaveRecord();
       Test.stopTest();
       
       List<Leave__c> insertedList = [SELECT Id FROM Leave__c WHERE Id =:leaveInstance4.Id];
       system.assert(insertedList.size() <> 0);
    }
    
    static testMethod void testsaveLeaveRecordNegativeCase(){
       Leave__c leaveInstance5 = new Leave__c();
       leaveInstance5.Start_Date__c = Date.valueOf('2015-12-15');
       leaveInstance5.End_Date__c = Date.valueOf('2015-12-18');
       leaveInstance5.Leave_Status__c = 'Approved';
       
       Test.startTest();
       ApprovalRequestController controllerInstance = new ApprovalRequestController();
       controllerInstance.leaveInstance = leaveInstance5;
       controllerInstance.saveLeaveRecord();
       Test.stopTest();
       
       for(ApexPages.Message msg :ApexPages.getMessages()){
         system.assertEquals('Leave Status should be Not Submitted!!',msg.getSummary());
       }
    }
    
    static testMethod void testshowLeaveHistory(){
       ApprovalRequestController controllerInstance = new ApprovalRequestController();
       controllerInstance.showLeaveHistory();
       system.assertEquals(6,controllerInstance.allUsersList.size());
    }
    
    static testMethod void testshowMyLeaveHistory(){
       ApprovalRequestController controllerInstance = new ApprovalRequestController();
       Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
       User user1 = new User(Alias = 'standt', Email='standarduser@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='Asia/Kolkata', UserName='standarduser1100@testorg.com');
       insert user1;
       Leave__c leaveInstance1 = new Leave__c();
       leaveInstance1.Employee__c = user1.Id;
       leaveInstance1.Start_Date__c = Date.valueOf('2015-12-06');
       leaveInstance1.End_Date__c = Date.valueOf('2015-12-09');
       leaveInstance1.Leave_Status__c = 'Pending';
       
       Leave__c leaveInstance2 = new Leave__c();
       leaveInstance2.Employee__c = user1.Id;
       leaveInstance2.Start_Date__c = Date.valueOf('2015-12-11');
       leaveInstance2.End_Date__c = Date.valueOf('2015-12-14');
       leaveInstance2.Leave_Status__c = 'Approved';
       
       Test.startTest();
       insert leaveInstance1;
       insert leaveInstance2;
       Test.stopTest();
       PageReference refpage = Page.ApprovalRequestSubmissionPage;
       refpage.getParameters().put('userId',user1.Id);
       Test.setCurrentPage(refpage);
       controllerInstance.showMyLeaveHistory();
       system.assertEquals(2,controllerInstance.usrLeaveList.size());
       system.assertEquals('" Most Eligible "',controllerInstance.eligibility);
    } 

}