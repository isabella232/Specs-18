# ODCM Data Feed

Facilitate sharing of data between spaces.

## Objective

ODCM needs to facilitate sharing of
 - Users
 - Step Templates
 - Server Extensions
 - Variables
 - Releases
 - Tentacles (Environments / Targets)

## Concepts

Terms / ideas

### Trust

 - Space B will only trust Space A, this is defined at the ODCM level and certificates are used to facilitate

### Broker

 - ODCM will be the broker/coordinator

### Feeds

 - A mechanism by which data is accessible, a known location to fetch/push data.


## Scenario 1 : Shared Variables

Barry Infrastructure has prepared some common infrastructure for the development teams to use, he would like to set up 1 set of variables that define connection strings and other related data once and make them available to any new space.

Barry can set these up once in an existing space, and "publish" them with unrestricted access to all other spaces. The ODCM will have a name for this variable set

## Scenario 2 : Air Gap

[Discussion Here](https://github.com/OctopusDeploy/Specs/issues/3)

Barry Infrastructure has a new requirement for an application that does credit card processing that is to *truly isolate production*.

He makes 2 spaces, `Dev-and-QA` and `Production`. `Dev-and-QA` can be an unrestricted set of machines and processes where the developers and QA people can spin up anything they need to get their jobs done.

But `Production` is now housing credit card data and other sensitive information, and for PCI compliance must have strict safeguards and policies for who can access and what gets deployed.

### Data Transmission Options

The Space that's being protected by an air gap:
 - Will only trust incoming packages
   - Configured certificates of trust will facilitate this, in the same way Octopus Deploy and Tentacles share trust.
 - It will have the option to obtain these packages via:
   - A manual fetch mechanism this can be for the most restricted of set ups.
   - Polling if the service fetching is a requirement
   - Pushed to it (simplest)

### Deployment Receipts
 - Optionally the Air Gapped Spaced can send back a "receipt" a signed audit log entry of what was deployed, when and by whom.

## Scenario 3 : Standard Environments

Barry Infrastructure wants to manage 1 all inclusive set of Environments (`a master list`), when Barry provisions a new Space he wants to be able to select from this list which Environments will populate the new Space.

The objective here is that Barry can very quickly get a usable space up for a development team.


# Implementation Considerations

## Feed

Surface *all* these items through as a Feed

 - Will be asynchronous; a `Space A` can "publish" via ODCM, and be offline when `Space B` fetches.
 - Optimize for performance; these feeds can be cached to alleviate direct load on the ODCM instance(s).

## Big Spaces

The real world problems of large spaces may still exist, if a given customer still has a space larger than is ideal, we still need to ensure communication taking with that space has no negative impact on ODCM and vice versa.

Factor in:
 - Configuration options for how data is transmitted, push/pull and frequency
 - That this does not have an impact on the concurrent task caps inside Octopus Deploy (health checks on some customers installations take ages)
