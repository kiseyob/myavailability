class Api::UsersController < ApplicationController
  def show
    user = User.find_by_name(params[:id].to_s.downcase) rescue nil
    unless user
      render :nothing => true, :status => 404
    else
      render :json => {email: user.email}, :status => 200
    end
  end

  def events
    user = User.find_by_name(params[:id].to_s.downcase) rescue nil
    unless user
      render :nothing => true, :status => 404
    else
      events = user.events
      unless events
        if Rails.env.production?
          Mailer.delay.internal(user, request.host)
        else
          Mailer.internal(user, request.host).deliver!
        end
        render :nothing => true, :status => 401
      else
        render :json => events, :status => 200
      end
    end
  end

  def create
    user = User.create :name=>params[:name].downcase, :password=>params[:password], :email=>params[:email].downcase
    user.save!
    render :json => user.events, :status => 200
  end
end
