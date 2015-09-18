class WelcomeController < ApplicationController
  include ApplicationHelper

  def index
  end

  def landing
    logger.info params.inspect
    if params[:landing_id] == 'dashboard' || params[:landing_id] == 'rooms' || params[:landing_id] == 'profile' || params[:landing_id] == 'settings'
      redirect_to '/' + params[:landing_id] + '/index'
    else if params[:landing_id] == 'landing'
      if is_number?(params[:room_id])
        @room = Room.find_by_id params[:room_id]
        if @room == nil
          redirect_to root_url, :alert => 'The room number could not be found'

        else
          if can? :read, @room
            if can? :use, @room
              @join_url = root_path+'bbb/join/'+@room.id.to_s
            else
              @join_url = nil
            end
            render 'landing_room'

          else
            user = User.find(@room.user_id)
            redirect_to root_url+user.username, :alert => 'You don\'t have permissions for seeing this room'
          end
        end
      else
        redirect_to root_url
      end

    else
      begin
        if is_number?(params[:landing_id])
          @user = User.find_by!(id: params[:landing_id])
        else
          @user = User.find_by!(username: params[:landing_id])
        end
        #If the user is found then look for the room
        @rooms = Room.where(:user_id => @user.id)
      rescue
        logger.info "Landing page not found"
        #if the user is not found then show an error
        raise ActionController::RoutingError.new('Landing page not Found')
        #render :file => 'public/404.html', :status => :not_found, :layout => false
      end
    end end
  end

  def about
  end

  def contact
  end

end
