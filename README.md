# Office Placement Application - Backend API

This repository contains the robust backend service for the "Office Placement Application," a digital tool designed to track and manage faculty and staff office assignments across a campus. Built with **Python**, **Django REST Framework**, and **Docker**, it provides a secure and comprehensive API for managing buildings, offices, faculty, departments, and their assignments.

This system is designed to integrate seamlessly with an existing legacy PostgreSQL database.

---

## Key Features

* **🐳 Dockerized:** Fully containerized application for easy deployment and consistent development environments.
* **🔐 Secure Authentication:** Full **JWT (JSON Web Token)** implementation for secure login and session management.
* **👤 User Registration:** Public endpoint allowing new users to sign up and create accounts via the API.
* **🛡️ Role-Based Access Control (RBAC):**
    * **Admin:** Full access to Create, Read, Update, and Delete (CRUD) all data.
    * **Authenticated Users:** Read-only access to view faculty lists and assignments.
    * **Public:** Access to general building and department information.
* **💾 Legacy Database Integration:** Expertly mapped to an existing PostgreSQL schema, preserving historical data integrity.
* **🧪 Automated Testing:** Comprehensive unit tests covering user registration, authentication flows, and permission enforcement.
* **🏢 Assignment Tracking:** Links faculty to specific offices with start/end dates, maintaining a historical log.
* **🔎 Advanced Filtering:** Filter API results by department, building, floor, capacity, or occupant name.

---

## 🛠️ Technology Stack

* **Core:** Python 3.10+, Django 5
* **API:** Django REST Framework (DRF)
* **Authentication:** `djangorestframework-simplejwt`
* **Infrastructure:** Docker & Docker Compose
* **Database:** PostgreSQL (Production-ready)
* **Environment:** `python-dotenv` for secure configuration
* **Utilities:** `dj_database_url`, `django-filter`

---

## 🏁 Getting Started

You can run this project either using **Docker** (Recommended) or **Locally** (Python venv).

### Option 1: Running with Docker (Recommended) 🐳

This is the fastest way to get started. You don't need to install Python or PostgreSQL on your machine.

**Prerequisites:**
* [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running.

**Steps:**

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/zeyneptokgoz-cpu/office-placement-application-.git](https://github.com/zeyneptokgoz-cpu/office-placement-application-.git)
    cd office-placement-application-
    ```

2.  **Start the Application:**
    ```bash
    docker-compose up --build
    ```
    *Wait until you see "database system is ready to accept connections" in the logs.*

3.  **Setup Database (First Time Only):**
    Open a *new* terminal window and run these commands to import the legacy data and fix ID sequences:
    
    ```bash
    # Import legacy SQL data (If you have the .sql file)
    docker cp officeplacement_backup.sql office-placement-backend-db-1:/backup.sql
    docker-compose exec db psql -U postgres -d officeplacementapp -f /backup.sql
    
    # Fix ID sequences (Crucial for adding new data)
    docker-compose exec web python manage.py sqlsequencereset api | docker-compose exec -T db psql -U postgres -d officeplacementapp
    
    # Create required system tables
    docker-compose exec web python manage.py migrate
    ```

4.  **Create an Admin User:**
    ```bash
    docker-compose exec web python manage.py createsuperuser
    ```

The API is now running at: **`http://127.0.0.1:8000/`**

---

### Option 2: Running Locally (Manual Setup) 🐍

If you prefer to run Python directly on your machine.

**Prerequisites:**
* Python 3.8+
* PostgreSQL installed and running locally.

**Steps:**

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/zeyneptokgoz-cpu/office-placement-application-.git](https://github.com/zeyneptokgoz-cpu/office-placement-application-.git)
    cd office-placement-application-
    ```

2.  **Create and activate a virtual environment:**
    ```bash
    # Windows
    python -m venv venv
    .\venv\Scripts\activate

    # macOS/Linux
    python3 -m venv venv
    source venv/bin/activate
    ```

3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Configure Environment Variables:**
    Create a `.env` file in the root directory and add your local DB credentials:
    ```ini
    DEBUG=True
    SECRET_KEY=your-secret-key
    DATABASE_URL=postgres://postgres:password@localhost:5432/officeplacementapp
    ```

5.  **Database Setup:**
    ```bash
    # If using the SQL backup:
    psql -U postgres -d officeplacementapp -f officeplacement_backup.sql
    python manage.py sqlsequencereset api | psql -U postgres -d officeplacementapp
    
    # Run migrations for system tables
    python manage.py migrate
    ```

6.  **Run Server:**
    ```bash
    python manage.py runserver
    ```

---

## 🧪 Running Tests

To ensure system stability, run the automated unit tests.

**With Docker:**
```bash
docker-compose exec web python manage.py test api