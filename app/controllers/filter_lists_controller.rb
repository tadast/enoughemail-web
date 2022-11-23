class FilterListsController < AuthenticatedController
  before_action :set_filter_list, only: %i[show edit update destroy]
  before_action :authorize_admin, only: %i[new edit update destroy create]

  # GET /filter_lists
  def index
    @filter_lists = FilterList.all
  end

  # GET /filter_lists/1
  def show
  end

  # GET /filter_lists/new
  def new
    @filter_list = FilterList.new
  end

  # GET /filter_lists/1/edit
  def edit
  end

  # POST /filter_lists
  def create
    @filter_list = FilterList.new(filter_list_params)

    if @filter_list.save
      redirect_to @filter_list, notice: "Filter List was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # POST /filter_lists/1/apply
  def apply
    @filter_list = FilterList.find(params.fetch(:filter_list_id))

    if @filter_list.applied?(current_organization)
      render :show, notice: "This Filter List is already applied to your organization"
    else
      @filter_list.apply!(by: current_user, organization: current_organization)

      redirect_to filter_lists_path, notice: "The Filter List is being applied, it may take a few minutes to complete"
    end
  end

  # DELETE /filter_lists/1/unapply
  def unapply
    @filter_list = FilterList.find(params.fetch(:filter_list_id))

    if @filter_list.applied?(current_organization)
      @filter_list.unapply!(by: current_user, organization: current_organization)

      redirect_to filter_lists_path, notice: "This Filter List is being removed. It can take several minutes."
    else
      redirect_to filter_lists_path, notice: "The Filter List has already been removed."
    end
  end

  # PATCH/PUT /filter_lists/1
  def update
    if @filter_list.update(filter_list_params)
      redirect_to @filter_list, notice: "Filter List was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def html_title
    super + " - Filter Lists"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_filter_list
    @filter_list = FilterList.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def filter_list_params
    params.require(:filter_list).permit(:name, :description, :email_pattern)
  end

  def authorize_admin
    return if current_user.email == "tadas@pdfcv.com" # LOL

    redirect_to root_path, notice: "Unauthorized"
  end
end
