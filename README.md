# Bare Bones DBT

In this tutorial, we'll walk through setting up a minimal project using DBT (Data Build Tool) for data transformation. We'll cover setting up the environment, creating queries, running transformations, and deploying to production. I setup this project, because I am trying to figure out how to spin up my own dbt project on my own data set. Existing tutorials use [jaffle_shop]() data and well established dbt projects. I just wanted to figure out the minimum needed to run re-occuring data transforms using DBT.

This example does use BQ, but I am going to try to keep the tutorial as agnostic as possible. 

## Project Goal
The goal of this project is to take data from a public dataset, perform transformations using DBT, and schedule these transformations to run on a regular basis. The transformed data will be added to one or more target tables for analysis. We will divide the steps into two parts: 

- Part 1: DBT setup
- Part 2: GCP deploy

## Part 1: setup DBT

### Prerequisites
- Basic knowledge of SQL
- Access to a cloud provider (e.g., Google Cloud Platform for BigQuery)
- Working terminal environment. I am running on a mac, so my instructions will be for Mac.

### Steps

1. **Install DBT CLI**: 
Dbt has a flavor for every datastore you use, in addition to the flavor of their cloud hosted project. I am using the opensource version for the BQ model. To figure our which version of flavor of DBT you need checkout the [install instructions](). 

Here is the code used to install the DBT CLI by tapping the DBT repository:

```
brew untap dbt-labs/dbt
brew tap dbt-labs/dbt-bigquery
```

2. **Initialize DBT Project**: 
So the setup for a DBT cloud project is different than a non-cloud project. If you use a cloud project, the web UI wil create a project for you, but if you are like me and want to use an opensource option you will need to create your own project in a repo. The dbt-cli has a commant for this. I chose the to name the new DBT project `cust-analytics`:

```
dbt init cust-analytics
```

and then inside the `cust-analytics` repo I was configured `git`

```
cd cust-analytics
git init
```

I would also recommend adding the following to `.gitignore`

```
profiles.yml
.user.yml
logs/
```

The `dbt init` command created a lot of extra empty repos. So if you want to remove the boiler plate you will end up with a slimmed down directory like this. 

```
├── README.md
├── dbt_project.yml
├── models
│   └── example
│       ├── bank_and_population_data.sql
│       └── bank_data.sql
└── profiles.yml
```

In the `dbt_project.yml`, we need to complete the last config step by pointing to the project and models.

```
name: 'cust_analytics'
version: '1.0.0'
config-version: 2

profile: 'cust_analytics'

model-paths: ["models"]

clean-targets:
  - "target"
  - "dbt_packages"
models:
  cust_analytics:
    # Config indicated by + and applies to all files under models/example/
    examples:
      +schema: test_public_data # in BQ dataset = dbt schema and project = dbt database
```

This says what to build, where to put the build auxiliary files, and where my transformations are located. I have assigned the BQ dataset to be called `test_public_data`. 

3. **Create Queries**: 
With the completely configured repo we can now add SQL queries that will build and populate our tables. Add SQL queries to the `.sql` files in your project directory. If you already have tables in your dataset, you will need to follow your schema's protocol, but if like me, you have to tables in the dataset, then DBT will create the tables for you.

My two queries are on data available in the [BigQuery public data project](). These are not actually queries with an analytics use case, but I wanted to test the concept of combining resources from two different datasets and creating a new view. So, TLDR, this in a engineer testing a feature set not an analytics gathering insights.

The format of queries are pretty straight foward. I created a CTE and then used that CTE to create a grouping of useful data. DBT formats everything like a `SELECT` statement. So instead of `Inserting` data into a DB, you can think of it as just querying the data you want and DBT handles the insert work for you. The last line of the file was the most interesting to me. 

```
select * from bank_assets;
```

This says that I want to use all the data in my `bank_assets` CTE in the new table the DBT is creating. The tables name is the name of the time BTW.

4. **Configure Profiles**: 
The second to last step is to connect the local isntance of DBT to our gcp project. Edit the `profiles.yaml` file with the necesary connection information. Locally I am using the [json keys]() method of connecting to DB, but in part 2 we will switch to Oauth via cloud service accounts.

One thing that I particularly like to so is store my `profile.yaml` in a specific location based on convenience or need. When you run `dbt init` it creates a `profiles.yml` in the `~/.dbt/profiles.yaml`. I prefer to keep it close to the repo and not combine then across dbt project.

11. **Run DBT**: Execute the DBT transformations locally to ensure they run successfully. This is the last step in the tutorial, but is also a valid way to run DBT jobs. If you are running DBT on prem, or connecting to a different cloud for your datawarehouse, running through a cron job and the `dbt run` command is a valid option. Since I move my `profiles.yml` from the default location I need to specify where is should be run from. 

```
dbt run --profiles-dir .
```

By following this tutorial, you should have a basic understanding of how to set up a project using DBT for data transformation.


## Part 2: DBT run on GCP

### Prerequisites
- Docker installed on your local machine

### Steps
1. **Pull DBT Docker Image**: Pull the DBT Docker image to your local machine using the following command:
   ```
   docker pull ghcr.io/dbt-labs/dbt-bigquery:1.6.7
   ```
7. **Build Docker Image**: Build a Docker image for your DBT project using the provided example Dockerfile.

8. **Deploy Docker Image**: Deploy the Docker image to a container registry such as Google Artifact Registry.

6. **Download Keys (Optional)**: If required, download authentication keys for local testing. For cloud deployment, consider using OAuth or service accounts.

9. **Set Up Cloud Run**: Create a Cloud Run service for your DBT project, ensuring it has access to the necessary datasets.

10. **Configure Cloud Scheduler**: Set up Cloud Scheduler to trigger your DBT transformations on a schedule.

### Production Requirements
- Artifact Registry for storing Docker images
- Cloud Run API for deploying containerized applications
- Cloud Scheduler API for scheduling jobs
- Service account for Cloud Run to access datasets

## Potential Concerns
- The need for an HTTP server to invoke DBT, which adds complexity to the deployment process.
