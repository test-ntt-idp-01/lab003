#!/bin/bash 
# creating pr and getting url
PR_LINK=$(gh pr create -B main -b "adding new redis component to iac" -t "deployed with github actions" -R test-ntt-idp-01/lab003-dev -H custom-new-branch)
echo $PR_LINK
# getting pr id
PR_ID+$(echo "$PR_LINK" | tail -n1 | cut -d "/" -f7)
echo $PR_ID
# approving pr
gh pr merge -a -R test-ntt-idp-01/lab003-dev  $PR_ID