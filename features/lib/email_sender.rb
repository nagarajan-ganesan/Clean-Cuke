class Emailsender
 def sendemail(mailmessage, emailsrvr, emailport, emailfrm, emailto, emailpassword)
    Pony.mail(
     :to => emailto, 
     :from => emailfrm,
     :subject => 'Webservice Automated Testing - Test Results', 
     :headers => { 'Content-Type' => 'text/html' },
     :body => mailmessage,
     :via => :smtp, 
     :via_options => {
       :address     => emailsrvr,
       :port     => emailport,
       :enable_starttls_auto => true,
       :user_name     => emailfrm,
       :password => emailpassword,
       :authentication     => :login,
     }
     )
  end
end