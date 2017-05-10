# ODCM Auth

Single Sign On / User & Group Management 

## Objective

Barry Infrastructure, as an ODCM administrator, will be able to control which groups of users have access to which Spaces. A group may consist of Users and/or external groups (i.e. those sourced from Active Directory or Azure AD).

Lisa Shipping, as a Space administrator, will be able to use Teams to manage which groups of users have which permissions in her Space, just like in Octopus today. For example, she could specify a Team which permits Developers to deploy things to the Dev environment. If Bob Specialist is a member of the Developer group in ODCM then when he is given access to the Space he'll be able to deploy to Dev immediately.

## Implementation


ODCM will be where it's all managed.
 - Create Users
   - Each user can have multiple external identity provider assocations
 - Setup Groups
 - Revoke User Access
 - It will make the User and Group list available as a Feed to the Spaces.


### JSON Web Tokens
 [Wikipedia](https://en.wikipedia.org/wiki/JSON_Web_Token) the .NET Implementation: [System.IdentityModel.Tokens.SecurityToken.JwtSecurityToken](https://msdn.microsoft.com/en-us/library/system.identitymodel.tokens.jwtsecuritytoken%28v=vs.114%29.aspx?f=255&MSPPError=-2147217396)

JWTs are encoded JSON strings, that have, 3 sections delimited by full stops
    - Header
	- Token
	- Checksum
	
	
	
Identity Token:
    - short lived - expirty scale: hours
	
Access Token:
    - only has an ID, like an API Key
	
	
	
	
	
	MIGRATION OF DOZENS of users
	across different spaces
	when they ENLIST 2 DOZEN instances as Spaces
	conflict resolution
	 - common account names
	 - maybe we can skip the admin (and using username/password)
	 - if it's AD - it'll be the same account
	 
	
	
	