[TOC]

# Network Rail WPS

## Project Description

NR Work Planning and Scheduling project is set to help NR leverage data and technology to optimise railway asset management and work planning, to improve safety, efficiency and the passenger and freight experience. The tool(s) which will be built in this project will enable the workforce, using technology, to **efficiently plan and deliver Network Rail’s commitments** through an optimised industry-leading maintenance regime.



## Terminologies

### Possessions

Possession is the term used by railway maintenance contractors (or network rail) to indicate that they have taken possession of the track (usually a [signal] block of track) and no trains are running, or a limited service is running.

### Abbreviations

| Abbreviation or Term | Description                                                  |
| -------------------- | ------------------------------------------------------------ |
| ALP                  | Asset Lifecycle Planning                                     |
| API                  | Application Programming  Interface                           |
| BAU                  | Business as usual                                            |
| CP                   | Control Period                                               |
| DU                   | Delivery Unit (Hierarchy =  District Code -> Region -> Route  -> DU -> Discipline within DU) |
| DPP                  | Draft Possession Plan (CPP -  Confirmed Possession Plan)     |
| EAM                  | Enterprise Asset  Management                                 |
| EH                   | Engineering Hours                                            |
| ELR                  | Engineers Line References                                    |
| ERP                  | Enterprise Resource  Planning                                |
| HLD                  | High Level Design                                            |
| INM                  | Integrated Network Model                                     |
| KPI                  | Key Performance Indicator                                    |
| LOR                  | Line of route                                                |
| LSP                  | Late Surrender Protection                                    |
| MDU                  | Maintenance Delivery Unit                                    |
| MNT                  | Maintenance                                                  |
| MQ                   | Message Queue                                                |
| MST                  | Maintenance Schedule Task                                    |
| NR                   | Network Rail                                                 |
| ORM                  | Operation Risk Management                                    |
| OSD                  | Outline Solution Design                                      |
| PCRO                 | Power Control Room  Operator                                 |
| PICOP                | Person In Charge of Possessions                              |
| PID's                | Passenger Information  Displays                              |
| PPI                  | Possession Plan Item                                         |
| PPS                  | Possession Planning System                                   |
| PR                   | Price Review                                                 |
| PRA                  | Person Requesting Access                                     |
| PWH-EH               | The person undertaking the role of Protecting Workers on the Track during Engineering Hours |
| QG                   | Quality Gate                                                 |
| RAP                  | Railway Access Plan                                          |
| RTE                  | Route                                                        |
| SMF                  | Service Measure Framework                                    |
| TAC                  | Track Access Controller                                      |
| TC                   | Traction Current                                             |
| TCS                  | Traction Current Section                                     |
| TH                   | Traffic Hours                                                |
| TOTEX                | Total Expenditure which includes  Capex & Opex               |
| TR                   | Time Recording                                               |
| UI                   | User Interface                                               |
| WO                   | Work Orders                                                  |
| WP                   | Weekly Plan                                                  |
| WPS                  | Work Planning and Scheduling                                 |
| WQ /  WREQ           | Work Request                                                 |
| WTP                  | Willingness to pay                                           |



| **Standard Job Units**      |                             |
| --------------------------- | --------------------------- |
| MI                          | Mile                        |
| RY                          | Rail Yard                   |
| PE                          | Point End                   |
| HR                          | Hours                       |
| NO                          | Number                      |
| BG                          | Building                    |
| LO                          | Location                    |
| EA                          | Each                        |
| SV                          | Service                     |
| YD                          | Yard                        |
| SM                          | Square Metre                |
| 22 - 220 yards (1/8th mile) | 22 - 220 yards (1/8th mile) |
| RM                          | Rail Mile                   |
| JT                          | Rail Joint                  |
| TT                          | Test                        |
| TY                          | Track Yard                  |
| DF                          | Defect                      |
| BY                          | Bays                        |
| TO                          | Tonnes                      |
| TR                          | Timber                      |

### Organisation Hierarchy

**District Code (RTK1) -> Route -> Delivery Unit ->Discipline (within DU) -> Maintenance Engineer -> Workgroup Set -> Workgroup**



## Datasets

### Received

- Standard Job Data
- MSTs
- Work Arising
- Approved Possessions
- Approved Trains
- Staff Roster
- Licenses/tickets

