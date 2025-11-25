# Office Placement Application - Backend API

This repository contains the robust backend service for the "Office Placement Application," a digital tool designed to track and manage faculty and staff office assignments across a campus. Built with **Python** and **Django REST Framework**, it provides a secure and comprehensive API for managing buildings, offices, faculty, departments, and their assignments.

This system is designed to integrate seamlessley with an existing legacy PostgreSQL database.

---

##  Key Features

* **🔐 Secure Authentication:** Full **JWT (JSON Web Token)** implementation for secure login and session management.
* **👤 User Registration:** Public endpoint allowing new users to sign up and create accounts via the API.
* **🛡️ Role-Based Access Control (RBAC):**
    * **Admin:** Full access to Create, Read, Update, and Delete (CRUD) all data.
    * **Authenticated Users:** Read-only access to view faculty lists and assignments.
    * **Public:** Access to general building and department information.
* **💾 Legacy Database Integration:** Expertly mapped to an existing PostgreSQL schema, preserving historical data integrity without data migration conflicts.
* **🧪 Automated Testing:** Comprehensive unit tests covering user registration, authentication flows, and permission enforcement.
* **🏢 Assignment Tracking:** Links faculty to specific offices with start/end dates, maintaining a historical log of occupants.
* **📊 Capacity Control:** Business logic prevents assigning personnel to fully occupied offices.
* **🔎 Advanced Filtering:** Filter API results by department, building, floor, capacity, or occupant name.

---

## 🛠️ Technology Stack

* **Core:** Python 3.10+, Django 5
* **API:** Django REST Framework (DRF)
* **Authentication:** `djangorestframework-simplejwt`
* **Database:** PostgreSQL (Production-ready)
* **Environment:** `python-dotenv` for secure configuration
* **Utilities:** `dj_database_url`, `django-filter`

---

## 🏁 Getting Started

Follow these instructions to set up the project on your local machine for development and testing.

### 1. Prerequisites

* [Python 3.8+](https://www.python.org/downloads/)
* [Git](https://git-scm.com/downloads)
* [PostgreSQL](https://www.postgresql.org/download/) (Local installation or cloud instance like Supabase)

### 2. Installation & Setup

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
    Create a `.env` file in the root directory (next to `manage.py`) and add your database credentials.
    * **Note:** Do not edit `settings.py` directly for secrets.

    ```ini
    # .env file content
    DEBUG=True
    SECRET_KEY=your-secret-key-here
    # Format: postgres://USER:PASSWORD@HOST:PORT/DB_NAME
    DATABASE_URL=postgres://postgres:password@localhost:5432/officeplacementapp
    ```

5.  **Database Setup (Legacy Integration):**
     Since this project uses a legacy database schema, you should restore the provided SQL backup instead of standard migration.

    *Option A: If you have the `officeplacement_backup.sql` file:*
    ```bash
    # Restore the database structure and data
    psql -U postgres -d officeplacementapp -f officeplacement_backup.sql
    
    # Fix Django ID sequences (Crucial step!)
    python manage.py sqlsequencereset api | psql -U postgres -d officeplacementapp
    ```

    *Option B: If starting fresh (Structure only):*
    ```bash
    python manage.py migrate
    ```

6.  **Create an Admin User:**
    ```bash
    python manage.py createsuperuser
    ```

### 3. Running the Server

Start the local development server:

```bash
python manage.py runserver