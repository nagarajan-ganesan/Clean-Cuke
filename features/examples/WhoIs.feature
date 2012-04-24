Feature:  Testing of who is my representative API

Scenario Outline: Get the list of representatives/senators by passing various parameters

Given The service base url is from config file
And the service end url is "<endurl>"

When I make a "GET" request
And send the service parameter "<pname>"
And the parameter value is "<pvalue>"
And request for "<format>"

Then the response code should be "<respcode>"
And I should see the tags "<tagstoverify>" in the response
And the response should be in "<format>"

Examples:
|endurl|pname|pvalue|format|respcode|tagstoverify|
|getall_mems.php|zip|46544|json|200|name, state, district, phone, office, website|
|getall_mems.php|zip|31023|xml|200|name, state, district, phone, office, website|
|getall_reps_byname.php|name|Donnelly|xml|200|name, state, district, phone, office, website|
|getall_reps_byname.php|name|Smith|json|200|name, state, district, phone, office, website|
|getall_reps_bystate.php|state|CA|xml|200|name, state, district, phone, office, website|
|getall_sens_bystate.php|state|ME|xml|200|name, state, district, phone, office, website|