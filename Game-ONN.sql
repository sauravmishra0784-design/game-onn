CREATE DATABASE  IF NOT EXISTS `gameonn_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gameonn_db`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: gameonn_db
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `slot_id` int NOT NULL,
  `user_id` int NOT NULL,
  `booking_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  PRIMARY KEY (`booking_id`),
  KEY `slot_id` (`slot_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`slot_id`) REFERENCES `slots` (`slot_id`),
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (15,1,1,'2025-09-29 03:54:55','2025-10-06 07:54:00','2025-10-06 08:54:00'),(16,1,1,'2025-09-29 03:55:15','2025-10-06 08:54:00','2025-10-06 09:54:00'),(21,5,1,'2025-09-29 18:51:15','2025-10-01 08:51:00','2025-10-01 09:51:00'),(22,5,1,'2025-09-29 18:53:09','2025-10-03 08:51:00','2025-10-03 09:51:00'),(24,5,1,'2025-09-29 19:55:17','2025-10-01 11:54:00','2025-10-01 12:54:00'),(25,5,1,'2025-09-29 20:07:55','2025-09-30 14:07:00','2025-09-30 15:07:00'),(26,5,1,'2025-09-29 20:08:56','2025-09-30 15:08:00','2025-09-30 16:08:00'),(27,5,1,'2025-09-29 20:16:47','2025-10-02 13:16:00','2025-10-02 14:16:00'),(30,2,4,'2025-09-29 22:49:03','2025-10-06 10:48:00','2025-10-06 11:48:00'),(31,10,5,'2025-09-30 04:16:19','2025-10-07 05:15:00','2025-10-07 06:15:00'),(32,5,1,'2025-09-30 06:10:16','2025-10-02 06:08:00','2025-10-02 07:08:00'),(33,2,1,'2025-09-30 15:32:34','2025-10-06 07:32:00','2025-10-06 08:32:00'),(34,4,7,'2025-10-01 09:53:31','2025-10-03 06:15:00','2025-10-03 09:15:00');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `games`
--

