global class EmployeeLeaveMailsProcessing implements Messaging.InboundEmailHandler{
     global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String body = email.plainTextBody;
        String mailBody = body.substringBetween('[',']');
        String reason = body.substringBetween('Reason{','}');
        if(String.isNotBlank(mailBody) && String.isNotBlank(reason))
        {
          system.debug('**************'+body);
          String startDate = body.substringBetween('[',',');
          String endDate = body.substringBetween(',',']');
          Date sDate = Date.valueOf(startDate);
          Date eDate = Date.valueOf(endDate);
           if(sDate > eDate){
             result.success = false;
             result.message='Incorrect Start Date,End Date!!Start Date should not be greater than End Date!!';
            }
            
        List<User> userList = [SELECT Id FROM User WHERE Name =:email.subject];
          if(userList <> NULL){
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
             result.message='Please put Name in subject and use proper Date Format!!\nPlease use correct Date Format in the Mail Body\nExample : [2015-10-08,2015-10-15]';
             result.success = false;
            }
           }
          else{
             result.message='Not an Employee of Eternus!!\nPlease put your Name in the Subject as it is mentioned on the Icard!!';
             result.success = false;
            }
        }
        else{
           result.message='Incorrect Leave Format!!Please put your name in the subject;Leave Start date and End Date in the body comma seperated within [];Leave Reason within {} with keyword Reason.\nExample : [2015-10-08,2015-10-15]\nReason{Have to attend Wedding ceremony}';
           result.success = false;
        }
       return result;
    }

}