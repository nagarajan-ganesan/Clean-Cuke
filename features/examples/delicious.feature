Feature:  Testing of Delicious - social bookmarking webservice

@AllDeliciousScenarios
Scenario Outline: Testing of Delicios Authentication  

Given The service base url is from config file
And the service end url is "<endurl>"

When I make a "GET" request
And I make the call with "<casename>"
And the username is "<username>"
And the password is "<password>"

Then the response code should be "<respcode>"
And I should see the tags "<tagstoverify>" in the response


Examples:
|casename|endurl|username|password|respcode|tagstoverify|
|valid credentials|v1/posts/get|nagtest|nrajan21580|200|bookmark_key, inbox_key, network_key, user|
|invalid password|v1/posts/get|nagtest|invalidpassword|200|bookmark_key, inbox_key, network_key, user|
|invalid username|v1/posts/get|invaliduser|nrajan21580|200|bookmark_key, inbox_key, network_key, user|