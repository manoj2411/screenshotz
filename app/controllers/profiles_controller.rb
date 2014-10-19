class ProfilesController < ApplicationController

  def show; end

  def update
    current_user.update_attribute :name, profile_params[:name]
    redirect_to :back
  end

  #  ===================
  #  = Private methods =
  #  ===================
  private
    # Only allow a trusted parameter "white list" through.
    def profile_params
      params.require(:profile).permit(:name)
    end


end
