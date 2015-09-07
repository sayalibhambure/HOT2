public with sharing class ScheduleMailToUser implements Schedulable{
    public void execute(SchedulableContext sc){
        MailToUser mailInstance = new MailToUser();
        Database.executeBatch(mailInstance);
    }

}