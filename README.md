# CCD/SSCS Docker :whale:

- [Quick start](#Quick start)
- [Elastic search](#elastic-search)

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) - minimum version 2.0.57 
- [jq Json Processor] (https://stedolan.github.io/jq)
- [Docker](https://www.docker.com)
- [Java 8](https://www.java.com)

You can increase the memory available to Docker from the Preferences|Advanced options on your Docker installation. We recommend allocating 12G. The SIDAM containers
are quite hungry.

## Quick start

First...

	cp .env.example .env

Then make the necessary changes at the top of the file.

***Note*** If you find yourself in a bit of a mess, you may want to destroy all your containers and images with the following command. This will make bringing it all up again slower as it will need to download the images again.

```bash
./bin/docker-clean.sh
```

## Getting Started (assuming idam stub used)

The first time you run the docker containers, you will need to pull the containers and setup the roles. This can be done with this script:

```bash
./bin/compose-up-full.sh
```

Each subsequent time after you can just run this to restart the containers:

```bash
./bin/compose-up.sh
```

## Switching between Idam stub and Idam
It's possible to disable the Idam containers and run CCD with an Idam Stub provided by ccd-test-stubs-service. This is useful as a back up plan for when docker Idam is broken or when you local machine is running low on memory and you don't want to spin up the whole Idam containers

### Enable Idam Stub

#### Step 1 - Disable Sidam containers

make sure 'sidam', 'sidam-local', 'sidam-local-ccd' docker compose files are not enabled. How you do that depends on your currently active compose files.
When no active compose files are present, the default ones are executed. But if there's any active, then the defautl ones are ignored. For example:

```bash
./ccd enable show

Currently active compose files:
backend
frontend
sidam
sidam-local
sidam-local-ccd

Default compose files:
backend
frontend
sidam
sidam-local
sidam-local-ccd
```

In this case sidam is currently explicitly enabled. To disable it:

```bash
./ccd disable sidam sidam-local sidam-local-ccd
```

If you are instead running with the default compose file as in:
```bash
./ccd enable show

Default compose files:
backend
frontend
sidam
sidam-local
sidam-local-ccd
```

You must explicitly enable only CCD compose files but exclude sidam:

```bash
./ccd enable backend frontend
./ccd enable show

Currently active compose files:
backend
frontend

Default compose files:
backend
frontend
sidam
sidam-local
sidam-local-ccd
```

#### Step 2 - Setup Env Vars

in the '.env' file, uncomment:

```yaml
#IDAM_STUB_SERVICE_NAME=http://ccd-test-stubs-service:5555
#IDAM_STUB_LOCALHOST=http://localhost:5555
```

To allow definition imports to work ('ccd-import-definition.sh') you need to:

```bash
export IDAM_STUB_LOCALHOST=http://localhost:5555
```

:warning: Please note: remember to unset 'IDAM_STUB_LOCALHOST' when switching back to the real Idam, otherwise definition import won't work

```bash
unset IDAM_STUB_LOCALHOST
```

#### Step 3 - (Optional) Customise IDAM roles

IDAM Stub comes with a predefined IDAM user.\
To permanently customise the stub user info such as its roles follow the instructions in 'backend.yml' -> ccd-test-stubs-service\
To modify the user info at runtime, see https://github.com/hmcts/ccd-test-stubs-service#idam-stub

#### Step 4 - Enable stub service dependency

Enable ccd-test-stubs-service dependency on ccd-data-store-api and ccd-definition-store-api in 'backend.yml' file.

Uncomment the below lines in 'backend.yml' file
```yaml 
      #      ccd-test-stubs-service:
      #        condition: service_started
```

Comment the below lines in 'backend.yml' file
```yaml 
      idam-api:
        condition: service_started
```


#### Step 5 - bringing it up

To bring up the containers, run the following from the root directory of the cloned repository:

```bash
./bin/compose-up.sh
```

#### Step 6 - import CCD definition

To import the CCD definition locally, please follow instructions in the sscs-ccd-definitions README. 


### Revert to Idam

#### Step 1 - Enable Sidam containers

```bash
./ccd enable sidam sidam-local sidam-local-ccd
```

or just revert to the default:

```bash
./ccd enable default
```

#### Step 2 - Setup Env Vars

in the '.env' file, make sure the following env vars are commented:

```yaml
#IDAM_STUB_SERVICE_NAME=http://ccd-test-stubs-service:5555
#IDAM_STUB_LOCALHOST=http://localhost:5555
```

then from the command line:

```bash
unset IDAM_STUB_LOCALHOST
```

#### Step 3 - Disable stub service dependency

Disable ccd-test-stubs-service dependency on ccd-data-store-api and ccd-definition-store-api in 'backend.yml' file.

Comment the below lines in 'backend.yml' file
```yaml 
    #   ccd-test-stubs-service:
    #       condition: service_started
```

Uncomment the below lines in 'backend.yml' file
```yaml 
      idam-api:
        condition: service_started
```

#### Step 4 - bringing it up

To bring up the containers, run the following from the root directory of the cloned repository:

```bash
./bin/compose-up-idam-full.sh
```

#### Step 5 - import CCD definition

To import the CCD definition locally, please follow instructions in the sscs-ccd-definitions README. 


### Switching between Idam and Idam Stub Example

```bash
#assuming no containers running and Idam is enabled

#start with Idam
./ccd compose up -d

#services started

./ccd compose stop

#enable Idam Stub follwing the steps in 'Enable Idam Stub'

#start with Idam Stub
./ccd compose up -d

#services started

you also can issue a 'down' when Idam Stub is enabled without risking of losing Idam data, since it's disabled
./ccd compose down

enable Idam follwing the steps in 'Revert to Idam'

#start with Idam. This will now create new CCD containers and reuse the old Idam ones
./ccd compose up -d
```

NOTE: :warning: always use 'compose up' rather than 'compose start' when switching between Idam and Idam Stub to have docker compose pick up env vars changes.


### Ready for take-off 🛫

You can now visit [http://localhost:3451](http://localhost:3451) (for CCD) or [http://localhost:3455](http://localhost:3455) (for Expert UI).

If not using the idam stub, you can log in using
 
    local.test@example.com
    Pa55word11

### Optional Compose Containers

Optional compose files can be found in the /compose directory. You can enable any of the optional container setups with a command such as:

    ./ccd enable pdf-service-api
    
And then run the following command:

    ./ccd compose up -d

### Replace Callback Urls

To manually replace the callback URLs you can run this script:

    ./gradlew run --args="~/defintions/CCD_SSCSDefinition_v5.1.01_AAT.xlsx url-swaps.yml"

### Import Case Definition

To manually import the case definition you can run this script:

    ./bin/ccd-import-definition.sh ~/defintions/CCD_SSCSDefinition_v5.1.01_AAT.xlsx
    
##Elastic Search

Some parts of the SSCS service require Elastic Search to be running in order to find cases. However, it is not recommended that this is always running as it uses a significant amount of RAM and can cause performance problems on your local environment.

The following use cases need Elastic Search:

- When submitting a case through SYA or Bulk scan, Elastic Search is required for the duplicate case check (same Mrn date/benefit type/nino)
- Logging into MYA (with appeal ref number in link) for an appellant, appointee, rep or joint party
- Linking a case to other similar cases (e.g. same nino, different mrn) for SYA and Bulk scan
- Case loader when it can't find a case by case id so instead uses the GAPS case reference 

### Starting Elastic Search for Development

- Set the ES_ENABLED_DOCKER environment variable to true in your `.env` file

- By default, ccd-logstash filters out SSCS cases. Therefore, we need to point logstash to the sscs config, build a local docker image and point sscs-docker at this new ccd-logstash image. To do this:
  
  1. Check out the https://github.com/hmcts/ccd-logstash project
  
  2. Run the `./bin/build-logstash-instances.sh` script
    
  3. In SSCS-Docker, update your ccd-logstash to use this local image by going to `elasticsearch.yaml` and setting the image to `image: "ccd/sscs-logstash:1.0"`
  
  4. Enable Elastic Search and logstash containers by adding `elasticsearch` to `tags.env` in SSCS-Docker

  5. Restart all docker containers. (Note: the first time I tried this it did not work and I had to restart my laptop in order for Elastic Search to be picked up)
    
  6. Reimport CCD definition file. When adding a CCD definition file elastic search indexes will be created. To verify, you can hit the elastic search api directly on localhost:9200 with the following command. It will return all stored indexes:
```shell script
curl -X GET http://localhost:9200/benefit_cases-000001
```

Note: if you start elastic search after having existing cases, these cases will not be searchable using ES.

### Useful Elastic Search commands:

The following command will return all cases currently indexed:
```shell script
curl -X GET http://localhost:9200/benefit_cases-000001/_search
```

The following command will return all indices on Elastic Search:
```shell script
curl -X GET http://localhost:9200/_cat/indices
```

This is an example of an Elastic Search query looking for a case reference of 1234: 
```shell script
curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "reference": "1234"
    }
  }
}
'
```

### CoreCaseDataApi Elastic Search Endpoint
    
You can search on local envs using this endpoint: `localhost:4452/searchCases?ctid=case_type`

An example of a JSON search query which would return any cases where the reference is 1234:
```json
{
    "query": {
        "match" : {
          "reference" : "1234"
        }
    }
}
```

Please see [ES docs - start searching](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-search.html) for more
examples of search queries.

Example curl:
```shell script
curl --location --request POST 'localhost:4452/searchCases?ctid=case_type' \
--header 'Content-Type: application/json' \
--header 'Authorization: <auth-token> \
--header 'ServiceAuthorization: <service-auth-token> \
--data-raw '{
  "query": {
    "match" : {
      "reference" : "1234"
    }
  }
}'
```

Example response:
```json
{
    "total": 1,
    "cases": [
        {
            "id": 1234,
            "jurisdiction": "jurisdiction",
            "state": "Open",
            "version": null,
            "case_type_id": "case_type",
            "created_date": "2020-03-09T16:05:01.742",
            "last_modified": "2020-03-09T16:05:01.745",
            "security_classification": "PUBLIC",
            "case_data": {},
            "data_classification": {
                "creatorId": "PUBLIC"
            },
            "after_submit_callback_response": null,
            "callback_response_status_code": null,
            "callback_response_status": null,
            "delete_draft_response_status_code": null,
            "delete_draft_response_status": null,
            "security_classifications": {
                "creatorId": "PUBLIC"
            }
        }
    ]
}
```

## To enable elastic search

NOTE: we recommend at lest 6GB of memory for Docker when enabling elasticsearch
    *  ./ccd enable elasticsearch (assuming backend is already enabled, otherwise enable it)
    *  export ES_ENABLED_DOCKER=true
    *  verify that Data Store is able to connect to elasticsearch: curl localhost:4452/health

## To enable **logstash**  

  `./ccd enable logstash` (assuming `elasticsearch` is already enabled, otherwise enable it)

 To run **service specific logstash instance**
   * First build the local log stash instances for all services using instructions on ccd-logstash [ccd-logstash](https://github.com/hmcts/ccd-logstash)
   * Export CCD_LOGSTASH_SERVICES environment variable to use service specific logstash instances
   * If CCD_LOGSTASH_SERVICES is not exported, then `ccd-logstash:latest` will be used
   * Make sure to set the below two environment variables in `.env` file
   * By default CCD_LOGSTASH_REPOSITORY_URL is point to remote repository `hmctspublic.azurecr.io`, this is defined in `.env` file.

 ```bash
     CCD_LOGSTASH_REPOSITORY_URL=hmctspublic.azurecr.io
 ```
   
    For local docker repository please change the values as below
    
 ```bash
     CCD_LOGSTASH_REPOSITORY_URL=hmcts
 ```
    * To run service specific instances of logstash, give service names a comma serparated string as below
    
 ```bash
     export CCD_LOGSTASH_SERVICES=divorce,sscs,ethos,cmc,probate
 ```

    * To run all service instances of logstash
    
 ```bash
     CCD_LOGSTASH_SERVICES=all
 ```

## LICENSE

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
