# Office Placement Application - Backend 

This repository contains the backend service for the "Office Placement Application," a digital tool designed to track and manage faculty and staff office assignments across a campus. Built with Python, Django, and Django REST Framework, it provides a comprehensive API for managing buildings, offices, faculty, departments, and their assignments.

---

## Key Features

* **RESTful API:** Full CRUD (Create, Read, Update, Delete) operations for all data models.
* **Relational Data:** Manages the complex relationships between buildings, offices, faculty, and departments.
* **Assignment Tracking:** Links faculty to specific offices with start and end dates.
* **Office History:** Maintains a complete historical log of an office's occupants over time.
* **Capacity Control:** Includes business logic to prevent assigning personnel to an office that is already at full capacity.
* **Advanced Search & Filtering:** Allows filtering API results by department, building, floor, capacity, or occupant name.
* **Browsable API:** A user-friendly, browser-based interface for testing and interacting with the API, generated automatically by DRF.
* **Admin Panel:** A pre-configured Django Admin interface for easy and direct data management by administrators.

---

##  Technology Stack

* **Backend:** Python 3, Django
* **API:** Django REST Framework (DRF)
* **Database:** PostgreSQL
* **Dependencies:** `pip` / `requirements.txt`
* **DB Connection:** `dj_database_url`
* **Filtering:** `django-filter`

---

##  Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing.

### 1. Prerequisites

* [Python 3.8+](https://www.python.org/downloads/)
* [Git](https://git-scm.com/downloads)
* A running [PostgreSQL](https://www.postgresql.org/download/) database (or a cloud-based instance, e.g., from [Supabase](https://supabase.com/))

### 2. Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/zeyneptokgoz-cpu/office-placement-application-.git](https://github.com/zeyneptokgoz-cpu/office-placement-application-.git)
    cd office-placement-application-
    ```

2.  **Create and activate a virtual environment:**
    ```bash
    # Create the environment
    python -m venv venv

    # Activate the environment
    # On Windows:
    .\venv\Scripts\activate
    # On macOS/Linux:
    source venv/bin/activate
    ```

3.  **Install dependencies:**
    (First, ensure you have the core packages installed)
    ```bash
    pip install django djangorestframework psycopg2-binary dj-database-url django-filter
    
    # After installing, save them to requirements.txt
    pip freeze > requirements.txt
    
    # (If requirements.txt is already complete, just run:)
    # pip install -r requirements.txt
    ```

4.  **Configure the Database:**
    * Open the `office_management/settings.py` file.
    * Find the line `DATABASE_URL = '...'`.
    * Paste your PostgreSQL connection URL into the quotes. (e.g., `postgres://user:password@host:port/dbname`)

5.  **Run Database Migrations:**
    This will create all the necessary tables in your PostgreSQL database.
    ```bash
    python manage.py migrate
    ```

6.  **Create an Admin Superuser:**
    You will use this account to log in to the `/admin` panel.
    ```bash
    python manage.py createsuperuser
    ```
    (Follow the prompts to create your username and password)

### 3. Running the Server

Once setup is complete, you can run the development server:

```bash
python manage.py runserver
