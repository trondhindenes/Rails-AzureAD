class SessionsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
   
    if session[:user_id]
      # Means our user is signed in. Add the authorization to the user
      User.find(session[:user_id]).add_provider(auth_hash)
   
      render :text => "You can now login using #{auth_hash["provider"].capitalize} too!"
    else
      # Log him in or sign him up
      auth = Authorization.find_or_create(auth_hash)
   
      # Create the session
      session[:user_id] = auth.uid
   
      render :text => "Welcome #{auth.uid}! <br> claims: #{auth_hash["extra"]["raw_info"].to_json}"
    end
  end  

  def failure
  end
  
  def destroy
    session[:user_id] = nil
    render :text => "You've logged out!"
  end
end
