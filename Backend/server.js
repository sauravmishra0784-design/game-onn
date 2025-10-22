require('dotenv').config();
const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql");
const cors = require("cors");
const path = require("path"); // ADD THIS
const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public'))); // ADD THIS LINE




const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD, // <-- Reads the password from .env
  database: process.env.DB_NAME
});

db.connect((err) => {
    if (err) {
        console.error("Database connection failed: " + err.stack);
        return;
    }
    console.log("Connected to MySQL database!");
});

// User Routes

app.post("/register", (req, res) => {
    const { username, email, phone, password } = req.body;
    const sql = "INSERT INTO users (username, email, phone, password) VALUES (?, ?, ?, ?)";
    db.query(sql, [username, email, phone, password], (err, result) => {
        if (err) {
            console.error(err);
            if (err.code === 'ER_DUP_ENTRY') {
                return res.status(409).send("Email or Username already exists.");
            }
            return res.status(500).send("Error registering user");
        }
        res.status(200).send("User registered successfully!");
    });
});

app.post('/login', (req, res) => {
    const { email, password } = req.body;
    const sql = "SELECT * FROM users WHERE email = ?";
    db.query(sql, [email], (err, result) => {
        if (err) return res.status(500).send("Database error");
        if (result.length > 0) {
            if (password === result[0].password) {
                res.status(200).json({
                    message: "Login successful",
                    user_id: result[0].id,
                    username: result[0].username
                });
            } else {
                res.status(401).send("Incorrect password");
            }
        } else {
            res.status(404).send("User not found");
        }
    });
});

app.get('/my-bookings/:userId', (req, res) => {
    const { userId } = req.params;
    const sql = `
        SELECT 
            b.booking_id, 
            s.slot_name, 
            s.rate,
            (s.rate * TIMESTAMPDIFF(HOUR, b.start_time, b.end_time)) as slot_total,
            COALESCE(SUM(sn.price * o.quantity), 0) as snacks_total,
            ((s.rate * TIMESTAMPDIFF(HOUR, b.start_time, b.end_time)) + COALESCE(SUM(sn.price * o.quantity), 0)) as grand_total,
            b.booking_time,
            b.start_time, 
            b.end_time,
            GROUP_CONCAT(CONCAT(sn.snack_name, ' (', o.quantity, 'x)') SEPARATOR ', ') as ordered_snacks
        FROM bookings b
        JOIN slots s ON b.slot_id = s.slot_id
        LEFT JOIN orders o ON b.booking_id = o.booking_id
        LEFT JOIN snacks sn ON o.snack_id = sn.snack_id
        WHERE b.user_id = ?
        GROUP BY b.booking_id
        ORDER BY b.start_time DESC`;
    db.query(sql, [userId], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error fetching your bookings");
        }
        res.json(result);
    });
});

// Public Routes

app.get("/slots", (req, res) => {
    const sql = "SELECT * FROM slots";
    db.query(sql, (err, result) => {
        if (err) return res.status(500).json({ message: "Error fetching slots" });
        res.json(result);
    });
});

app.get("/slots/:slot_id/games", (req, res) => {
    const { slot_id } = req.params;
    const sql = `
        SELECT g.game_name, g.genre 
        FROM games g
        JOIN slot_games sg ON g.game_id = sg.game_id
        WHERE sg.slot_id = ?`;
    db.query(sql, [slot_id], (err, result) => {
        if (err) return res.status(500).json({ message: "Error fetching games" });
        res.json(result);
    });
});

app.get('/snacks', (req, res) => {
    const sql = "SELECT * FROM snacks ORDER BY snack_name";
    db.query(sql, (err, result) => {
        if (err) return res.status(500).json({ message: "Error fetching snacks" });
        res.json(result);
    });
});

// Transaction Routes

app.post("/book", (req, res) => {
    const { slot_id, user_id, start_time, duration_hours } = req.body;

    const startTimeObj = new Date(start_time);
    const endTimeObj = new Date(startTimeObj.getTime() + duration_hours * 60 * 60 * 1000);
    
    const formattedStartTime = startTimeObj.toISOString().slice(0, 19).replace('T', ' ');
    const formattedEndTime = endTimeObj.toISOString().slice(0, 19).replace('T', ' ');

    const conflictCheckSql = `
        SELECT * FROM bookings 
        WHERE slot_id = ? 
        AND (start_time < ? AND end_time > ?)
    `;
    db.query(conflictCheckSql, [slot_id, formattedEndTime, formattedStartTime], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error checking for booking conflicts.");
        }

        if (result.length > 0) {
            return res.status(409).send("This time slot is already booked. Please choose a different time.");
        }

        const bookSql = "INSERT INTO bookings (slot_id, user_id, start_time, end_time) VALUES (?, ?, ?, ?)";
        db.query(bookSql, [slot_id, user_id, formattedStartTime, formattedEndTime], (err, bookingResult) => {
            if (err) {
                console.error(err);
                return res.status(500).send("Error creating booking");
            }
            
            res.status(200).json({
                message: "Slot booked successfully!",
                booking_id: bookingResult.insertId
            });
        });
    });
});

