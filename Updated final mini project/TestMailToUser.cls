@isTest
public class TestMailToUser {
    static testMethod void testBatchCall(){
        MailToUser mailInstance = new MailToUser();
        Database.ExecuteBatch(mailInstance);
    }

}