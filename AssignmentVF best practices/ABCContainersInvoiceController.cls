public with sharing class ABCContainersInvoiceController {
	
	public List<Line_Item__c> LineItemList;
	public List<Invoice_statement__c> statementList;
	public Id invoiceId;
	//List<Invoice_statement__c> RelatedInvoiceList{get; set;}
	public Invoice_statement__c invoice{get; set;}
	
	
	
	public List<Invoice_statement__c> getstatementList()
	{
		statementList=[SELECT id,ItemName__c,ItemNumber__c,Name,Company_City__c,Company_Name__c,Company_Phone__c,Company_Street__c,Customer_City__c,Customer_Email__c,Customer_Name__c,Customer_Phone__c,Customer_Street__c FROM Invoice_statement__c ];
		return statementList;
	}
	
	public PageReference showLineItems()
	{
		invoiceId=ApexPages.currentPage().getParameters().get('invoId');
		System.debug('##########################'+invoiceId);
		PageReference pdfpage=Page.ABCContainersInvoice;
		pdfpage.getParameters().put('invoiceToPrint',invoiceId);
		pdfpage.setRedirect(true);
		return pdfpage;
		
	}
	
	public List<Line_Item__c> getLineItemList()
	{
		invoiceId=ApexPages.currentPage().getParameters().get('invoiceToPrint');
		LineItemList=[SELECT id,Unit_Price__c,Unit_Sold__c,Price__c,Invoice_statement__r.Total__c FROM Line_Item__c where Invoice_statement__c = :invoiceId];
	    invoice=[SELECT id,ItemName__c,ItemNumber__c,Name,Company_City__c,Company_Name__c,Company_Phone__c,Company_Street__c,Customer_City__c,Customer_Email__c,Customer_Name__c,Customer_Phone__c,Customer_Street__c FROM Invoice_statement__c WHERE id= :invoiceId];
		return LineItemList;
	}
	
/*	public List<Invoice_statement__c> getRelatedInvoiceList()
	{
		invoiceId=ApexPages.currentPage().getParameters().get('invoiceToPrint');
		RelatedInvoiceList=[SELECT id,ItemName__c,ItemNumber__c,Name,Company_City__c,Company_Name__c,Company_Phone__c,Company_Street__c,Customer_City__c,Customer_Email__c,Customer_Name__c,Customer_Phone__c,Customer_Street__c FROM Invoice_statement__c WHERE id= :invoiceId];
		return RelatedInvoiceList;
	}       */
	
	
	
}