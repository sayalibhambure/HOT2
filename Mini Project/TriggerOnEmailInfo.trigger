trigger TriggerOnEmailInfo on EmailInfo__c (after insert) {
    
if(trigger.isAfter && trigger.isInsert){
    system.debug('%%%%%%%%%%%%%%%%%%%%%%Inside trigger%%%%%%%%%%%%%%%%%%%%');
    TriggerOnEmailInfoHandler.queryStringPassing(trigger.new);
}

}