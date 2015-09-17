public class EternusAttendanceController {
    public String pwd                {get; set;}
    public string loginMesg          {get; set;}
    public String logoutMesg         {get; set;}
    public boolean rendHistory       {get; set;}
    public boolean rendNewLeave      {get; set;}
    public String password;
    public List<Leave__c> usrLeaves  {get; set;}
    public Leave__c leaveInstance    {get; set;}
    
    public EternusAttendanceController(){
      rendHistory = false;
      rendNewLeave = false;
      leaveInstance = new Leave__c();
    }
    
    public PageReference redirectToLogin(){
      PageReference pagelogin = Page.EternusLoginPage;
      pagelogin.setRedirect(true);
      return pagelogin;
    }
    
    public PageReference redirectToLogout(){
      PageReference pagelogout = Page.EternusLogoutPage;
      pagelogout.setRedirect(true);
      return pagelogout;
    }
    
    public PageReference goToHomePage(){
      PageReference homepage = Page.EternusAttendancePage;
      homepage.setRedirect(true);
      return homepage;
    }
    
    public PageReference verifyPassword(){
      PageReference pg = new PageReference('/apex/EternusLoginPage');
      List<User> userList=[SELECT Id,Name FROM User WHERE Password__c =:pwd];
       if(userList.size() == 0){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.CheckPasswordMessage));
        pwd = '';
       }
       else{
        List<Login_Details__c> logInstanceList = [SELECT Id,LogoutTime__c FROM Login_Details__c 
                                                  WHERE Employee__c =:userList[0].Id AND 
                                                  CreatedDate=today];
         if(logInstanceList.size() == 0 ){
            Login_Details__c loginInstance = new Login_Details__c();
            loginInstance.Name = 'Login '+userList[0].Name;
            loginInstance.LoginTime__c = system.now();
            loginInstance.Employee__c = userList[0].Id;
            insert loginInstance;
            system.debug('************************'+loginInstance.LoginTime__c);
            DateTime curentTime = loginInstance.LoginTime__c;
            String TimeZones = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
            system.debug('################'+TimeZones);
            String str =TimeZones.substring(12,TimeZones.length());
            system.debug('TimeZones.substring(12,TimeZones.length())*****************'+str);
            List<String> strList = str.split('\\(',2);
            system.debug('@@@@@@@@@@@@@@@@@'+strList);
            string strTimeZone = strList[1].substring(0,strList[1].length()-1);
            system.debug(strTimeZone);
            string strCurrentTime = curentTime.format('YYYY-MM-dd HH:mm:ss',strTimeZone);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Have a nice day '+userList[0].Name+'!!\n Your Login Time is '+strCurrentTime));
            pwd = '';
          }
          else{
            Integer len = logInstanceList.size();
            if(logInstanceList[len-1].LogoutTime__c <> NULL){
              Login_Details__c loginInstance = new Login_Details__c();
              loginInstance.Name = 'Login '+userList[0].Name;
              loginInstance.LoginTime__c = system.now();
              loginInstance.Employee__c = userList[0].Id;
              insert loginInstance;
              DateTime CurentTime = loginInstance.LoginTime__c;
              string strCurrentTime = CurentTime.format('YYYY-MM-dd HH:mm:ss','Asia/Kolkata');
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Have a nice day '+userList[0].Name+'!!\n Your Login Time is '+strCurrentTime));
              pwd = '';
             }
            else{
	          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.AlreadyloggedInMessage));
	          pwd = '';
              }
            }
        }
        return pg;
    }
    
    public PageReference verifylogoutPassword(){
      PageReference pg = new PageReference('/apex/EternusLogoutPage');
      List<User> userList=[SELECT Id,Name FROM User WHERE Password__c =:pwd];
      if(userList.size() == 0){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.CheckPasswordMessage));
        pwd = '';
       }
      else{
        try{
         List<Login_Details__c> loginInstance1 = [SELECT Id,Employee__c,LoginTime__c,
                                                  LogoutTime__c FROM Login_Details__c WHERE 
                                                  Employee__c =:userList[0].Id 
                                                  AND LogoutTime__c = NULL];
         if(loginInstance1.size() <> 0){
         List<Login_Details__c> loginInstance =[SELECT Id,Employee__c,LoginTime__c 
                                                FROM Login_Details__c WHERE 
                                                Employee__c =:userList[0].Id 
                                                ORDER BY CreatedDate];
         loginInstance[loginInstance.size()-1].LogoutTime__c = system.now();
         update loginInstance;
         DateTime logoutTime = loginInstance[loginInstance.size()-1].LogoutTime__c;
         String logout = logoutTime.format('yyyy-MM-dd HH:mm:ss','Asia/Kolkata');
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Logout Successful '+userList[0].Name+'!!\n Your Logout time is '+logout));
         pwd = '';
            }
         else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.NotLoggedInMessage)); 
          }
         }
        catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.NotLoggedInMessage));
          }
          
        }
      return pg;
    }
    
    public void viewLeaveHistory(){
      if(String.isBlank(pwd))
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.EnterPasswordMessage));
      else{
          password = pwd;
        List<User> usrInstanceList = [SELECT Id FROM User WHERE Password__c =:pwd];
        if(usrInstanceList.isEmpty()){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.CheckPasswordMessage)); 
        }else{
        usrLeaves = [SELECT Employee__c,Start_Date__c,End_Date__c,Leave_Status__c,Leave_Reason__c 
                     FROM Leave__c WHERE Employee__c =:usrInstanceList[0].Id 
                     ORDER BY Start_Date__c];
           if(!usrLeaves.isEmpty()){
             rendHistory = true;
           }
           else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.NoLeaveHistoryForUser)); 
        }
      }
    }
    
    public void showNewLeaveSection(){
      rendNewLeave = true;
    }
    
    public void customInsertLeave(){
      List<User> usrInstance = [SELECT Id,Name FROM User WHERE Password__c =:password];
      if(leaveInstance.Employee__c <> usrInstance[0].Id){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check Employee Name!!Leave can be applied only for '+usrInstance[0].Name +' !!')); 
      }
      else{
      insert leaveInstance;
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Leave applied successfully!!'));
      leaveInstance.clear();
      }
    }
    
    public void clearAll(){
      rendHistory = false;
      rendNewLeave = false;  
    }

}