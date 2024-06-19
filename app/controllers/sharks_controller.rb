class SharksController < ApplicationController
  before_action :set_shark, only: %i[ show edit update destroy ]

  # GET /sharks or /sharks.json
  def index
    @sharks = Shark.all
  end

  # GET /sharks/1 or /sharks/1.json
  def show
  end

  # GET /sharks/new
  def new
    @shark = Shark.new
  end

  # GET /sharks/1/edit
  def edit
  end

  # POST /sharks or /sharks.json
  def create
    @shark = Shark.new(shark_params)

    respond_to do |format|
      if @shark.save
        track_event('shark_created', @shark)
        format.html { redirect_to shark_url(@shark), notice: "Shark was successfully created." }
        format.json { render :show, status: :created, location: @shark }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sharks/1 or /sharks/1.json
  def update
    respond_to do |format|
      if @shark.update(shark_params)
        track_event('shark_updated', @shark)
        format.html { redirect_to shark_url(@shark), notice: "Shark was successfully updated." }
        format.json { render :show, status: :ok, location: @shark }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sharks/1 or /sharks/1.json
  def destroy
    @shark.destroy!
    track_event('shark_destroyed', @shark)

    respond_to do |format|
      format.html { redirect_to sharks_url, notice: "Shark was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shark
      @shark = Shark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shark_params
      params.require(:shark).permit(:name, :facts)
    end

    # Track event using AmplitudeAPI
    def track_event(event_name, shark)
      event_properties = {
        shark_id: shark.id,
        shark_name: shark.name,
        facts: shark.facts
      }
      AMPLITUDE_CLIENT.track_event(user_id: current_user.id, event_type: event_name, event_properties: event_properties)
    end
end
