#!/bin/bash
#
# Install, register, start GitLab Runner on Mac
#
# Reference: http://docs.gitlab.com/ce/ci/docker/using_docker_build.html
# https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/install/osx.md
#
# Requirements
# If you need to build docker, install Docker for Mac: https://docs.docker.com/engine/installation/mac/
# Gitlab repoistory runner token, put it in ~user/.gitlab-runner/ci-token 
# Gitlab server name, put it in ~user/.gitlab-runner/ci-server: e.g. https://example-ci.com/ci

runnerPlist="$HOME/gitlab-runner.plist"
runnerToken="$HOME/.gitlab-runner/ci-token"
gitlabCI="$HOME/.gitlab-runner/ci-server"

# Download binary
function download(){
  runnerUrl=https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-darwin-amd64
  sudo curl --output /usr/local/bin/gitlab-ci-multi-runner $runnerUrl
  sudo chmod +x /usr/local/bin/gitlab-ci-multi-runner
}

# Update
function update(){
  cmd=stop
  start_stop_status
  download
  cmd=start
  start_stop_status
}

# Run the following as regular user 
function register(){
  gitlab-ci-multi-runner register -n \
    --url $gitlabCI \
    --registration-token $runnerToken \
    --executor shell \
    --tag-list shell \
    --description "Runner On Mymac"
  gitlab-ci-multi-runner start
}

# Install
function install(){
  cd $HOME
  if [ -f "$runnerPlist" ];
  then  
   echo "Runner is instaled already - $runnerPlist already exist."
   exit 0
  else
    gitlab-ci-multi-runner install
  fi
}

# Start, stop, status
function start_stop_status(){
  gitlab-ci-multi-runner $cmd
}

# Uninstall
function uninstall(){
  gitlab-ci-multi-runner stop 
  if [ -f "runnerPliust" ];
  then
      gitlab-ci-multi-runner uninstall
  else
      echo "Runner plist file doesn't exist. Nothing to uninstall."
  fi
}

if [ ! -x "/usr/local/bin/gitlab-ci-multi-runner" ]; then
  download
fi

if [[ ! -f "$runnerToken" ]] || [[ ! -f "$gitlabCI" ]];
then
  echo "Please get GitLab runner token and store it in $runnerToken."
  echo "Please put GitLab server name url in $gitlabCI"
  exit 1
else
  runnerToken=$(cat $HOME/.gitlab-runner/ci-token)
  gitlabCI=$(cat $HOME/.gitlab-runner/ci-server)
fi

cmd=$1
case $cmd in
  start|stop|status)
    start_stop_status
    ;;
  install|uninstall|register|update)
    $cmd 
    ;;
  *)
    echo "Unknown command $cmd."
    echo "./$0 stop|start|status|install|uninstall|register|update"
    exit 1
    ;;
esac
