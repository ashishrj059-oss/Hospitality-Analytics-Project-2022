# 🏨 Hospitality Domain Data Analytics Dashboard

An end-to-end Data & Business Analytics project for the hospitality domain. This project analyzes key operational and revenue metrics for AtliQ Grands (a hotel chain operating across major Indian cities) to provide strategic insights into revenue realization, room category performance, booking platform share, and occupancy trends.

---

## 📌 Executive Summary

AtliQ Grands operates in the luxury and business hotel sector in India. Due to strategic moves by competitors and inefficiencies in booking channel management, the chain experienced a decline in market share and revenue. 

This project delivers a comprehensive analytics solution—built in **Excel and Power BI / Power Query**—that evaluates **3 months of performance data** across key metrics such as **ADR, RevPAR, Occupancy %, Realisation %, and Cancellation Rates**.

---

## 🎯 Key Performance Indicators (KPIs)

The analytical model tracks core operational and financial metrics:

| Metric | Value | Business Definition / Formula |
| :--- | :--- | :--- |
| **Total Revenue** | **₹1,70,87,71,229** (~₹1.71B) | `SUM(fact_bookings[revenue_realized])` |
| **Total Bookings** | **134,590** | `COUNT(fact_bookings[booking_id])` |
| **Average Daily Rate (ADR)** | **₹12,696** | `Total Revenue / Total Bookings` |
| **Occupancy Rate (%)** | **57.87%** | `Successful Bookings / Total Capacity` |
| **Realisation (%)** | **70.15%** | `Checked Out Bookings / Total Bookings` |
| **Cancellation Rate (%)** | **24.83%** | `Cancelled Bookings / Total Bookings` |
| **No-Show Rate (%)** | **5.02%** | `No Show Bookings / Total Bookings` |
| **Average Customer Rating** | **3.6 / 5.0** | `AVERAGE(fact_bookings[ratings_given])` |
| **Analysis Period** | **92 Days** | May – July 2022 |

---

## 🌆 Key Business Insights

### 1. Performance by City
* **Mumbai** is the largest revenue driver, generating **₹668.6M** across 43,455 bookings, with the highest RevPAR (**₹8,906.66**).
* **Bangalore** follows with **₹420.4M** in revenue (32,016 bookings), maintaining an Occupancy % of **55.77%**.
* **Delhi** achieved the highest **Occupancy Rate (60.55%)** and Realisation Rate (**70.05%**), generating **₹294.5M**.
* **Hyderabad** logged 34,888 bookings generating **₹325.2M**, with an ADR of **₹5,413.69**.

### 2. Room Class Performance
* **Elite Rooms**: Generated the highest revenue (**₹560.27M**) with an ADR of **₹11,317.47** and average rating of **3.60**.
* **Premium Rooms**: Generated **₹462.17M** in revenue.
* **Presidential Suites**: Contributed **₹376.75M** to total revenue.
* **Standard Rooms**: Accounted for **₹309.58M** of realized revenue.

### 3. Booking Channels & Market Share
* **Others (Aggregators / Unclassified OTAs)**: Contributed **40.91%** of overall bookings.
* **MakeYourTrip**: Held the largest explicit channel share at **19.99%**.
* **LogTrip**: Represented **10.96%** of bookings.
* **Direct Online**: Represented **9.94%** of bookings.
* **Tripster** & **Journey**: Accounted for **7.16%** and **6.02%** respectively.
* **Direct Offline**: Represented **5.02%** of bookings.

---
**🛠️ Tech Stack & Tools Used**

Business Intelligence & Visualization: Power BI / Excel Dashboards

Data Transformation & ETL: Power Query / DAX

Data Analysis & Modeling: Data Analytics, Pivot Tables, Advanced Formulas

Version Control: Git & GitHub

**💡 Recommendations for Business Strategy**

Optimize Dynamic Pricing: Implement dynamic pricing strategies during peak demand weeks (W19, W20, W24) to boost RevPAR without negatively affecting occupancy.

Reduce Cancellation Rates: With cancellation rates sitting near 24.83%, introduce non-refundable booking tiers or partial prepayment policies for third-party OTAs.

Direct Booking Incentives: Boost direct online bookings (currently 9.94%) by introducing loyalty perks or direct booking discounts to reduce commission costs from third-party channels (MakeYourTrip, LogTrip).

Targeted Service Improvements: Address guest feedback in lower-rated properties to improve the overall chain rating above the current 3.6 / 5.0 average.

**👥 Project Team**

Ashish Raj A – Project Lead

Yash Bhagwan Mundhe – Project Lead

Manjiri Ingale

Yash Naresh Satpute

Usha Asode

Aaditya Pravin Borkar

Jaismeen Kaur


## 📐 Data Model & DAX Formulas

The project uses DAX measures for robust KPI calculations across fact and dimension tables:

```dax
// Total Revenue
Total Revenue = SUM(fact_bookings[revenue_realized])

// Total Bookings Count
Total Bookings = COUNT(fact_bookings[booking_id])

// Average Daily Rate (ADR)
ADR = DIVIDE([Total Revenue], [Total Bookings], 0)

// Total Cancelled Bookings
Total cancelled booking = CALCULATE(COUNT(fact_bookings[booking_id]), fact_bookings[booking_status] = "Cancelled")

// Cancellation Rate
Cancellation % = DIVIDE([Total cancelled booking], COUNT(fact_bookings[booking_id]), 0)

// Realisation Percentage
Realisation % = DIVIDE(CALCULATE(COUNT(fact_bookings[booking_id]), fact_bookings[booking_status] = "Checked Out"), [Total Bookings])

// No Show Rate
No Show Rate % = DIVIDE(CALCULATE(COUNT(fact_bookings[booking_id]), fact_bookings[booking_status] = "No show"), [Total Bookings])

// Distinct Days Count
No of Days = DISTINCTCOUNT(fact_bookings[check_in_date])
