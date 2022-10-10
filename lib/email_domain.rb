class EmailDomain
  COMMON_PROVIDERS = IO.read(Rails.root.join("config/common_email_domains.txt")).split("\n").freeze

  def initialize(value)
    @value = value
  end

  def common?
    COMMON_PROVIDERS.include?(@value.to_s.downcase.strip)
  end
end
