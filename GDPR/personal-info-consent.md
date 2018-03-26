# PII Consent in Octopus

Not exactly an EULA, as this is not the purchaser (that EULA) is part of the installation, this is for the user supplying (or already supplied) personal identifiable information

## Requirement

Gather consent from users about the personal data and that will be stored. Along with making it clear, that actions they perform in the application are tracked. Their company (controller of Octopus) is the contact point for this.

## Proposed Changes

### EULA acceptance for all users

Gather consent via a UI modal dialog. If using the portal you have accept it, ALL USERS would be impacted after that installed version.

Modal dialog with terms, and accept button, needs checkbox that's not ticked by default.

![image](https://user-images.githubusercontent.com/119096/37906547-db494e22-3145-11e8-9dbe-a9faaca161b7.png)

#### Wording
Title: `Individual Privacy Agreement`
H3: `Your Personal Identifiable Information (PII)`
Content: 
```
The PII stored on this Octopus Deploy installation includes:
  - Full Name
  - Email address
  - Data related to 3rd party Single Sign On (SSO) services
  - Behavioral data, through the audit log actions including their time performed by you and maps directly to the other PII they have supplied

  Custom PII, includes any additional information you supply while using this application.
```

Checkbox: `I acknowledge and accept these categories of PII are stored about me`

### Revoking consent

User Profile, a `consent` tab. 

![image](https://user-images.githubusercontent.com/119096/37907379-3db5ec26-3148-11e8-8b67-fb445115075c.png)

It would explain they need contact their Octopus administrator to request this, and that there's caveats, audit data will not be purged. 

A future extension could be to send the admin an email on their behalf.

#### Withdrawal wording
```
You need to have given consent for Octopus to store Personal Identifiable Information in order to do your
tasks in Octopus Deploy. If you wish to revoke consent you will need to contact your
Octopus Administrator and discuss your options with them.
```

### No impact to API

Locking down the API to prevent users who haven't accepted seems heavy handed, and we would need to exclude service accounts to not break customer integrations. We know customers also use regular accounts for CI/CD integrations.
