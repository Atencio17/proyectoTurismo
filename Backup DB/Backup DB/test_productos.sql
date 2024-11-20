-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: test
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

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
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `idProducto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) DEFAULT NULL,
  `detalle` varchar(500) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `categoria` varchar(45) DEFAULT NULL,
  `tipo` varchar(45) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idProducto`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (8,'Arepa de queso','Deliciosa arepa asada rellena de queso, perfecto para pasar el hambre.','https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Arepitas_Food_Macro.jpg/273px-Arepitas_Food_Macro.jpg','Gastronomía','Platillo',5000.00),(9,'Coctel de camarones','Conocido tipicamente como ceviche, un aperitivo común y delicioso para cuando visites playas.','https://uploads.vibra.co/1/2020/12/ceviche-de-camaron-4.jpg','Gastronomía','Platillo',6000.00),(10,'Mote de queso','Uno de los platillo más tipicos de la región caribe colombiana, con su sabor unico que se combina con el queso.','https://static-uat.cambiocolombia.com/s3fs-public/2023-04/mote_de_queso.jpeg','Gastronomía','Platillo',18000.00),(12,'Sombrero vueltiao','Sombrero tipico de la region caribe, actualmente sombrero nacional.','https://s3.amazonaws.com/rtvc-assets-canalinstitucional.tv/s3fs-public/2022-01/historia%20del%20sombrero%20vueltiao.jpg','Artesanía','Accesorio',20000.00),(13,'Hamaca','Elaborado con un fuerte tejido por artesanos, en el cual puedes descansar y si lo deseas dormir tambien.','https://www.artesaniaswattaa.com/cdn/shop/products/IMG_8700c.jpg?v=1663037001&width=1445','Artesanía','Artículo textiles',80000.00),(14,'Mochila Wayúu','Mochila tejida en representación tradicional comunidad Wayúu, tienden a robar miradas por el bello tejido y colores que tienen','https://artesaniascolombianas.co/wordpress/wp-content/uploads/2017/11/mochila_wayuu_135_2.jpg','Artesanía','Accesorio',30000.00),(15,'Cocada','Delicioso dulce hecho a base de coco, muy famoso por ser vendidas por mujeres llamadas \'palenqueras\', mujeres que hacen parte de la historia colombiana','https://cdn.colombia.com/gastronomia/2014/01/31/cocadas-1625.gif','Gastronomía','Postre',1500.00),(16,'Vasijas de barro','Artesanía hecha a base de barro, perfecta para decoraciones o usos como teteras, platos, etc.','https://radionacional-v3.s3.amazonaws.com/s3fs-public/styles/portadas_relaciona_4_3/public/node/article/field_image/IMG-20210625-WA0026.jpg?h=c673cd1c&itok=XqL7tM77','Artesanía','Decoracion',12000.00);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-18 21:17:23
