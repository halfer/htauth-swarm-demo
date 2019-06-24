Htauth/Swarm demo
===

Introduction
---

I have a need to create a very simple PHP-based control panel for a microservice API, and
the currrent plan is to deploy the control panel into AWS Fargate alongside the existing
containers. We would want some simple authentication on the control panel, which will
involve both IP filtering and a simple htauth username/password.

However, colleagues and I wondered if htauth would work with Fargate, since it will spin up
multiple instances of the same container, and thus any cookie state in PHP would disappear
and reappear as the load balancer invisibily switches from one container to another.

In fact, it turns out that in the htauth protocol, there _are_ no cookies - the credentials
are remembered by the browser and, I suspect, are presented and re-hashed on each request.
This means that we can still use this simple authentication system, even though we do not
have a central database to handle cookies.

Fork
---

This repository is a simplified fork of my [CD Demo Container](https://github.com/halfer/cd-demo-container),
which uses multiple Docker containers in a Swarm to achieve zero-downtime upgrades.

Preparation
---

On a Linux server, ensure that Docker is installed and ensure that Docker is in Swarm mode:

    docker swarm init

You can, optionally, add additional nodes to the Swarm, but it is not necessary for this
demonstration.

Usage
---

Firstly, clone this repo:

    git clone https://github.com/halfer/htauth-swarm-demo.git
    cd htauth-swarm-demo

Then, build the Docker image and give it a tag (say `0.1` in this example):

    docker build -t http-auth-swarm-demo:0.1 .

Finally, create a new service for this image. The exact number of replicas does not
matter, as long as it is more than one. You can also swap the host-side port number
to something other than 80 if that is already taken on your machine:

    docker service create \
        --name htauth-swarm-demo \
        --replicas 4 \
        --publish 80:80 \
        htauth-swarm-demo:0.1

Finally, open `http://localhost` in your browser, and note the credentials provided.
Click on the "secret" page and enter the credentials to gain access, and then refresh
the page a few times to see the container GUID rotate (on my machine it seems to stick
with each container for 20-30 seconds, and then move on, so be patient).

On the secret page it reads the credentials from PHP, which suggests to me that
these details are passed via request headers, rather than creating server and client-side
cookies.

How it works
---

When the container starts up, it writes a GUID into the web server docroot, and this
remains static for the lifetime of the container. When you access the site via your
browser, the [Routing Mesh](https://docs.docker.com/engine/swarm/ingress/#using-the-routing-mesh)
will direct your requests to one of the available containers, based on an internal
networking algorithm.

Once you have authed into the secret page, your browser will send your credentials
with every page request, and thus even if the container changes (signfied by a change
of GUID) it will still work.

Upgrading
---

If you want to tinker with the code, go ahead! You will need to rebuild your image,
and give it a new version number, otherwise the Swarm will assume no container
replacements are necessary. Let us assume you bump up to `0.2`, and then you can upgrade
the image backing your container replicas:

    docker service update \
         --image htauth-swarm-demo:0.2 \
         htauth-swarm-demo

License
---

This material is licensed under the [MIT License](https://opensource.org/licenses/MIT),
which means you can pretty much do anything you like with it.
