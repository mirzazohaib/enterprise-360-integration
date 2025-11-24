# Enterprise 360° Integration Hub

![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen) ![MuleSoft](https://img.shields.io/badge/Platform-MuleSoft-blue) ![License](https://img.shields.io/badge/License-MIT-yellow)

**A full-lifecycle API-Led Connectivity solution orchestrating an Order-to-Fulfillment pipeline.** This project unifies data from **PostgreSQL**, **Legacy SOAP Systems**, **SFTP/CSV**, and **External REST APIs** into a coherent Customer 360° view.

---

## 🏗 Architecture

_(Architecture Diagram to be inserted here)_

## 🚀 Key Features

- **Legacy Modernization:** Wraps SOAP XML complexities behind a clean RESTful System API.
- **Reliability:** Implements Dead Letter Queues (DLQ) for zero-data-loss error handling.
- **Orchestration:** Intelligent routing based on real-time inventory stock levels.
- **CI/CD:** Automated build pipeline via GitHub Actions.

---

## 📸 Implementation Evidence

### 1. Legacy System Modernization (SOAP to REST)

**Goal:** Abstract the complexity of the legacy XML-based inventory system.
**Proof:** The screenshot below demonstrates the **Inventory System API** accepting a clean JSON request. Internally, the flow transforms this into a SOAP Envelope, queries the mock legacy backend, and maps the XML response back to simplified JSON.

![Inventory System API Proof](/src/docs/assets/sys-inventory-proof.png)

---

### 2. Financial Data Ingestion (CSV/SFTP)
**Goal:** Automate the digitization of legacy financial records from flat files.
**Proof:** The console log below shows the **Finance System API** detecting a new CSV file in the watched directory, parsing the flat-file structure, and converting it into a standard JSON array for downstream processing.

![Finance System CSV Log](/src/docs/assets/sys-finance-csv-logs.png)

---