class FilterRulesController < AuthenticatedController
  before_action :set_filter_rule, only: %i[show edit update destroy]

  # GET /filter_rules
  def index
    @filter_rules = current_organization.filter_rules
  end

  # GET /filter_rules/1
  def show
  end

  # GET /filter_rules/new
  def new
    @filter_rule = Organization.new
  end

  # GET /filter_rules/1/edit
  def edit
  end

  # POST /filter_rules
  def create
    @filter_rule = current_user.filter_rules.new(
      filter_rule_params.merge(organization_id: current_organization.id)
    )

    if @filter_rule.save
      redirect_to @filter_rule, notice: "Filter rule was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /filter_rules/1
  def update
    if @filter_rule.update(filter_rule_params)
      redirect_to @filter_rule, notice: "Filter rule was successfully changed."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /filter_rules/1
  def destroy
    @filter_rule.destroy
    redirect_to filter_rules_url, notice: "Filter rule was successfully removed."
  end

  private

  def set_filter_rule
    current_organization.filter_rules.find(params[:id])
  end

  def current_organization
    current_user.organization
  end

  # Only allow a list of trusted parameters through.
  def filter_rule_params
    params.require(:filter_rule).permit(:email_pattern, :source, :scope)
  end
end
