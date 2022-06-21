class UsersController < ApplicationController
    before_action :authorize, only: :show
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    #POST /signup
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id 
        render json: user, status: :created
    end

    #GET /me
    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else
            render json: { errors: ["Not authorized"] }, status: :unauthorized
        end
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

    def authorize
        return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end

    def render_unprocessable_entity_response(e)
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity 
    end
        
end
