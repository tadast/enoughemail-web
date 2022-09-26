class ApplicationMailbox < ActionMailbox::Base
  routing /block/i => :forwards
end
