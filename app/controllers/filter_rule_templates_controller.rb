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
