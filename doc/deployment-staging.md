# Deploying to staging environment (registers-frontend-research)

We have a staging environment named `registers-frontend-research`

## Deploying
Deploys are performed from your local machine using the CF CLI

*From your checkout directory*
```
npm install
cf login
cf target -s sandbox
cf push -f manifest-research.yml
```

## Logging in
https://registers-frontend-research.cloudapps.digital/ is protected by basic auth. To find the credentials run:
```
cf target -s sandbox
cf env research-basic-auth-service | grep 'User-Provided' --a 2
```

## Populating register data 
See [Populating data on sandbox](../README.md#sandbox)