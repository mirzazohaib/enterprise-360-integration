# Enterprise 360° Integration Hub

![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen) ![MuleSoft](https://img.shields.io/badge/Platform-MuleSoft-blue) ![License](https://img.shields.io/badge/License-MIT-yellow)

**A full-lifecycle API-Led Connectivity solution orchestrating an Order-to-Fulfillment pipeline.** This project unifies data from **PostgreSQL**, **Legacy SOAP Systems**, **SFTP/CSV**, and **External REST APIs** into a coherent Customer 360° view.

---

## 🏗 Architecture

```mermaid
graph TD
    %% Actors
    Client([Sales Portal / Mobile App])

    %% Experience Layer
    subgraph Experience_Layer [Experience Layer]
        ExpOrder[Order Exp API]
        ExpCust[Customer Exp API]
    end

    %% Process Layer
    subgraph Process_Layer [Process Layer]
        ProcOrder[Order Orchestration API]
        Proc360[Customer 360 Aggregator]
    end

    %% System Layer
    subgraph System_Layer [System Layer]
        SysInv[Inventory System API]
        SysDB[Fulfillment System API]
        SysCRM[CRM System API]
        SysFin[Finance System API]
    end

    %% Backends
    Legacy((Legacy SOAP))
    NeonDB[(Neon PostgreSQL)]
    Reqres((SaaS CRM))
    CSV((SFTP / CSV))

    %% Connections
    Client --> ExpOrder
    Client --> ExpCust

    ExpOrder --> ProcOrder
    ExpCust --> Proc360

    ProcOrder -- Check Stock --> SysInv
    ProcOrder -- Insert Order --> SysDB

    Proc360 -- Parallel Call --> SysCRM
    Proc360 -- Parallel Call --> SysFin

    SysInv <--> Legacy
    SysDB <--> NeonDB
    SysCRM <--> Reqres
    SysFin <--> CSV
```

## 🚀 Key Features

- **Legacy Modernization:** Wraps SOAP XML complexities behind a clean RESTful System API.
- **Reliability:** Implements Dead Letter Queues (DLQ) for zero-data-loss error handling.
- **Orchestration:** Intelligent routing based on real-time inventory stock levels.
- **CI/CD:** Automated build pipeline via GitHub Actions.

---

## 🔐 Enterprise Architecture & Security

### 1. Externalized Configuration Strategy

**Goal:** Enable "Write Once, Deploy Anywhere" by removing hardcoded values.
**Implementation:**

- **Environment Isolation:** Configuration is split into `dev.yaml`, `sit.yaml`, and `prod.yaml`. The specific environment is selected at runtime via the `-Denv` variable.
- **Centralized Management:** A single `global.xml` file manages all connector configurations (HTTP, Database, VM), ensuring consistency across all API flows.

### 2. Secure Properties (Encryption at Rest)

**Goal:** Protect sensitive credentials (database passwords) from exposure.
**Implementation:**

- **Mule Secure Properties Module:** Used to encrypt secrets using Blowfish/AES algorithms.
- **Runtime Decryption:** Secrets are stored as `![encrypted_value]` in the source code and decrypted only in memory using a master key passed at runtime (`-Dkey=...`).

---

## 📸 Implementation Evidence

### 1. Legacy System Modernization (SOAP to REST)

**Goal:** Abstract the complexity of the legacy XML-based inventory system.
**Proof:** The screenshot below demonstrates the **Inventory System API** accepting a clean JSON request. Internally, the flow transforms this into a SOAP Envelope, queries the mock legacy backend, and maps the XML response back to simplified JSON.

![Inventory System API Proof](docs/assets/sys-inventory-proof.png)

---

### 2. Financial Data Ingestion (CSV/SFTP)

**Goal:** Automate the digitization of legacy financial records from flat files.
**Proof:** The console log below shows the **Finance System API** detecting a new CSV file in the watched directory, parsing the flat-file structure, and converting it into a standard JSON array for downstream processing.

![Finance System CSV Log](docs/assets/sys-finance-csv-logs.png)

---

### 3. External CRM Integration (REST & SaaS)

**Goal:** Unify customer profile data from external SaaS platforms using secure API Key authentication.
**Proof:** The screenshot below shows the **CRM System API** proxying a request to an external REST service (reqres.in), injecting the required `x-api-key` header, and transforming the specific vendor response into our canonical "Customer Profile" JSON format.

![CRM System API Proof](docs/assets/sys-crm-proof.png)

---

## 🛡️ Reliability & Resilience

### 1. Dead Letter Queue (DLQ) Pattern

**Goal:** Prevent data loss during database outages.
**Architecture:**

1.  **Try:** The system attempts to insert the order into PostgreSQL.
2.  **Catch:** If connectivity fails, the **On Error Propagate** scope catches the transaction.
3.  **Recover:** The payload is published to a persistent **VM Queue (DLQ)**.
4.  **Process:** A separate background flow listens to the DLQ and safely archives the failed message for manual retry.

**Proof:** The screenshot below shows the `dlq_error_log` table capturing a failed transaction that would have otherwise been lost.

![DLQ Proof](docs/assets/rel-dlq-proof.png)

---

### 2. Global Error Handling Strategy

**Goal:** Ensure a consistent, professional API experience even when systems fail.
**Architecture:** A centralized Error Handler catches all system exceptions (404 Not Found, 405 Method Not Allowed, 500 Server Error). Instead of exposing raw Java stack traces, the API transforms these into standardized JSON error responses with correlation IDs for tracking.

**Proof:** The screenshot below shows the Global Handler catching an invalid `GET` request (Method Not Allowed) and returning a clean JSON response instead of a system crash.

![Global Error Handler Proof](docs/assets/rel-global-error-proof.png)

---

## 🧠 Process Layer (Orchestration)

### 1. Smart Order Routing

**Goal:** Implement business logic to prevent orders for out-of-stock items.
**Logic:** The **Process API** orchestrates calls between the Inventory System and the Fulfillment Database. It uses a **Choice Router** to make real-time decisions:

- **Path A (In Stock):** Proceed to insert order into PostgreSQL.
- **Path B (Out of Stock):** Immediately reject order with HTTP 409 Conflict.

![Orchestration Flow](docs/assets/proc-orchestration-flow.png)

---

### 2. Logic Validation (Negative Testing)

**Goal:** Ensure the system correctly rejects orders when inventory is unavailable.
**Proof:** By sending a specific product ID (`P-999`), the system simulates an "Out of Stock" scenario. The Process API correctly catches this state and returns a **409 Conflict** status, preventing the database insertion.

![409 Conflict Proof](docs/assets/proc-order-409-proof.png)

---

### 3. Customer 360 Aggregation (Scatter-Gather)

**Goal:** Reduce API latency by fetching data from multiple systems in parallel.
**Logic:** The **Customer Process API** uses a **Scatter-Gather** router to simultaneously call the external CRM and the internal Finance History system. It aggregates the responses into a unified profile 2x faster than sequential calls.

![Customer 360 Proof](docs/assets/proc-customer360-proof.png)

---

## 🧪 Quality Assurance

### 1. Automated Unit Testing (MUnit)

**Goal:** Verify business logic transformations in isolation without external dependencies.
**Proof:** The MUnit test suite validates the **Inventory System API**. It mocks the input payload (`P-101`) and asserts that the flow correctly returns the status `IN_STOCK`, proving the DataWeave logic is accurate.

![MUnit Test Result](docs/assets/dev-munit-proof.png)

---

## 📉 Agile Delivery Methodology

This project followed a strict **Agile Scrum** methodology managed via JIRA.

- **Sprints:** 2-week delivery cycles.
- **Epics:** Grouped by Architectural Layer (System, Process, Experience).
- **Stories:** Defined with clear Acceptance Criteria and Gherkin syntax.

![JIRA Backlog](docs/assets/jira-backlog.png)
