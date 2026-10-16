+++
title = "GovQL"
description = "A public GraphQL API for accessing US Congressional data."
weight = 1

[extra]
tags = ["GraphQL", "API", "civic_tech"]
links = [
  { name = "site", url = "https://govql.us" },
  { name = "source", url = "https://github.com/govql/govql" }
]
+++

## The problem

I wanted to ~yell at~ provide constructive consituent feedback to one of my
senators on some of his votes on nominations. Rather than saying, "I disagree
with all the times you voted *x* way," I wanted to be able to say, "Over *x*
nomination votes you've voted *y* way *z* times. That's *p*% - more than all but
*q* senators in your party."

There are some sources for this type of data, but none were kept up-to-date in
the aggregate format I wanted. You can download vote data, one XML file at a
time, from [congress.gov](https://www.congress.gov) and there's even an API.
However, the API didn't cover Senate votes and, because it's a REST API, in
order to get all of a certain type of vote for a particular member of congress
would involve dozens (if not hundreds or thousands) of API calls.

Around the same time I happened to be playing with GraphQL and it occurred to me
that it could be quite useful to build a GraphQL API for government data. It
could give journalists and researchers an easier way to dig up interesting
insights. The idea languished for a while, but in early 2026 I had time to
launch the first version.

## What I built

- Give an architectural overview, some screenshots, etc.

## Technical decisions

- Keeping it performant on a $6/month DO droplet
- Limiting query complexity
- Postgraphile isn't a panacea - you have to think about the aggregations
- CI/CD - rolling your own