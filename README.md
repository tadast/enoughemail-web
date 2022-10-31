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
- [x] Error handling - make sure bg workers are idempotent
- [x] paginate users - make sure to trawl through all pages of users recursively
- [x] check if we can always use primary address, users have many aliases etc

## Post shipping to chattermill

- [ ] First to set up org is admin, admin confirms moderators
- [ ] audit trail to see who signed up, changed filters
- [ ] Recognize user aliases when receiving email

## 2nd client
- [ ] Respond to bounced emails
- [ ] Moderators/admins can invite other moderators/admins
- [ ] Add custom labels to filtered emails i.e. block-domain-for-everyone+recruiters@.. would add a 'recruiters' label
- [ ] (bug) iOS landing page covers the Hero section
- [ ] Pre-made lists that can be applied
- [ ] Display a list of admins/moderators in the org
- [ ] Display a list of Gmail users in the org
- [ ] When a new user joins the Google Workspace, apply all pre-existing Filter Rules
- [ ] Email cheat-sheet w/ pdf attached when a new user onboards
- [ ] when removing rules from UI, allow grace period i.e. mark for removal -> undo
- [ ] create new rules via UI
- [ ] allow bulk-importing domain rules
- [ ] Consider bundling newly created filter rules together under a single Gmail filter with "OR"
- [ ] Basic branding
- [ ] Onboarding email/video
- [ ] Add forwarding emails to gmail user address book
- [ ] Privacy policy and T&Cs
- [ ] Pricing numbers and page
- [ ] How to charge (invoice?, later stripe)
- [ ] Paginate filter rules
- [ ] Make it available on Google Workspace Marketplace
- [x] Set up error tracking (Honeybadger)
- [x] Set up work email @enoughemail.com
- [x] Logo
- [x] how do we know who's an admin? Try admin@domain, if not available, ask who's an admin?

## 3rd Client or later
- [ ] like hey.com - shitlist by default, need to approve to receive in future. But on gmail
- [ ] Easy way to send cease and desist emails?


## Data

Common [email domains list source](https://gist.github.com/ammarshah/f5c2624d767f91a7cbdc4e54db8dd0bf).

[SVG illustrations](https://freesvgillustration.com)

## Setup video

After following [setup instructions](https://developers.google.com/workspace/guides/create-credentials#service-account) I also needed to enable:
https://console.developers.google.com/apis/api/admin.googleapis.com/overview
https://console.developers.google.com/apis/api/gmail.googleapis.com/overview

consider disabling them before making the onboarding video?