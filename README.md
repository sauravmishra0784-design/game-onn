 GAME-ONN – Gaming Café Booking System

GAME-ONN is a full-stack web application developed as part of a college project to simplify the daily operations of a gaming café.  
It allows users to book PCs, track sessions, and order snacks while providing an admin panel to manage users, bookings, and overall café activity.

---


Features
- User registration and login  
- Real-time PC slot booking  
- Admin dashboard to monitor sessions and users  
- Snack ordering linked to bookings  
- MySQL database for structured data management  

---

 Tech Stack
*Frontend:* HTML, CSS, JavaScript  
*Backend:* Node.js, Express.js  
*Database:* MySQL  
*Tools Used:* MySQL Workbench, Visual Studio Code  

---

Setup and Usage

1. **Clone this repository**
   ```bash
 git clone https://github.com/sauravmishra0784-design/game-onn.git
Install dependencies

npm install
Set up the database
Create a new MySQL database named gameonn_db.
Import the SQL file provided in the /database folder (Dump20251003.sql) to create all required tables.
The database includes tables for users, slots, bookings, snacks, orders, games, and slot–game mappings.
Configure environment variables
In the root folder, create a file named .env and add:

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password_here
DB_NAME=gameonn_db
This keeps your database credentials private.
Update your server.js (Database connection)

Replace your existing database connection with:
require('dotenv').config();
const mysql = require('mysql2');
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});
Then create a .gitignore file and add this line:

.env
This ensures your password and credentials are not visible on GitHub.
Run the app

node server.js
Open in browser
Visit http://localhost:3000
Author
Developed by Saurav Mishra

B.Sc. IT – KET’s V.G. Vaze College of Arts, Science and Commerce
