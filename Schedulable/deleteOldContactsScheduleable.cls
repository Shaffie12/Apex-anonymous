global class DeleteOld Implements Schedulable
{
    

    global void execute(SchedulableContext sc)
    {   
        Date cur = datetime.now().date();
        Date boundary_date = Date.newInstance(cur.year()-7,1,1);

        List<Contact> oldCons =[select id, recordtypeid, createddate, 
        (select id,status_of_job__c, Last_completed_hours__c from volunteer_jobs__r),
        (select id,truedate__c from cases) from contact where createddate <= N_YEARS_AGO:7 ];

        Set<Contact> consToDelete = new Set<Contact>();
        Set<Contact> consWithoutCase = new Set<Contact>();
      

        //check the jobs
        for(Contact c: oldCons)
        {
            if(c.volunteer_jobs__r.size()==0)
                consToDelete.add(c);
            else 
            {
                Boolean hasActiveJob =false;
                for(GW_volunteers__volunteer_job__c j: c.volunteer_jobs__r)
                {
                    if(!(j.status_of_job__c.equals('Inctive')) || (j.Last_completed_hours__c.date()> boundary_date) )
                    {
                        hasActiveJob=true;
                        break;
                    }
                }
                if(!hasActiveJob)
                    consToDelete.add(c);  
            }
        }

        //check the cases
        for(Contact c:oldCons)
        {
            if(c.cases.size()==0)
                consWithoutCase.add(c);
            else 
            {
                Boolean hasRecentCase =false;
                for(Case ca: c.cases)
                {
                    if(ca.truedate__c > boundary_date)
                    {
                        hasRecentCase=true;
                        break;
                    }
                }
                if(!hasRecentCase)
                    consWithoutCase.add(c);   
            }
            
        }

        //intersection of the two sets will be deleted
        consToDelete.retainAll(consWithoutCase);

        System.Debug(consToDelete.size());



    }
}
