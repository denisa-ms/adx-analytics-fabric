---
published: true                        # Optional. Set to true to publish the workshop (default: false)
type: workshop                          # Required.
title: Building an Analytics Platform with MS Fabric Real time analytics              # Required. Full title of the workshop
short_title: MS Fabric - Real time analytics Tutorial    # Optional. Short title displayed in the header
description: In this technical workshop, you will build a complete Analytics Platform   # Required.
level: advanced                         # Required. Can be 'beginner', 'intermediate' or 'advanced'
authors:                                # Required. You can add as many authors as needed      
  - Denise Schlesinger
contacts:                               # Required. Must match the number of authors
  - https://github.com/denisa-ms
  - https://www.linkedin.com/in/deniseschlesinger/
duration_minutes: 180                    # Required. Estimated duration in minutes
tags: azure, data, analytics, Kusto, bicep, azure data explorer, fabric         # Required. Tags for filtering and searching

---

# Introduction
Suppose you own an e-commerce website selling bike accessories.  
You have millions of visitors a month, you want to analyze the website traffic, consumer patterns and predict sales.  
This workshop will walk you through the process of building an end-to-end Data Analytics Solution for your e-commerce website using MS Fabric Real time Analytics.

You will learn how to:
* Build a star schema in MS Fabric RTA (Real time analytics)
* Use Fabric data pipelines for CDC (change data capture) to ingest data from an operational DB (SQL server)
* Stream events into Azure Event hubs and ingest them into MS Fabric RTA (Real time analytics) using EventStream
* Create data transformations in Fabric RTA (Real time analytics)
* Create reports for real time visualizations using RTA (Real time analytics) dashboards

