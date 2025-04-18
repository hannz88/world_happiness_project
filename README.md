# World Happiness Report Workflow

![Workflow for World Happiness Report](/image/World_Happiness_workflow.png)

## **Problem description**

World Happiness Report is a global wellbeing report published yearly that also include the metrics on several other factors that affect wellbeing of a population. This project implements a data pipeline for getting the data from Kaggle and processing it using Terraform, Kestra and dbt. The report is then visualised on Looker.


## **Features**
- **Cloud:** The project uses Terraform to set up GCP resources like Compute Engine, VM, BigQuery, and GCS.
- **Orchestration and Data ingestion :** Here, we're using Kestra by running Python script that connects to Kaggle via its API. Then, Kestra helps to facilitate loading the data onto Google Cloud bucket before loading it to the datawarehouse.
- **Data Warehouse:** Here, we're using Google BigQuery DataWarehouse to store the data by partitioning the table by Date. Note that the original data contains only year. 
- **Data Transformation:** dbt builds data models and metrics for analysis.
- **Visualization:** after build, data is then visualized using Looker.

## **Project Structure**
- **`terraform/`**: Contains Terraform configurations.
- **`kestra/`**: Includes Kestra workflow definitions.
- **`dbt/`**: Houses dbt models and configurations for data transformation.
- **`Python/`**: Contains Python scripts for data extraction.

## **Note**
After running terraform apply, ssh into the virtual machine that it creates and run the following command:

```shell
sudo chmod a+w /mnt/disks/gce-containers-mounts/gce-persistent-disks/data-disk-0/
```
```shell
sudo chmod 666 /var/run/docker.sock
```

To open Kestra, navigate to the created VM's public ip at the port 8080. 
After importing and running the `Kestra/01_gcp_kv.yaml` file, navigate to Namespace's KV Store and update `KAGGLE_KEY` and `KAGGLE_USER`.
Finally, run the following to get the service_account details:
```shell
terraform output service_account > temp_sa.json
```
Copy and paste the content of the `temp_sa.json` into the `GCP_CREDS` KV.

Afterwards, upload other Kestra yaml files onto Kestra and run them separately. `04_gcp_world_happiness_scheduled.yaml` was the script for running the script automatically at a scheduled time. We're running this at 1 minute past 0000. THis does not need to be run on the first time.

Then, run the `05_gcp_dbt.yaml` file. This will sync all the `dbt` files from this repo and transform the tables from the datawarehouse.

Please ensure that the values for the following are correct in the namespace:
- dataset
- project
- location


## **Looker**
The link to the public visualization is here: https://lookerstudio.google.com/reporting/dc99d0ef-20ff-49cf-9995-de3a5c72f1f2