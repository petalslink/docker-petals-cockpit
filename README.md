# Docker image for Petals Cockpit

This image allows to run a Petals Cockpit server.  
Petals cockpit in an administration tool providing a visual interface for Petals ESB instances.

For the first run, remember to take a look at the terminal, where you should find an URL with a user setup token.

## Launch a container from this image

```properties
# Download the image
docker pull petals/petals-cockpit:latest

# Start in detached mode
docker run -d -p 8080:8080 --name petals-cockpit petals/petals-cockpit:latest

# Verify the container was launched
docker ps

# Watch what happens
docker logs petals-cockpit

# Verify the ports used on the host (example)
sudo lsof -i :8484

# Get information about the container
docker inspect petals-cockpit

# Introspect the container
docker exec -ti petals-cockpit /bin/sh
```

The example shows how to get the last version.  
You can obviously change the version. Each Petals container version has its own image.
Versions match. As an example, to get Petals Cockpit 0.20.0, just type in `docker pull petals/petals-cockpit:0.20.0`.

## Run parameters

When running Petals Cockpit by a docker image, a default administrator user is added automatically:
* username: `admin`
* user: `admin`
* password: `admin`

It is possible to change this user with the following parameters: 

| Argument | Optional | Default | Description |
| -------- | :------: | :-----: | ----------- |
| COCKPIT_USERNAME | yes | `admin` | The user's id, also his login. |
| COCKPIT_NAME | yes | `admin` | The name under which the user will appear. |
| COCKPIT_PASS | yes | `admin` | The user's password. |
| COCKPIT_WORKSPACE | yes | - | The user's workspace. Which will be set as current workspace for the user.  **Beware, only compatible with version 0.22.0 or higher.** |

> An user added with parameters is always added as an admin.

## Run with parameters example
It is pretty straightforward :
```
docker run \
	-p 8080:8080 --name petals-cockpit \
	-e COCKPIT_USERNAME="user001" \
	-e COCKPIT_NAME="myName" \
	-e COCKPIT_PASS="myOwnPassword" \
	-e COCKPIT_WORKSPACE="myWorkspace" \
	petals/petals-cockpit:latest
```

## Build an image (introduction)

This project allows to build a Docker image for both tagged releases and the last snapshot versions of Petals Cockpit.  
The process is a little bit different for each case. All of this relies a Docker build arguments.

| Argument | Optional | Default | Description |
| -------- | :------: | :-----: | ----------- |
| COCKPIT_VERSION | yes | `LATEST` | The version of the Petals Cockpit distribution to use. `LATEST` is the latest stable release, `SNAPSHOT` is the latest build (may be unstable). You can also specify the tagged version number for instance: `v0.21.0`. |

By using these parameters correctly, you can achieve what you want, provided the artifact is present on gitlab.

Workspace generation feature is compatible with `SNAPSHOT`and version `0.22.0` (or higher) builds, see run parameters.

## Build an image (examples)

### Stable version

The example is quite simple to understand:

```
docker build \
		--build-arg COCKPIT_VERSION=LATEST \
		-t petals/petals-cockpit:latest \
		-t petals/petals-cockpit:0.21.0 \
		.

```
It's also possible to choose a [specific tag](https://gitlab.com/linagora/petals-cockpit/tags):

```
docker build \
		--build-arg COCKPIT_VERSION=v0.21.0 \
		-t petals/petals-cockpit:latest \
		-t petals/petals-cockpit:0.21.0 \
		.
```

The **latest** tag for Docker should only be used if this is the last released version of Petals Cockpit.

### Unstable latest version

Just use the `SNAPSHOT` keyword:

```
docker build \
		--build-arg COCKPIT_VERSION=SNAPSHOT \
		-t petals/petals-cockpit:unstable \
		-t petals/petals-cockpit:0.22.0-SNAPSHOT \
		.
```

Such images should not be shared on Petals's official repository.

## Publish the image on Docker Hub

This section is obviously reserved to those that have access to the petals organization.  
**It is assumed you already built the image locally and tested it.**

```properties
# Define your properties
DOCKER_HUB_USER=""
DOCKER_HUB_PWD=""
COCKPIT_VERSION="0.21.0"

# Connect to the hub
docker login -u=${DOCKER_HUB_USER} -p=${DOCKER_HUB_PWD}

# Push the image
docker push petals/petals-cockpit:${COCKPIT_VERSION}
docker push petals/petals-cockpit:latest

# Log out
docker logout

# Tag the Git repository
git tag -a -f "docker-petals-cockpit-${PETALS_VERSION}" -m "Dockerfile for Petals Cockpit ${RELEASE_VERSION}"
git push --tags origin master
```

## Supported Docker versions

This image is officially supported on Docker version 1.9.0.  
Please see [the Docker installation documentation](https://docs.docker.com/install/)
for details on how to upgrade your Docker daemon.

## License

These images are licensed under the terms of the [AGPLv3](https://www.gnu.org/licenses/agpl-3.0.fr.html).

## Documentation

Documentation and sources for Petals Cockpit can be found [on gitlab](https://gitlab.com/linagora/petals-cockpit)

Documentation for Petals ESB can be found on [its wiki](https://doc.petalslink.com).  
You can also visit [its official web site](http://petals.ow2.org).
