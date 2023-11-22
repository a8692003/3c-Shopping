-- MariaDB dump 10.19  Distrib 10.4.28-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: combuy
-- ------------------------------------------------------
-- Server version	10.4.28-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `combuy`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `combuy` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;

USE `combuy`;

--
-- Table structure for table `bannerimg`
--

DROP TABLE IF EXISTS `bannerimg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bannerimg` (
  `img_id` int(11) NOT NULL AUTO_INCREMENT,
  `dir` varchar(100) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `link` varchar(100) NOT NULL,
  PRIMARY KEY (`img_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bannerimg`
--

LOCK TABLES `bannerimg` WRITE;
/*!40000 ALTER TABLE `bannerimg` DISABLE KEYS */;
/*!40000 ALTER TABLE `bannerimg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `brand` (
  `brand_id` int(11) NOT NULL AUTO_INCREMENT,
  `brand` varchar(50) NOT NULL,
  `content` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`brand_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brand`
--

LOCK TABLES `brand` WRITE;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` VALUES (1,'APPLE','apple .inc'),(2,'Acer',NULL),(3,'ASUS',NULL),(4,'Microsoft',NULL),(5,'Lenovo',NULL),(6,'DELL',NULL),(7,'HP',NULL),(8,'LG',NULL),(9,'MSI',NULL);
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `card`
--

DROP TABLE IF EXISTS `card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `card` (
  `card_id` int(11) NOT NULL AUTO_INCREMENT,
  `card_num` varchar(17) NOT NULL,
  `expiry_date` varchar(5) NOT NULL,
  `security_code` varchar(4) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`card_id`) USING BTREE,
  KEY `user_id` (`user_id`),
  CONSTRAINT `card_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `card`
--

LOCK TABLES `card` WRITE;
/*!40000 ALTER TABLE `card` DISABLE KEYS */;
INSERT INTO `card` VALUES (1,'1111222233335556','0523','987',6),(2,'2222333344445555','0524','312',6),(4,'0123654655121234','0324','561',6),(5,'5201321521513215','0524','321',42);
/*!40000 ALTER TABLE `card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(50) NOT NULL,
  `content` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'筆電',NULL),(2,'滑鼠',NULL),(3,'鍵盤',NULL);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collect`
--

DROP TABLE IF EXISTS `collect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collect` (
  `user_id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  `update_time` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`,`prod_id`,`spec_id`) USING BTREE,
  KEY `prod_id` (`prod_id`),
  KEY `user_id` (`user_id`),
  KEY `spec_id` (`spec_id`),
  CONSTRAINT `collect_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `collect_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`),
  CONSTRAINT `collect_ibfk_3` FOREIGN KEY (`spec_id`) REFERENCES `sellspec` (`spec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collect`
--

LOCK TABLES `collect` WRITE;
/*!40000 ALTER TABLE `collect` DISABLE KEYS */;
INSERT INTO `collect` VALUES (6,5,0,'2023-09-06 12:15:08'),(6,12,0,'2023-08-25 14:34:14'),(6,14,0,'2023-08-26 14:44:14');
/*!40000 ALTER TABLE `collect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_product`
--

DROP TABLE IF EXISTS `order_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_product` (
  `order_id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `comment` varchar(300) DEFAULT NULL,
  `comment_grade` tinyint(4) DEFAULT NULL,
  `comment_time` datetime DEFAULT NULL,
  PRIMARY KEY (`order_id`,`prod_id`,`spec_id`) USING BTREE,
  KEY `prod_id` (`prod_id`),
  KEY `format_id` (`spec_id`),
  CONSTRAINT `order_product_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_product_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`),
  CONSTRAINT `order_product_ibfk_3` FOREIGN KEY (`spec_id`) REFERENCES `sellspec` (`spec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_product`
--

LOCK TABLES `order_product` WRITE;
/*!40000 ALTER TABLE `order_product` DISABLE KEYS */;
INSERT INTO `order_product` VALUES (1,1,0,40900,1,NULL,NULL,NULL),(1,1,1,40900,2,'nice?!?',1,'2023-09-06 16:29:34'),(2,1,0,40900,1,NULL,NULL,NULL),(2,1,1,40900,2,NULL,NULL,NULL),(3,1,0,40900,1,'超爛',5,'2023-08-26 14:15:41'),(3,1,1,40900,1,'爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了',5,'2023-08-25 14:15:41'),(3,6,0,34900,5,'爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了',5,'2023-08-25 14:15:41'),(3,13,0,52900,1,'爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了',5,'2023-08-25 14:15:41'),(4,1,0,40900,2,'很棒',4,'2023-08-28 11:18:34'),(4,1,1,40900,1,'很棒',3,'2023-08-28 11:18:34');
/*!40000 ALTER TABLE `order_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `order_date` datetime NOT NULL DEFAULT current_timestamp(),
  `recipient` varchar(100) NOT NULL,
  `recipient_address` varchar(300) NOT NULL,
  `recipient_phone` varchar(50) NOT NULL,
  `state` tinyint(4) NOT NULL DEFAULT 1 COMMENT '訂單取消 0\r\n訂單成立 1\r\n訂單完成 2',
  `pay` tinyint(4) NOT NULL DEFAULT 0 COMMENT '尚未付款 0\r\n付款完成 1',
  `pay_method` tinyint(4) NOT NULL COMMENT '銀行或郵局轉帳 0\r\n信用卡(一次付清)　 1',
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,6,'2023-08-25 00:00:00','買家一的收件人','台中市中區臺灣大道一段1號','0912345678',2,1,0),(2,6,'2023-08-26 07:10:00','買家一的收件人','台中市中區臺灣大道一段1號','0912345678',0,0,0),(3,7,'2023-08-25 14:12:15','買家2的收件人','台中市中區臺灣大道一段1號','0912345678',2,1,0),(4,7,'2023-08-25 14:13:22','買家2的收件人','台中市中區臺灣大道一段1號','0912345678',1,1,1);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `prod_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `prod_name` varchar(50) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `creat_time` datetime NOT NULL DEFAULT current_timestamp(),
  `update_time` datetime NOT NULL DEFAULT current_timestamp(),
  `transport` tinyint(4) NOT NULL DEFAULT 2 COMMENT '郵寄寄送 0\r\n宅配/快遞　 1\r\n全部 2',
  `payment` tinyint(4) NOT NULL DEFAULT 2 COMMENT '銀行或郵局轉帳 0\r\n信用卡(一次付清)　 1\r\n全部 2',
  PRIMARY KEY (`prod_id`),
  KEY `user_id` (`user_id`),
  KEY `brand_id` (`brand_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`brand_id`),
  CONSTRAINT `product_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,2,'acer Nitro AN515 i5/RTX4050 12代電競筆電	',2,1,'2023-08-24 00:00:00','2023-08-24 00:00:00',2,2),(4,2,'acer Nitro AN515 RTX4060 電競筆電',2,1,'2023-08-25 10:31:58','2023-08-25 10:31:58',2,2),(5,2,'acer Swift GO SFG16-71 13代輕薄筆電',2,1,'2023-08-25 10:38:56','2023-08-25 10:38:56',2,2),(6,2,'acer Swift5 SF514 纖薄觸控筆電',2,1,'2023-08-25 10:55:24','2023-08-25 10:55:24',2,2),(7,2,'acer Predator Helios PH18 13代掠奪者電競',2,1,'2023-08-25 11:04:18','2023-08-25 11:04:18',2,2),(8,3,'TUF Gaming A15 FA507NU 軍規電競',3,1,'2023-08-25 11:18:22','2023-08-25 11:18:22',2,2),(9,3,'ASUS Vivobook 16 X1605ZA',3,1,'2023-08-25 12:46:49','2023-08-25 12:46:49',2,2),(10,3,'ASUS Zenbook Pro 14 OLED UX6404VI',3,1,'2023-08-25 12:53:03','2023-08-25 12:53:03',2,2),(11,3,'ASUS ROG Zephyrus G14 GA402XV 西風之神輕薄電競',3,1,'2023-08-25 12:58:04','2023-08-25 12:58:04',2,2),(12,3,'ASUS ROG Strix SCAR 17 G733PZ',3,1,'2023-08-25 13:05:00','2023-08-25 13:05:00',2,2),(13,4,'LG gram 16 16Z90R 13代輕薄筆電',8,1,'2023-08-25 13:12:41','2023-08-25 13:12:41',2,2),(14,4,'LG gram 16 16Z90R',8,1,'2023-08-25 13:26:05','2023-08-25 13:26:05',2,2),(15,5,'MSI Stealth16 MercedesAMG 聯名創作者筆電',9,1,'2023-08-25 13:40:21','2023-08-25 13:40:21',2,1),(16,5,'MSI Modern 15 B7M 輕薄高效筆電',9,1,'2023-08-25 13:46:44','2023-08-25 13:46:44',2,1),(17,5,'MSI Stealth 14Studio A13VE 微星輕薄電競筆電',9,1,'2023-08-25 13:54:21','2023-08-25 13:54:21',2,2),(18,5,'DELL Inspiron Gaming G15-5530-R1768BTW',6,1,'2023-08-25 14:01:52','2023-08-25 14:01:52',2,2);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_tag`
--

DROP TABLE IF EXISTS `product_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tag` (
  `prod_id` int(11) NOT NULL,
  `tag` int(11) NOT NULL,
  PRIMARY KEY (`prod_id`,`tag`),
  KEY `tag` (`tag`),
  CONSTRAINT `product_tag_ibfk_1` FOREIGN KEY (`tag`) REFERENCES `tag` (`tag`),
  CONSTRAINT `product_tag_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_tag`
--

LOCK TABLES `product_tag` WRITE;
/*!40000 ALTER TABLE `product_tag` DISABLE KEYS */;
INSERT INTO `product_tag` VALUES (1,1),(1,3),(4,3),(5,5),(6,2),(6,5),(7,3),(7,6),(8,3),(8,6),(9,2),(10,1),(10,3),(10,6),(11,1),(11,5),(11,6),(12,3),(12,6),(13,2),(13,5),(14,2),(14,5),(15,1),(15,4),(16,2),(16,5),(16,6),(17,1),(17,3),(17,5),(17,6),(18,3),(18,6);
/*!40000 ALTER TABLE `product_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productimg`
--

DROP TABLE IF EXISTS `productimg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productimg` (
  `img_id` int(11) NOT NULL AUTO_INCREMENT,
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  `dir` varchar(100) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '產品圖 0\r\n介紹圖 1',
  PRIMARY KEY (`img_id`),
  KEY `prod_id` (`prod_id`),
  CONSTRAINT `productimg_ibfk_1` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productimg`
--

LOCK TABLES `productimg` WRITE;
/*!40000 ALTER TABLE `productimg` DISABLE KEYS */;
INSERT INTO `productimg` VALUES (1,1,0,'/images/products/','189823.jpg',0),(2,1,0,'/images/products_info/','186419-1.jpg',1),(3,4,0,'/images/products/','186420.jpg',0),(4,4,0,'/images/products_info/','186420-1.jpg',1),(5,5,0,'/images/products/','185606.jpg',0),(6,6,0,'/images/products/','171303.jpg',0),(7,6,0,'/images/products_info/','167295-1.jpg',1),(8,7,0,'/images/products/','185611.jpg',0),(9,7,0,'/images/products_info/','185611-1.jpg',1),(10,8,0,'/images/products/','190351.jpg',0),(11,8,0,'/images/products_info/','190351-1.jpg',1),(12,9,0,'/images/products/','190102.jpg',0),(13,9,0,'/images/products_info/','184102-1.jpg',1),(14,10,0,'/images/products/','187733.jpg',0),(15,10,0,'/images/products_info/','187733-1.jpg',1),(16,11,0,'/images/products/','186517.jpg',0),(17,11,0,'/images/products_info/','186517-1.jpg',1),(18,12,0,'/images/products/','185722.jpg',0),(19,12,0,'/images/products_info/','185722-1.jpg',1),(20,13,0,'/images/products/','187307.jpg',0),(21,13,0,'/images/products_info/','185202-1.jpg',1),(22,14,0,'/images/products/','185202.jpg',0),(23,14,0,'/images/products_info/','185202-1.jpg',1),(24,15,0,'/images/products/','190165.jpg',0),(25,15,0,'/images/products_info/','190165-1.jpg',1),(26,16,0,'/images/products/','190125.jpg',0),(27,16,0,'/images/products_info/','190125-1.jpg',1),(28,17,0,'/images/products/','189900.jpg',0),(29,17,0,'/images/products_info/','189900-1.jpg',1),(30,18,0,'/images/products/','189282.jpg',0),(31,18,0,'/images/products_info/','189282-1.jpg',1),(33,1,1,'/images/products/','189823-1.jpg',0),(34,1,1,'/images/products_info/','186419-1.jpg',1),(35,5,1,'/images/products/','185606-1.jpg',0),(36,9,1,'/images/products/','190102-1.jpg',0),(37,9,2,'/images/products/','190102-2.jpg',0),(38,9,1,'/images/products_info/','184102-1.jpg',1),(39,9,2,'/images/products_info/','184102-1.jpg',1),(40,11,1,'/images/products/','186517-1.jpg',0),(41,11,1,'/images/products_info/','186517-1.jpg',1),(42,13,1,'/images/products/','187307-1.jpg',0),(43,13,1,'/images/products_info/','185202-1.jpg',1),(44,13,2,'/images/products/','187307-2.jpg',0),(45,13,2,'/images/products_info/','185202-1.jpg',1),(46,14,1,'/images/products/','185202-1.jpg',0),(47,14,1,'/images/products_info/','185202-1.jpg',1);
/*!40000 ALTER TABLE `productimg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sellspec`
--

DROP TABLE IF EXISTS `sellspec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sellspec` (
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  `spec_name` varchar(21) NOT NULL,
  `contnet` varchar(500) DEFAULT NULL,
  `price` int(11) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `publish` int(11) NOT NULL DEFAULT 0 COMMENT '不公開 0\r\n公開 1',
  `create_time` datetime NOT NULL DEFAULT current_timestamp(),
  `update_time` datetime NOT NULL DEFAULT current_timestamp(),
  `info_content` varchar(2500) DEFAULT NULL,
  `cpu` varchar(150) DEFAULT NULL,
  `gpu` varchar(150) DEFAULT NULL,
  `ram` varchar(100) DEFAULT NULL,
  `os` varchar(100) DEFAULT NULL,
  `screen` varchar(150) DEFAULT NULL,
  `battery` varchar(100) DEFAULT NULL,
  `warranty` varchar(150) DEFAULT NULL,
  `size` varchar(100) DEFAULT NULL,
  `weight` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`prod_id`,`spec_id`),
  KEY `spec_id` (`spec_id`),
  CONSTRAINT `sellspec_ibfk_1` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sellspec`
--

LOCK TABLES `sellspec` WRITE;
/*!40000 ALTER TABLE `sellspec` DISABLE KEYS */;
INSERT INTO `sellspec` VALUES (1,0,'基本款','189823',40900,1000,1,'2023-08-25 09:38:59','2023-08-25 09:38:59','商品規格\r\n處理器：Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)\r\n記憶體：16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\nSSD硬碟：512GB NVMe PCIe Gen4 SSD / 共2個插槽，已經使用1個\r\n傳統硬碟：無，有一個2.5吋硬碟空間可以擴充\r\n螢幕：15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i Dual Band(2.4 GHz/5 GHz) 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth 5.1\r\n攝影機：HD (1280 x 720)with Temporal Noise Reduction(TNR)Dual Mic\r\nI/O 介面：\r\n1 x Type-C (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)支援影像傳輸\r\n3 x TypeA USB 3.2\r\n1 x HDMI 2.1\r\n1 x Microphone-in/Headphone-out jack\r\n1 x RJ45 (Killer Ethernet E2600)\r\n尺寸：360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm\r\n重量：2.5 kg\r\n變壓器：230W\r\n電池：57Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache','NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)','16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\n','Windows 11 家用版','15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光','57Wh Li-ion battery','二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修','360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm','2.5 kg'),(1,1,'紅色款','189823',40900,1500,1,'2023-08-25 09:38:59','2023-08-25 09:38:59','商品規格\r\n處理器：Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)\r\n記憶體：16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\nSSD硬碟：512GB NVMe PCIe Gen4 SSD / 共2個插槽，已經使用1個\r\n傳統硬碟：無，有一個2.5吋硬碟空間可以擴充\r\n螢幕：15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i Dual Band(2.4 GHz/5 GHz) 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth 5.1\r\n攝影機：HD (1280 x 720)with Temporal Noise Reduction(TNR)Dual Mic\r\nI/O 介面：\r\n1 x Type-C (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)支援影像傳輸\r\n3 x TypeA USB 3.2\r\n1 x HDMI 2.1\r\n1 x Microphone-in/Headphone-out jack\r\n1 x RJ45 (Killer Ethernet E2600)\r\n尺寸：360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm\r\n重量：2.5 kg\r\n變壓器：230W\r\n電池：57Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache','NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)','16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\n','Windows 11 家用版.','15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光','57Wh Li-ion battery','二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修','360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm','2.5 kg'),(4,0,'基本款','186420',52900,1000,1,'2023-08-25 10:33:34','2023-08-25 10:33:34','商品規格\r\n處理器：Intel Core i7-12700H 14核心/20緒 2.3 GHz 超頻 4.7 GHz / 24M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4060 8G-GDDR6 MGP 140W滿血版(支援獨顯直連)\r\n記憶體：16GB DDR5-4800 / 共2個插槽，已經使用1個，最高支援32G\r\nSSD硬碟：512GB NVMe PCIe Gen4 SSD / 共2個插槽，已經使用1個\r\n傳統硬碟：無，有一個2.5吋硬碟空間可以擴充\r\n螢幕：15.6吋 165Hz 1920X1080 FHD/IPS/霧面/LED背光\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i Dual Band(2.4 GHz/5 GHz) 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth 5.1\r\n攝影機：HD (1280 x 720)with Temporal Noise Reduction(TNR)Dual Mic\r\nI/O 介面：\r\n1 x Type-C (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)支援影像傳輸\r\n3 x TypeA USB 3.2\r\n1 x HDMI 2.1\r\n1 x Microphone-in/Headphone-out jack\r\n1 x RJ45 (Killer Ethernet E2600)\r\n尺寸：360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm\r\n重量：2.5 kg\r\n變壓器：280W\r\n電池：57Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n','Intel Core i7-12700H 14核心/20緒 2.3 GHz 超頻 4.7 GHz / 24M Cache','NVIDIA® GeForce RTX™ 4060 8G-GDDR6 MGP 140W滿血版(支援獨顯直連)','16GB DDR5-4800 / 共2個插槽，已經使用1個，最高支援32G','Windows 11 家用版','15.6吋 165Hz 1920X1080 FHD/IPS/霧面/LED背光','57Wh Li-ion battery','二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修','360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm','2.5 kg'),(5,0,'基本款','185606',40900,100,1,'2023-08-25 10:40:02','2023-08-25 10:40:02','商品規格\r\n處理器：Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache\r\n顯示卡：intel Iris Xe Graphics\r\n記憶體：16GB LPDDR5 Onboaed / 記憶體無法擴充\r\nSSD硬碟：512G M.2 PCIe SSD / 共2個插槽，已使用1個\r\n傳統硬碟：不可擴充\r\n螢幕：16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits\r\n光碟機： NO\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer Wireless Wi-Fi 6E 1675i 2.4 GHz/5 GHz/6 GHz三頻段 802.11 a/b/g/n/ac/ax 2x2 MU-MIMO+Bluetooth 5.1\r\n視訊鏡頭：QHD (2560 x 1440) with Temporal Noise Reduction(TNR)\r\n其他規格：\r\n1x HDMI 2.1\r\n2x TypeC (USB4®40Gbps)(Thunderbolt 4)(DC-in 20 V; 100 W)支援影像傳輸\r\n2x USB Type-A(USB 3.2 Gen 1)\r\n1x COMBO audio jack\r\n1x Card Reader(microSD Card reader)\r\n1x 指紋辨識\r\n尺寸：356 (W) x 242.6 (D) x 14.9 (H) mm\r\n重量：1.6 kg\r\n變壓器：100W Type-C\r\n電池：65Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache','intel Iris Xe Graphics','16GB LPDDR5 Onboaed / 記憶體無法擴充','Windows 11 家用版','16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits','65Wh Li-ion battery','二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修','356 (W) x 242.6 (D) x 14.9 (H) mm','1.6 kg'),(5,1,'黑色款','185606',40900,100,1,'2023-08-25 10:40:02','2023-08-25 10:40:02','商品規格\r\n處理器：Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache\r\n顯示卡：intel Iris Xe Graphics\r\n記憶體：16GB LPDDR5 Onboaed / 記憶體無法擴充\r\nSSD硬碟：512G M.2 PCIe SSD / 共2個插槽，已使用1個\r\n傳統硬碟：不可擴充\r\n螢幕：16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits\r\n光碟機： NO\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer Wireless Wi-Fi 6E 1675i 2.4 GHz/5 GHz/6 GHz三頻段 802.11 a/b/g/n/ac/ax 2x2 MU-MIMO+Bluetooth 5.1\r\n視訊鏡頭：QHD (2560 x 1440) with Temporal Noise Reduction(TNR)\r\n其他規格：\r\n1x HDMI 2.1\r\n2x TypeC (USB4®40Gbps)(Thunderbolt 4)(DC-in 20 V; 100 W)支援影像傳輸\r\n2x USB Type-A(USB 3.2 Gen 1)\r\n1x COMBO audio jack\r\n1x Card Reader(microSD Card reader)\r\n1x 指紋辨識\r\n尺寸：356 (W) x 242.6 (D) x 14.9 (H) mm\r\n重量：1.6 kg\r\n變壓器：100W Type-C\r\n電池：65Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache','intel Iris Xe Graphics','16GB LPDDR5 Onboaed / 記憶體無法擴充','Windows 11 家用版','16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits','65Wh Li-ion battery','二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修','356 (W) x 242.6 (D) x 14.9 (H) mm','1.6 kg'),(6,0,'基本款','171303',34900,1000,1,'2023-08-25 10:40:02','2023-08-25 10:40:02','商品規格\r\n處理器：Intel Core i5-1135G7 4核心/8緒 2.4GHz 超頻 4.2GHz / 8M Cache\r\n顯示卡：Intel® Iris® Xe Graphics\r\n記憶體：16G LPDDR4X Onboard\r\nSSD硬碟：512G M.2 PCIe SSD\r\n傳統硬碟：無法擴充\r\n螢幕：14吋 FHD IPS 觸控康寧玻璃螢幕\r\n光碟機： NO\r\n作業系統：Windows 11 家用版\r\n無線規格：WiFi-6、藍芽5.0\r\n其他規格：\r\n1 X HDMI\r\n1 X USB3.1 TypeC1 (USB 3.2 Gen 1)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)\r\n2 X USB3.0\r\n1 X HD像素網路攝影機\r\n1 X COMBO audio jack\r\n指紋辨識\r\n尺寸：318 (W) x 206 (D) x 14.9/14.9 (H) mm\r\n重量：1.05 Kg\r\n變壓器：65W\r\n電池：56Wh(4-cell)\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i5-1135G7 4核心/8緒 2.4GHz 超頻 4.2GHz / 8M Cache','intel Iris Xe Graphics','16G LPDDR4X Onboard','Windows 11 家用版','14吋 FHD IPS 觸控康寧玻璃螢幕','56Wh(4-cell)','二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修','318 (W) x 206 (D) x 14.9/14.9 (H) mm','1.05 Kg'),(7,0,'基本款','185611',116900,1000,1,'2023-08-25 11:40:02','2023-08-25 11:40:02','商品規格\r\n處理器：Intel® Core™ i9-13900HX 核心處理器 5.4 GHz (36MB Cache, up to 5.4 GHz, 8 P-cores and 16 E- cores)\r\n顯示卡：NVIDIA® GeForce RTX™ 4080 12G-GDDR6 MGP 165W滿血版 (支援獨顯直連、動態顯示切換、G-sync)\r\n記憶體：32GB DDR5-5600MHz/ 共2個插槽，已經使用2個，最高支援32G\r\nSSD硬碟：1T+1T PCIe NVMe SED SSD/ 共2個插槽，已經使用2個\r\n傳統硬碟： 無\r\n螢幕：16\" WQXGA 2560 x 1600/16:10/IPS/165Hz/霧面/LED背光/DCI-P3 100%/500 nits\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i 2.4 GHz/5 GHz 雙頻段 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth® 5.1\r\n攝影機：FHD (1920 x 1080) with Temporal Noise Reduction(TNR)\r\nI/O 介面：\r\n2x (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)\r\n2x USB 3.2 Gen 2\r\n1x USB 3.2 Gen 1\r\n1x HDMI 2.1\r\n1x microSD Card reader\r\n1x Microphone-in/Headphone-out jack\r\n尺寸：405 (W) x 311.61 (D) x 26.9/28.9 (H) mm\r\n重量：3.16 kg\r\n變壓器：330 W\r\n電池：90Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel® Core™ i9-13900HX 核心處理器 5.4 GHz (36MB Cache, up to 5.4 GHz, 8 P-cores and 16 E- cores)','NVIDIA® GeForce RTX™ 4080 12G-GDDR6 MGP 165W滿血版 (支援獨顯直連、動態顯示切換、G-sync)','32GB DDR5-5600MHz/ 共2個插槽，已經使用2個，最高支援32G','Windows 11 家用版','16\" WQXGA 2560 x 1600/16:10/IPS/165Hz/霧面/LED背光/DCI-P3 100%/500 nits','90Wh Li-ion battery','二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修','405 (W) x 311.61 (D) x 26.9/28.9 (H) mm','3.16 kg'),(8,0,'基本款','190351',34999,1000,1,'2023-08-25 12:42:21','2023-08-25 12:42:21','商品規格\r\n處理器：AMD Ryzen™ 7 7735H (8-core/16-thread, 16MB L3 cache, up to 4.7 GHz max boost)\r\n顯示卡：\'NVIDIA® GeForce RTX™ 4050 6GB GDDR6(具備MUX獨顯直連)\r\n2420MHz* at 140W (2370MHz Boost Clock+50MHz OC, 115W+25W Dynamic Boost)\r\n記憶體：8GB DDR5-4800 / 共2個插槽，已經使用1個，最大支援32G\r\nSSD硬碟：512GB PCIe® 4.0 NVMe™ M.2 SSD / 共2個插槽，已使用1個\r\n傳統硬碟：無法擴充\r\n螢幕：15.6 \"(薄邊框)/FHD (1920 x 1080) 16:9/144Hz/IPS-level/Anti-glare/NTSC 72%/SRGB 100%/G-Sync\r\n光碟機： 無\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6(802.11ax) (Dual band) 2*2 + Bluetooth® 5.2\r\n鍵盤：Backlit Chiclet Keyboard 1-Zone RGB\r\n網路攝影機：720P HD camera\r\nIO PORT :\r\n1x RJ45 LAN port\r\n1x Type C USB 4 support DisplayPort™ / G-SYNC\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™ / power delivery / G-SYNC\r\n2x USB 3.2 Gen 1 Type-A\r\n1x HDMI 2.1 FRL\r\n1x 3.5mm Combo Audio Jack\r\n尺寸：35.4 x 25.1 x 2.24 ~ 2.49 cm\r\n重量：2.20 Kg\r\n電池：90WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 240W AC Adapter, Output: 20V DC, 12A, 240W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','AMD Ryzen™ 7 7735H (8-core/16-thread, 16MB L3 cache, up to 4.7 GHz max boost)','NVIDIA® GeForce RTX™ 4050 6GB GDDR6(具備MUX獨顯直連)\r\n2420MHz* at 140W (2370MHz Boost Clock+50MHz OC, 115W+25W Dynamic Boost)','512GB PCIe® 4.0 NVMe™ M.2 SSD / 共2個插槽，已使用1個','Windows11 64Bits 英/泰/簡中/印尼/越南/繁中','15.6 \"(薄邊框)/FHD (1920 x 1080) 16:9/144Hz/IPS-level/Anti-glare/NTSC 72%/SRGB 100%/G-Sync','90WHrs, 4S1P, 4-cell Li-ion','二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年','35.4 x 25.1 x 2.24 ~ 2.49 cm','2.20 Kg'),(9,0,'基本款','190102',30900,1000,1,'2023-08-25 12:42:21','2023-08-25 12:42:21','商品規格\r\n處理器：Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache\r\n顯示卡：Intel Iris Xᵉ Graphics\r\n記憶體：16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G\r\nSSD硬碟：512GB M.2 NVMe™ PCIe® 3.0 SSD / 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio\r\n光碟機：NO\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6 (802.11ax)+Bluetooth 5.0 (Dual band) 2*2\r\n網路攝影機：720p HD 攝影機, 含防窺鏡頭蓋\r\nIO 介面：\r\n1x HDMI 1.4\r\n1x 3.5mm Combo Audio Jack\r\n1x DC-in\r\n1x USB 2.0 Type-A\r\n1x USB 3.2 Gen 1 Type-C\r\n2x USB 3.2 Gen 1 Type-A\r\n尺寸：35.87 x 24.95 x 1.99 ~ 1.99 cm\r\n重量：1.88kg\r\n電池：42WHrs\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n備註：此機型沒有附贈包包、滑鼠','Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache','Intel Iris Xᵉ Graphics','16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G','Windows11 64Bits 英/泰/簡中/印尼/越南/繁中','16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio','42WHrs','二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年','35.87 x 24.95 x 1.99 ~ 1.99 cm','1.88kg'),(9,1,'銀灰款','190102',30900,1000,1,'2023-08-25 12:48:21','2023-08-25 12:48:21','商品規格\r\n處理器：Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache\r\n顯示卡：Intel Iris Xᵉ Graphics\r\n記憶體：16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G\r\nSSD硬碟：512GB M.2 NVMe™ PCIe® 3.0 SSD / 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio\r\n光碟機：NO\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6 (802.11ax)+Bluetooth 5.0 (Dual band) 2*2\r\n網路攝影機：720p HD 攝影機, 含防窺鏡頭蓋\r\nIO 介面：\r\n1x HDMI 1.4\r\n1x 3.5mm Combo Audio Jack\r\n1x DC-in\r\n1x USB 2.0 Type-A\r\n1x USB 3.2 Gen 1 Type-C\r\n2x USB 3.2 Gen 1 Type-A\r\n尺寸：35.87 x 24.95 x 1.99 ~ 1.99 cm\r\n重量：1.88kg\r\n電池：42WHrs\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n備註：此機型沒有附贈包包、滑鼠','Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache','Intel Iris Xᵉ Graphics','16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G','Windows11 64Bits 英/泰/簡中/印尼/越南/繁中','16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio','42WHrs','二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年','35.87 x 24.95 x 1.99 ~ 1.99 cm','1.88kg'),(9,2,'炫彩款','190102',31900,1000,1,'2023-08-25 12:48:21','2023-08-25 12:48:21','商品規格\r\n處理器：Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache\r\n顯示卡：Intel Iris Xᵉ Graphics\r\n記憶體：16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G\r\nSSD硬碟：512GB M.2 NVMe™ PCIe® 3.0 SSD / 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio\r\n光碟機：NO\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6 (802.11ax)+Bluetooth 5.0 (Dual band) 2*2\r\n網路攝影機：720p HD 攝影機, 含防窺鏡頭蓋\r\nIO 介面：\r\n1x HDMI 1.4\r\n1x 3.5mm Combo Audio Jack\r\n1x DC-in\r\n1x USB 2.0 Type-A\r\n1x USB 3.2 Gen 1 Type-C\r\n2x USB 3.2 Gen 1 Type-A\r\n尺寸：35.87 x 24.95 x 1.99 ~ 1.99 cm\r\n重量：1.88kg\r\n電池：42WHrs\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n備註：此機型沒有附贈包包、滑鼠','Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache','Intel Iris Xᵉ Graphics','16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G','Windows11 64Bits 英/泰/簡中/印尼/越南/繁中','16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio','42WHrs','二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年','35.87 x 24.95 x 1.99 ~ 1.99 cm','1.88kg'),(10,0,'基本款','187733',84900,1500,1,'2023-08-25 12:54:40','2023-08-25 12:54:40','商品規格\r\n處理器：Intel® Core™ i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4070 Laptop GPU 8GB GDDR6\r\n顯示卡功耗：35-115 W\r\n記憶體：32GB(16GB*2) DDR5-4800 / 共2個插槽，已使用2個，最高支援48GB\r\nSSD硬碟：1TB M.2 NVMe™ PCIe / 共1個插槽，已使用1個\r\n傳統硬碟：No\r\n螢幕尺寸：14.5 吋, 2.8K (2880 x 1800) OLED 16:10 , 德國萊因 (TÜV Rheinland) 低藍光護眼認證, SGS 認證護眼螢幕, 螢幕佔比 90%\r\n作業系統：Windows 11 Home\r\n光碟機：無,請另購外接式光碟機\r\n網路規格：Wi-Fi 6E(802.11ax) (雙頻) 2*2\r\n藍芽規格：Bluetooth 5\r\n視訊鏡頭：FHD 攝影機加紅外線功能，支援 Windows Hello 含防窺鏡頭蓋\r\n鍵盤規格：背光巧克力鍵盤, 1.4mm 鍵程\r\n指紋辨識：No / Yes\r\nNFC :\r\n喇叭/音效技術：智慧放大技術, 內建喇叭, 內建陣列麥克風, harman/kardon (進階), 支援 Cortana 語音辨識\r\nI/O規格：\r\n1x USB 3.2 Gen 2 Type-A\r\n1x USB 3.2 Gen 2 Type-C 支援顯示/供電\r\n1x Thunderbolt™ 4 支援顯示/供電\r\n1x HDMI 2.1 FRL\r\n1x 3.5mm 複合式音源線插孔\r\n1 x DC 輸入\r\nSD 4.0 讀卡機r\r\n尺寸：32.18 x 22.33 x 1.79 ~ 1.79 cm\r\n重量：1.60 kg (3.53 lbs)\r\n變壓器：ø6.0, 200W AC Adapter, Output: 20V DC, 10A, 200W, Input: 100~240V AC 50/60Hz universal\r\n電池：76WHrs，4S1P，4 芯鋰離子\r\n保固：二年台灣地區保固/一年國際旅約保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel® Core™ i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache','NVIDIA® GeForce RTX™ 4070 Laptop GPU 8GB GDDR6','32GB(16GB*2) DDR5-4800 / 共2個插槽，已使用2個，最高支援48GB','Windows 11 Home','4.5 吋, 2.8K (2880 x 1800) OLED 16:10 , 德國萊因 (TÜV Rheinland) 低藍光護眼認證, SGS 認證護眼螢幕, 螢幕佔比 90%','76WHrs，4S1P，4 芯鋰離子','二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年','32.18 x 22.33 x 1.79 ~ 1.79 cm','1.60 kg'),(11,0,'基本款','186517',65999,1280,1,'2023-08-25 13:00:33','2023-08-25 13:00:33','商品規格\r\n處理器：AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)\r\n顯示卡：NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)\r\n記憶體：16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G\r\n硬碟：1TB PCIe® 4.0 NVMe™ M.2 SSD / 總共2個插槽，已經使用1個\r\n螢幕：14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth® 5.2\r\nI/O:\r\n1x Type C USB 4 support DisplayPort™ / power delivery\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™\r\n2x USB 3.2 Gen 2 Type-A\r\n1x card reader (microSD) (UHS-II)\r\n1x HDMI 2.1 FRL\r\n尺寸：31.2 x 22.7 x 1.95 ~ 2.05 cm\r\n重量：1.72 Kg\r\n電池：76WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 240W AC Adapter, Output: 20V DC, 12A, 240W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)','NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)','16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G','Windows11 64Bits 英/泰/簡中/印尼/越南/繁中','14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n','76WHrs, 4S1P, 4-cell Li-ion','二年國際保固 / LCD無亮點保固 / 電池保固一年','31.2 x 22.7 x 1.95 ~ 2.05 cm','1.72 Kg'),(11,1,'限量聯名款','186517',69999,500,0,'2023-08-25 13:00:33','2023-08-25 13:00:33','商品規格\r\n處理器：AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)\r\n顯示卡：NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)\r\n記憶體：16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G\r\n硬碟：1TB PCIe® 4.0 NVMe™ M.2 SSD / 總共2個插槽，已經使用1個\r\n螢幕：14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth® 5.2\r\nI/O:\r\n1x Type C USB 4 support DisplayPort™ / power delivery\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™\r\n2x USB 3.2 Gen 2 Type-A\r\n1x card reader (microSD) (UHS-II)\r\n1x HDMI 2.1 FRL\r\n尺寸：31.2 x 22.7 x 1.95 ~ 2.05 cm\r\n重量：1.72 Kg\r\n電池：76WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 240W AC Adapter, Output: 20V DC, 12A, 240W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)','NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)','16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G','Windows11 64Bits 英/泰/簡中/印尼/越南/繁中','14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n','76WHrs, 4S1P, 4-cell Li-ion','二年國際保固 / LCD無亮點保固 / 電池保固一年','31.2 x 22.7 x 1.95 ~ 2.05 cm','1.72 Kg'),(12,0,'基本款','185722',99999,999,0,'2023-08-25 13:05:42','2023-08-25 13:05:42','商品規格\r\n處理器：AMD Ryzen™ 9 7945HX (16-core/32-thread, 64MB L3 cache, up to 5.4 GHz max boost)\r\n顯示卡：NVIDIA® GeForce RTX™ 4080 12GB GDDR6(具備MUX獨顯直連)\r\nROG Boost: 2330MHz* at 175W (2280MHz Boost Clock+50MHz OC, 150W+25W Dynamic Boost)\r\n記憶體：32GB DDR5-4800 / 共2個插槽，已使用2個，最高支援64G\r\n硬碟：1TB PCIe® 4.0 NVMe™ M.2 Performance SSD / 共2個插槽，已使用1個\r\n螢幕：17.3 \"(薄邊框)/WQHD (2560 x 1440) 16:9/240Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Dolby Vision/G-Sync\r\n光碟機： 無\r\n作業系統：Windows11 64Bits\r\n鍵盤：Backlit Chiclet Keyboard Per-Key RGB\r\n無線規格：Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth® 5.2\r\n視訊鏡頭：720P HD camera\r\nI/O：\r\n1x 2.5G LAN port\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™ / G-SYNC\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™ / power delivery / G-SYNC\r\n2x USB 3.2 Gen 1 Type-A\r\n1x HDMI 2.1 FRL\r\n1x 3.5mm Combo Audio Jack\r\n尺寸：39.5 x 28.2 x 2.34 ~ 2.83 cm\r\n重量：3.0Kg\r\n電池：90WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 330W AC Adapter, Output: 20V DC, 16.5A, 330W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','AMD Ryzen™ 9 7945HX (16-core/32-thread, 64MB L3 cache, up to 5.4 GHz max boost)','NVIDIA® GeForce RTX™ 4080 12GB GDDR6(具備MUX獨顯直連)\r\nROG Boost: 2330MHz* at 175W (2280MHz Boost Clock+50MHz OC, 150W+25W Dynamic Boost)','32GB DDR5-4800 / 共2個插槽，已使用2個，最高支援64G','Windows11 64Bits','17.3 \"(薄邊框)/WQHD (2560 x 1440) 16:9/240Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Dolby Vision/G-Sync','90WHrs, 4S1P, 4-cell Li-ion','二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年','39.5 x 28.2 x 2.34 ~ 2.83 cm','3.0Kg'),(13,0,'灰','187307',52900,500,1,'2023-08-25 13:14:02','2023-08-25 13:14:02','商品規格\r\n處理器：Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 6000MHz OnBoard / 不可擴充\r\n硬碟：512G NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache','Intel Iris Xe 顯示晶片','16G LPDDR5 6000MHz OnBoard / 不可擴充','WINDOWS 11 HOME (64BIT)','16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%','80Wh','2年保固 / 2年到府收送','355.1 x 242.3 x 16.8 mm','1199g'),(13,1,'黑','187307',52900,500,1,'2023-08-25 13:14:02','2023-08-25 13:14:02','商品規格\r\n處理器：Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 6000MHz OnBoard / 不可擴充\r\n硬碟：512G NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache','Intel Iris Xe 顯示晶片','16G LPDDR5 6000MHz OnBoard / 不可擴充','WINDOWS 11 HOME (64BIT)','16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%','80Wh','2年保固 / 2年到府收送','355.1 x 242.3 x 16.8 mm','1199g'),(13,2,'白','187307',52900,500,1,'2023-08-25 13:14:02','2023-08-25 13:14:02','商品規格\r\n處理器：Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 6000MHz OnBoard / 不可擴充\r\n硬碟：512G NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache','Intel Iris Xe 顯示晶片','16G LPDDR5 6000MHz OnBoard / 不可擴充','WINDOWS 11 HOME (64BIT)','16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%','80Wh','2年保固 / 2年到府收送','355.1 x 242.3 x 16.8 mm','1199g'),(14,0,'曜石黑','185202',52900,0,1,'2023-08-25 13:28:02','2023-08-25 13:28:02','商品規格\r\n處理器：Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 5200MHz OnBoard / 不可擴充\r\n硬碟：1TB NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache','Intel Iris Xe 顯示晶片','16G LPDDR5 5200MHz OnBoard / 不可擴充','WINDOWS 11 HOME (64BIT)','16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%','80Wh','2年保固 / 2年到府收送','355.1 x 242.3 x 16.8 mm','1199g'),(14,1,'沉靜灰','185202',52900,500,1,'2023-08-25 13:28:50','2023-08-25 13:28:50','商品規格\r\n處理器：Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 5200MHz OnBoard / 不可擴充\r\n硬碟：1TB NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache','Intel Iris Xe 顯示晶片','16G LPDDR5 5200MHz OnBoard / 不可擴充','WINDOWS 11 HOME (64BIT)','16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%','80Wh','2年保固 / 2年到府收送','355.1 x 242.3 x 16.8 mm','1199g'),(15,0,'基本款','190165',95900,720,1,'2023-08-25 13:41:28','2023-08-25 13:41:28','商品規格\r\n處理器：Intel Core i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache\r\n顯示卡：NVIDIA GeForce RTX 4070 Laptop GPU 8GB GDDR6\r\n記憶體：32GB(16G*2) DDR5-5200 / 共2個插槽，已使用2個插槽，最高支援64G\r\n固態硬碟：2TB NVMe PCIe Gen4 / 共2個插槽，已使用1個插槽\r\n傳統硬碟：無\r\n螢幕：16\" UHD+(3840x2400), OLED, VESA DisplayHDR™ 600 Certified, 100% DCI-P3(Typical)\r\n光碟機：無，需另購外接式光碟機\r\n作業系統：Windows 11 Pro\r\n無線規格：Intel® Killer™ Wi-Fi 6E AX1675, Bluetooth v5.3\r\n鍵盤規格：SteelSeries單鍵RGB全彩背光電競鍵盤\r\n視訊鏡頭：IR FHD type (30fps@1080p)\r\n其他規格：\r\n1x Type-C (USB3.2 Gen2 / DP)\r\n1x Type-C (USB / DP / Thunderbolt™ 4) with PD charging\r\n1x Type-A USB3.2 Gen2\r\n1x Micro SD Card Reader\r\n1x HDMI™ 2.1 (8K @ 60Hz / 4K @ 120Hz)\r\n1x RJ45\r\n1x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.8 x 259.7 x 19.95 mm\r\n重量：1.88 kg\r\n變壓器：240W\r\n電池：4-Cell 99.9 Battery (Whr)\r\n保固：二年台灣地區保固/一年國際旅約保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel Core i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache','NVIDIA GeForce RTX 4070 Laptop GPU 8GB GDDR6','32GB(16G*2) DDR5-5200 / 共2個插槽，已使用2個插槽，最高支援64G','Windows 11 Pro','16\" UHD+(3840x2400), OLED, VESA DisplayHDR™ 600 Certified, 100% DCI-P3(Typical)','80Wh','二年台灣地區保固/一年國際旅約保固/電池保固一年','355.8 x 259.7 x 19.95 mm','1.88 kg'),(16,0,'基本款','190125',30900,600,1,'2023-08-25 13:48:04','2023-08-25 13:48:04','商品規格\r\n處理器：AMD Ryzen7 7730U 8核心/16緒 2.0GHz超頻4.5GHz/ L2快取 4MB+L3快取 16MB\r\n顯示卡：AMD Radeon™ Graphics\r\n記憶體：16GB*1 DDR4-3200 onboard\r\nSSD硬碟： 512GB NVMe PCIe SSD / 共1個插槽，已使用1個\r\n螢幕尺寸：15.6\" FHD (1920x1080), IPS-Level\r\n作業系統：Windows 11 Home\r\n光碟機：無,請另購外接式光碟機\r\n網路規格：AMD RZ608 Wi-Fi 6E\r\n藍芽規格：Bluetooth v5.2\r\n視訊鏡頭：HD type (30fps@720p)\r\n鍵盤規格：白色背光鍵盤\r\n喇叭/音效技術：\r\n2x 2W Speaker\r\n1x Mic-in/Headphone-out Combo Jack\r\nI/O規格：\r\n1x Type-C USB3.2 Gen2 with PD charging\r\n1x Type-A USB3.2 Gen2\r\n2x Type-A USB2.0\r\n1x Micro SD Card Reader\r\n1x HDMI™ 2.1 (4K @ 60Hz)\r\n尺寸：359 x 241 x 19.9 mm\r\n重量：1.75 kg\r\n變壓器：65W adapter\r\n電池：3-Cell 39.3 / 53.8 Battery (Whr)\r\n保固：2年保固 台灣地區2年到府收送 免費客服電話0800-018880','AMD Ryzen7 7730U 8核心/16緒 2.0GHz超頻4.5GHz/ L2快取 4MB+L3快取 16MB','AMD Radeon™ Graphics','16GB*1 DDR4-3200 onboard','Windows 11 Home','15.6\" FHD (1920x1080), IPS-Level','3-Cell 39.3 / 53.8 Battery (Whr)','2年保固 台灣地區2年到府收送 免費客服電話0800-018880','359 x 241 x 19.9 mm','1.75 kg'),(17,0,'基本款','189900',58900,450,1,'2023-08-25 13:56:41','2023-08-25 13:56:41','商品規格\r\n處理器：Intel® Core™i7-13620H , 10核心 / 16緒 1.5GHz 超頻4.9GHz / 24M Cache\r\n顯示卡：GeForce RTX™ 4050 筆記型電腦GPU 6GB GDDR6\r\n記憶體：16GB(8G*2) DDR5-5200 / 共2個插槽，已經使用2個，最高64GB\r\nSSD硬碟：512GB M.2 SSD (NVMe PCIe)/ 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：14” FHD+ (1920x1200), 165Hz, IPS-Level\r\n作業系統：Windows 11 Pro\r\n光碟機：無,請另購外接式光碟機\r\n網路規格：Intel® Killer™ AX Wi-Fi 6E\r\n藍芽規格：Bluetooth v5.3\r\n視訊鏡頭：IR HD type (30fps@720p)\r\n鍵盤規格：Per-Key RGB Keyboard\r\n喇叭/音效技術：\r\n2x 2W Woofer\r\n2x 2W Speaker\r\n1x Mic-in/Headphone-out Combo Jack\r\nIO 介面：\r\n1x Type-C (USB / DP / Thunderbolt™ 4)\r\n1x Type-C (USB3.2 Gen2 / DP) with PD charging\r\n1x Type-A USB3.2 Gen2\r\n1x HDMI™ 2.1 (8K @ 60Hz / 4K @ 120Hz)\"\r\n尺寸：315 x 246 x 19 mm\r\n重量：1.7 kg\r\n變壓器：240W adapter\r\n電池：4-Cell 72 Battery (Whr)\r\n保固：2年保固台灣地區2年到府收送 免費客服電話0800-018880\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主','Intel® Core™i7-13620H , 10核心 / 16緒 1.5GHz 超頻4.9GHz / 24M Cache','GeForce RTX™ 4050 筆記型電腦GPU 6GB GDDR6','16GB(8G*2) DDR5-5200 / 共2個插槽，已經使用2個，最高64GB','Windows 11 Pro','14” FHD+ (1920x1200), 165Hz, IPS-Level','4-Cell 72 Battery (Whr)','2年保固台灣地區2年到府收送 免費客服電話0800-018880','315 x 246 x 19 mm','1.7 kg'),(18,0,'基本款','189282',49900,750,1,'2023-08-25 14:03:03','2023-08-25 14:03:03','商品規格\r\n處理器：第13代 Intel® Core™ i7-13650HX (24 MB 快取記憶體, 14 核, 最高睿頻 4.90 GHz)\r\n顯示卡：NVIDIA® GeForce® RTX™ 4050, 6 GB GDDR6\r\n記憶體：16GB (8GBx2) DDR5 4800MHz   (2 Slot/ up to 32G)\r\nSSD硬碟：M.2 2230 512GB NVMe Gen 4 Class 35 (擴充第二顆M.2，需要加購螺絲墊片與散热片)\r\n螢幕尺寸：15.6吋 FHD (1920x1080) 165Hz, 3ms, sRGB-100%, ComfortViewPlus, NVIDIA G-SYNC+DDS 顯示器\r\n光碟機：No\r\n作業系統：Windows® 11  家用版 64位元 三國語言版(繁體中文、簡體中文、英文)\r\n網路規格：Intel Wi-Fi 6 AX201, 2x2 802.11ax 1\r\n視訊鏡頭：720p (30 fps) HD RGB 攝影機，單一內建麥克風\r\n音效與喇叭：立體聲喇叭，搭載 Realtek ALC3254，2 x 2.5 W\r\n鍵盤規格：繁體中文 Qwerty 背光 鍵盤 含 數字鍵台 (無 G-Key)\r\nI/O規格：\r\n1x 耳機 (耳機和麥克風組合) 連接埠\r\n1x RJ45 乙太網路連接埠\r\n3x USB 3.2 Gen 1 連接埠\r\n1x HDMI 2.1 連接埠\r\n1x USB-C 3.2 Gen 2 連接埠，具備 DisplayPort™\r\n軟體：Mcafee 12M、Microsoft® Office 試用版\r\n尺寸：高度：25.4 x 368.9 x 289.9 (mm)\r\n重量：2.81 kg\r\n變壓器：330W\r\n電池：鋰離子(86 瓦時)電池 含Alienware 電池防護技術\r\n保固：2年 頂級支援 1-2 營業日 到府服務 含 HW-SW 支援\r\n備註：以上資料僅供參考，如有任何問題，請依原廠公告為主。','第13代 Intel® Core™ i7-13650HX (24 MB 快取記憶體, 14 核, 最高睿頻 4.90 GHz)','NVIDIA® GeForce® RTX™ 4050, 6 GB GDDR6','16GB (8GBx2) DDR5 4800MHz   (2 Slot/ up to 32G)','Windows® 11  家用版 64位元 三國語言版(繁體中文、簡體中文、英文)','15.6吋 FHD (1920x1080) 165Hz, 3ms, sRGB-100%, ComfortViewPlus, NVIDIA G-SYNC+DDS 顯示器','鋰離子(86 瓦時)電池 含Alienware 電池防護技術','2年 頂級支援 1-2 營業日 到府服務 含 HW-SW 支援','25.4 x 368.9 x 289.9 (mm)','2.81 kg');
/*!40000 ALTER TABLE `sellspec` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopcart`
--

DROP TABLE IF EXISTS `shopcart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shopcart` (
  `user_id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`prod_id`,`spec_id`) USING BTREE,
  KEY `prod_id` (`prod_id`),
  KEY `spec_id` (`spec_id`),
  CONSTRAINT `shopcart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `shopcart_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`),
  CONSTRAINT `shopcart_ibfk_3` FOREIGN KEY (`spec_id`) REFERENCES `sellspec` (`spec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopcart`
--

LOCK TABLES `shopcart` WRITE;
/*!40000 ALTER TABLE `shopcart` DISABLE KEYS */;
INSERT INTO `shopcart` VALUES (6,1,0),(6,1,1),(6,7,0),(6,9,2),(6,11,1);
/*!40000 ALTER TABLE `shopcart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `tag` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(50) NOT NULL,
  PRIMARY KEY (`tag`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (1,'CP值'),(2,'文書機'),(3,'電競機'),(4,'繪圖效能機'),(5,'極度輕薄'),(6,'開學季學生主打');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `rights` tinyint(4) NOT NULL DEFAULT 2 COMMENT '管理員 0\r\n賣家 1\r\n買家 2\r\n',
  `acc` varchar(20) NOT NULL,
  `pwd` varchar(1000) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `birth` date NOT NULL,
  `address` varchar(300) DEFAULT NULL,
  `photo` varchar(300) DEFAULT NULL,
  `change_pwd_time` date NOT NULL DEFAULT current_timestamp(),
  `creat_time` date NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  KEY `right` (`rights`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,0,'admin','$2b$10$PiWmGE8pvsjfIVT6EKMkG.1o5rYH8Kjr3jU6aqtE2coQlZTb1VgXy','管理員1號','0912345678','admin01@email.com','2000-01-01','台中市南屯區黎明路二段658號',NULL,'2023-08-24','2023-08-24'),(2,1,'seller01','$2b$10$WKiCfj0XWaKXIk1tzkgLCe2RsED.HX4qBISH9cZRHj9yscXX2eScG','賣家1號','0912345678','seller01@email.com','2000-01-01','台中市南屯區黎明路二段658號',NULL,'2023-08-24','2023-08-24'),(3,1,'seller02','$2b$10$xb3a/HSMVro24rigOU7gRumbFkGNm1AjYZybqzmwWq6YPebzpcx9u','賣家2號','0912345678','seller02@email.com','2000-01-01','台中市南屯區黎明路二段658號',NULL,'2023-08-24','2023-08-24'),(4,1,'seller03','$2b$10$I0S5zCuU7BpDzVrHw6UmnO7bAQuT5F9nq0N41FM6oDPdipkqob5Rm','賣家3號','0912345678','seller03@email.com','2000-01-01','台中市南屯區黎明路二段658號',NULL,'2023-08-24','2023-08-24'),(5,1,'seller04','$2b$10$VGuiO4kiyQGvB1q1R1pnPOkamWccoskzY7Nllxa8WKwujdvtfML7K','賣家4號','0912345678','seller04@email.com','2000-01-01','台中市南屯區黎明路二段658號',NULL,'2023-08-24','2023-08-24'),(6,2,'buyer01','$2b$10$lIfLO0xAj2vRPegkpvt7jO3lNArwo8jTl/jt/0I2Xc2rrZLi5o4zq','買家1號','0912345678','buyer01@email.com','2000-01-12','臺中市南屯區黎明路二段658號','/images/user/image_1694066131797.png','2023-09-03','2023-08-24'),(7,2,'buyer02','$2b$10$XZOwlduXlfQPw3vXXuDczO7AFA6c/7zyynp2gML5/syOHoHYWV2gC','買家2號','0912345678','buyer02@email.com','2000-01-01','台中市南屯區黎明路二段658號',NULL,'2023-08-24','2023-08-24'),(8,2,'buyer03','$2b$10$5x/uAEkltwc2bgO1qc2wIudU0KwwuImi8Em2Y7sgEIEvHB5hziKLe','買家3號','0912345678','buyer03@email.com','2000-01-01','台中市南屯區黎明路二段658號',NULL,'2023-08-24','2023-08-24'),(9,2,'buyer04','$2b$10$u/mx7VRJ2XPGkTnvIjsjIelB.VFy34k./UZlX2wufyHDsHbStR3yq','買家4號','0912345678','buyer04@email.com','2000-01-01','台中市南屯區黎明路二段658號',NULL,'2023-08-24','2023-08-24'),(10,2,'buyer05','$2b$10$YD6jXZdDUvN1opHU5LzGkuw/vjc1j9JsQCBPh/lT1DSx.sxLR997C','買家5號','0912345678','buyer05@gmail.com','2000-01-01','台中市南屯區黎明路二段658號',NULL,'2023-08-24','2023-08-24'),(18,2,'Aa010102','$2b$10$hvosbHJys4XZ.weVdIPkT.kBhnbmmnQMlGVh3Z0xwIqKfg4DansQi','aaa','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(19,2,'Aa010103','$2b$10$wq15RNi3PS5BQ8Nf9pTTg.odW42/o.UR7NKeEKXE1qZpbUQzCCGv.','aaa','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(20,2,'Aa010104','$2b$10$brnxY9S6kvqRZ5SE/I6cfuvUr/lNvmiFEote0QIQZj1MeLxQm5172','aaa','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(21,2,'Aa010105','$2b$10$FOK9OWLvggfH/NVD8uTbx.vOrVU8rNYoH894mrWdEtWV.Ww0ZP.zG','aaa','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(22,2,'Aa010106','$2b$10$vPADhJpEL2UcFcM7XwtT6eZzkb3ZWVFgVFV9t09obGkHjn2Hk1pyW','aaa','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(23,2,'Aa010107','$2b$10$p8RZojH3EuBBsH55OBaStuN5mCfx9v71FIyVF00sCFKFa1EDtKw0C','aaa','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(24,2,'Aa010108','$2b$10$HNqCrvTbgLeOxTY0aE9EOOKcrcguFRsONzQxBcgPKLL3VqScl419S','a','0912345678','a@gmail.com','2000-02-02',NULL,NULL,'2023-08-30','2023-08-30'),(25,2,'Aa010109','$2b$10$DGr5rCgczPlYl3ZcBtJHAeNyiDw8aB0r8XqTa0TUANQ0/OXl2Ary6','a','0912345678','a@gmail.com','2000-02-02',NULL,NULL,'2023-08-30','2023-08-30'),(26,2,'Ab010101','$2b$10$Vvjg8KH/malRtGwfI6Tzu.shNM9VlCPRO5W5g5ITzBe76WCmDGPvy','aaa','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(27,1,'Ab010102','$2b$10$vcK6d.W9jA5lx.XVG7y2iOTeqCpvKXVFXmgJnyum/eb2l.OqhOuxa','Ab010102','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(28,2,'Ab010103','$2b$10$7DTKYpi2gsw2b/l2D3o2LucjewnPf1zxS5fChrb9LCPezTn5oqLwW','Ab010103','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(30,2,'Ab010105','$2b$10$0fTzedslNWdBj0UBZvLgKe.qOxI95cQH20yoj57ZQUUpvebWFKm42','Ab010105','0912345678','a@gmail.com','2000-01-01',NULL,NULL,'2023-08-30','2023-08-30'),(41,2,'Bb010101','$2b$10$cLRMoDajQU/udKS1GlqAI.rKXcJHRHRt5OUhIghNja2ttinHOR4xS','Bb010101','0912345678','asda@gmail.com','1977-07-06',NULL,NULL,'2023-09-04','2023-09-04'),(42,2,'Bbb010101','$2b$10$4J8BCn3Gq9Ul5x1ptG8rmOvA0/WkSPyw5xnFgC7U7Vb68y3xj31ue','Bbb010101','0912345677','asd@gmail.com','1987-09-30','彰化縣彰化市彰美路1段1號',NULL,'2023-09-04','2023-09-04');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `vw_all_order_product_count`
--

DROP TABLE IF EXISTS `vw_all_order_product_count`;
/*!50001 DROP VIEW IF EXISTS `vw_all_order_product_count`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_all_order_product_count` AS SELECT
 1 AS `order_id`,
  1 AS `prod_id`,
  1 AS `spec_id`,
  1 AS `counts` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_comment`
--

DROP TABLE IF EXISTS `vw_comment`;
/*!50001 DROP VIEW IF EXISTS `vw_comment`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_comment` AS SELECT
 1 AS `prod_id`,
  1 AS `spec_id`,
  1 AS `user_id`,
  1 AS `order_id`,
  1 AS `prod_name`,
  1 AS `spec_name`,
  1 AS `name`,
  1 AS `state`,
  1 AS `comment`,
  1 AS `comment_grade`,
  1 AS `comment_time`,
  1 AS `img_src` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_order_detail`
--

DROP TABLE IF EXISTS `vw_order_detail`;
/*!50001 DROP VIEW IF EXISTS `vw_order_detail`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_order_detail` AS SELECT
 1 AS `order_id`,
  1 AS `user_id`,
  1 AS `prod_id`,
  1 AS `spec_id`,
  1 AS `prod_name`,
  1 AS `spec_name`,
  1 AS `price`,
  1 AS `count`,
  1 AS `subtotla`,
  1 AS `img_src` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_order_info`
--

DROP TABLE IF EXISTS `vw_order_info`;
/*!50001 DROP VIEW IF EXISTS `vw_order_info`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_order_info` AS SELECT
 1 AS `user_id`,
  1 AS `order_id`,
  1 AS `recipient`,
  1 AS `recipient_address`,
  1 AS `recipient_phone`,
  1 AS `state`,
  1 AS `pay`,
  1 AS `pay_method`,
  1 AS `total`,
  1 AS `order_date` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_product_comment_grade`
--

DROP TABLE IF EXISTS `vw_product_comment_grade`;
/*!50001 DROP VIEW IF EXISTS `vw_product_comment_grade`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_product_comment_grade` AS SELECT
 1 AS `prod_id`,
  1 AS `spec_id`,
  1 AS `comment_grade` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_products_detail`
--

DROP TABLE IF EXISTS `vw_products_detail`;
/*!50001 DROP VIEW IF EXISTS `vw_products_detail`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_products_detail` AS SELECT
 1 AS `prod_id`,
  1 AS `spec_id`,
  1 AS `prod_name`,
  1 AS `spec_name`,
  1 AS `brand`,
  1 AS `category`,
  1 AS `publish`,
  1 AS `cpu`,
  1 AS `gpu`,
  1 AS `ram`,
  1 AS `os`,
  1 AS `screen`,
  1 AS `battery`,
  1 AS `size`,
  1 AS `weight`,
  1 AS `warranty`,
  1 AS `info_content`,
  1 AS `img_src` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_products_info`
--

DROP TABLE IF EXISTS `vw_products_info`;
/*!50001 DROP VIEW IF EXISTS `vw_products_info`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_products_info` AS SELECT
 1 AS `prod_id`,
  1 AS `spec_id`,
  1 AS `seller_id`,
  1 AS `brand_id`,
  1 AS `category_id`,
  1 AS `prod_name`,
  1 AS `spec_name`,
  1 AS `seller_name`,
  1 AS `brand`,
  1 AS `category`,
  1 AS `publish`,
  1 AS `price`,
  1 AS `stock`,
  1 AS `sales`,
  1 AS `inventory`,
  1 AS `comment_grade`,
  1 AS `create_time`,
  1 AS `update_time`,
  1 AS `img_src` */;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'combuy'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_cards` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_cards`(IN p_user_id INT)
BEGIN
    SELECT
        user.user_id,
        user.name,
        card.card_num,
        card.expiry_date,
        card.security_code
    FROM
        card
    LEFT JOIN `user` ON user.user_id = card.user_id
    WHERE
        card.user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_collect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_collect`(IN `p_user_id` INT)
BEGIN
    SELECT
        user_id,
        collect.prod_id,
        collect.spec_id,
        vw_products_info.prod_name,
        vw_products_info.spec_name,
        vw_products_info.price,
        vw_products_info.publish,
        vw_products_info.img_src,
        collect.update_time
    FROM
        collect
    LEFT JOIN vw_products_info ON collect.prod_id = vw_products_info.prod_id AND collect.spec_id = vw_products_info.spec_id
    WHERE user_id = p_user_id
        ORDER BY collect.update_time DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_order`(IN `p_user_id` INT, IN `p_order_id` INT)
BEGIN
    SELECT
        orders.user_id,
        orders.order_id,
        order_product.prod_id,
        order_product.spec_id,
        vw_products_info.prod_name,
        vw_products_info.spec_name,
        order_product.count,
        order_product.price,
        (
            order_product.count * order_product.price
        ) AS amount,
        vw_products_info.img_src
    FROM
        order_product
    LEFT JOIN vw_products_info ON order_product.prod_id = vw_products_info.prod_id AND order_product.spec_id = vw_products_info.spec_id
    LEFT JOIN orders ON order_product.order_id = orders.order_id
    WHERE
        orders.state != 0 AND user_id = p_user_id AND orders.order_id = p_order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_orderList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_orderList`(IN p_user_id INT)
BEGIN
    SELECT
        orders.order_id,
        user.user_id,
        user.name AS buyer,
        SUM(TEMPTABLE.amount) AS total,
        orders.recipient,
        orders.recipient_address,
        orders.recipient_phone,
        orders.state,
        orders.pay,
        orders.pay_method,
        orders.order_date
    FROM
        orders
    LEFT JOIN(
        SELECT
            orders.user_id,
            orders.order_id,
            order_product.prod_id,
            order_product.spec_id,
            (
                order_product.count * order_product.price
            ) AS amount
        FROM
            order_product
        LEFT JOIN orders ON order_product.order_id = orders.order_id
    ) AS TEMPTABLE
ON
    orders.order_id = TEMPTABLE.order_id
LEFT JOIN USER ON user.user_id = orders.user_id
WHERE
    orders.user_id = p_user_id
GROUP BY
    orders.order_id ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_shopcart` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_shopcart`(IN p_user_id INT)
BEGIN
    SELECT
        user_id,
        shopcart.prod_id,
        shopcart.spec_id,
        vw_products_info.prod_name,
        vw_products_info.spec_name,
        vw_products_info.price,
        vw_products_info.publish,
        vw_products_info.img_src
    FROM
        shopcart
    LEFT JOIN vw_products_info ON shopcart.prod_id = vw_products_info.prod_id AND shopcart.spec_id = vw_products_info.spec_id
    WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `combuy`
--

USE `combuy`;

--
-- Final view structure for view `vw_all_order_product_count`
--

/*!50001 DROP VIEW IF EXISTS `vw_all_order_product_count`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_all_order_product_count` AS select `orders`.`order_id` AS `order_id`,`order_product`.`prod_id` AS `prod_id`,`order_product`.`spec_id` AS `spec_id`,`order_product`.`count` AS `counts` from (`orders` left join `order_product` on(`orders`.`order_id` = `order_product`.`order_id`)) where `orders`.`state` <> 0 and `order_product`.`count` is not null order by `orders`.`order_id`,`order_product`.`prod_id`,`order_product`.`spec_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_comment`
--

/*!50001 DROP VIEW IF EXISTS `vw_comment`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_comment` AS select `order_product`.`prod_id` AS `prod_id`,`order_product`.`spec_id` AS `spec_id`,`user`.`user_id` AS `user_id`,`orders`.`order_id` AS `order_id`,`vw_products_info`.`prod_name` AS `prod_name`,`vw_products_info`.`spec_name` AS `spec_name`,`user`.`name` AS `name`,`orders`.`state` AS `state`,ifnull(`order_product`.`comment`,'') AS `comment`,ifnull(`order_product`.`comment_grade`,0) AS `comment_grade`,`order_product`.`comment_time` AS `comment_time`,`vw_products_info`.`img_src` AS `img_src` from (((`order_product` left join `orders` on(`order_product`.`order_id` = `orders`.`order_id`)) left join `user` on(`orders`.`user_id` = `user`.`user_id`)) left join `vw_products_info` on(`order_product`.`prod_id` = `vw_products_info`.`prod_id` and `order_product`.`spec_id` = `vw_products_info`.`spec_id`)) where `orders`.`state` <> 0 order by `order_product`.`comment_time` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_order_detail`
--

/*!50001 DROP VIEW IF EXISTS `vw_order_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_order_detail` AS select `order_product`.`order_id` AS `order_id`,`orders`.`user_id` AS `user_id`,`order_product`.`prod_id` AS `prod_id`,`order_product`.`spec_id` AS `spec_id`,`vw_products_info`.`prod_name` AS `prod_name`,`vw_products_info`.`spec_name` AS `spec_name`,`order_product`.`price` AS `price`,`order_product`.`count` AS `count`,`order_product`.`price` * `order_product`.`count` AS `subtotla`,`vw_products_info`.`img_src` AS `img_src` from ((`order_product` left join `vw_products_info` on(`order_product`.`prod_id` = `vw_products_info`.`prod_id` and `order_product`.`spec_id` = `vw_products_info`.`spec_id`)) left join `orders` on(`order_product`.`order_id` = `orders`.`order_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_order_info`
--

/*!50001 DROP VIEW IF EXISTS `vw_order_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_order_info` AS select `vw_order_detail`.`user_id` AS `user_id`,`vw_order_detail`.`order_id` AS `order_id`,`orders`.`recipient` AS `recipient`,`orders`.`recipient_address` AS `recipient_address`,`orders`.`recipient_phone` AS `recipient_phone`,`orders`.`state` AS `state`,`orders`.`pay` AS `pay`,`orders`.`pay_method` AS `pay_method`,sum(`vw_order_detail`.`subtotla`) AS `total`,`orders`.`order_date` AS `order_date` from (`vw_order_detail` left join `orders` on(`vw_order_detail`.`order_id` = `orders`.`order_id`)) group by `vw_order_detail`.`order_id` order by `orders`.`order_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_product_comment_grade`
--

/*!50001 DROP VIEW IF EXISTS `vw_product_comment_grade`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_product_comment_grade` AS select `product`.`prod_id` AS `prod_id`,`sellspec`.`spec_id` AS `spec_id`,round(avg(`order_product`.`comment_grade`),1) AS `comment_grade` from (((`sellspec` left join `product` on(`sellspec`.`prod_id` = `product`.`prod_id`)) left join `order_product` on(`sellspec`.`spec_id` = `order_product`.`spec_id` and `sellspec`.`prod_id` = `order_product`.`prod_id`)) left join `orders` on(`order_product`.`order_id` = `orders`.`order_id`)) where `orders`.`state` <> 0 and `order_product`.`comment_grade` is not null group by `sellspec`.`prod_id`,`sellspec`.`spec_id` order by `sellspec`.`prod_id`,`sellspec`.`spec_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_products_detail`
--

/*!50001 DROP VIEW IF EXISTS `vw_products_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_products_detail` AS select `product`.`prod_id` AS `prod_id`,`sellspec`.`spec_id` AS `spec_id`,`product`.`prod_name` AS `prod_name`,`sellspec`.`spec_name` AS `spec_name`,`brand`.`brand` AS `brand`,`category`.`category` AS `category`,`sellspec`.`publish` AS `publish`,`sellspec`.`cpu` AS `cpu`,`sellspec`.`gpu` AS `gpu`,`sellspec`.`ram` AS `ram`,`sellspec`.`os` AS `os`,`sellspec`.`screen` AS `screen`,`sellspec`.`battery` AS `battery`,`sellspec`.`size` AS `size`,`sellspec`.`weight` AS `weight`,`sellspec`.`warranty` AS `warranty`,`sellspec`.`info_content` AS `info_content`,ifnull(concat(`productimg`.`dir`,`productimg`.`filename`),'') AS `img_src` from ((((`product` left join `sellspec` on(`product`.`prod_id` = `sellspec`.`prod_id`)) left join `brand` on(`product`.`brand_id` = `brand`.`brand_id`)) left join `category` on(`category`.`category_id` = `product`.`category_id`)) left join (select `productimg`.`prod_id` AS `prod_id`,`productimg`.`type` AS `TYPE`,`productimg`.`dir` AS `dir`,`productimg`.`filename` AS `filename` from `productimg`) `productimg` on(`sellspec`.`prod_id` = `productimg`.`prod_id` and `productimg`.`TYPE` = 1)) group by `sellspec`.`prod_id`,`sellspec`.`spec_id` order by `sellspec`.`prod_id`,`sellspec`.`spec_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_products_info`
--

/*!50001 DROP VIEW IF EXISTS `vw_products_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_products_info` AS select `product`.`prod_id` AS `prod_id`,`sellspec`.`spec_id` AS `spec_id`,`product`.`user_id` AS `seller_id`,`product`.`brand_id` AS `brand_id`,`product`.`category_id` AS `category_id`,`product`.`prod_name` AS `prod_name`,`sellspec`.`spec_name` AS `spec_name`,`user`.`name` AS `seller_name`,`brand`.`brand` AS `brand`,`category`.`category` AS `category`,`sellspec`.`publish` AS `publish`,`sellspec`.`price` AS `price`,`sellspec`.`stock` AS `stock`,ifnull(`vw_all_order_product_count`.`counts`,0) AS `sales`,`sellspec`.`stock` - ifnull(`vw_all_order_product_count`.`counts`,0) AS `inventory`,ifnull(`vw_product_comment_grade`.`comment_grade`,0) AS `comment_grade`,`sellspec`.`create_time` AS `create_time`,`sellspec`.`update_time` AS `update_time`,ifnull(concat(`productimg`.`dir`,`productimg`.`filename`),'/images/products/default.jpg') AS `img_src` from (((((((`product` left join `sellspec` on(`product`.`prod_id` = `sellspec`.`prod_id`)) left join `user` on(`user`.`user_id` = `product`.`user_id`)) left join `brand` on(`product`.`brand_id` = `brand`.`brand_id`)) left join `category` on(`category`.`category_id` = `product`.`category_id`)) left join `vw_all_order_product_count` on(`sellspec`.`prod_id` = `vw_all_order_product_count`.`prod_id` and `sellspec`.`spec_id` = `vw_all_order_product_count`.`spec_id`)) left join (select `productimg`.`prod_id` AS `prod_id`,`productimg`.`spec_id` AS `spec_id`,`productimg`.`type` AS `TYPE`,`productimg`.`dir` AS `dir`,`productimg`.`filename` AS `filename` from `productimg`) `productimg` on(`sellspec`.`prod_id` = `productimg`.`prod_id` and `sellspec`.`spec_id` = `productimg`.`spec_id` and `productimg`.`TYPE` = 0)) left join `vw_product_comment_grade` on(`sellspec`.`prod_id` = `vw_product_comment_grade`.`prod_id` and `sellspec`.`spec_id` = `vw_product_comment_grade`.`spec_id`)) group by `sellspec`.`prod_id`,`sellspec`.`spec_id` order by `sellspec`.`prod_id`,`sellspec`.`spec_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-07 14:02:44
