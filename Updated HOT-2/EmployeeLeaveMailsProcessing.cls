global class EmployeeLeaveMailsProcessing implements Messaging.InboundEmailHandler{
    
   //Processes Leave request Mail from Employees and instantiates Leave record accordingly
   global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope){
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    Date sDate;
    Date eDate;
    String body = email.plainTextBody;
    String mailBody = body.substringBetween('[',']');
    String reason = body.substringBetween('Reason{','}');
    if(String.isNotBlank(mailBody) && String.isNotBlank(reason))
    {
      system.debug('**************'+body);
      String startDate = body.substringBetween('[',',');
      String endDate = body.substringBetween(',',']');
      try{
      sDate = Date.valueOf(startDate);
      eDate = Date.valueOf(endDate);
      }
      catch(Exception e){
        result.success = false;
        result.message= system.Label.IncorrectDateFormat;
        return result;
      }
      if(sDate > eDate){
        result.success = false;
        result.message= system.Label.StartDateNotGreater;
       }
            
     List<User> userList = [SELECT Id FROM User WHERE Name =:email.subject];
       if(!userList.isEmpty()){
        try{
         Leave__c leaveInstance = new Leave__c();
         leaveInstance.Employee__c = userList[0].Id;
         leaveInstance.Start_Date__c = Date.valueOf(startDate);
         leaveInstance.End_Date__c = Date.valueOf(endDate);
         leaveInstance.Leave_Status__c = 'Not Submitted';
         leaveInstance.Leave_Reason__c = reason;
         insert leaveInstance;
        }
        catch(Exception e){
         result.message= system.Label.NameInSubjectMessage;
         result.success = false;
         }
        }
       else{
        result.message= system.Label.NotAnEternusEmployeeMessage;
        result.success = false;
         }
        }
    else{
      result.message= system.Label.IncorrectLeaveFormat;
      result.success = false;
      }
       return result;
    }

}