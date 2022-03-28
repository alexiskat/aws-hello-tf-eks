#!/bin/bash

if [ "$1" = "" ]
then
		echo "Usage: $0 <tag to release>"
	  exit
fi
set  -euf -o pipefail
TAG=$1

read -p "Please, confirm the environment (e.g. dev, preprod, prod)? " -r
ENV=$REPLY

read -p "Please, confirm the operation (e.g. apply, plan)? " -r
OPT=$REPLY

TAG_CONFIRMATION="${ENV}-infra-${OPT}"

if [[ ! $TAG_CONFIRMATION = $TAG ]]
then
  echo "Did you mean to deploy to ${TAG}?"
  exit 1
fi


set  -euf -o pipefail

echo "Deleting tag ${TAG} if present"

git tag -d $TAG & git push --delete origin $TAG || true

echo "Creating and pushing tag ${TAG}"
git tag $TAG && git push origin $TAG
