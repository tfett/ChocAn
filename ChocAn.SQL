-- phpMyAdmin SQL Dump
-- version 3.5.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 28, 2013 at 03:36 AM
-- Server version: 5.5.29
-- PHP Version: 5.4.10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `chocAn`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddService`(IN `arg1` DATE, IN `arg2` INT(9), IN `arg3` INT(9), IN `arg4` VARCHAR(4), IN `arg5` DATETIME, IN `arg6` VARCHAR(150))
    NO SQL
BEGIN

   	 SET @sql_text = 
   CONCAT (
       "INSERT INTO `service` VALUES ('"
       ,arg1
       ,"', '"
       ,arg2
       ,"', "
       ,arg3
       ,"', "
       ,arg4
       ,"', "
       ,arg5
       ,"', "
       ,arg6
       , ")"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
        
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EFTReport`(IN `arg1` DATE)
    NO SQL
    DETERMINISTIC
BEGIN
    	SET @sql_text = 
   CONCAT (
       "Select p.name, sum(sr.cost) from provider p, service s, serviceRel sr where s.recordDate > '"
       , arg1
       , "' AND s.recordDate < '"
       , CURDATE()
       , "' AND s.providerID = p.providerID AND sr.code = s.code Group by p.name"
       ," into outfile '/usr/local/dbOut/eft-reports-"
       , NOW()
       , ".csv'"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetManagerReport`(IN `arg1` DATE)
    NO SQL
    DETERMINISTIC
BEGIN
    	SET @sql_text = 
   CONCAT (
       "Select p.name, count(*), sum(sr.cost) from provider p, service s, serviceRel sr where s.recordDate > '"
       , arg1
       , "' AND s.recordDate < '"
       , CURDATE()
       , "' AND s.providerID = p.providerID AND sr.code = s.code Group by p.name"
       ," into outfile '/usr/local/dbOut/reports-manager-results-"
       , NOW()
       , ".csv'"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
    
        SET @sql_text = 
   CONCAT (
       "SELECT p.name, sum(sr.cost), count(*) FROM service s, provider p, serviceRel sr where s.recordDate > '"
       , arg1
       , "' AND s.recordDate < '"
       , CURDATE()
       , "' AND s.providerID = p.providerID Group by p.name"
       ," into outfile '/usr/local/dbOut/reports-manager-aggregate-"
       , NOW()
       , ".csv'"
    );
        PREPARE s2 FROM @sql_text;
	EXECUTE s2;
	DROP PREPARE s2;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetReport`(IN `options` INT, IN `arg1` INT)
    NO SQL
BEGIN

    CASE options
    WHEN 1 THEN 
   	 SET @sql_text = 
   CONCAT (
       "Select * From serviceRel into outfile '/usr/local/dbOut/service-reports-"
       , NOW()
       , ".csv'"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
    WHEN 2 THEN 
    	SET @sql_text = 
   CONCAT (
       "SELECT * From provider where providerID = "
       , arg1
       , " into outfile '/usr/local/dbOut/reports-provider-header-"
       , NOW()
       , ".csv'"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
        SET @sql_text = 
   CONCAT (
       "Select s.serviceDate, s.recordDate, s.memberID, s.code, sr.cost From service s, provider p, serviceRel sr where s.providerID = "
       , arg1
       ," AND s.providerID = p.providerID AND sr.code = s.code"
       , " into outfile '/usr/local/dbOut/reports-provider-results"
       , NOW()
       , ".csv'"
    );
        PREPARE s2 FROM @sql_text;
	EXECUTE s2;
	DROP PREPARE s2;
        SET @sql_text = 
   CONCAT (
       "SELECT SUM( sr.cost ) , count( * )  FROM service s, provider p, serviceRel sr WHERE s.providerID ="
       , arg1
       ," AND s.providerID = p.providerID AND sr.code = s.code"
       , " into outfile '/usr/local/dbOut/reports-provider-aggregate"
       , NOW()
       , ".csv'"
    );
        PREPARE s3 FROM @sql_text;
	EXECUTE s3;
	DROP PREPARE s3;
WHEN 3 THEN 
    	SET @sql_text = 
   CONCAT (
       "Select * From member where memberID ="
       , arg1
       , " into outfile '/usr/local/dbOut/reports-member-header-"
       , NOW()
       , ".csv'"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
    
        SET @sql_text = 
   CONCAT (
       "Select s.serviceDate, p.name, sr.description From service s, provider p, serviceRel sr, member m where m.memberID=" 
       , arg1
       ," AND s.memberID = m.memberID AND sr.code = s.code AND s.providerID = p.providerID"
       , " into outfile '/usr/local/dbOut/reports-member-results"
       , NOW()
       , ".csv'"
    );
        PREPARE s2 FROM @sql_text;
	EXECUTE s2;
	DROP PREPARE s2;
    END CASE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetService`(IN `arg1` VARCHAR (4))
BEGIN
   	 SELECT description 
   	 FROM serviceRel
   	 WHERE code  = arg1;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetStatus`(IN `userId` INT)
BEGIN
   	 SELECT status 
   	 FROM member
   	 WHERE memberId = userId;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ModifyMember`(IN `options` INT, IN `arg1` INT(9), IN `arg2` VARCHAR(50), IN `arg3` VARCHAR(100), IN `arg4` VARCHAR(40), IN `arg5` VARCHAR(2), IN `arg6` VARCHAR(7), IN `arg7` VARCHAR(40))
    NO SQL
BEGIN

    CASE options
    WHEN 1 THEN 
   	 SET @sql_text = 
   CONCAT (
       "INSERT INTO `member` VALUES ('"
       ,arg1
       ,"', '"
       ,arg2
       ,"', "
       ,arg3
       ,"', "
       ,arg4
       ,"', "
       ,arg5
       ,"', "
       ,arg6
       ,"', "
       ,arg7
       , ")"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;

    WHEN 2 THEN 
    	SET @sql_text = 
   CONCAT (
       "UPDATE `member` SET 
        `name` = "
       ,arg2
       , ", `street` ='"
       ,arg3
       , ", `city` ='"
       ,arg4
       , ", `state` ='"
       ,arg5
       , ", `zip` ='"
       ,arg6
       , ", `status` ='"
       ,arg7
       , "' WHERE `memberID` = '"
       ,arg1
       ,"' LIMIT 1"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
        

    END CASE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ModifyProvider`(IN `options` INT, IN `arg1` INT(9), IN `arg2` VARCHAR(40), IN `arg3` VARCHAR(100), IN `arg4` VARCHAR(50), IN `arg5` VARCHAR(2), IN `arg6` VARCHAR(7))
    NO SQL
BEGIN

    CASE options
    WHEN 1 THEN 
   	 SET @sql_text = 
   CONCAT (
       "INSERT INTO `provider` VALUES ('"
       ,arg1
       ,"', '"
       ,arg2
       ,"', "
       ,arg3
       ,"', "
       ,arg4
       ,"', "
       ,arg5
       ,"', "
       ,arg6
       , ")"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;

    WHEN 2 THEN 
    	SET @sql_text = 
   CONCAT (
       "UPDATE `provider` SET 
        `name` = "
       ,arg2
       , ", `street` ='"
       ,arg3
       , ", `city` ='"
       ,arg4
       , ", `state` ='"
       ,arg5
       , ", `zip` ='"
       ,arg6
       , "' WHERE `providerID` = '"
       ,arg1
       ,"' LIMIT 1"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
        

    END CASE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ModifyService`(IN `options` INT, IN `arg1` VARCHAR(4), IN `arg2` VARCHAR(200), IN `arg3` DOUBLE)
    NO SQL
BEGIN

    CASE options
    WHEN 1 THEN 
   	 SET @sql_text = 
   CONCAT (
       "INSERT INTO `serviceRel` VALUES ('"
       ,arg1
       ,"', '"
       ,arg2
       ,"', "
       ,arg3
       , ")"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
    WHEN 2 THEN 
    	SET @sql_text = 
   CONCAT (
       "UPDATE `serviceRel` SET `cost` = "
       ,arg3
       , ", `description` ='"
       ,arg2
       , "' WHERE `code` = '"
       ,arg1
       ,"' LIMIT 1"
    );

	PREPARE s1 FROM @sql_text;
	EXECUTE s1;
	DROP PREPARE s1;
        

    END CASE;
END$$

DELIMITER ;


-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `memberID` int(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `street` varchar(100) NOT NULL,
  `city` varchar(40) NOT NULL,
  `state` varchar(2) NOT NULL,
  `zip` int(7) NOT NULL,
  `status` varchar(40) NOT NULL,
  PRIMARY KEY (`memberID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`memberID`, `name`, `street`, `city`, `state`, `zip`, `status`) VALUES
(1, 'Krea Fetters', '1370 SW Woodward Way', 'Portland', 'OR', 97124, 'Active'),
(2, 'Tyler Fetters', '1370 SW Woodward Way', 'Portland', 'OR', 97124, 'Cured'),
(3, 'Koryn Cauthorn', '123 street dr.', 'Portland', 'OR', 97225, 'Active'),
(4, 'Mark Cauthorn', '8899 Eagle Crest Blvd.', 'Eagle Crest', 'OR', 97701, 'Inactive'),
(5, 'Vicki Cauthorn', '8899 Eagle Crest Blvd.', 'Eagle Crest', 'OR', 97701, 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `provider`
--

CREATE TABLE `provider` (
  `providerID` int(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `street` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(2) NOT NULL,
  `zip` varchar(5) NOT NULL,
  PRIMARY KEY (`providerID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `provider`
--

INSERT INTO `provider` (`providerID`, `name`, `street`, `city`, `state`, `zip`) VALUES
(1, 'Choco Enterprises', '1435 Stark St.', 'Portland', 'OR', '97080'),
(2, 'Chocolate Free', '7230 Division St.', 'Portland', 'OR', '97081'),
(3, 'Choc-no', '4875 Burnside St.', 'Portland', 'OR', '97225');

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `serviceDate` date NOT NULL,
  `providerID` int(9) NOT NULL,
  `memberID` int(9) NOT NULL,
  `code` varchar(4) NOT NULL,
  `recordDate` datetime NOT NULL,
  `comments` varchar(150) NOT NULL,
  PRIMARY KEY (`serviceDate`,`providerID`,`memberID`,`code`),
  KEY `code` (`code`),
  KEY `memberID` (`memberID`),
  KEY `providerID` (`providerID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`serviceDate`, `providerID`, `memberID`, `code`, `recordDate`, `comments`) VALUES
('2013-01-05', 1, 2, 'SHOK', '2013-02-05 05:44:32', 'Successful Implementation and Therapy'),
('2013-05-01', 1, 3, 'NUTR', '2013-05-02 07:44:32', 'Successful Implementation and Therapy'),
('2013-05-02', 2, 2, 'NUTR', '2013-05-08 19:01:29', 'Succesful Treatment Session, Great Progress'),
('2013-05-03', 2, 3, 'SHOK', '2013-05-06 19:01:56', 'Unsuccesful requires another appt');

-- --------------------------------------------------------

--
-- Table structure for table `serviceRel`
--

CREATE TABLE `serviceRel` (
  `code` varchar(4) NOT NULL,
  `description` varchar(200) NOT NULL,
  `cost` float NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `serviceRel`
--

INSERT INTO `serviceRel` (`code`, `description`, `cost`) VALUES
('SHOK', 'Shock Therapy Treatement', 79.95),
('NUTR', 'Nutritional Guidance Appointment', 75.99),
('CONC', 'Mental Counseling Therapy', 125.99),
('GROP', 'Group Counseling Therapy', 69.99),
('GORG', 'Chocolate Overload Therapy', 35.99),
('TEST', 'Some Description GOOD', 26.89);
