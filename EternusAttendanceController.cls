public class EternusAttendanceController {
    public String pwd {get; set;}
    public string loginMesg {get; set;}
    public String logoutMesg {get; set;}
    
    public PageReference redirectToLogin(){
      PageReference pagelogin = new PageReference('/apex/EternusLoginPage');
      return pagelogin;
    }
    
    public PageReference redirectToLogout(){
      PageReference pagelogout = new PageReference('/apex/EternusLogoutPage');
      return pagelogout;
    }
    
    public PageReference goToHomePage(){
        PageReference homepage = new PageReference('/apex/EternusAttendancePage');
        homepage.setRedirect(true);
        return homepage;
    }
    
    public PageReference verifyPassword(){
        PageReference pg = new PageReference('/apex/EternusLoginPage');
        List<User> userList=[SELECT Id,Name FROM User WHERE Password__c =:pwd];
        if(userList.size() == 0){
          //loginMesg = 'Illegal Access!!Check Password!!';
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Illegal Access!!Check Password!!'));
          pwd = '';
          }
          else{
            List<Login_Details__c> logInstanceList = [SELECT Id,LogoutTime__c FROM Login_Details__c WHERE Employee__c =:userList[0].Id AND CreatedDate=today];
            if(logInstanceList.size() == 0 ){
              Login_Details__c loginInstance = new Login_Details__c();
              loginInstance.Name = 'Login '+userList[0].Name;
              loginInstance.LoginTime__c = system.now();
              loginInstance.Employee__c = userList[0].Id;
              insert loginInstance;
              system.debug('************************'+loginInstance.LoginTime__c);
              DateTime CurentTime = loginInstance.LoginTime__c;
              String TimeZones = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
              system.debug('################'+TimeZones);
              String str =TimeZones.substring(12,TimeZones.length());
              system.debug('TimeZones.substring(12,TimeZones.length())*****************'+str);
              List<String> strList = str.split('\\(',2);
              system.debug('@@@@@@@@@@@@@@@@@'+strList);
              string strTimeZone = strList[1].substring(0,strList[1].length()-1);
              system.debug(strTimeZone);
              string strCurrentTime = CurentTime.format('YYYY-MM-dd HH:mm:ss',strTimeZone);
              //loginMesg = 'Have a nice day '+userList[0].Name+'!!\n Your Login Time is '+strCurrentTime;
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
                //loginMesg = 'Have a nice day '+userList[0].Name+'!!\n Your Login Time is '+strCurrentTime;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Have a nice day '+userList[0].Name+'!!\n Your Login Time is '+strCurrentTime));
                pwd = '';
                }
                else{
	                //loginMesg = 'Illegal access!! Already logged In!!';
	                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Illegal access!! Already logged In!!'));
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
          //logoutMesg = 'Illegal Access!!Check Password!!';
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Illegal Access!!Check Password!!'));
          pwd = '';
          }
          else{
          try{
            List<Login_Details__c> loginInstance1 = [SELECT Id,Employee__c,LoginTime__c,LogoutTime__c FROM Login_Details__c WHERE Employee__c =:userList[0].Id AND LogoutTime__c = NULL];
            if(loginInstance1.size() <> 0){
            List<Login_Details__c> loginInstance =[SELECT Id,Employee__c,LoginTime__c FROM Login_Details__c WHERE Employee__c =:userList[0].Id ORDER BY CreatedDate];
            loginInstance[loginInstance.size()-1].LogoutTime__c = system.now();
            update loginInstance;
            DateTime logoutTime = loginInstance[loginInstance.size()-1].LogoutTime__c;
            String logouT = logoutTime.format('yyyy-MM-dd HH:mm:ss','Asia/Kolkata');
            //logoutMesg = 'Logout Successful '+userList[0].Name+'!!\n Your Logout time is '+logouT;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Logout Successful '+userList[0].Name+'!!\n Your Logout time is '+logouT));
            pwd = '';
            }
            else{
               //logoutMesg = 'Illegal access!! You have not Logged In!!';
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Illegal access!! You have not Logged In!!')); 
            }
          }
          catch(Exception e){
              //logoutMesg = 'Illegal access!! You have not Logged In!!';
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Illegal access!! You have not Logged In!!'));
          }
          
          }
        return pg;
    }

}