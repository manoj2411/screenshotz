class ScreenshotsController < ApplicationController
  before_action :set_screenshot, only: [:edit, :update, :destroy]
  skip_before_filter :authenticate_user!, only: [:show]

  # GET /screenshots
  def index
    redirect_to action: :new
  end

  # GET /screenshots/1
  def show
    @screenshot = Screenshot.find_by_substitute_id!(params[:sid])
    verify_session_and_update_views
  end

  # GET /screenshots/new
  def new
    @screenshots = current_user.screenshots
    @screenshot = Screenshot.new
  end

  # GET /screenshots/1/edit
  def edit;end

  # POST /screenshots
  def create
    @screenshot = current_user.screenshots.build(screenshot_params)
    if @screenshot.valid?
      begin
        capture_screenshot_and_set_image
      rescue => e
        redirect_to :back , error: "Error occured: #{e}"
        return
      end
      @screenshot.save
      redirect_to [:edit, @screenshot], notice: 'Screenshot was successfully created.'
    else
      @screenshots = current_user.screenshots
      render :new
    end
  end

  # PATCH/PUT /screenshots/1
  def update
    if @screenshot.update(screenshot_params)
      redirect_to [:edit, @screenshot], notice: 'Screenshot was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /screenshots/1
  def destroy
    @screenshot.destroy
    redirect_to action: :new, notice: 'Screenshot was successfully destroyed.'
  end

  #  ===================
  #  = Private methods =
  #  ===================
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_screenshot
      @screenshot = current_user.screenshots.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def screenshot_params
      params.require(:screenshot).permit(:name, :url, :image)
    end

    def verify_session_and_update_views
      unless session[:viewed_for]
        @screenshot.update_views
        session[:viewed_for] = @screenshot.id
      end
    end

    def capture_screenshot_and_set_image
      f = Screencap::Fetcher.new(@screenshot.url)
      save_path = Rails.root.join("public/screenshots/#{current_user.id}/")
      FileUtils.mkpath save_path
      save_path = save_path + 'last_screenshot.png'
      @screenshot.image = f.fetch(output: save_path)
    end
end
