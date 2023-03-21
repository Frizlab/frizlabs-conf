# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
m4_dnl Just does not support “import *” so we cannot just (haha) import the contents of a folder and be done with it.
m4_dnl Instead we have to do a template.
m4_ifelse(___M4___COMPUTER_GROUP___M4___, `work',m4_dnl

ssh-infra instance-name:
	gcloud --project happn-infra compute ssh --tunnel-through-iap {{ instance-name }}

ssh-preprod instance-name:
	gcloud --project happn-preprod compute ssh --tunnel-through-iap {{ instance-name }}

ssh-dev instance-name:
	gcloud --project happn-dev compute ssh --tunnel-through-iap {{ instance-name }}
)m4_dnl
