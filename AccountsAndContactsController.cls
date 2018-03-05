public class AccountsAndContactsController{

    public List<Account>accounts {get; set;}
    public List<Contact>contacts {get; set;}
    public List<String>labelList {get; set;}
    public List<ContactHistory>contactHistory {get; set;}
    
    Public String accid;
    Public String label;

    public String getAccid(){
        return accid;
    }

    public List<String> getLabelList(){
        return labelList;
    }

    public List<ContactHistory> getContactHistory(){
        return contactHistory;
    }
    
    public AccountsAndContactsController(ApexPages.StandardController controller) {

      	accid = ApexPages.currentPage().getParameters().get('accid');
      	label = ApexPages.currentPage().getParameters().get('label');

       	accounts = [SELECT Id, Name  From Account ORDER BY CreatedDate DESC Limit 5];
        
        String queryStr = '';

        if(accid!=null){
            queryStr += 'AccountId = \''+accid+'\' ';
        }

        if(label!=null){
            queryStr += 'And Labels__c = \''+label+'\' ';
        }

        if(queryStr!=''){
            queryStr = 'Where '+queryStr+' ';
        }


        String query='select Id, FirstName, LastName, Labels__c from Contact '+queryStr;

        contacts =Database.query(query);
        
       	labelList = getPicklistValues('Contact', 'Labels__c');

        contactHistory = [Select CreatedDate, CreatedBy.Name, CreatedBy.Id, Field, NewValue, OldValue from ContactHistory];

    }

    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 

        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); 
        for (Schema.PicklistEntry a : pick_list_values) { 
            lstPickvals.add(a.getValue());
        }

        return lstPickvals;
    }

}
