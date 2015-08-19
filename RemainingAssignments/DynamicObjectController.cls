public with sharing class DynamicObjectController {
    public String selectObj {get; set;}
    public List<String> selectField {get; set;}
    public String selectRecord {get; set;}
    public String selectedField {get; set;}
    public List<SelectOption> ObjectList = new List<SelectOption>();
    public List<SelectOption> FieldList {get; set;}
    public List<SelectOption> RecordList {get; set;}
    public List<SelectOption> selectedFieldsList{get; set;}
    public String ascOrder {get; set;}
    public Map<String,Schema.SObjectType> mapSchema = new Map<String,Schema.SObjectType>();
   // public Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
    public List<String> objects;
    public Boolean rendSection2 {get; set;}
    public Boolean rendSec4 {get; set;}
    public List<sObject> dynamicRecordsList {get; set;}
    public String queryString {get; set;}
    public List<String> strFlds {get; set;}
    public List<String> strfinal {get; set;}
    public String strConcatenated {get; set;}
    public String orderFld {get; set;}
     public Boolean rendSec2 {get; set;}  
     public Boolean rendSec3 {get; set;}
     public Boolean rendSec5 {get; set;}
    
    public DynamicObjectController()
    {
        dynamicRecordsList = new List<sObject>();
        selectedFieldsList = new List<SelectOption>();
        selectField = new List<String>();
        FieldList = new List<SelectOption>();
        rendSec2 = false;
        rendSec4 = false;
        rendSec3 = false;
        rendSec5 = false;
    }
 
  public List<SelectOption> getObjectList()
    {
        rendSec2 = true;
        dynamicRecordsList.clear();
        ObjectList.clear();
        mapSchema = schema.getGlobalDescribe();
        objects = new List<String>(mapSchema.keySet());
        objects.sort(); 
        System.debug('mapSchema$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+mapSchema);
        for(String obj : objects)
        {
           ObjectList.add(new SelectOption(obj,obj)); 
        }
        return ObjectList;
    }
    
  public void showFieldList()
    {
       FieldList.clear();
       System.debug('Clear@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+FieldList);
       rendSection2 = true;
       System.debug('Method2 called**********************************************');
       System.debug('selectObj##############################'+selectObj);
       mapSchema = Schema.getGlobalDescribe();
       Map<String, Schema.SObjectField> fieldMap = mapSchema.get(selectObj).getDescribe().fields.getMap(); 
       System.debug('fieldMapValues^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'+fieldMap.values());
       
       for(String fieldName : fieldMap.keySet())
       {
           FieldList.add(new SelectOption(fieldName,fieldName));
       }
       
    }
   
    public void showSelectedFields()
    {
       rendSec3 = true;
       selectedFieldsList.clear();
       for(String strField : selectField)
        {
        selectedFieldsList.add(new SelectOption(strField,strField));
        }
    } 
    
    public void undoSelectedFields()
    {
      //  List<String> selct = selectedFieldsList.getValue();
      for(Integer i=0;i<selectedFieldsList.size();i++)
      {
          if(selectedFieldsList[i].getValue()==selectedField)
          {
              selectedFieldsList.remove(i);
          } 
      }
      
    }
    
    public void showQuery()
    {
        System.debug('Show query called======@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        rendSec4 = true;
        strFlds = new List<String>();
        strfinal = new List<String>();
        for(SelectOption s : selectedFieldsList)
        {
            strFlds.add(s.getValue());
        }
        strConcatenated='';
        for(String str : strFlds)
        {
            strConcatenated = strConcatenated + str + ',';
        } 
        strConcatenated = strConcatenated.removeEnd(',');
        system.debug('strConcatenated###################################'+strConcatenated);
        
         if(orderFld == NULL && selectRecord == NULL && ascOrder == NULL)
            queryString = ' SELECT ' + strConcatenated + ' FROM ' + selectObj;

        else if(selectRecord == NULL)
            queryString = ' SELECT ' + strConcatenated + ' FROM ' + selectObj + ' ORDER BY '+orderFld+' '+ ascOrder;
            
        else if(orderFld == NULL)
           queryString = ' SELECT ' + strConcatenated + ' FROM ' + selectObj + ' LIMIT '+ selectRecord;
            
        else
            queryString = ' SELECT ' + strConcatenated + ' FROM ' + selectObj + ' ORDER BY '+orderFld+' '+ ascOrder +' LIMIT '+ selectRecord;
    }
    
    public void ExecuteQuery()
    {
     rendSec5 = true;
     dynamicRecordsList = Database.query(queryString);
    }

}