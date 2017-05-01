class VisitsController < CrudController
  before_action :set_visit, only: [:show, :edit, :update, :destroy]

  def index
    @visits = Visit.all
  end

  def show
  end

  def new
    @visit = Visit.new
  end

  def edit
  end

  def create
    @visit = Visit.new(visit_params)

    respond_to do |format|
      if @visit.save
        format.html { redirect_to @visit, notice: 'Visit was successfully created.' }
        format.json { render :show, status: :created, location: @visit }
      else
        format.html { render :new }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @visit.update(visit_params)
        format.html { redirect_to @visit, notice: 'Visit was successfully updated.' }
        format.json { render :show, status: :ok, location: @visit }
      else
        format.html { render :edit }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @visit.destroy
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Visit was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      flash[:notice] = 'Visit can not be destroyed.'
      redirect_to root_path
    end
  end

  def update_keys
    if params[:building_id]
      keys = Key.by_building_id(params[:building_id]).availables
      render json: keys.to_json(only: [:id, :code])
    end
  end

  private
    def set_visit
      @visit = Visit.find(params[:id])
    end

    def visit_params
      params.require(:visit).permit(:key, :key_id, :building, :building_id, :owner, :owner_id, :visitor, :visitor_id,
                                    :realtor, :realtor_id, :start_at, :finished_at, :observation)
    end
end
