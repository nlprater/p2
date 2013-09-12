#GET =========================

get '/login' do 
  erb :login
end

get '/create_user' do
  erb :create_user
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/user/:user_id/events' do
  @user = User.find(params[:user_id])  
  @created_events = @user.created_events
  erb :created_events
end

get '/create_event' do
  erb :create_event
end

get '/event/:event_id/edit' do
  @event = Event.find(params[:event_id])
  erb :edit_delete_event
end

#POST =========================

 post '/login' do
  @user = User.find_by_email(params[:user][:email])

  if @user && @user.authenticate(params[:user][:password])
    session[:user_id] = @user.id
    redirect('/')
  else
    @error = "Whatchu talkin bout, Willis?"
    erb :login
  end
end

post '/create_user' do  
  @user = User.new(:first_name => params[:user][:first_name],:last_name => params[:user][:last_name],:email => params[:user][:email],:birthdate => params[:user][:birthdate],:password => params[:user][:password],:password_confirmation => params[:user][:password_confirmation])

  if @user.save
    session[:user_id] = @user.id
    redirect to '/'
  else
    @error = "You messed up, sucka!"
    erb :create_user
  end
end

post '/create_event' do
  if request.xhr?
  	p params
    @event = Event.new(
  	:user_id => current_user.id,
    :name => params[:name],
    :location => params[:location],
    :starts_at => params[:starts_at],
    :ends_at => params[:ends_at]
  	)

  	if @event.save
      li = "<li><a class='event_links' href='/event/#{@event.id}/edit'>#{@event.name} at #{@event.location} on #{@event.starts_at}</a></li>"
  	  return li
    end
  else
    @event = Event.new(
  	  :user_id => current_user.id,
      :name => params[:event][:name],
      :location => params[:event][:location],
      :starts_at => params[:event][:starts_at],
      :ends_at => params[:event][:ends_at]
  	  )
      if @event.save
        redirect to "/user/#{current_user.id}/events"
      else
        @error = "You messed up, sucka!"
        erb :created_events
      end
  end
end

post '/event/:event_id/edit' do
  @event = Event.find(params[:event_id])

  @event.update(
  	:user_id => current_user.id,
    :name => params[:event][:name],
    :location => params[:event][:location],
    :starts_at => params[:event][:starts_at],
    :ends_at => params[:event][:ends_at]
  	)

  if @event.save
    redirect to "/user/#{current_user.id}/events"
  else
    @error = "You messed up, sucka!"
    erb :create_event
  end

end

post '/event/:event_id/delete' do
  @event = Event.find(params[:event_id])
  @event.destroy
  redirect "/user/#{current_user.id}/events"
end
