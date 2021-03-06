@isTest
private class ChatterGraphJSControllerTest {
  static testMethod void testGetJson() {
    // Set up data
    User user = new User(Alias='test', Email='user@test.org',
      EmailEncodingKey='UTF-8', LastName='TestChatterGraph', LanguageLocaleKey='en_US',
      LocalesIdKey='en_US', ProfileId=[SELECT Id FROM Profile WHERE Name='システム管理者'].Id,
      TimezoneSidKey='America/Los_Angeles', UserName='user@chattergraph.test.org');
    insert(user);

    User user2 = new User(Alias='test2', Email='user2@test.org',
      EmailEncodingKey='UTF-8', LastName='Test2ChatterGraph', LanguageLocaleKey='en_US',
      LocalesIdKey='en_US', ProfileId=[SELECT Id FROM Profile WHERE Name='システム管理者'].Id,
      TimezoneSidKey='America/Los_Angeles', UserName='user2@chattergraph.test.org');
    insert(user2);

    EntitySubscription es = new EntitySubscription();
    es.SubscriberId = user.Id;
    es.ParentId = user2.Id;
    insert(es);

    String expectedGraphJson = '"graph":[{id:"' + user.Id + '",name:"TestChatterGraph",adjacencies:["' + user2.Id + '"],data:{type:""}},{id:"' + user2.Id + '",name:"Test2ChatterGraph",adjacencies:[],data:{type:""}}]';

    Test.startTest();
    System.runAs(user) {
      ChatterGraphJSController cg = new  ChatterGraphJSController();
      String json = cg.getJson();
      String graphJson = json.substring(1, json.indexOf(',"photoUrls":'));
      System.assertEquals(expectedGraphJson, graphJson);

      Map<String, String> typeToFilter = new Map<String, String>();
      typeToFilter.put('user', 'id!=\'\'');
      cg = new  ChatterGraphJSController();
      json = cg.getJson(user.Id, 6, typeToFilter);
      graphJson = json.substring(1, json.indexOf(',"photoUrls":'));
      System.assertEquals(expectedGraphJson, graphJson);
    }
    Test.stopTest();
  }
}