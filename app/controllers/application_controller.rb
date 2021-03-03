require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "775d310f3b2ab8122aa40f036bd1921e2f859842969acc931d40c336f1beef51080eae2fb53e4459befe3dad2f9d932365f7dac5194710773c9112d19b4c6758"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if session[:user_id]
      redirect :'/tweets'
    end
    erb :signup
  end

  post '/signup' do
    if session[:user_id]
      binding.pry
      redirect :'/tweets'
    end
    # binding.pry
    if params[:username] == "" || params[:email] == "" || params[:password] ==""
      # flash[:message] = "You cannot leave a field blank."
      redirect :'/signup'
    else
      user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = user.id
    end
    redirect :'/tweets'
  end

  get '/login' do
    if session[:user_id]
      redirect :'/tweets'
    end
    erb :'login'
  end

  post '/login' do
    if session[:user_id]
      redirect :'/tweets'
    end
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect :'/tweets'
    else
      # flash[:message] = "Incorrect username or password."
      redirect :'/login'
    end
  end

  get '/logout' do
    if session[:user_id]
      session.clear
      redirect :'/login'
    else
      redirect :'/'
    end
  end


end
