require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require 'pry'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end

get '/' do
  redirect '/events'
end

get '/events' do
  @events = Event.all.sort_by &:name
  erb :index
end

get '/events/submit' do
  authenticate!
  erb :submit
end

post '/events/submit' do
  @event = Event.create(name: params['name'], description: params['description'], location: params['location'])
  redirect "/events/#{@event.id}"

end

binding.pry
get '/events/:id' do
    @event = Event.find_by_id(params[:id])

    @attendees = Attendee.find_by(params[:event_id])
    binding.pry
    erb :details
end
binding.pry

post '/events/:id' do
  authenticate!
  attendee = Attendee.create(users_id: current_user.id, events_id: params[:id])
  flash[:notice] = "You have successfully joined this meetup!"
  redirect '/events'
end

