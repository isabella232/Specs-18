# Upload to S3 Step

Deploying applications to AWS generally involves uploading files to an S3 bucket.

There are a couple of options for this today, each with downsides:

- Use the community library [Amazon S3 Upload Step](https://library.octopusdeploy.com/step-templates/302e0653-e84e-4db6-be53-1ee1a56dea88/actiontemplate-amazon-s3-upload). The downside with this is that it requires the files to already be on disk.  Which requires running a _Deploy a Package_ step.  Which requires a Tentacle. Requiring a Tentacle to deploy to AWS is not ideal.  

- Script the upload to S3 yourself, and run the script from within a package (and set the step to _Run on Server_).  This will cause the package to be extracted on the Octopus Server (or a worker), and the files are then available to the script. The downsides here are first that you have to script it yourself, and second that this is not immediately obvious to a user not intimately familiar with Octopus. 

**tl;dr we need a built-in Upload to S3 step**

They are 3 ways you may wish to use this step:

- Option 1: Upload the entire package to S3
- Option 2: Upload a single file from a package
- Option 3: Upload multiple files from a package 

## Option 1: Upload the entire package to S3

![](ui-mocks/upload-to-s3-entire-package.png "width=500")

## Option 2: Upload a single file from a package

![](ui-mocks/upload-to-s3-single-file.png "width=500")

## Option 3: Upload multiple files from a package 

![](ui-mocks/upload-to-s3-multiple-files.png "width=500")


## Variable Substitution

When uploading single or multiple files from within a package, we will provide the ability to perform variable-substitution. For a single file upload, this will simply be a checkbox.  For multiple files, multiple globs can be supplied to select the files to perform substitution on.

We _could_ also provide the ability to extract, substitute, and repack the package when uploading an entire package. I'm not inclined to do this though.  Transforming config files doesn't seem to be best-practice when deploying to AWS. For example, when deploying an ElasticBeanstalk app, a better option seems to be to set [environment properties](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-softwaresettings.html).  These are then exposed as environment variables on some platforms, or via the `ConfigurationManager.AppSettings` class in [.NET apps](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_NET.container.console.html).  