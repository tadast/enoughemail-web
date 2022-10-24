class FilterRulesController < AuthenticatedController
  before_action :set_filter_rule, only: %i[show edit update destroy]

  # GET /filter_rules
  def index
    if params[:except]
      flash[:notice] = "Filter rule removal is in-progress"
    end
    @filter_rules = current_organization.filter_rules.where.not(id: params[:except])
  end

  # GET /filter_rules/new
  # def new
  #   @filter_rule = FilterRule.new
  # end

  # POST /filter_rules
  # def create
  #   @filter_rule = current_user.filter_rules.new(
  #     filter_rule_params.merge(organization_id: current_organization.id)
  #   )

  #   if @filter_rule.save
  #     redirect_to @filter_rule, notice: "Filter rule was successfully added."
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /filter_rules/1
  # def update
  #   if @filter_rule.update(filter_rule_params)
  #     redirect_to @filter_rule, notice: "Filter rule was successfully changed."
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  # DELETE /filter_rules/1
  def destroy
    FilterRuleRemovalJob.perform_later(filter_rule: @filter_rule, user: current_user)
    redirect_to filter_rules_url(except: @filter_rule.id), notice: "Filter rule removal has started successfully."
  end

  def html_title
    super + " - Filter rules"
  end

  private

  def set_filter_rule
    @filter_rule = current_organization.filter_rules.find(params[:id])
  end

  def current_organization
    current_user.organization
  end

  # Only allow a list of trusted parameters through.
  def filter_rule_params
    params.require(:filter_rule).permit(:email_pattern, :source, :scope)
  end
end
