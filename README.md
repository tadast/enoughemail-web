# Rought plan

## MVP (usable for Chattermill)
- [x] Set up domain
- [~] Landing site with value proposition
- [x] Encrypt the google credentials
- [x] Flow from new user to org
- [ ] Set up inbound email in prod
- [ ] Access control to manage orgs and rules, how do we know who's an admin? Try admin@domain, if not available, ask who's an admin?
- [ ] Roles, adding others to the org
- [ ] Page/video for Google setup instructions
- [ ] Add labels to filtered emails?
- [ ] Implement rule deletion in the UI
- [x] Prevent blocking own domain
- [x] Prevent blocking common domains like gmail.com
- [x] Add block rules to our database so that filters can be recreated
- [x] Deploy
- [x] Decide and buy a domain

## 2nd client
- [ ] when removing rules from UI, allow grace period i.e. mark for removal -> undo
- [ ] create new rules via UI
- [ ] allow bulk-importing domain rules
- [ ] Basic branding
- [ ] Logo
- [ ] Onboarding email/video
- [ ] Allow org admin to add more moderators
- [ ] Add forwarding emails to gmail user address book
- [ ] Privacy policy and T&Cs
- [ ] Pricing numbers and page
- [ ] How to charge (invoice?, later stripe)
- [ ] Add custom labels to filtered emails i.e. block-domain-for-everyone+recruiters@.. would add a 'recruiters' label
- [ ] Easy way to send cease and desist emails


## Data

Common [email domains list source](https://gist.github.com/ammarshah/f5c2624d767f91a7cbdc4e54db8dd0bf).

[SVG illustrations](https://freesvgillustration.com)