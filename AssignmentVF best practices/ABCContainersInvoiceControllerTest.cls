
@isTest
private class ABCContainersInvoiceControllerTest {

    static testMethod void testForGettingInvoiceList() {
        
        Invoice_statement__c invoice = new Invoice_statement__c();
        invoice.Customer_City__c='Pune';
        invoice.Company_City__c='Pune';
        
         List<Invoice_statement__c> invoiceList=new List<Invoice_statement__c>();
         invoiceList.add(invoice);
         insert invoiceList;
         
         ABCContainersInvoiceController controllerinstance = new ABCContainersInvoiceController();
         controllerinstance.getstatementList();
       
        //Testing invoice list size
        System.assertEquals(1,controllerinstance.getstatementList().size());
        
        Line_Item__c line=new Line_Item__c();
        line.Invoice_statement__c=invoice.id;
        
        Line_Item__c line1=new Line_Item__c();
        line1.Invoice_statement__c=invoice.id;
        insert line;
        insert line1;
       
       PageReference pageInvoiceList = Page.ABCInvoice;
       Test.setCurrentpage(pageInvoiceList);
       
       
       
       
    }
}