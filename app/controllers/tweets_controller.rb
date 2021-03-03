class TweetsController < ApplicationController


  get '/tweets' do
    if session[:user_id]
      @tweets = Tweet.all
      erb :'tweets/index'
    else
      redirect :'/login'
    end
  end

  get '/tweets/new' do
    if !session[:user_id]
      redirect :'/login'
    end
    erb :'tweets/new'
  end

  get '/tweets/:id' do
    if !session[:user_id]
      redirect :'/login'
    end
    @tweet = Tweet.find_by(id: params[:id])
    erb :'tweets/show'
  end

  get '/tweets/:id/edit' do
    if !session[:user_id]
      redirect :'/login'
    end
    @tweet = Tweet.find_by(id: params[:id])
    erb :'tweets/edit'
  end


  post '/tweets' do
    if params[:content] == ""
      redirect :'/tweets/new'
    else
      Tweet.create(content: params[:content], user_id: session[:user_id])
    end
    redirect :'/tweets'
  end

  patch '/tweets/:id/edit' do
    if !session[:user_id]
      redirect :'/login'
    end
    tweet = Tweet.find_by(id: params[:id])
    if tweet.user_id == session[:user_id] && params[:content] != ""
      tweet.update(content: params[:content])
      redirect :"tweets/#{params[:id]}"
    end
  end

  delete '/tweets/:id/delete' do
    if !session[:user_id]
      redirect :'/login'
    end
    if Tweet.find_by(id: params[:id]).user_id == session[:user_id]
      Tweet.find_by(id: params[:id]).destroy
    else
      redirect :"/tweets/#{params[:id]}"
    end
  end
end
