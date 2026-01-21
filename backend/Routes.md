# Notes API - Postman Documentation

**Base URL:** `{{host}}/api`  
*(e.g., http://localhost:8000/api)*

## 🔑 Authentication (Public Routes)

### 1. Register
*   **Method:** `POST`
*   **URL:** `/register`
*   **Body (JSON):**
    ```json
    {
        "name": "John Doe",
        "email": "john@example.com",
        "password": "password123"
    }
    ```

### 2. Login
*   **Method:** `POST`
*   **URL:** `/login`
*   **Body (JSON):**
    ```json
    {
        "email": "john@example.com",
        "password": "password123"
    }
    ```
    *Note: Save the `token` from the response to use in protected routes.*

---

## 🛡️ Protected Routes
*These require a `Bearer Token` in the Authorization header.*

### 3. Logout (Current Device)
*   **Method:** `POST`
*   **URL:** `/logout`

### 4. Logout (All Devices)
*   **Method:** `POST`
*   **URL:** `/logout-all`

### 5. Get Authenticated User
*   **Method:** `GET`
*   **URL:** `/me`

---

## 📝 Notes Management (CRUD)
*Require `Bearer Token`*

### 6. List All Notes
*   **Method:** `GET`
*   **URL:** `/notes`

### 7. Create Note
*   **Method:** `POST`
*   **URL:** `/notes`
*   **Body (JSON):**
    ```json
    {
        "title": "My Note",
        "content": "This is the note body"
    }
    ```

### 8. View Note
*   **Method:** `GET`
*   **URL:** `/notes/{id}`

### 9. Update Note
*   **Method:** `PUT` / `PATCH`
*   **URL:** `/notes/{id}`
*   **Body (JSON):**
    ```json
    {
        "title": "Updated Title",
        "content": "Updated content"
    }
    ```

### 10. Delete Note
*   **Method:** `DELETE`
*   **URL:** `/notes/{id}`

---

## 👥 Admin/Debug
### 11. List All Users
*   **Method:** `GET`
*   **URL:** `/users`
