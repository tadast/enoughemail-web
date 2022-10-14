class ApplicationMailbox < ActionMailbox::Base
  routing(/@had\.enoughemail/i => :forwards)
end
