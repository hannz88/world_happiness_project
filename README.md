# World Happiness Report Workflow

## **Problem description**

World Happiness Report is a global wellbeing report published yearly that also include the metrics on several other factors that affect wellbeing of a population. This project implements a data pipeline for getting the data from Kaggle and processing it using Terraform, Kestra and dbt.


## **Features**
- **Cloud:** The project uses Terraform to set up GCP resources like Compute Engine, VM, BigQuery, and GCS.
- **Orchestration and Data ingestion :** Here, we're using Kestra by running Python script that connects to Kaggle via its API. Then, Kestra helps to facilitate loading the data onto Google Cloud bucket before loading it to the datawarehouse.
- **Data Warehouse:** Here, we're using Google BigQuery DataWarehouse to store the data by partitioning the table by Date. Note that the original data contains only year. 
- **Data Transformation:** dbt builds data models and metrics for analysis.
- **Visualization:** after build, data is ready to be visualized.

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

To open Kestra, navigate to the created VM's public ip at the port 8080. 
After importing and running the `Kestra/01_gcp_kv.yaml` file, navigate to Namespace's KV Store and update `KAGGLE_KEY` and `KAGGLE_USER`.
Finally, run the following to get the service_account details:
```shell
terraform output service_account > temp_sa.json
```
Copy and paste the content of the `temp_sa.json` into the `GCP_CREDS` KV.
