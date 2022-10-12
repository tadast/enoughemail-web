class CommonDomainOrganizationsController < AuthenticatedController
  skip_before_action :ensure_organisation_set_up
  def show
  end
end
