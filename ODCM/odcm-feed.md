# ODCM Data Feed

Facilitie sharing of data between spaces.

## Objective

ODCM needs to facilitate sharing of 
 - Users
 - Step Templates
 - Server Extensions
 - Variables
 - Releases
 - Tentacles (Environments / Targets)
 
## Concepts
 ### Trust
 
 - Space B will only trust Space A, this is defined at the ODCM level and certificates are used to facilitate 
 
 ### Broker - This is ODCM
 
 - ODCM will be the broker/co-ordinator
 
 ### Feeds
 
 - 
 

## Scenario 1 : Shared Variables


## Scenario 2 : Air Gap

Barry Infrastructure has a new requirement for an application that does credit card processing that is to *truly issolate production*. 

He makes 2 spaces, `Dev-and-QA` and `Production`. `Dev-and-QA` can be an unrestricted set of machines and processes where the developers and QA people can spin up anything they need to get their jobs done.

But `Production` is now housing credit card data and other sensitive information, and for PCI compliance must have strict safeguards and policies for who can access and what gets deployed.

The Space that's being protected by an air gap:
 - Will only trust incoming packages
 - It will have the option to obtain these packages via:
   - A manual fetch mechanism this can be for the most restricted of set ups.
   - Polling if the service fetching is a requirement
   - Pushed to it (simplest)

## Scenario 3 : Stanard Environments

Barry Infrastructure wants to manage 1 all inclusive set of Environments (`a master list`), when Barry provisions a new Space he wants to be able to select from this list

   
## Implementation 

### Surface these items through as a Feed
 - Will be asynchronous; a `Space A` can "publish" via ODCM, and be offline when `Space B` fetches.
 - Optimize for performance; these feeds can be cached to alleviate direct load on the ODCM instance(s).
