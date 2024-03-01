# Steps

1. docker pull ghcr.io/dbt-labs/dbt-bigquery:1.6.7
1. brew untap dbt-labs/dbt
1. brew tap dbt-labs/dbt-bigquery
   this is a huge run just to pull down and call dbt init
   dbt init is not available on just the cli :sad-face"
1. dbt init cust-analytics
1. add query to your .sql file
   we don't think schema is required
   also the name in profiles.yaml needs to match your dbt_profile.yaml
1. download keys file for local testing... I think we will use oauth for cloud run and that is just a service account issue
1. create queries
1. run dbt 
1. build http server
    I don't like having to do this, but it is just the endpoint for scheduler to call
1. build docker image
    from example
1. deploy docker image
    from example
1. build cloud run
1. build schedule

# Goal
* ~in legacy project take data from public data set~
* run transformation on a schedule
* ~add to 2~or more tables

# prod requirements
* artifact registry for docker image
* cloud run api
* cloud scheduler api
* service account for cloud run to be able to access datasets? 

# problems? 
* you have to have an http server that invokes dbt.
