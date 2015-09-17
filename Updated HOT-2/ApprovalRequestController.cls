public class ApprovalRequestController {
    public static final Decimal LEAVES_PERMITTED = 20.00;
    public static final String STATUS_APPROVED = 'Approved';
    public static final String STATUS_PENDING = 'Pending';
    public static final String STATUS_REJECTED = 'Rejected';
    public static final String STATUS_NOTSUBMITTED = 'Not Submitted';
    
    public List<Leave__c> leaveList;
    
    public List<Leave__c> approvedLeaveList      {get; set;}
    public List<Leave__c> pendingLeaveList       {get; set;}
    public List<Leave__c> rejectedLeaveList      {get; set;}
    public List<User> allUsersList               {get; set;}
    public List<Leave__c> usrLeaveList           {get; set;}
    public boolean rendNewLeaveBlock             {get; set;}
    public Decimal totLeavestaken                {get; set;}
    public Decimal leavesBalance                 {get; set;}
    public String eligibility                    {get; set;}
    public Leave__c leaveInstance                {get; set;}
    
    public Id idOfLeave;
    public Id idOfUser;
    
    public ApprovalRequestController(){
       leaveList = new List<Leave__c>();
       pendingLeaveList = new List<Leave__c>();
       approvedLeaveList = new List<Leave__c>();
       rejectedLeaveList = new List<Leave__c>();
       allUsersList = new List<User>();
       usrLeaveList = new List<Leave__c>();
       rendNewLeaveBlock = false;
       leaveInstance = new Leave__c();
    }
    
    //Common Method to query on leaves
    public List<Leave__c> globalQuery(Set<String> statusSet){
       leaveList = [SELECT Employee__c,Start_Date__c,End_Date__c,Leave_Status__c,Leave_Reason__c 
                    FROM Leave__c WHERE Leave_Status__c IN :statusSet];
       return leaveList;
    }
    
    //Retrieve Leave records with Pending and not submitted status
    public void showPendingLeaves(){
       Set<String> set_Status = new Set<String>();
       set_Status.add(STATUS_PENDING);
       set_Status.add(STATUS_NOTSUBMITTED);
       pendingLeaveList = globalQuery(set_Status);
       if(pendingLeaveList.isEmpty()){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.No_Pending_Leaves)); 
       }
       else{
         approvedLeaveList.clear();
         rejectedLeaveList.clear();
         allUsersList.clear();
         usrLeaveList.clear();
         rendNewLeaveBlock = false;
       }
    }
    
    //Retrieve Leave records with Status Approved
    public void showApprovedLeaves(){
       Set<String> set_Status = new Set<String>();
       set_Status.add(STATUS_APPROVED);
       approvedLeaveList = globalQuery(set_Status);
       if(approvedLeaveList.isEmpty()){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.No_Approved_Leaves));
       }
       else{
         pendingLeaveList.clear();
         rejectedLeaveList.clear();
         allUsersList.clear();
         usrLeaveList.clear();
        rendNewLeaveBlock = false;
       }
    }
    
    //Retrieve Leave records with Status Rejected
    public void showRejectedLeaves(){
       Set<String> set_Status = new Set<String>();
       set_Status.add(STATUS_REJECTED);
       rejectedLeaveList = globalQuery(set_Status);
       if(rejectedLeaveList.isEmpty()){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.No_Rejected_Leaves));
       }
       else{
         pendingLeaveList.clear();
         approvedLeaveList.clear();
         allUsersList.clear();
         usrLeaveList.clear();
         rendNewLeaveBlock = false;
       }
    }
    
    //Method to submit leave record for Approval
    public void submitForApproval(){
      idOfLeave = ApexPages.currentPage().getParameters().get('leaveId');
      system.debug('idOfLeave******************'+idOfLeave);
       
      //Create An Approval Request For Leave
      try{
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setObjectId(idOfLeave);
        
      //Submit The Approval Request
      Approval.ProcessResult result = Approval.process(request);
      }
      catch(Exception e){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.LeaveRequestNotSubmitted));
        return;
       }
      List<Leave__c> leaveInstanceList = [SELECT Id,Leave_Status__c FROM 
                                          Leave__c WHERE Id =:idOfLeave];
      leaveInstanceList[0].Leave_Status__c = STATUS_PENDING;
      update leaveInstanceList;
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,system.Label.LeaveRequestSubmitted));
    }
    
    //Method to show Leave Logging section
    public void leaveLogging(){
       pendingLeaveList.clear();
       approvedLeaveList.clear();
       allUsersList.clear();
       usrLeaveList.clear();
       rejectedLeaveList.clear();
       rendNewLeaveBlock = true;
    }
    
    //Method to save Leave record through VF Page
    public void saveLeaveRecord(){
      if(leaveInstance.Leave_Status__c <> STATUS_NOTSUBMITTED)
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.LeaveStatusShouldBeNotSubmitted));
      else{
        if(leaveInstance.Start_Date__c > leaveInstance.End_Date__c){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.StartDateNotGreater));
          }
        else{
           insert leaveInstance;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,system.Label.LeaveLogged));
         }
        }
    }
   
   //Retrieves all Users 
   public void showLeaveHistory(){
      allUsersList = [Select Name From User ORDER BY Name];
       if(allUsersList.isEmpty()){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Users')); 
       }
       else{
         rendNewLeaveBlock = false;
         pendingLeaveList.clear();
         approvedLeaveList.clear();
         usrLeaveList.clear();
         rejectedLeaveList.clear();
       }
    }
    
    //Shows Leave History of selected User
    public void showMyLeaveHistory(){
       idOfUser = ApexPages.currentPage().getParameters().get('userId');
       usrLeaveList = [SELECT Employee__c,Start_Date__c,End_Date__c,
                       Number_Of_Days__c,Leave_Status__c,Leave_Reason__c
                       FROM Leave__c WHERE Employee__c =:idOfUser];

       system.debug('usrLeaveList***********************************'+usrLeaveList);
       if(usrLeaveList.isEmpty()){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.NoLeaveHistoryForUser));  
       }
       else{
         AggregateResult agr= [SELECT sum(Number_Of_Days__c) s FROM Leave__c WHERE
                               Employee__c =:idOfUser AND Leave_Status__c =: STATUS_APPROVED];

         if(agr.get('s') == NULL){
            totLeavestaken = 0.00; 
         }else{
          totLeavestaken = (Decimal)agr.get('s');
          system.debug('totLeavestaken********************'+totLeavestaken);
         }
         leavesBalance = LEAVES_PERMITTED - totLeavestaken;
         if(leavesBalance >= 15.00){
           eligibility = '" Most Eligible "';
         }
         else if(leavesBalance >= 7.00 && leavesBalance < 15){
            eligibility = '" Moderate "'; 
         }
         else{
            eligibility = '" Least Eligible "';
         }
         pendingLeaveList.clear();
         approvedLeaveList.clear();
         allUsersList.clear();
         rejectedLeaveList.clear();
         rendNewLeaveBlock = false;
       } 
    }

}