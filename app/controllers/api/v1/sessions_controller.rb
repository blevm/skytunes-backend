class Api::V1::SessionsController < ApplicationController

  def create
    @user = User.find_by(k: params[:k])

    # byebug

    if (@user)
      # @user.update(k: '')

      # byebug

      render json: {
        username: @user.username,
        image: @user.image_url,
        token: get_token(payload(@user.username, @user.id))
      }
    else
      render json: {
        errors: "Those credentials don't match anything we have in our database."
      }, status: :unauthorized
    end
  end

end
