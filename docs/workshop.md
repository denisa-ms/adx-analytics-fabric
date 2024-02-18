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
This workshop will walk you through the process of building an end-to-end Data Analytics Solution in **less than 1 HOUR**, for your e-commerce website using MS Fabric Real time Analytics.  


You will learn how to:
* Build a star schema in MS Fabric RTA (Real time analytics)
* Use Fabric data pipelines for CDC (change data capture) to ingest data from an operational DB (SQL server)
* Stream events into Azure Event hubs and ingest them into MS Fabric RTA (Real time analytics) using EventStream
* Create data transformations in Fabric RTA (Real time analytics)
* Create reports for real time visualizations using RTA (Real time analytics) dashboards

All the code in this tutorial can be found here:   
[ADX Analytics github repo](<https://github.com/denisa-ms/adx-analytics-fabric>)  


**Built by:**   
**Denise Schlesinger**   
**Principal Cloud Solution Architect @Microsoft**   
[Linkedin](<https://www.linkedin.com/in/deniseschlesinger/>)     
[Github](<https://github.com/denisa-ms>)



---

# The e-commerce store   

The e-commerce store data entities are:  
* Impressions: event logged when a product is in the search results.
![Impressions](assets/store1.png)  
* Clicks: event logged when the product is clicked and the customer has viewed the details.  
![Clicks](assets/store2.png)  
* Orders: the customers orders.  
* Products: the product catalog.  

Photo by <a href="https://unsplash.com/@himiwaybikes?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Himiway Bikes</a> on <a href="https://unsplash.com/photos/black-and-gray-motorcycle-parked-beside-brown-wall-Gj5PXw1kM6U?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>  
Photo by <a href="https://unsplash.com/@headaccessories?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">HEAD Accessories</a> on <a href="https://unsplash.com/photos/silver-and-orange-head-lamp-9uISZprJdXU?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>  
Photo by <a href="https://unsplash.com/@jxk?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Jan Kopřiva</a> on <a href="https://unsplash.com/photos/a-close-up-of-a-helmet-with-sunglasses-on-it-CT6AScSsQQM?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
  

---

 # Architecture

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

# Data schema

* **Products**: shortcut to an external table in the SQL DB.   
* **BronzeOrders**: raw data for the orders, copied to Fabric KQL DB using CDC using Fabric Data pipelines.
* **Orders**: table created based on an update policy with transformed data.  
* **OrdersLatest**: materialized view showing only the latest change in the order record.  
* **Impressions**: streaming events representing the product being seen by the customer. Will be streamed into Fabric KQL DB from eventstream and events hub. We will push synthetic data (fake data) into an event hub, using a Fabric Notebook.  
* **Clicks**: streaming events representing the product being clicked by the customer. Will be streamed into Fabric KQL DB from eventstream and events hub. We will push synthetic data (fake data) into an event hub, using a Fabric Notebook.   

![MRD](assets/mrd.png)  

---

# Resources to be created 

At the end of this tutorial we will have the following entities:  
* An SQL server with the Adventure works sample DB (aka: the operational DB for our e-commerce store).  
* An event hub with 2 hubs: **clicks** and **impressions** streaming the events we will generate.   
* Fabric KQL DB
* Fabric Lakehouse
* Fabric Data Pipeline
* Fabric Event streams for ingesting clicks and impressions events from Event hub into our KQL DB
* Fabric Notebooks for synthetic data generation (event streaming)
* Fabric Real time Dashboard for visualization  
  
![Deployed resources](assets/infra4.png)

---

# Pre-requisites
* An [Azure Subscription](<https://azure.microsoft.com/en-us/free/>) where you have admin permissions.   
* [Microsoft Fabric](<https://www.microsoft.com/en-us/microsoft-fabric/getting-started>) with admin permissions.   

---

# Building the Infrastructure
Run powershell script in the Azure portal - Cloudshell

1. Go to the azure portal and login with a user that has **administrator permissions**.  
2. Open the cloud shell in the azure portal.  
3. Upload the file called ([createAll.ps1](<https://github.com/denisa-ms/adx-analytics-fabric/blob/main/infrastructure%20scripts/createAll.ps1>)) in the github repo by using the upload file button in the cloud shell.  
4. Upload the file called ([deployAll.bicep](<https://github.com/denisa-ms/adx-analytics-fabric/blob/main/infrastructure%20scripts/deployAll.bicep>)) in the github repo by using the upload file button in the cloud shell.  
5. Run in cloudShell:  
```
./createAll.ps1   
```  

<div class="info" data-title="Note">

> This takes time, so be patient 
</div>

![Alt text](assets/infra1.png)
![Alt text](assets/infra2.png)
![Alt text](assets/infra3.png)
![Alt text](assets/infra4.png)


---


# KQL Database schema  
![MRD](assets/mrd.png)

---


# Post deployment tasks  

<div class="info" data-title="Note">

> Since we are using SQL serverless, this step is used to "awake" our SQL server
</div>

Open Azure Data Studio and connect to our SQL DB.  
![SQL DB](assets/sql1.png)  


---

# Building the Analytics platform
## Fabric Workspace 
Create a Fabric Workspace
![alt text](assets/fabric1.png)
![alt text](assets/fabric2.png)
## KQL DB
Create a KQL DB - this is our analytics DB
![alt text](assets/fabric3.png)
![alt text](assets/fabric4.png)
Go to the github repo for this tutorial and copy the KQL commands in the file:  
[KQL script](<https://github.com/denisa-ms/adx-analytics-fabric/blob/main/kql/createAll.kql>)
![alt text](assets/fabric5.png)
Paste them in the KQL DB data explore pane
![alt text](assets/fabric6.png)
Go to the Azure portal and copy the sql servername we created in the deployment scripts  
![alt text](assets/fabric5-1.png)
Paste it in the KQL DB data explore pane for the external table creation  
![alt text](assets/fabric6-1.png)
Run all commands in the KQL DB data explore pane one by one to create all the tables, update policies and materialized views  
![alt text](assets/fabric7.png)
## Data pipeline
Create a Data pipeline to copy the data from the SQL DB orders table to our KQL DB using CDC
![alt text](assets/fabric8.png)
![alt text](assets/fabric9.png)
![alt text](assets/fabric10.png)
![alt text](assets/fabric11.png)
![alt text](assets/fabric12.png)
![alt text](assets/fabric13.png)
![alt text](assets/fabric14.png)
![alt text](assets/fabric15.png)
![alt text](assets/fabric16.png)
![alt text](assets/fabric17.png)
![alt text](assets/fabric18.png)
Run a KQL command to check the orders were copied into our KQL DB
![alt text](assets/fabric19.png)
## Notebooks
Import the notebooks to generate sytnetic data from the githup repo here:  
[Notebooks](<https://github.com/denisa-ms/adx-analytics-fabric/tree/main/notebooks>)
![alt text](assets/fabric20.png)
![alt text](assets/fabric21.png)
![alt text](assets/fabric22.png)
![alt text](assets/fabric22-1.png)
In order for the notebooks to run, we will create an environment with the imported python libraries to be used when running the notebooks.
![alt text](assets/fabric25.png)
![alt text](assets/fabric27.png)
![alt text](assets/fabric28.png)
Connect the Notebook to the created environment
![alt text](assets/fabric28-1.png)
![alt text](assets/fabric28-2.png)
Go to the azure portal and create a shared access policy for the event hub created in the deployment and copy it
![alt text](assets/fabric28-3.png)
Paste the event hub connection string into the notebook to generate synthetic events
![alt text](assets/fabric28-4.png)
Run the notebook's cells to generate "fake" impressions and clicks events and stream them to our event hubs
![alt text](assets/fabric28-5.png)
## Eventstream 
Create an eventstream to stream events from event hub to our KQL DB
![alt text](assets/fabric30.png)
![alt text](assets/fabric31.png)
![alt text](assets/fabric32.png)
![alt text](assets/fabric33.png)
![alt text](assets/fabric34.png)
![alt text](assets/fabric35.png)
![alt text](assets/fabric36.png)
![alt text](assets/fabric37.png)
![alt text](assets/fabric38.png)
![alt text](assets/fabric39.png)
![alt text](assets/fabric40.png)
![alt text](assets/fabric41.png)
![alt text](assets/fabric42.png)
![alt text](assets/fabric43.png)
![alt text](assets/fabric44.png)
Run a KQL query to check the incoming events in the clicks table
![alt text](assets/fabric45.png)
## Dashboard
Download the JSON file defining the dashboard located at [RTA Dashboard](<https://github.com/denisa-ms/adx-analytics-fabric/blob/main/dashboards/dashboard-analytics%20RTA%20dashboard.json>)
Go to our KQL DB in the Fabric Workspace to copy the KQL cluster URI and paste it in the json file defining the dashboard, save the file  
![alt text](assets/fabric45-1.png)
![alt text](assets/fabric45-2.png)
![alt text](assets/fabric45-3.png)
Create a Real time analytics Dashboard to visualize the data
![alt text](assets/fabric46.png)
![alt text](assets/fabric47.png)
![alt text](assets/fabric48.png)
![alt text](assets/fabric49.png)
![alt text](assets/fabric50.png)
Visualize the streaming data that will be refreshed every 30 seconds, or manually refresh it to save the changes
![alt text](assets/fabric54.png)
Stop running the notebook
![alt text](assets/fabric55.png)

