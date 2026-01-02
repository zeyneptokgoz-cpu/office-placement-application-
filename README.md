This project is a robust RESTful API designed to manage university and corporate office resources. It facilitates the management of Buildings, Departments, Faculty Members, Offices, and Staff Assignments.

Built with Django REST Framework and Dockerized with PostgreSQL, this backend is architected to serve data securely to any Frontend application (React, Vue, Vanilla JS).

## Technology Stack

* **Core Framework:** Python 3.10, Django 5.x
* **API:** Django REST Framework (DRF)
* **Database:** PostgreSQL 15
* **Containerization:** Docker & Docker Compose
* **Authentication:** JWT (JSON Web Tokens) via `simplejwt`
* **Security:** CORS Headers configured for Frontend integration

## Project Structure

```text
office-management/
├── api/                  # Main application (Models, Serializers, Views)
├── office_management/    # Project settings (URL configurations, settings.py)
├── requirements.txt      # Python dependencies
├── docker-compose.yml    # Docker services configuration
├── Dockerfile            # Backend image build instructions
├── populate.py           # Database seeding script
└── manage.py             # Django command-line utility
PrerequisitesEnsure the following is installed on your system:Docker Desktop (running Linux containers)Installation and SetupFollow these steps to deploy the application locally.1. Build and Run ContainersOpen your terminal in the project root directory and execute the following command:Bashdocker-compose up --build -d
This command will:Build the Python backend image.Start the PostgreSQL database container (office_db).Start the Backend server container (office_backend) on Port 8000.2. Database Seeding (Recommended)To populate the database with initial real-world data (Buildings, Departments, Faculty, and Offices) and generate user accounts automatically, run the included population script:Bashdocker exec -it office_backend python populate.py
Note: This script checks for existing data to prevent duplicates.3. Create an Administrative UserTo access the Django Admin Panel, you must create a superuser account. Run the following command while the container is running:Bashdocker exec -it office_backend python manage.py createsuperuser
Follow the on-screen prompts to set a username and password.API DocumentationThe API follows RESTful conventions.Base URL: http://127.0.0.1:8000/api/AuthenticationThe API is protected using JWT. You must obtain a token to access protected endpoints.1. Register a UserEndpoint: POST /api/sign-up/Body:JSON{
    "username": "newuser",
    "email": "test@test.com",
    "password": "password123"
}
2. Login (Obtain Token)Endpoint: POST /api/token/Body:JSON{
    "username": "newuser",
    "password": "password123"
}
Response:JSON{
    "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
Important: For all subsequent requests to protected endpoints, you must include the Access Token in the request header:Authorization: Bearer <YOUR_ACCESS_TOKEN>Key EndpointsMethodEndpointDescriptionGET/api/offices/List all offices with nested Building and Department details.GET/api/buildings/List all buildings.GET/api/departments/List all departments.GET/api/faculty/List all faculty members.GET/api/assignments/View current staff-room assignments.Sample Response (GET /offices/)The API returns a nested JSON structure:JSON[
    {
        "room_id": 1,
        "room_number": "AS-101",
        "capacity": 4,
        "floor_id": 1,
        "building": {
            "building_id": 1,
            "name": "Engineering Faculty",
            "code": "ENG"
        },
        "department": {
            "department_id": 2,
            "name": "Computer Science"
        }
    }
]
Admin PanelThe project includes a graphical interface for database management.Navigate to: http://127.0.0.1:8000/admin/Login using the superuser credentials created in the installation step.From this panel, you can manually Add, Edit, or Delete records.Frontend IntegrationCORS (Cross-Origin Resource Sharing) is configured to allow connections from standard frontend development environments.Allowed Origins:http://localhost:3000 (React/Vue/Angular default)http://127.0.0.1:5500 (VS Code Live Server)To modify these origins, update the CORS_ALLOWED_ORIGINS list in office_management/settings.py.TroubleshootingIssue: Connection Refused / Site can't be reachedEnsure Docker Desktop is running.Check if the containers are active by running docker ps.If containers are stopped, run docker-compose up again.Issue: Database Connection ErrorEnsure the HOST variable in settings.py is set to office_db.Ensure the database container is fully initialized before the backend tries to connect.Issue: 500 Internal Server ErrorView the server logs to diagnose the issue:Bashdocker logs office_backend --tail 50