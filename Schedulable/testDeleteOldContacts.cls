@istest
class TestDeleteOldContact {
    
    static testmethod void test()
    {
        Date oldDate = Date.newInstance(2012,01,01);
        Time oldTime = Time.newInstance(0,0,0,0); 
        DateTime oldDt = DateTime.newInstance(oldDate,oldTime);
        
        Contact c1 = new Contact
        (
            FirstName ='Test1',
            LastName ='Test1',
            Contact_Ethnicity__c ='Prefer not to say',
            Relationship_Status__c ='Prefer not to say',
            Gender__c='Prefer not to say',
            LeadSource='Other',
            RecordTypeId = '0123Y000000pHGPQA2'
         );
        
        
        //just make some with jobs and active hours or with cases to test now. 
        Contact v1 = new Contact
        (
            FirstName ='Test2',
            LastName ='Test2',
            Contact_Ethnicity__c ='Prefer not to say',
            Relationship_Status__c ='Prefer not to say',
            Gender__c='Prefer not to say',
            LeadSource='Other',
            for_campaign__c='7013N000000NjfNQAS',
            gw_volunteers__volunteer_status__c ='Active',
            volunteer_progress__c ='Matched to a client',
            DBS_Returned_Date__c=Date.newInstance(2012,01,01),
            RecordTypeId = '0123Y000000pHGKQA2' 
        );
        
          Contact c2 = new Contact
        (
            FirstName ='Test3',
            LastName ='Test3',
            Contact_Ethnicity__c ='Prefer not to say',
            Relationship_Status__c ='Prefer not to say',
            Gender__c='Prefer not to say',
            LeadSource='Other',
            RecordTypeId = '0123Y000000pHGPQA2'
         );
        
        insert c1;
        insert c2;
        insert v1;
        Test.setCreatedDate(c1.Id, oldDt);
        Test.setCreatedDate(v1.Id, oldDt);
        Test.setCreatedDate(c2.id,oldDt);

        GW_Volunteers__Volunteer_Job__c job1 = new GW_Volunteers__Volunteer_Job__c
        (
            recordtypeid='0120O000000LAY6QAO',
            name='Test1+Test2 job',
            District__c='Colchester',
            Site__c='Colchester',
            Coordinator__c ='0050O000008KiQzQAK',
            volunteer__c = v1.id,
            client__c=c1.id,
            gw_volunteers__Campaign__c='7013N000000NjfNQAS',
            progress__c ='Befriending assignment ended',
            gw_volunteers__Inactive__c = true,
            leave_reason__c='Discontinued'
        ); 
        
         GW_Volunteers__Volunteer_Job__c job2 = new GW_Volunteers__Volunteer_Job__c
        (
            recordtypeid='0120O000000LAY6QAO',
            name='Test1+Test2 job',
            District__c='Colchester',
            Site__c='Colchester',
            Coordinator__c ='0050O000008KiQzQAK',
            volunteer__c = v1.id,
            client__c=c2.id,
            gw_volunteers__Campaign__c='7013N000000NjfNQAS',
            progress__c ='Befriending assignment started',
            gw_volunteers__Inactive__c = false,
            gw_volunteers__Ongoing__c=true
        ); 
        
        insert job1;
        insert job2;
        
        GW_volunteers__volunteer_hours__c hourRecord = new GW_volunteers__volunteer_hours__c
        (
            gw_volunteers__contact__c = v1.id,
            gw_volunteers__volunteer_job__c = job1.id,
            gw_volunteers__status__c ='Completed',
            GW_Volunteers__Number_of_Volunteers__c=1,
            gw_volunteers__hours_worked__c=5,
            gw_volunteers__planned_start_date_time__c=Datetime.newInstance(2012,02,01),
            gw_volunteers__start_date__c=Date.newInstance(2012,02,01)
                     
        );
        
         GW_volunteers__volunteer_hours__c hourRecord1 = new GW_volunteers__volunteer_hours__c
        (
            gw_volunteers__contact__c = v1.id,
            gw_volunteers__volunteer_job__c = job2.id,
            gw_volunteers__status__c ='Completed',
            GW_Volunteers__Number_of_Volunteers__c=1,
            gw_volunteers__hours_worked__c=5,
            gw_volunteers__planned_start_date_time__c=Datetime.newInstance(2020,02,01),
            gw_volunteers__start_date__c=Date.newInstance(2020,02,01)
                     
        );
        insert hourRecord;
        insert hourRecord1;
        
        Case case1 =new Case
        (
            recordtypeid='0123Y000000daBvQAI',
            contactid =c1.id,
            district__c = 'Colchester',
            site__c='Colchester',
            subject='testcase',
            origin='Red Cross',
            type='Loneliness',
            reason='Dementia',
            status='Befriending assignment started',
            delegate__c='0050O000008KiQzQAK'
         );
        
         Case case2 =new Case
        (
            recordtypeid='0123Y000000daBvQAI',
            contactid =c2.id,
            district__c = 'Colchester',
            site__c='Colchester',
            subject='testcase',
            origin='Red Cross',
            type='Loneliness',
            reason='Dementia',
            status='Befriending assignment started',
            delegate__c='0050O000008KiQzQAK'
         );
        insert case1;
        insert case2;
        Test.setCreatedDate(case2.id,oldDt);
        
        
        List<Contact> oldConsBefore = [select id from contact where createddate<2015-01-01T00:00:00.000+0000];
        Test.startTest();
        
        //schedule
        String jobId = System.schedule('DeleteOldContact', '0 0 0 14 6 ? 2080', 
                                       new DeleteOldContact());
        
        
        Test.stopTest();
        
    }
    

}