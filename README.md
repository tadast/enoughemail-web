# Rought plan

## MVP (usable for Chattermill)
- [x] Set up domain
- [~] Landing site with value proposition
- [x] Encrypt the google credentials
- [x] Flow from new user to org
- [x] Test Google credentials/admin button
- [~] Page/video for Google service account setup instructions (or help to set up on video call?)
- [x] Prevent blocking own domain
- [x] Prevent blocking common domains like gmail.com
- [x] Add block rules to our database so that filters can be recreated
- [x] Deploy
- [x] Decide and buy a domain
- [x] Switch to a paid render.com plan
- [x] configure GCS for prod
- [x] Set up inbound email in prod
- [x] Option to block for me only v.s. everyone
- [x] Nav bar?
- [x] Implement rule deletion in the UI

## 2nd client
- [x] Set up work email @enoughemail.com
- [ ] Select a list of users in the org
- [ ] Collect and show event history for each org
- [ ] Access control to manage orgs and rules, how do we know who's an admin? Try admin@domain, if not available, ask who's an admin?
- [ ] Roles, adding others to the org
- [ ] Add labels to filtered emails?
- [ ] When a new user joins the org, apply all pre-existing Filter Rules
- [ ] Email cheat-sheet w/ pdf attached when a new user onboards
- [ ] when removing rules from UI, allow grace period i.e. mark for removal -> undo
- [ ] create new rules via UI
- [ ] allow bulk-importing domain rules
- [ ] Basic branding
- [x] Logo
- [ ] Onboarding email/video
- [ ] Allow org admin to add more moderators
- [ ] Add forwarding emails to gmail user address book
- [ ] Privacy policy and T&Cs
- [ ] Pricing numbers and page
- [ ] How to charge (invoice?, later stripe)
- [ ] Add custom labels to filtered emails i.e. block-domain-for-everyone+recruiters@.. would add a 'recruiters' label
- [ ] Easy way to send cease and desist emails?
- [ ] Paginate filter rules
- [ ] Make it available on Google Workspace Marketplace


## Data

Common [email domains list source](https://gist.github.com/ammarshah/f5c2624d767f91a7cbdc4e54db8dd0bf).

[SVG illustrations](https://freesvgillustration.com)

## Setup video

After following [setup instructions](https://developers.google.com/workspace/guides/create-credentials#service-account) I also needed to enable:
https://console.developers.google.com/apis/api/admin.googleapis.com/overview
https://console.developers.google.com/apis/api/gmail.googleapis.com/overview

consider disabling them before making the onboarding video?