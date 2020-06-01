# basicauth-rproxy-perpath
Apache httpd configured as a reverse proxy.  It protects the upstream service using basic auhthentication.  The usernames and passwords for are stored in a DynamoDB table.

This is packaged as a Docker container and it is available here https://hub.docker.com/r/richardjkendall/basicauth-rproxy-perpath

This is based on the pam-dynamo module (which provides a PAM interface to usernames/passwords stored in DynamoDB).  The base image of this is here https://hub.docker.com/r/richardjkendall/ubuntu-pam-dynamo

## Configuration
The container uses a number of environment variables to pass in configuration.  They are defined below:

|Variable|Purpose|Example|
|---|---|---|
|UPSTREAM|The backend service that requests should be sent to.  Should only be the DNS name/IP address and port + a trailing slash, no scheme.  Only supports HTTP backends|server:port/
|FOLDERS|The paths that need to be protected (or not) with basic authentication.  Should JSON, an array of objects.|*see example below*|
|REGION|The AWS region containing the DynamoDB table with the usernames and passwords.  Can be any valid AWS region.|ap-southeast-2|
|TABLE|The name of the DynamoDB table containing the usernames and passwords.|basicAuthUsers|
|REALM|The name of the realm being used for this deployment|test|
|CACHE_FOLDER|The path of the folder being used to store the user cache|/tmp/cache|
|CACHE_DURATION|The duration of the caching in seconds|120|

### Example folders config
The folders variable expects a JSON string which is an array of objects where each object is the following:

```json
{
  "folder": "<path>",
  "auth": "<yes or no>"
}
```

Where ``auth`` is set to yes the path will be protected by basic auth and where it is set to no it will not be protected by basic auth.

The ``auth`` setting can be used to allow sub-folders to be public while their parents are protected, for example:

```json
[
  {
    "folder": "/",
    "auth": "yes"
  },
  {
    "folder": "/events",
    "auth": "no"
  },
]
```

This would allow the ``/events`` path to be public while the root is protected.

### DynamoDB table
The expected structure and content of the DynamoDB table is here https://github.com/richardjkendall/pam-dynamo
