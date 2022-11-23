class FilterRuleTemplatesController < AuthenticatedController
  before_action :set_filter_rule_template, only: %i[show edit update destroy]
  before_action :authorize_admin, only: %i[new edit update destroy create]

  # GET /filter_rule_templates
  def index
    @filter_rule_templates = FilterRuleTemplate.all
  end

  # GET /filter_rule_templates/1
  def show
  end

  # GET /filter_rule_templates/new
  def new
    @filter_rule_template = FilterRuleTemplate.new
  end

  # GET /filter_rule_templates/1/edit
  def edit
  end

  # POST /filter_rule_templates
  def create
    @filter_rule_template = FilterRuleTemplate.new(filter_rule_template_params)

    if @filter_rule_template.save
      redirect_to @filter_rule_template, notice: "Filter rule template was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # POST /filter_rule_templates/1/apply
  def apply
    @filter_rule_template = FilterRuleTemplate.find(params.fetch(:filter_rule_template_id))

    if @filter_rule_template.applied?(current_organization)
      render :show, notice: "This template is already applied to your organization"
    else
      @filter_rule_template.apply!(by: current_user, organization: current_organization)

      redirect_to filter_rule_templates_path, notice: "The template is being applied, it may take a few minutes to complete"
    end
  end

  # DELETE /filter_rule_templates/1/unapply
  def unapply
    @filter_rule_template = FilterRuleTemplate.find(params.fetch(:filter_rule_template_id))

    if @filter_rule_template.applied?(current_organization)
      @filter_rule_template.unapply!(by: current_user, organization: current_organization)

      redirect_to filter_rule_templates_path, notice: "This template is being removed. It can take several minutes."
    else
      redirect_to filter_rule_templates_path, notice: "The template has already been removed."
    end
  end

  # PATCH/PUT /filter_rule_templates/1
  def update
    if @filter_rule_template.update(filter_rule_template_params)
      redirect_to @filter_rule_template, notice: "Filter rule template was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_filter_rule_template
    @filter_rule_template = FilterRuleTemplate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def filter_rule_template_params
    params.require(:filter_rule_template).permit(:name, :description, :email_pattern)
  end

  def authorize_admin
    return if current_user.email == "tadas@pdfcv.com" # LOL

    redirect_to root_path, notice: "Unauthorized"
  end
end
