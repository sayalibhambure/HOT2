public with sharing class CountryCityDependentController {
	
public String selectedCountry{get; set;}	
public String selectedCity{get; set;}
 List<SelectOption> countryoptions = new  List<SelectOption> ();
 List<SelectOption> cityoptions = new  List<SelectOption> ();
 
 
 public CountryCityDependentController()
 {
 	
 }

public List<SelectOption> getcountryoptions()
{
	
	 List<Country__c> lstcountries = new List<Country__c>();
	  lstcountries =  Country__c.getAll().values();
	  System.debug('lstcountries@@@@@@@@@@@@@@@@'+lstcountries);
	 for(Country__c country : lstcountries)
	 {
	 	countryoptions.add(new SelectOption(country.Name__c,country.Name__c));
	 	
	 }
	 System.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^'+countryoptions);
	 
	 return countryoptions;
}

public List<SelectOption> getcityoptions()
{
	List<City__c> lstcity = new List<City__c>();
	
    lstcity=[SELECT Name__c FROM City__c where Country__c = :selectedCountry ];
    cityoptions.clear();
    System.debug('lstcity @@@@@@@@@@@@@@@@@@@'+lstcity);
    for(City__c city : lstcity)
    {
        
    	cityoptions.add(new SelectOption(city.Name__c,city.Name__c));
    	
    }
   
    System.debug('cityoptions@@@@@@@@@@@@@@@@@@@'+cityoptions);
	return cityoptions;
}



}