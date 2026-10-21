+++
title = "VPS Setup"
description = "Lightweight setup for a server hosting multiple containerized applications."
weight = 5

[extra]
tags = ["Docker", "Compose", "containers", "infra", "cloud"]
links = [
  { name = "source", url = "https://github.com/GrossNate/my-shared-server" }
]
mermaid_icons = ["thesvg:caddy", "thesvg:docker", "thesvg:nginx", "la:node-js", "material-symbols:database", "material-symbols:person"]
+++

## The problem

I had a few projects ready to deploy and a number of others planned in the near
future and I didn't want to spend a lot of time setting up hosting for each new
app/site or make ad hoc modifications to an nginx configuration every time. I'm
drawn to infrastructure-as-code solutions, but Kubernetes, Terraform, or Pulumi
are serious overkill for what I'm trying to accomplish. I also don't want to get
locked into a specific Cloud provider, so that eliminates another batch of
solutions.

## What I built

My VPS setup runs in Docker Compose and uses Caddy as a reverse proxy to route
traffic to the individual apps running on the server. It includes a separate
`compose.yml` file for each site or application that will pull image(s) from
a container registry. It's a relatively simple structure, but it's enough to
make deploying a new application into a repeatable process that takes only a few
minutes.

### Architecture diagram of VPS[^1]
{% <mermaid> %}
architecture-beta
    service user(material-symbols:person)[User]
    group router(thesvg:docker)[Docker Compose]
        service caddy(thesvg:caddy)[Reverse Proxy] in router
        group grossdev[gross.dev site] in router
          service grossdev_nginx(thesvg:nginx)[site] in grossdev
        group requesthole[RequestHole app] in router
          service requesthole_nginx(thesvg:nginx)[front end] in requesthole
          service requesthole_backend(la:node-js)[back end] in requesthole
        service docker_data(material-symbols:database)[Docker volume] in router
    user:B -- T:caddy
    caddy:B -- T:grossdev_nginx
    caddy:B -- T:requesthole_nginx
    requesthole_nginx:B -- T:requesthole_backend
    requesthole_backend:L -- R:docker_data
    align row grossdev_nginx requesthole_nginx
    align column requesthole_nginx requesthole_backend
    align row docker_data requesthole_backend
{% </mermaid> %}

## Technical decisions/notes

- It might seem strange to use Caddy *and* Nginx, but I did this because Caddy
  handles SSL certificates automatically. This greatly simplifies adding a new
  application or site for a new domain.
- I haven't set up any sort of deployment automation. While this wouldn't be
  too difficult (and I've done this on another project), it's a level of
  complexity that's unnecessary for my personal projects.
- I haven't built a backup/restore or migration mechanisms for application data
  yet. That's because it's not necessary yet. While RequestHole does store
  data in a Docker Volume, it's not the sort of application where a user would
  expect their data to persist for any particular duration. I have a few
  projects in the pipeline that will require more careful data handling and I'll
  improve that aspect of this setup when the time comes.

[^1]: This Mermaid diagram was lovingly handcrafted. I hope it helps you
      understand the architecture, but if not then at least I still had fun
      making it.