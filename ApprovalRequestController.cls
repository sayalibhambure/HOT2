public class ApprovalRequestController {
    public List<Leave__c> approvedLeaveList {get; set;}
    public List<Leave__c> pendingLeaveList {get; set;}
    public List<Leave__c> rejectedLeaveList {get; set;}
    public List<Leave__c> allLeaveList {get; set;}
    public List<User> allUsersList {get; set;}
    public List<Leave__c> usrLeaveList {get; set;}
    public boolean rendpendingBlock {get; set;}
    public boolean rendapprovedBlock {get; set;}
    public boolean rendrejectedBlock {get; set;}
    public boolean rendNewLeaveBlock {get; set;}
    public boolean rendAllLeavesBlock {get; set;}
    public boolean rendUserLeaveBlock {get; set;}
    public Id idOfLeave;
    public Id idOfUser;
    public Decimal totLeavestaken {get; set;}
    public Decimal leavesPermitted {get; set;}
    public Decimal leavesBalance {get; set;}
    public String eligibility{get; set;}
    public Leave__c leaveInstance {get; set;}
    
    public ApprovalRequestController(){
       rendpendingBlock = false;
       rendapprovedBlock = false;
       rendrejectedBlock = false;
       rendNewLeaveBlock = false;
       rendAllLeavesBlock = false;
       rendUserLeaveBlock = false;
       leavesPermitted = 20.00;
       leaveInstance = new Leave__c();
    }
    
    public void showPendingLeaves(){
       pendingLeaveList = [SELECT Employee__c,Start_Date__c,End_Date__c,Leave_Status__c FROM Leave__c WHERE Leave_Status__c = 'Pending' OR Leave_Status__c = 'Not Submitted'];
       if(pendingLeaveList.isEmpty()){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Pending Leaves!!')); 
       }
       else{
        rendpendingBlock = true;
        rendapprovedBlock = false;
        rendrejectedBlock = false;
        rendNewLeaveBlock = false;
        rendAllLeavesBlock = false;
        rendUserLeaveBlock = false;
       }
    }
    
    public void showApprovedLeaves(){
       approvedLeaveList = [SELECT Employee__c,Start_Date__c,End_Date__c,Leave_Status__c FROM Leave__c WHERE Leave_Status__c = 'Approved'];
       if(approvedLeaveList.isEmpty()){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Approved Leaves!!'));
       }
       else{
        rendapprovedBlock = true;
        rendpendingBlock = false;
        rendrejectedBlock = false;
        rendNewLeaveBlock = false;
        rendAllLeavesBlock = false;
        rendUserLeaveBlock = false;  
       }
    }
    
    public void showRejectedLeaves(){
       rejectedLeaveList = [SELECT Employee__c,Start_Date__c,End_Date__c,Leave_Status__c FROM Leave__c WHERE Leave_Status__c = 'Rejected'];
       if(rejectedLeaveList.isEmpty()){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Rejected Leaves!!'));
       }
       else{
        rendrejectedBlock = true;
        rendpendingBlock = false;
        rendapprovedBlock = false;
        rendNewLeaveBlock = false;
        rendAllLeavesBlock = false;
        rendUserLeaveBlock = false;
       }
    }
    
    public void submitForApproval(){
       idOfLeave = ApexPages.currentPage().getParameters().get('leaveId');
       system.debug('idOfLeave******************'+idOfLeave);
       //Create An Approval Request For Leave
       Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
       req1.setObjectId(idOfLeave);
        
       //Submit The Approval Request
       Approval.ProcessResult result = Approval.process(req1);
       Leave__c leaveInstance = [SELECT Id,Leave_Status__c FROM Leave__c WHERE Id =:idOfLeave];
       leaveInstance.Leave_Status__c = 'Pending';
       update leaveInstance;
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Leave Request Submitted For Approval!!'));
    }
    
    public void leaveLogging(){
        rendrejectedBlock = false;
        rendpendingBlock = false;
        rendapprovedBlock = false;
        rendNewLeaveBlock = true;
        rendAllLeavesBlock = false;
        rendUserLeaveBlock = false;
    }
    
    public void saveLeaveRecord(){
      if(leaveInstance.Leave_Status__c <> 'Not Submitted')
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Leave Status should be Not Submitted!!'));
      else{
        if(leaveInstance.Start_Date__c > leaveInstance.End_Date__c){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Leave Start Date Cannot Be greater Than Leave End Date!!'));
          }
        else{
          insert leaveInstance;
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Leave Successfully Logged!!'));
         }
        }
    }

   public void showLeaveHistory(){
       allUsersList = [Select Name From User ORDER BY Name];
       if(allUsersList.isEmpty()){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Users')); 
       }
       else{
         rendAllLeavesBlock = true;
         rendrejectedBlock = false;
         rendpendingBlock = false;
         rendapprovedBlock = false;
         rendNewLeaveBlock = false;
         rendUserLeaveBlock = false;
       }
    }
    
    public void showMyLeaveHistory(){
       idOfUser = ApexPages.currentPage().getParameters().get('userId');
       usrLeaveList = [SELECT Employee__c,Start_Date__c,End_Date__c,Number_Of_Days__c,Leave_Status__c,Leave_Reason__c FROM Leave__c WHERE Employee__c =:idOfUser];
       system.debug('usrLeaveList***********************************'+usrLeaveList);
       if(usrLeaveList.isEmpty()){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Leave History for this User!!User Most Eligible for Leave!!'));  
       }
       else{
         AggregateResult agr= [SELECT sum(Number_Of_Days__c) s FROM Leave__c WHERE Employee__c =:idOfUser AND Leave_Status__c = 'Approved'];
         if(agr.get('s') == NULL){
            totLeavestaken = 0.00; 
         }else{
          totLeavestaken = (Decimal)agr.get('s');
          system.debug('totLeavestaken********************'+totLeavestaken);
         }
         leavesBalance = leavesPermitted - totLeavestaken;
         if(leavesBalance >= 15.00){
           eligibility = '" Most Eligible "';
         }
         else if(leavesBalance >= 7.00 && leavesBalance < 15){
            eligibility = '" Moderate "'; 
         }
         else{
            eligibility = '" Least Eligible "';
         }
         rendUserLeaveBlock = true;
         rendAllLeavesBlock = false;
         rendrejectedBlock = false;
         rendpendingBlock = false;
         rendapprovedBlock = false;
         rendNewLeaveBlock = false;
       } 
    }
    
   /* public PageReference clearAll(){
        PageReference refpage = new PageReference('/apex/ApprovalRequestSubmissionPage');
        refpage.setRedirect(true);
        return refpage;
    }*/

}