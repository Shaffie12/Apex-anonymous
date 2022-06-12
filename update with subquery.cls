list<GW_Volunteers__Volunteer_Job__c> jobs = 
    [SELECT Id, createddate, (select id, gw_volunteers__hours_worked__c from gw_volunteers__volunteer_hours__r where gw_volunteers__total_hours_worked__c =5) FROM GW_Volunteers__Volunteer_Job__c  
     where createddate < 2022-04-12T00:00:00Z and createddate > 2022-04-11T00:00:00Z];
list<gw_volunteers__volunteer_hours__c> hours = new list<gw_volunteers__volunteer_hours__c>();

for(GW_Volunteers__Volunteer_Job__c j: jobs)
{
    for(gw_volunteers__volunteer_hours__c h: j.gw_volunteers__volunteer_hours__r)
    {
        h.gw_volunteers__hours_worked__c = 1;
        hours.add(h);
    }
}

try
{
    update hours;
}
catch(DmlException e)
{
    System.debug(e.getMessage());
}