app.post('/orders', (req, res) => {
    const { booking_id, snack_id, quantity } = req.body;
    if (!booking_id || !snack_id || !quantity) {
        return res.status(400).send("Missing required fields.");
    }
    const sql = "INSERT INTO orders (booking_id, snack_id, quantity) VALUES (?, ?, ?)";
    db.query(sql, [booking_id, snack_id, quantity], (err, result) => {
        if (err) {
            console.error(err);
            if (err.code === 'ER_NO_REFERENCED_ROW_2') {
                return res.status(404).send("Booking ID not found.");
            }
            return res.status(500).send("Error placing order.");
        }
        res.status(201).send("Order placed successfully!");
    });
});

// Admin Routes

app.post('/admin/login', (req, res) => {
    const ADMIN_USERNAME = "admin";
    const ADMIN_PASSWORD = "password123";
    const { username, password } = req.body;
    if (username === ADMIN_USERNAME && password === ADMIN_PASSWORD) {
        res.status(200).send("Login successful");
    } else {
        res.status(401).send("Invalid credentials");
    }
});

app.get('/admin/bookings/current', (req, res) => {
    const sql = `
        SELECT 
            b.booking_id, 
            u.username, 
            s.slot_name, 
            b.start_time, 
            b.end_time,
            GROUP_CONCAT(
                CONCAT(sn.snack_name, ' (', o.quantity, 'x)') 
                SEPARATOR ', '
            ) AS ordered_snacks
        FROM bookings b
        JOIN users u ON b.user_id = u.id
        JOIN slots s ON b.slot_id = s.slot_id
        LEFT JOIN orders o ON b.booking_id = o.booking_id
        LEFT JOIN snacks sn ON o.snack_id = sn.snack_id
        WHERE DATE(b.start_time) >= CURDATE()
        GROUP BY b.booking_id
        ORDER BY b.start_time ASC
    `;
    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error fetching current bookings");
        }
        res.json(result);
    });
});

app.get('/admin/users', (req, res) => {
    const sql = "SELECT id, username, email, phone, Registration_date FROM users";
    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error fetching users");
        }
        res.json(result);
    });
});

app.delete('/bookings/:bookingId', (req, res) => {
    const { bookingId } = req.params;
    
    const findSlotSql = "SELECT slot_id FROM bookings WHERE booking_id = ?";
    db.query(findSlotSql, [bookingId], (err, result) => {
        if (err || result.length === 0) {
            console.error(err);
            return res.status(404).send("Booking not found.");
        }
        
        const slotId = result[0].slot_id;
        const deleteSql = "DELETE FROM bookings WHERE booking_id = ?";
        db.query(deleteSql, [bookingId], (err, deleteResult) => {
            if (err) {
                console.error(err);
                return res.status(500).send("Error deleting booking.");
            }
            const updateSlotSql = "UPDATE slots SET availability = TRUE WHERE slot_id = ?";
            db.query(updateSlotSql, [slotId], (err, updateResult) => {
                if (err) {
                    console.error(err);
                    return res.status(500).send("Error making slot available.");
                }
                res.status(200).send("Booking cancelled successfully.");
            });
        });
    });
});

// Games Management

app.get('/admin/games', (req, res) => {
    const sql = "SELECT * FROM games ORDER BY game_name";
    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error fetching games");
        }
        res.json(result);
    });
});

app.post('/admin/games', (req, res) => {
    const { game_name, genre } = req.body;
    const sql = "INSERT INTO games (game_name, genre) VALUES (?, ?)";
    db.query(sql, [game_name, genre], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error adding game");
        }
        res.status(200).send("Game added successfully!");
    });
});

app.delete('/admin/games/:gameId', (req, res) => {
    const { gameId } = req.params;

    const deleteAssignmentsSql = "DELETE FROM slot_games WHERE game_id = ?";
    db.query(deleteAssignmentsSql, [gameId], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error removing game assignments");
        }

        const deleteGameSql = "DELETE FROM games WHERE game_id = ?";
        db.query(deleteGameSql, [gameId], (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).send("Error deleting game");
            }
            res.status(200).send("Game and its assignments deleted successfully!");
        });
    });
});

app.get('/admin/slots', (req, res) => {
    const sql = "SELECT slot_id, slot_name FROM slots ORDER BY slot_name";
    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error fetching slots");
        }
        res.json(result);
    });
});

app.post('/admin/assign-game', (req, res) => {
    const { game_id, slot_id } = req.body;
    
    const checkSql = "SELECT * FROM slot_games WHERE slot_id = ? AND game_id = ?";
    db.query(checkSql, [slot_id, game_id], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error checking assignment");
        }
        
        if (result.length > 0) {
            return res.status(409).send("This game is already assigned to this PC");
        }
        
        const insertSql = "INSERT INTO slot_games (slot_id, game_id) VALUES (?, ?)";
        db.query(insertSql, [slot_id, game_id], (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).send("Error assigning game");
            }
            res.status(200).send("Game assigned to PC successfully!");
        });
    });
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});