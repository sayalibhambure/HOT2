@isTest
public class TestInstantiateAttendanceObject {
    static testMethod void testAttendanceCalculation(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User userInstance = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='Asia/Kolkata', UserName='standarduser1190@testorg.com');
        User userInstance1 = new User(Alias = 'standt11', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testinggg', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='Asia/Kolkata', UserName='standarduser1290@testorg.com');
        insert userInstance;
        insert userInstance1;
        
        Leave__c leaveInstance = new Leave__c();
        leaveInstance.Employee__c = userInstance.Id;
        leaveInstance.Start_Date__c = Date.valueof('2015-09-15');
        leaveInstance.End_Date__c = Date.valueof('2015-09-17');
        leaveInstance.Leave_Status__c = 'Approved';
        
        DateTime myDateTime = DateTime.newInstance(2015, 9, 15, 8, 6, 16);
        DateTime myDateTime1 = DateTime.newInstance(2015, 9, 15, 18, 6, 16);
        Login_Details__c loginDetailInstance = new Login_Details__c();
        loginDetailInstance.Employee__c = userInstance1.Id;
        loginDetailInstance.LoginTime__c = myDateTime;
        loginDetailInstance.LogoutTime__c = myDateTime1;
        //loginDetailInstance.Hours_Worked__c = 9;
        Test.startTest();
        insert leaveInstance;
        insert loginDetailInstance;
        InstantiateAttendanceObject obj = new InstantiateAttendanceObject();
        obj.dailyAttendanceCalculation();
        Test.stopTest();
        
        Attendance_details__c objAttendance = [SELECT Id,Total_Employees__c,
                                               Total_Employees_On_Leave__c,
                                               TotalEmployeesPresentToday__c,
                                               Total_Employees_Working_Extra_Hours__c,
                                               Total_Employees_Not_Working_8_Hours__c,
                                               Total_Employees_Absent__c FROM Attendance_details__c
                                               WHERE CreatedDate=today];

        system.assertEquals(8,objAttendance.Total_Employees__c);
        system.assertEquals(1,objAttendance.Total_Employees_On_Leave__c);
        system.assertEquals(1,objAttendance.TotalEmployeesPresentToday__c);
        system.assertEquals(1,objAttendance.Total_Employees_Working_Extra_Hours__c);
        system.assertEquals(0,objAttendance.Total_Employees_Not_Working_8_Hours__c);
        system.assertEquals(6,objAttendance.Total_Employees_Absent__c);
    }
    

}