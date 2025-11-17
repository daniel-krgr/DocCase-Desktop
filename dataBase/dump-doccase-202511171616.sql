-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: doccase
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `anexos`
--

DROP TABLE IF EXISTS `anexos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `anexos` (
  `idanexos` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(120) DEFAULT NULL,
  `path` varchar(200) DEFAULT NULL,
  `steps_idsteps` int NOT NULL,
  `item` int DEFAULT NULL,
  PRIMARY KEY (`idanexos`),
  KEY `fk_anexos_steps1_idx` (`steps_idsteps`),
  CONSTRAINT `fk_anexos_steps1` FOREIGN KEY (`steps_idsteps`) REFERENCES `steps` (`idsteps`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `atores`
--

DROP TABLE IF EXISTS `atores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atores` (
  `idatores` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) DEFAULT NULL,
  `funcao` varchar(45) DEFAULT NULL,
  `nivel` varchar(45) DEFAULT NULL,
  `projeto_idprojeto` int NOT NULL,
  PRIMARY KEY (`idatores`),
  KEY `fk_atores_projeto1_idx` (`projeto_idprojeto`),
  CONSTRAINT `fk_atores_projeto1` FOREIGN KEY (`projeto_idprojeto`) REFERENCES `projeto` (`idprojeto`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `caso_uso`
--

DROP TABLE IF EXISTS `caso_uso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caso_uso` (
  `idcaso_uso` int NOT NULL AUTO_INCREMENT,
  `descricao` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `versao` varchar(45) DEFAULT NULL,
  `projeto_idprojeto` int NOT NULL,
  `data_criacao` date DEFAULT NULL,
  `hora_criacao` time DEFAULT NULL,
  `etiqueta_idetiqueta` int NOT NULL,
  `nome` varchar(120) DEFAULT NULL,
  `precondicao` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idcaso_uso`),
  KEY `fk_caso_uso_projeto1_idx` (`projeto_idprojeto`),
  KEY `fk_caso_uso_etiqueta1_idx` (`etiqueta_idetiqueta`),
  CONSTRAINT `fk_caso_uso_etiqueta1` FOREIGN KEY (`etiqueta_idetiqueta`) REFERENCES `etiqueta` (`idetiqueta`),
  CONSTRAINT `fk_caso_uso_projeto1` FOREIGN KEY (`projeto_idprojeto`) REFERENCES `projeto` (`idprojeto`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `caso_uso_versao`
--

DROP TABLE IF EXISTS `caso_uso_versao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caso_uso_versao` (
  `idversao` int NOT NULL AUTO_INCREMENT,
  `caso_uso_id` int NOT NULL,
  `versao` int NOT NULL,
  `nome` varchar(120) DEFAULT NULL,
  `descricao` longtext,
  `precondicao` varchar(200) DEFAULT NULL,
  `data_versao` datetime NOT NULL,
  `usuario_nome` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`idversao`),
  KEY `idx_caso_uso_versao_caso` (`caso_uso_id`),
  CONSTRAINT `fk_caso_uso_versao_caso` FOREIGN KEY (`caso_uso_id`) REFERENCES `caso_uso` (`idcaso_uso`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `etiqueta`
--

DROP TABLE IF EXISTS `etiqueta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etiqueta` (
  `idetiqueta` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(45) DEFAULT NULL,
  `projeto_idprojeto` int NOT NULL,
  PRIMARY KEY (`idetiqueta`),
  KEY `fk_etiqueta_projeto1_idx` (`projeto_idprojeto`),
  CONSTRAINT `fk_etiqueta_projeto1` FOREIGN KEY (`projeto_idprojeto`) REFERENCES `projeto` (`idprojeto`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fluxo`
--

DROP TABLE IF EXISTS `fluxo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fluxo` (
  `idfluxo` int NOT NULL AUTO_INCREMENT,
  `versao` varchar(45) DEFAULT NULL,
  `tipo_fluxo` varchar(45) DEFAULT NULL,
  `pre_requisito` longtext,
  `projeto_idprojeto` int NOT NULL,
  `caso_uso_idcaso_uso` int NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idfluxo`),
  KEY `fk_fluxo_projeto` (`projeto_idprojeto`),
  KEY `fk_fluxo_caso_uso` (`caso_uso_idcaso_uso`),
  CONSTRAINT `fk_fluxo_caso_uso` FOREIGN KEY (`caso_uso_idcaso_uso`) REFERENCES `caso_uso` (`idcaso_uso`),
  CONSTRAINT `fk_fluxo_projeto` FOREIGN KEY (`projeto_idprojeto`) REFERENCES `projeto` (`idprojeto`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fluxo_para_caso_uso`
--

DROP TABLE IF EXISTS `fluxo_para_caso_uso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fluxo_para_caso_uso` (
  `idfluxo_para_caso_uso` int NOT NULL AUTO_INCREMENT,
  `fluxo_idpasos` int NOT NULL,
  `caso_uso_idcaso_uso` int NOT NULL,
  PRIMARY KEY (`idfluxo_para_caso_uso`),
  KEY `fk_fluxo_para_caso_uso_fluxo1_idx` (`fluxo_idpasos`),
  KEY `fk_fluxo_para_caso_uso_caso_uso1_idx` (`caso_uso_idcaso_uso`),
  CONSTRAINT `fk_fluxo_para_caso_uso_caso_uso1` FOREIGN KEY (`caso_uso_idcaso_uso`) REFERENCES `caso_uso` (`idcaso_uso`),
  CONSTRAINT `fk_fluxo_para_caso_uso_fluxo1` FOREIGN KEY (`fluxo_idpasos`) REFERENCES `fluxo` (`idfluxo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `idlog` int NOT NULL AUTO_INCREMENT,
  `data_log` date DEFAULT NULL,
  `hora_log` time DEFAULT NULL,
  `descricao` varchar(200) DEFAULT NULL,
  `tipo` varchar(45) DEFAULT NULL,
  `usuarios_para_time_idusuarios_para_time` int NOT NULL,
  PRIMARY KEY (`idlog`),
  KEY `fk_log_usuarios_para_time1_idx` (`usuarios_para_time_idusuarios_para_time`),
  CONSTRAINT `fk_log_usuarios_para_time1` FOREIGN KEY (`usuarios_para_time_idusuarios_para_time`) REFERENCES `usuarios_para_time` (`idusuarios_para_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mensagens`
--

DROP TABLE IF EXISTS `mensagens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mensagens` (
  `idmensagens` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(45) DEFAULT NULL,
  `descricao` varchar(200) DEFAULT NULL,
  `steps_idsteps` int NOT NULL,
  `item` int DEFAULT NULL,
  PRIMARY KEY (`idmensagens`),
  KEY `fk_mensagens_steps1_idx` (`steps_idsteps`),
  CONSTRAINT `fk_mensagens_steps1` FOREIGN KEY (`steps_idsteps`) REFERENCES `steps` (`idsteps`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `projeto`
--

DROP TABLE IF EXISTS `projeto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projeto` (
  `idprojeto` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) DEFAULT NULL,
  `descricao` varchar(200) DEFAULT NULL,
  `time_idtime` int NOT NULL,
  `data_cadastro` date DEFAULT NULL,
  `op_publico` varchar(1) DEFAULT NULL,
  `codigo` varchar(3) DEFAULT NULL,
  `detalhe` longtext,
  PRIMARY KEY (`idprojeto`),
  KEY `fk_projeto_time1_idx` (`time_idtime`),
  CONSTRAINT `fk_projeto_time1` FOREIGN KEY (`time_idtime`) REFERENCES `time` (`idtime`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `projeto_imagem`
--

DROP TABLE IF EXISTS `projeto_imagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projeto_imagem` (
  `idimagem` int NOT NULL AUTO_INCREMENT,
  `projeto_idprojeto` int NOT NULL,
  `nome_arquivo` varchar(255) DEFAULT NULL,
  `mime` varchar(100) DEFAULT NULL,
  `imagem` longblob,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idimagem`),
  KEY `idx_img_projeto` (`projeto_idprojeto`),
  CONSTRAINT `fk_img_projeto` FOREIGN KEY (`projeto_idprojeto`) REFERENCES `projeto` (`idprojeto`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regra_negocio`
--

DROP TABLE IF EXISTS `regra_negocio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regra_negocio` (
  `idregra_negocio` int NOT NULL AUTO_INCREMENT,
  `caso_uso_idcaso_uso` int NOT NULL,
  `versao` varchar(45) DEFAULT NULL,
  `cod` int DEFAULT NULL,
  `descricao` varchar(200) DEFAULT NULL,
  `item` int DEFAULT NULL,
  `nome` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idregra_negocio`),
  KEY `idx_regra_caso_uso` (`caso_uso_idcaso_uso`),
  CONSTRAINT `fk_regra_caso_uso` FOREIGN KEY (`caso_uso_idcaso_uso`) REFERENCES `caso_uso` (`idcaso_uso`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `setps_para_fluxo`
--

DROP TABLE IF EXISTS `setps_para_fluxo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setps_para_fluxo` (
  `idsetps_para_fluxo` int NOT NULL AUTO_INCREMENT,
  `steps_idsteps` int NOT NULL,
  `fluxo_idpasos` int NOT NULL,
  PRIMARY KEY (`idsetps_para_fluxo`),
  KEY `fk_setps_para_fluxo_steps1_idx` (`steps_idsteps`),
  KEY `fk_setps_para_fluxo_fluxo1_idx` (`fluxo_idpasos`),
  CONSTRAINT `fk_setps_para_fluxo_fluxo1` FOREIGN KEY (`fluxo_idpasos`) REFERENCES `fluxo` (`idfluxo`),
  CONSTRAINT `fk_setps_para_fluxo_steps1` FOREIGN KEY (`steps_idsteps`) REFERENCES `steps` (`idsteps`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `steps`
--

DROP TABLE IF EXISTS `steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `steps` (
  `idsteps` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) DEFAULT NULL,
  `tipo_evento` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`idsteps`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `steps_has_fluxo`
--

DROP TABLE IF EXISTS `steps_has_fluxo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `steps_has_fluxo` (
  `steps_idsteps` int NOT NULL,
  `fluxo_idpasos` int NOT NULL,
  PRIMARY KEY (`steps_idsteps`,`fluxo_idpasos`),
  KEY `fk_steps_has_fluxo_fluxo1_idx` (`fluxo_idpasos`),
  KEY `fk_steps_has_fluxo_steps1_idx` (`steps_idsteps`),
  CONSTRAINT `fk_steps_has_fluxo_fluxo1` FOREIGN KEY (`fluxo_idpasos`) REFERENCES `fluxo` (`idfluxo`),
  CONSTRAINT `fk_steps_has_fluxo_steps1` FOREIGN KEY (`steps_idsteps`) REFERENCES `steps` (`idsteps`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time`
--

DROP TABLE IF EXISTS `time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time` (
  `idtime` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idtime`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `idusuarios` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `senha` varchar(80) DEFAULT NULL,
  `data_cadastro` date DEFAULT NULL,
  `sobrenome` varchar(120) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `img_user` varchar(200) DEFAULT NULL,
  `nivel_acesso` varchar(100) DEFAULT NULL,
  `funcao` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idusuarios`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuarios_para_time`
--

DROP TABLE IF EXISTS `usuarios_para_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_para_time` (
  `idusuarios_para_time` int NOT NULL AUTO_INCREMENT,
  `usuarios_idusuarios` int NOT NULL,
  `time_idtime` int NOT NULL,
  PRIMARY KEY (`idusuarios_para_time`),
  KEY `fk_usuarios_para_time_usuarios_idx` (`usuarios_idusuarios`),
  KEY `fk_usuarios_para_time_time1_idx` (`time_idtime`),
  CONSTRAINT `fk_usuarios_para_time_time1` FOREIGN KEY (`time_idtime`) REFERENCES `time` (`idtime`),
  CONSTRAINT `fk_usuarios_para_time_usuarios` FOREIGN KEY (`usuarios_idusuarios`) REFERENCES `usuarios` (`idusuarios`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'doccase'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-17 16:16:53
