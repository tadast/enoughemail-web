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

## 2nd client
- [ ] Recognize user aliases when receiving email
- [ ] audit trail to see who signed up, changed filters
- [ ] Respond to bounced emails
- [ ] Moderators/admins can invite other moderators/admins
- [ ] Add custom labels to filtered emails i.e. block-domain-for-everyone+recruiters@.. would add a 'recruiters' label
- [ ] (bug) iOS landing page covers the Hero section
- [ ] Pre-made lists that can be applied
- [ ] Display a list of admins/moderators in the org
- [x] Import a list of Gmail users in the org to be used in billing
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

## Slack webhooks

The [gem](https://github.com/kmrshntr/omniauth-slack/pull/68) is outdated, monkeypatch `token_url: '/api/oauth.v2.access'` to make it work

## run with https locally

openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt
FORCE_SSL=true rails s -b 'ssl://localhost:3000?key=tmp/localhost.key&cert=tmp/localhost.crt'

## Data

Common [email domains list source](https://gist.github.com/ammarshah/f5c2624d767f91a7cbdc4e54db8dd0bf).

[SVG illustrations](https://freesvgillustration.com) [and another one](https://undraw.co/search)

Recruiter lists: https://github.com/drcongo/spammy-recruiters/blob/master/spammers.txt https://recruiters.wtf/  https://www.kandidate.com/blog/wp-content/uploads/2016/02/List-of-Recruiters.txt


## Setup video

After following [setup instructions](https://developers.google.com/workspace/guides/create-credentials#service-account) I also needed to enable:
https://console.developers.google.com/apis/api/admin.googleapis.com/overview
https://console.developers.google.com/apis/api/gmail.googleapis.com/overview

consider disabling them before making the onboarding video?

## Landing page feedback

Oliver:
- Unclear what is "unwanted email", be more concrete?
- Was not clear how it works, did mention filters, but not the email interface
- He thought it would be like a firewall setup or something
- Diagram/pictures would help

Dzotas:
- understood the email forwarding UI and filter for future emails
- did not know what is Google Workplace
- did not know if it works for all email clients (e.g. outlook)
- found it confusing that you don't need to download or log in anywhere
- would love a video explainer of how it works

Deioo:
- Would just try or look for a demo to understand how it works
- not entirely clear how it's different from "mark as junk"
- you forward an email somewhere and never hear from that address, neiher do your colleagues
- would expect an onboaridng email with instructions after joining
- It's a collective effort
- Doesn't say how much it costs


Omnix:
a) I'd remove "Keep everyones inbox free from useless email." from the first feature box, it's a bit of an odd fragment and starting on the next sentence is much clearer and is the best explanation of "unwanted" on the page.
b) I wouldn't personally sign up without more knowledge of what clicking the Google signin button is going to do - will it start filtering email? Will I be able to opt in and try it? What costs? There are hints in the "No peeking" feature box, but it isn't fully explained. Maybe it needs a link to get more info rather than cluttering the main page.
c) It's a little unclear if "unwanted" is chosen by you or the user - does the user need to train it?

Malcolm:

At first glance, it looks good, is uncluttered, and the copy reads well.

What it does:
- I register to your service with Google
- I send you any emails from people/companies I don't want to hear from again
- The service creates org-wide filter rules that stop emails from those people being received by anyone at my company

Questions/concerns:
- I'd be interested in trying it out, and know what an email filter is, but I have some resistance to signing in. What am I authenticating with your service for? Is there a way I can see it in action without having to do that?
- It took a moment to grasp what the service does. This line made it click, "Wave goodbye to cold sellers, unwanted recuiters and services that you can't unsubscribe from, no matter how hard you try.". I wonder if that's worth communicating earlier in the page?

Ming:
[10:58 am, 09/11/2022] Ming: I understand what it does, I honestly thought outlook had similar functionality at a corporate level
[10:58 am, 09/11/2022] Ming: Like setting up spam filters or whatever, I get updates every couple of months from central pushed into my laptop, assume things like updated spam filters are included
[10:58 am, 09/11/2022] Ming: But I'm naive
[10:59 am, 09/11/2022] Ming: You don't have a pricing point or structure yet?  But I would expect that on another page
i think you need to talk to some HR / IT people to figure out how they deal with the problem of spam
[11:14 am, 09/11/2022] Ming: from a layman i really think the value (which you haven't really covered in the webpage) is stopping recruiters headhunting your staff.  Because that is the biggest cost and value to a SME who doesn't have central IT functiuon
[11:15 am, 09/11/2022] Ming: but ultimately, recruiters tend to get people through linkedin nowadays

Ria:
This is specifically arguing for EAs, but the stats are interesting: https://www.executivesecretarylive.com/wp-content/uploads/2020/10/Ebook-Email-Triage-System-Jan21.pdf

https://www.linkedin.com/pulse/open-letter-anyone-working-assistant-lucy-brazier/

"Execs spend 5h a day on email"

If you pitch it as saving X% of a team's time and what is that worth, I think you're golden

I'd use it in a heartbeat, especially now I know it's a 'skip the inbox' rather than 'disappear forever' situation. That was my only concern to be honest.

- recruiters message resonated, saves time

CP:
- I'd want to know who's creating what rules to avoid mistakes
- Would like to see stats of what emails got blocked, but not willing to allow peeking into email contents (senders are ok) - it's good to know the value it creates
- maybe a webhook so events can be fed into slack
- consider outlook/ms too
- sceptical of freemium - high support cost, questionable gains, devalues the product
- could charge more than $3 per user per month, just needs to demonstrate value
- could "pick a fight" with recruiters
- is there really no way to see senders/headers, but no content, so you can do stats

TFC:
- is happy with superhuman, but sees value in protecting others
- would be cool to have different roles e.g. everyone can suggest a block, but it needs to be reviewed by admins. Admin blocks go straight in

