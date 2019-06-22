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

FIXME https://github.com/halfer/cd-demo-container

Preparation
---

FIXME

Usage
---

FIXME

License
---

This material is licensed under the [MIT License](https://opensource.org/licenses/MIT),
which means you can pretty much do anything you like with it.
