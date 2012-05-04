Feature:  Testing of user create service of macys.com

@usercreateservice
Scenario Outline: Testing of user create service  

Given The service base url is from config file
And the service end url is "<endurl>"

When I make a "POST" request
And I make the call with "<casename>"
And the username is "<username>"
And the password is "<password>"
And the request body is "usercreatebody.txt"
And executing the user create service

Then the response code should be "<respcode>"
And I should see the tags "<tagstoverify>" in the response

Examples:
|casename|endurl|username|password|respcode|tagstoverify|
|create new user|v2/user|nagarajan@test1.com|test123|200|firstName, userId|
|creating existing user|v2/user|nagarajan@test1.com|test123|502|already registered|
|Invalid user|v2/user|nagarajan.com|test123|200|firstName, userId|