Most of the above are available in Ellipse, PPS, Oracle. [NR ALP & WPS (Private) - new data from Arunava - All Documents (sharepoint.com)](https://arcadiso365.sharepoint.com/teams/NRALPWPSPrivate/Shared Documents/Forms/AllItems.aspx?originalPath=aHR0cHM6Ly9hcmNhZGlzbzM2NS5zaGFyZXBvaW50LmNvbS86ZjovdC9OUkFMUFdQU1ByaXZhdGUvRWd4VkRjTUh6QWhPc3RyR0pXSExHRkFCNTVaeTR2c0U1Y2RlN2Yyc3QwR1Ridz9ydGltZT1tMHlHbTY0ZTJVZw&viewid=6c33cc15-855b-427c-b0df-d1901e44d37d&id=%2Fteams%2FNRALPWPSPrivate%2FShared Documents%2FGeneral%2F02 Project Delivery%2F01 ALP %2B WPS - Common Delivery Aspects%2F03 Data%2FWPS%2Fnew data from Arunava) contains the Shrewsbury examples which have been analysed in `possessions-clean.r`.

### Awaiting

- Geo-spatial datasets

  Additional layers needed from Geo-RINM (spatial layers database)

  -  Structures
  -  Infrastructure Features
  -  Infrastructure Network Model
  -  Addresses
  -  Track Access Billing
  -  OS MasterMap
  -  Track Gauging
  -  Drainage
  -  Earthworks
  -  Property
  -  Flood Risk
  -  Hazards
  -  Land Information
  -  Mining
  -  Organisational Boundaries
  -  Administrative Boundaries
  -  Common Consequence Tool
  -  Aerial Survey Imagery
  -  Historic Maps
  -  Base Maps

  

- Complex possessions and their workorders

- Roster data in its useable format.

- TBD

### Data Summary

In order to identify the workorders that take place in a possession, the ELR and TrackID from both possessions and workorders will be used in the join. Afterwards, the From and To Mileage and From and To Date are used to to filter the workorders. The `possessions_clean.r` script does not include the date filter because date filtering is currently not our priority.

Also, there is no link between the "standard jobs" and "actual competencies and roster of resources" carrying out the jobs.

We have received loads of datasets in different formats each time it's been sent. I have summarised the important columns in each of the important datasets below. 

#### Possessions data

Track ID alone is not a unique identifier, so it needs a way of describing location (e.g. ELR + miles). The other challenge is to manage the difference between “Track ID that the asset is located on” vs “Track ID(s) that need to be blocked in order to work on that asset”. Examples: a Switch may be attached to a particular Track ID in Ellipse, but you would need to block two or more tracks to do work on that switch; some assets (e.g. drainage assets) do not have a Track ID at all but may require some or all tracks at a location to be blocked to work on them.

Below are some important columns in the Shrewsbury possessions data.

- **BusinessPossRef**: This field contains information relating to a particular possession e.g. P2021/2667344. It is not a unique field.
- From Time
- From Date
- To Time
- To Date

#### Work Order data

Below are some important columns in the Shrewsbury workorder data.

- **Structured Plant No**: "TrackID" can be extracted from this field.  
- **ELR**
- Work Order Mileage From
- Work Order Mileage To

Note: There is no supervisor, competency information in the workorder datasets received thus far. This is one of the reasons why resource planning is currently an issue.

#### People data

- **Person_ID: 106590** (Primary Key)
- EMPLOYEE_NUMBER: 72604
- FIRST_NAME
- EMAIL_ADDRESS: Elonmusk@networkrail.co.uk   
- USER_NAME: EMusk
- **SUPERVISOR_EMPLOYEE_NUMBER: 52465** (Foreign Key)
- POSITION_ID: 4232364
- LOCATION_ID: 268227  

#### Competency data

**"Date From" and "Date To" column**

Some records in "Date From" and "Date To" column in Comepetence.xls appears as 01-Jan-51. This means 01-Jan-1951.

When we want to check an ‘active’ competence we compare a date, typically today’s date, to see if it is between the DATE_FROM and the DATE_TO. In the cases where both the DATE_FROM and DATE_TO are both the same, or today’s date is beyond the DATE_TO, e.g. 03-NOV-15, the competence is no longer active. Where the DATE_TO is blank (NULL) then the competence is effectively active forever.

**"CERTIFICATION_REQUIRED" column**

There is another column CERTIFICATION_REQUIRED for which the values are N and Y. Please note CERTIFICATION_REQUIRED from per_competences relates to whether this is a Sentinel related competence. See below for Personal Track Safety, where Sentinel Competence is ticked. This field relates to CERTIFICATION_REQUIRED = Y.

Note: NR EBus send Sentinel details of Sentinel related competences and all the valid per_competence_elements (employee competences) for that competence. (Check email for Query on Competency data from Rupert Grover on 19/05/2021)

**"SUPERVISOR_EMPLOYEE_NUMBER" column**

This key can be used to merge with the People data.

#### Roster data

The Roster data is not in a format that is useful to Arcadis Gen. The Roster data will have to be repackaged in a way that we can pre-process without much hassle. One of such datasets can be found 

[here]: https://arcadiso365.sharepoint.com/:x:/r/teams/NRALPWPSPrivate/Shared%20Documents/General/02%20Project%20Delivery/01%20ALP%20+%20WPS%20-%20Common%20Delivery%20Aspects/03%20Data/WPS/Data%20from%20Akio/Western/Copy%20of%20Template%2023_Roster.xlsx?d=wf68f20e555ff4d49a7761eaf4fdaec52&amp;csf=1&amp;web=1&amp;e=i9BBGg	"here"

### Assumptions

- Using the Shrewsbury Track Diagram as reference, if the track direction is right to left, in the protection limits (which is a free text field), this is referred to as down main. If the track direction is left to right, in the protection limits (which is a free text field), this is referred to as up main. 
- 80% of jobs are cyclic, 20% are unique. The 20% are what we need to focus on currently because it causes a lot of disruption.

### Data Definition

There are 2 files, Data Definition 1 and 2. They are both located in [NR ALP & WPS (Private) - Documentation - All Documents (sharepoint.com)](https://arcadiso365.sharepoint.com/teams/NRALPWPSPrivate/Shared Documents/Forms/AllItems.aspx?originalPath=aHR0cHM6Ly9hcmNhZGlzbzM2NS5zaGFyZXBvaW50LmNvbS86ZjovdC9OUkFMUFdQU1ByaXZhdGUvRWd4VkRjTUh6QWhPc3RyR0pXSExHRkFCNTVaeTR2c0U1Y2RlN2Yyc3QwR1Ridz9ydGltZT1tMHlHbTY0ZTJVZw&viewid=6c33cc15-855b-427c-b0df-d1901e44d37d&id=%2Fteams%2FNRALPWPSPrivate%2FShared Documents%2FGeneral%2F02 Project Delivery%2F01 ALP %2B WPS - Common Delivery Aspects%2F03 Data%2FWPS%2FDocumentation). These files contain the Organisation hierarchy and the SQL queries used to extract the Plant Number specific to asset classes.

### Azure Data Catalogue

[NR ALP & WPS (Private) - Azure - All Documents (sharepoint.com)](https://arcadiso365.sharepoint.com/teams/NRALPWPSPrivate/Shared Documents/Forms/AllItems.aspx?originalPath=aHR0cHM6Ly9hcmNhZGlzbzM2NS5zaGFyZXBvaW50LmNvbS86ZjovdC9OUkFMUFdQU1ByaXZhdGUvRWd4VkRjTUh6QWhPc3RyR0pXSExHRkFCNTVaeTR2c0U1Y2RlN2Yyc3QwR1Ridz9ydGltZT1tMHlHbTY0ZTJVZw&viewid=6c33cc15-855b-427c-b0df-d1901e44d37d&id=%2Fteams%2FNRALPWPSPrivate%2FShared Documents%2FGeneral%2F02 Project Delivery%2F01 ALP %2B WPS - Common Delivery Aspects%2F03 Data%2FWPS%2FAzure)

## Status

**Data Issues**

We had 3 major issues with the possession data:

- Track id mismatch
- Asset id mismatch
- Unavailability of Start and End ELRs of each lines blocked within Possessions.

As far as I know, we have started to receive datasets in usable formats for some possessions in Shrewsbury region that ameliorate the first 2 issues. For the 3rd issue, currently we are assuming that. the Start and End ELR are the same. 

We are awaiting more complex possessions. Meanwhile, we are tasked with testing the library of possessions and workorders in the possessions planning tool.

## Next steps

- Ask users how they know someone can do a job given the workorder.
- Update the INA document version 2.0. section 3.3.1.
  - Update attributes: Uniqueness, Completeness, timeliness, Consistency etc.
- Feed in the workorders from the shrewsbury example into the possessions planning app.
- How does the planner highlight the people needed? We need this in data format. Can we have the document which shows
  - holidays



## Roles

- Tayo Ososanya - Data Modeller
- Richard Davey - Data Scientist
- Dan Scott
- Carl Takamizawa
- Akio Menlove

 

## Contacts 

- Richard Davey - Data Scientist



## Methodology

N/A



## File-location

All data sets, documentation and scripts in my possessions have been uploaded here [NR ALP & WPS (Private) - WPS - All Documents (sharepoint.com)](https://arcadiso365.sharepoint.com/teams/NRALPWPSPrivate/Shared Documents/Forms/AllItems.aspx?originalPath=aHR0cHM6Ly9hcmNhZGlzbzM2NS5zaGFyZXBvaW50LmNvbS86ZjovdC9OUkFMUFdQU1ByaXZhdGUvRWd4VkRjTUh6QWhPc3RyR0pXSExHRkFCNTVaeTR2c0U1Y2RlN2Yyc3QwR1Ridz9ydGltZT1tMHlHbTY0ZTJVZw&viewid=6c33cc15-855b-427c-b0df-d1901e44d37d&id=%2Fteams%2FNRALPWPSPrivate%2FShared Documents%2FGeneral%2F02 Project Delivery%2F01 ALP %2B WPS - Common Delivery Aspects%2F03 Data%2FWPS)

 and are also located in the SSD 

> D:\Desktop\Network Rail WPS 



## Scripts

All scripts used are on www.github.com/tayoso2/nr_wps_2021. 

`possessions_clean.r` is the script which joins Shrewsbury (simple) possessions and workorder data.

