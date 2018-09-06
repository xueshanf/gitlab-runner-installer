# gitlab-runner-installer

This scripts automates Gitlab runner setup for Mac. It downloads, registers itself to a GitLab server, installs and starts the runner service.

This runner is a shell excecutor. __.gitlab-ci.yml__ example is a docker image build job [example](https://github.com/xueshanf/docker-nodeapp.git).

Docker For Mac needs to be installed in order to build docker images.

# Usage example

## Clone the repo

```console
$ git clone https://github.com/xueshanf/gitlab-runner-installer.git
```

## Configuration

Store Gitlab repoistory runner token in ~/.gitlab-runner/ci-token
Store Gitlab server endpoint in ~/.gitlab-runner/ci-server: e.g. https://example-ci.com/ci

## Start the service

```console
$ cd gitlab-runner-installer
$ ./gitlab-runner-wrapper.sh download
$ ./gitlab-runner-wrapper.sh register
$ ./gitlab-runner-wrapper.sh install
$ ./gitlab-runner-wrapper.sh start
$ ./gitlab-runner-wrapper.sh verify
./gitlab-runner-wrapper.sh verify
WARNING: Running in user-mode.

Verifying runner... is alive                        runner=6ef5aa1f
```

For all other commands:

```console
$ gitlab-runner --help
```

## Stop the runner service

```console
$ gitlab-runner stop
```
