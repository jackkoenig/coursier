#!/usr/bin/env bash
set -ev

cd "$(dirname "${BASH_SOURCE[0]}")/.."

if [ "$TRAVIS_BRANCH" != "" ]; then
  source scripts/setup-build-tools.sh
  npm install
  npm install bower
  git checkout -- package.json
  export PATH="$PATH:$(pwd)/node_modules/bower/bin"

  mkdir -p target
  git clone https://github.com/coursier/versioned-docs.git target/versioned-docs
  cd target/versioned-docs
  cp -R versioned_docs versioned_sidebars versions.json ../../doc/website/
  cd -
fi

git status

mill -i all doc.publishLocal doc.docusaurus.yarnRunBuild doc.docusaurus.postProcess

if [ "${PUSH_WEBSITE:-""}" = 1 ]; then
  ./scripts/push-website.sh
fi

