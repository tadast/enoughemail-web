class OrganizationsController < AuthenticatedController
  before_action :set_organization, only: %i[show edit update destroy]
  skip_before_action :ensure_organisation_set_up
  # GET /organizations/1
  def show
  end

  # GET /organizations/new
  def new
    if current_user.organization
      redirect_to current_user.organization and return
    end

    @organization = Organization.new(domain: current_user.email.split("@").last)
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  def create
    if current_user.organization
      redirect_to current_user.organization and return
    end

    @organization = Organization.new(organization_params)

    @organization.domain ||= current_user.domain_from_email

    if @organization.save
      current_user.update!(organization: @organization)
      redirect_to @organization, notice: "Organization was successfully created."
    else
      Rails.logger.error @organization.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: "Organization was successfully updated."
    else
      Rails.logger.error @organization.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /organizations/1
  def destroy
    # @organization.destroy
    # redirect_to organizations_url, notice: "Organization was successfully destroyed."
  end

  def html_title
    super + " - Organization"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = current_user.organization
  end

  # Only allow a list of trusted parameters through.
  def organization_params
    params.require(:organization).permit(
      :domain,
      :billing_email,
      :google_domain_wide_delegation_credentials,
      :admin_email,
      :google_auth_scope_set
    )
  end
end
