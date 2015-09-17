public class InstantiateAttendanceObject {
    public static final String APPROVED_STATUS = 'Approved';
    public static final String ACTIVE_USERSTATUS = 'Active';  
    // USER_STATUS_ACTIVE
    
    public void dailyAttendanceCalculation(){
     Attendance_details__c attendInstance = new Attendance_details__c();
     attendInstance.Total_Employees__c = [SELECT count() FROM User];
     attendInstance.Total_Employees_Active__c = [SELECT count() FROM User 
                                                 WHERE Status__c =: ACTIVE_USERSTATUS];
     
     //Calculating employees On Leave
     Integer onLeaveCount = 0;
     List<Leave__c> apprvdLeaveList = [SELECT Id,Employee__c,Start_Date__c,End_Date__c FROM 
                                       Leave__c WHERE Leave_Status__c =: APPROVED_STATUS];
     system.debug('apprvdLeaveList******************'+apprvdLeaveList);
     for(Leave__c apprvdLeave :apprvdLeaveList){
         system.debug('Inside for********');
         system.debug('**************'+Date.today());
         system.debug('StartDate********'+apprvdLeave.Start_Date__c);
         system.debug('EndDate********'+apprvdLeave.End_Date__c);
       if((apprvdLeave.Start_Date__c <= Date.today()) && (Date.today() <= apprvdLeave.End_Date__c)){
           system.debug('Inside If**********************');
         onLeaveCount = onLeaveCount + 1;
       }
     }
     attendInstance.Total_Employees_On_Leave__c = onLeaveCount;
     
     //Calculating Employees Absent today
     Set<Id> EmpsPresentIds = new Set<Id>();
     List<Login_Details__c> EmpsPresentToday = [SELECT Id,Employee__c FROM 
                                                Login_Details__c WHERE CreatedDate = today];
     system.debug('EmpsPresentToday***************'+EmpsPresentToday);
     for(Login_Details__c emp : EmpsPresentToday){
         EmpsPresentIds.add(emp.Employee__c);
     }
     system.debug('EmpsPresentIds**************'+EmpsPresentIds);
     List<User> empsNotPresent = [SELECT Id FROM User WHERE Id NOT In :EmpsPresentIds];
     system.debug('empsNotPresent*********'+empsNotPresent);
     Integer EmpNotPresent = empsNotPresent.size();
     Integer EmpAbsent = EmpNotPresent - onLeaveCount;
     attendInstance.Total_Employees_Absent__c = EmpAbsent;
     
     //Calculating Employees Working for less than 8 hours and Employees working for extra hours
     List<Decimal> allUserHours = new List<Decimal>();
     List<User> listUser = [SELECT Id,Name FROM User ORDER BY Name];
     for(User objUser :listUser){
       AggregateResult sumHours = [SELECT sum(Hours_Worked__c) s FROM Login_Details__c WHERE
                                   Employee__c =:objUser.Id AND CreatedDate = today];
       system.debug('*****************'+sumHours.get('s'));
       Decimal hr = (Decimal)sumHours.get('s');
       allUserHours.add(hr);
      }
     system.debug('allUserHours**********'+allUserHours);
      
     List<Decimal> lessHours = new List<Decimal>();
     List<Decimal> workingExtra = new List<Decimal>();
     List<Decimal> working8Hours = new List<Decimal>();
     for(Decimal hour : allUserHours){
       if(hour < 8.0)
         lessHours.add(hour);
       else if(hour > 8.0)
         workingExtra.add(hour);
       else
         working8Hours.add(hour);
      }
      attendInstance.Total_Employees_Not_Working_8_Hours__c = lessHours.size();
      attendInstance.Total_Employees_Working_Extra_Hours__c = workingExtra.size();
      insert attendInstance;
    }
}