All the code in this tutorial can be found here:   
[ADX Analytics github repo](<https://github.com/denisa-ms/adx-analytics-fabric>)  


---

# Architecture   

At the end of this tutorial we will have the following entities:  
* An SQL server with the Adventure works sample DB
* An event hub with 2 hubs: clicks and impressions that will receive the events we will generate as streaming data.   
* Fabric KQL DB
* Fabric Lakehouse
* Fabric Data Pipeline
* Fabric Event streams for ingesting clicks and impressions events from Event hub into our KQL DB
* Fabric Notebooks for synthetic data generation (event streaming)
* Fabric Real time Dashboard for visualization  
  
![Deployed resources](assets/infra1.png)

## Architectural Diagram
![Architectural Diagram](assets/architecture.png)

---

# Fabric RTA Features 

We are showcasing many of Fabric RTA capabilities:  
* [Shortcuts](<https://learn.microsoft.com/en-us/fabric/real-time-analytics/onelake-shortcuts?tabs=onelake-shortcut>)   
  Products table: defined as an external table hosted in our operational SQL DB. 
  A shortcut is a schema entity that references data stored external to a KQL database in your cluster.  

* [Event streams](<https://learn.microsoft.com/en-us/fabric/real-time-analytics/event-streams/overview>)  ingest-data-overview#continuous-data-ingestion>)   
  Clicks and Impressions tables: are ingested from Azure Event Hub using event streams  

* [Data pipelines](<https://learn.microsoft.com/en-us/fabric/data-factory/tutorial-end-to-end-pipeline>)  
  BronzeOrders table is populated by a Fabric Data pipeline using CDC (change data capture) from our operational SQL DB  

* [Update policies](<https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/update-policy>)    
  Orders table: created on ingestion based on Kusto's update policies feature, that allows appending rows to a target table by applying transformations to a source table.  

* [Materialized views](<https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/materialized-views/materialized-view-overview>)  
  OrdersLatest table: materialized view - exposes an aggregation over a table or other materialized view  

---

# Pre-requisites
* An [Azure Subscription](<https://azure.microsoft.com/en-us/free/>) where you have admin permissions
* [Microsoft Fabric] (<https://www.microsoft.com/en-us/microsoft-fabric/getting-started>)

---

# Building the Infrastructure
Run powershell script in the Azure portal - Cloudshell

1. Go to the azure portal and login with a user that has administrator permissions
2. Open the cloud shell in the azure portal
3. Upload the file called ([createAll](<../infrastructure scripts/createAll.ps1>)) in the github repo by using the upload file button in the cloud shell
4. Run 
```
./createAll.ps1   
```  


<div class="info" data-title="Note">

> This takes time, so be patient 
</div>

![Alt text](assets/deploy1.png)
![Alt text](assets/deploy2.png)
![Alt text](assets/deploy3.png)
![Alt text](assets/deploy4.png)

---
 
# KQL Database schema  
![MRD](assets/mrd.png)

You can review all the commands used to create external tables, update policies, materialized views and mappings for ingestion in the [KQL script](<https://github.com/denisa-ms/ADX-Analytics/blob/main/infrastructure%20scripts/script.kql>) file.  
 This is the script we run in the deployment after creating the Kusto cluster.

---

# Post deployment tasks
## Define the event hub SAS (shared access policy) in [.env](https://github.com/denisa-ms/ADX-Analytics/blob/main/.env.template) file

<div class="task" data-title="Task">

> * Go to the Event hub -> Shared access policies  
> * Add  
> * Create a Policy called "adxdemo" with "Manage" privileges  
> * Save and copy the "Connection string–primary key"  
> * Paste into [.env](https://github.com/denisa-ms/ADX-Analytics/blob/main/.env.template) file the event hub connection string   
```
EVENT_HUB_CONN_STRING = "<event hub connection string>"   
```
</code>


![event hub](assets/eventhub1.png)
![sas](assets/eventhub2.png)
![createsas](assets/eventhub3.png)

<br />

## Open Azure Data Studio and connect to our SQL DB
![Alt text](assets/sql1.png)  

<div class="info" data-title="Note">

> Since we are using SQL serverless, this step is used to "awake" our SQL server
</div>

## Open Azure Data Factory to run the Change Data Capture
In this step we "stream" all the orders from the "SalesOrderDetail" table in SQL to Kusto

<div class="task" data-title="Task">

> Go to the Azure Data Factory in the Created Resource Group
> Launch the ADF Studio
> Author -> Pipelines -> "SQLToADX_orders"
> Click on "debug"
</div>

![Alt text](assets/adf1.png)
![Alt text](assets/adf3.png)
![Alt text](assets/adf4.png)

## Create synthetic events by running a Notebook
<div class="task" data-title="Task">

> * Follow the instructions in the [README file](https://github.com/denisa-ms/ADX-Analytics/blob/main/notebooks/README.md) located in the [notebooks](https://github.com/denisa-ms/ADX-Analytics/blob/main/notebooks) folder for creating a python virtual environment  
> * Run [Generate Synthetic events notebook](<https://github.com/denisa-ms/ADX-Analytics/blob/main/notebooks/Generate%20synthetic%20events%20.ipynb>)
</div>

## Generate updates on the SQL SalesOrderDetail table
<div class="task" data-title="Task">

> * If you did not create a python virtual environment yet, Follow the instructions in the [README file](notebooks/README.md) located in the [notebooks](https://github.com/denisa-ms/ADX-Analytics/blob/main/notebooks) folder for creating a python virtual environment  
> * Run [Generate orders updates notebook](<https://github.com/denisa-ms/ADX-Analytics/blob/main/notebooks/Generate%20orders%20updates.ipynb>)  
> * Run the CDC pipeline in Azure Data Factory to send the changes from SQL to Kusto (see [Open Azure Data Factory to run the Change Data Capture (CDC)](#open-azure-data-factory-to-run-the-change-data-capture) above  
</div>

---

# Read data in Kusto
Your Kusto DB should look like this:  
![Alt text](assets/kql1.png)
<br />

- Copy all KQL queries from the [exercise1.kql](https://github.com/denisa-ms/ADX-Analytics/blob/main/KQL/exercise1.kql) file to the Azure Data Explorer Web UI and run queries one by one.

<br />

![Alt text](assets/kql2.png)
<br />

---

# Visualization in Azure Data Explorer web UI  

<div class="task" data-title="Important">

> If you changed the "prefix" param in the [deployAll.bicep](<https://github.com/denisa-ms/ADX-Analytics/blob/main/infrastructure%20scripts/deployAll.bicep>) file  
> You have to edit the [JSON defining the ADX WEB UI Dashboard data source](<https://github.com/denisa-ms/ADX-Analytics/blob/main/ADX%20dashboards/dashboard-Ecommerce%20dashboard.json>) as follows:  

```
    "dataSources": [
      {
        "id": "535ee10e-e104-4df6-a3eb-ac5cd7834691",
        "name": "storeDB",
        "scopeId": "kusto",
        "clusterUri": "https://prefix-kusto.westeurope.kusto.windows.net/",
        "database": "storeDB",
        "kind": "manual-kusto"
      }
    ],
```
<br />
</div> 

Import the dashboard as follows:
![Alt text](assets/dashboard1.png)
![Alt text](assets/dashboard2.png)
<br />

---

# Visualization and alerts in Grafana
Import the dashboard into Grafana as follows:

![Open grafana](assets/grafana1.png)
![Open grafana](assets/grafana5.png)
![Open grafana](assets/grafana6.png)
![Open grafana](assets/grafana7.png)
![Open grafana](assets/grafana8.png)
![Open grafana](assets/grafana9.png)
![Open grafana](assets/grafana2.png)
![Open grafana](assets/grafana3.png)
![Open grafana](assets/grafana4.png)
![Open grafana](assets/grafana10.png)

<br />

---

# Visualization in Power BI

## Open the Power BI template provided in this demo to read from Azure Data Explorer

![power BI](assets/pbi6.png)
![power BI](assets/pbi7.png)
![power BI](assets/pbi8.png)
![power BI](assets/pbi9.png)
![power BI](assets/pbi10.png)

## Create a new Power BI report

![power BI](assets/pbi1.png)
![power BI](assets/pbi2.png)
![power BI](assets/pbi3.png)
![power BI](assets/pbi4.png)
![power BI](assets/pbi5.png)

For more instructions:
[Use Azure Data Explorer data in Power BI](<https://learn.microsoft.com/en-us/azure/data-explorer/power-bi-data-connector?tabs=web-ui>)

---

# Alerts in Azure Data Explorer

You have 3 options to create alerts on Azure data Explorer:  
## Azure Logs (Preview)

Azure Monitor Alerts allow you to monitor your Azure and application telemetry to quickly identify issues affecting your service. The Azure Monitor alerts is introducing now support for running queries on Azure Data Explorer (ADX) tables, and even joining data between ADX and data in Log Analytics and Application Insights. 
As part of this newly added support, log alert rules now support managed identities for Azure resources – allowing you to see and control the exact permissions of your log alert rule. 

To write queries to Log Search Alerts (LSA) you need to use the ADX(‘<cluster url>’) pattern.   
Learn more:  
![Alerts in Azure Logs](assets/alerts1.png)

## Power automate
The Azure Data Explorer connector for Power Automate (previously Microsoft Flow) enables you to orchestrate and schedule flows, send notifications, and alerts, as part of a scheduled or triggered task.  
For more information: [Azure Data Explorer connector for Microsoft Power Automate](<https://learn.microsoft.com/en-us/azure/data-explorer/flow>)

## Alerts in Grafana  
Grafana is an analytics platform where you can query and visualize data, and then create and share dashboards based on your visualizations. Grafana provides an Azure Data Explorer plug-in, which enables you to connect to and visualize data from Azure Data Explorer. The plug-in works with both Azure Managed Grafana and self-hosted Grafana.  

For more information: [Create alerts in Grafana](<https://learn.microsoft.com/en-us/azure/data-explorer/grafana?tabs=azure-managed-grafana#create-alerts>)  


---

# Additional Information

## Monitoring 
 Azure Monitor diagnostic logs provide data about the operation of Azure resources.  
 Azure Data Explorer uses diagnostic logs for insights on ingestion, commands, query, and tables.  
 You can export operation logs to Azure Storage, event hub, or Log Analytics to monitor ingestion, commands, and query status.  
 Logs from Azure Storage and Azure Event Hubs can be routed to a table in your Azure Data Explorer cluster for further analysis.

[Setup diagnostic logs](<https://learn.microsoft.com/en-us/azure/data-explorer/using-diagnostic-logs?tabs=ingestion>)  
[Create an Azure alert on FailedIngestion table](<https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/tutorial-log-alert>)


## Connecting to Azure Data Explorer  
[How to configure an app registration to connect to Azure Data Explorer](https://learn.microsoft.com/en-us/azure/data-explorer/provision-entra-id-app)  

* Adding an AAD user from another tenant to access from PBI to ADX   
.add database ['storeDB'] admins ("aaduser=user@yourdomain.com;your aad tenant id here")  

* Adding an AAD app to ADX as admin + run the following command inside ADX    
.add database ['your db name'] users ('aadapp=your app-id') 'Demo app put your comment here (AAD)'   