DROP TABLE IF EXISTS `games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `games` (
  `game_id` int NOT NULL AUTO_INCREMENT,
  `game_name` varchar(100) NOT NULL,
  `genre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games`
--

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;
INSERT INTO `games` VALUES (28,'God of War Ragnarok','Action Adventure'),(29,'Sekiro','Action RPG'),(30,'Black Myth Wukong','Action RPG'),(31,'Hitman 3','Stealth'),(32,'Ghost of Tsushima','Action Adventure'),(33,'Hogwarts Legacy','Action RPG'),(34,'GTA V','Open World'),(35,'Spiderman','Action Adventure'),(36,'Elden Ring','Action RPG'),(37,'Gran Turismo','Racing'),(38,'Tekken 8','Fighting'),(39,'Street Fighter 6','Fighting'),(40,'It Takes Two','Adventure'),(41,'Diablo 4','Action RPG'),(43,'Rainbow Six Siege','Tactical FPS'),(44,'Fortnite','Battle Royale'),(45,'Valorant','Tactical FPS'),(46,'FC 26','Sports'),(47,'Counter Strike 2','Tactical FPS');
/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `snack_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `order_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `booking_id` (`booking_id`),
  KEY `snack_id` (`snack_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`snack_id`) REFERENCES `snacks` (`snack_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (10,30,9,1,'2025-09-29 22:51:38'),(11,30,13,1,'2025-09-29 22:51:38'),(12,30,7,1,'2025-09-29 22:51:38'),(13,30,8,1,'2025-09-30 00:51:41'),(14,16,11,1,'2025-09-30 00:53:22'),(15,31,8,4,'2025-09-30 04:17:02'),(16,32,7,1,'2025-09-30 06:12:56'),(17,33,8,4,'2025-09-30 15:33:06'),(18,34,13,5,'2025-10-01 09:54:32');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slot_games`
--

DROP TABLE IF EXISTS `slot_games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slot_games` (
  `slot_id` int NOT NULL,
  `game_id` int NOT NULL,
  PRIMARY KEY (`slot_id`,`game_id`),
  KEY `game_id` (`game_id`),
  CONSTRAINT `slot_games_ibfk_1` FOREIGN KEY (`slot_id`) REFERENCES `slots` (`slot_id`),
  CONSTRAINT `slot_games_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slot_games`
--

LOCK TABLES `slot_games` WRITE;
/*!40000 ALTER TABLE `slot_games` DISABLE KEYS */;
INSERT INTO `slot_games` VALUES (1,28),(3,28),(1,29),(1,30),(4,30),(2,31),(2,32),(4,32),(2,33),(4,33),(1,34),(3,34),(2,35),(3,35),(3,36),(4,36),(5,37),(6,37),(8,37),(9,37),(5,38),(7,38),(9,38),(5,39),(7,39),(8,39),(6,40),(7,40),(9,40),(6,41),(7,41),(8,41),(10,43),(11,43),(12,43),(10,44),(11,44),(12,44),(10,45),(11,45),(11,46),(12,46),(10,47),(12,47);
/*!40000 ALTER TABLE `slot_games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slots`
--

DROP TABLE IF EXISTS `slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slots` (
  `slot_id` int NOT NULL AUTO_INCREMENT,
  `slot_name` varchar(50) NOT NULL,
  `slot_type` enum('single','two_player','four_player') NOT NULL,
  `availability` tinyint(1) DEFAULT '1',
  `rate` decimal(6,2) NOT NULL,
  PRIMARY KEY (`slot_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slots`
--

LOCK TABLES `slots` WRITE;
/*!40000 ALTER TABLE `slots` DISABLE KEYS */;
INSERT INTO `slots` VALUES (1,'Solo PC 1','single',1,50.00),(2,'Solo PC 2','single',1,50.00),(3,'Solo PC 3','single',1,50.00),(4,'Solo PC 4','single',1,50.00),(5,'Duo PC 1','two_player',1,80.00),(6,'Duo PC 2','two_player',1,80.00),(7,'Duo PC 3','two_player',1,80.00),(8,'Duo PC 4','two_player',1,80.00),(9,'Duo PC 5','two_player',1,80.00),(10,'Squad PC 1','four_player',1,150.00),(11,'Squad PC 2','four_player',1,150.00),(12,'Squad PC 3','four_player',1,150.00);
/*!40000 ALTER TABLE `slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snacks`
--

DROP TABLE IF EXISTS `snacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `snacks` (
  `snack_id` int NOT NULL AUTO_INCREMENT,
  `snack_name` varchar(100) NOT NULL,
  `price` decimal(6,2) NOT NULL,
  PRIMARY KEY (`snack_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snacks`
--

LOCK TABLES `snacks` WRITE;
/*!40000 ALTER TABLE `snacks` DISABLE KEYS */;
INSERT INTO `snacks` VALUES (6,'Coke',20.00),(7,'Pepsi',20.00),(8,'Lays Chips',15.00),(9,'Kurkure',15.00),(10,'Bingo Chips',15.00),(11,'Nachos',40.00),(13,'Oreo',20.00),(15,'Chocolate Bar',30.00),(16,'Energy Drink',50.00),(17,'Water Bottle',10.00),(18,'Juice Pack',25.00);
/*!40000 ALTER TABLE `snacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `Registration_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Saurav123','saurav123@gmail.com','8452088588','12345','2025-09-28 22:35:07'),(3,'Nidhi','Nidhi12@gmail.com','','12345','2025-09-28 22:35:07'),(4,'balraj gopi','balraj@gmail.com','1234567890','pass123','2025-09-29 22:46:56'),(5,'om','ombot@gmail.com','','123','2025-09-30 04:14:34'),(6,'Hardik','hardik@gmail.com','123456789','12345','2025-09-30 05:56:16'),(7,'tanmay','upalekart@gmail.com','7021925252','tanmay@117','2025-10-01 09:48:52');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-03  4:18:11
