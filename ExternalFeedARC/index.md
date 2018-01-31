User configures channel to use ARC.

Feed can be configured to be polled X seconds (only hits packages we know about)

Every 20 seconds:
 * Check all projects for used packages
 * Group by feed
 * Filter those with sync disabled
 * Pass the package list to the feed sync (some feeds might be optimal for multiple packages).

For each pacakage
* Update with the current list of versions.
* Some feeds may need to pull _all_ versions, others may be able to optimise: page until same packages returned.


On server startup this process needs to take place once before polling starts
We dont make any claims to be able to created releases for packages pushed while server was offline. Allows us to avoid storing in DB.

* Assuming _on average_ a version is XX.XX.XXX = 9 chars. 16 bytes a char = approx  **144 bytes per version**.
* Assuming 10 package builds per work day = 2600 versions per year = approx **0.3MB per year**
* Assuming 5 different Projects thats **1.5MB per year**.
* With GZIP in interim that comes to **<2% (30K)**

### Scenarios
* User creates release for _1.0.0_
    1. _v1.0.1_ pushed: **ARC Triggers**
    2. _v0.5.0_ Pushed: **ARC Triggers??**

* User has two channels with the following rules
    * [1.0, 2.0) - Master
    * [2.0,] - Dev
    1. _v2.1_ pushed: **ARC Triggers Dev**
    2. _v1.5_ pushed: **ARC Triggers DEV**
    3. _v0.1_ pushed: **No Trigger**

* User has two channels with the following rules
    * _null_ - Master
    * ^alpha.*$ - Hotfix
    1. _v2.1_ pushed: **ARC Triggers Master**
    2. _v2.1-alpha.2_ pushed: **ARC Triggers Hotfix _& Master_??**

