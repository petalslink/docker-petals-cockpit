# Docker image for Petals Cockpit

This image allows to run a Petals Cockpit server.  
Petals cockpit in an administration tool providing a visual interface for Petals ESB instances.

For the first run, remember to take a look at the terminal, where you should find an URL with a user setup token.

> For the moment, JMX connections do not work outside the container.

## Launch a container from this image

```properties
# Download the image
docker pull petalslink/petals-cockpit:latest

# Start in detached mode
docker run -d -p 8080:8080 --name petals-cockpit petalslink/petals-cockpit:latest

# Verify the container was launched
docker ps

# Watch what happens
docker logs petals-cockpit

# Verify the ports used on the host (example)
sudo lsof -i :8080

# Get information about the container
docker inspect petals-cockpit

# Introspect the container
docker exec -ti petals-cockpit /bin/bash
```

The example shows how to get the last version.  
You can obviously change the version. Each Petals container version has its own image.
Versions match. As an example, to get Petals Cockpit 0.20.0, just type in `docker pull petalslink/petals-cockpit:0.20.0`.

## Build an image (introduction)

This project allows to build a Docker image for both tagged releases and the last snapshot versions of Petals Cockpit.  
The process is a little bit different for each case. All of this relies a Docker build arguments.

| Argument | Optional | Default | Description |
| -------- | :------: | :-----: | ----------- |
| COCKPIT_VERSION | yes | `LATEST` | The version of the Petals Cockpit distribution to use. `LATEST` is the latest stable release, `SNAPSHOT` is the latest build (may be unstable). You can also specify the tagged version number for instance: `0.21.0`. |

By using these parameters correctly, you can achieve what you want, provided the artifact is present on gitlab.

## Build an image (examples)

### Stable version

The example is quite simple to understand.

```
docker build \
		--build-arg COCKPIT_VERSION=0.21.0 \
		-t petalslink/petals-cockpit:latest \
		-t petalslink/petals-cockpit:0.21.0 \
		.
```

The **latest** tag for Docker should only be used if this is the last released version of Petals Cockpit.

### Unstable latest version

Just use the `SNAPSHOT` keyword:

```
docker build \
		--build-arg PETALS_VERSION=SNAPSHOT \
		-t petalslink/petals-cockpit:unstable \
		-t petalslink/petals-cockpit:0.22.0-SNAPSHOT \
		.
```

Such images should not be shared on Petals's official repository.

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
