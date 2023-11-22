-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- 主機： localhost:3306
-- 產生時間： 2023-09-15 06:36:23
-- 伺服器版本： 5.7.24
-- PHP 版本： 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫: `combuy`
--

DELIMITER $$
--
-- 程序
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_cards` (IN `p_user_id` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_collect` (IN `p_user_id` INT)   BEGIN
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
    WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_order` (IN `p_user_id` INT, IN `p_order_id` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_orderList` (IN `p_user_id` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_shopcart` (IN `p_user_id` INT)   BEGIN
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
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `bannerimg`
--

CREATE TABLE `bannerimg` (
  `img_id` int(11) NOT NULL,
  `dir` varchar(100) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `link` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `brand`
--

CREATE TABLE `brand` (
  `brand_id` int(11) NOT NULL,
  `brand` varchar(50) NOT NULL,
  `content` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `brand`
--

INSERT INTO `brand` (`brand_id`, `brand`, `content`) VALUES
(1, 'APPLE', 'apple .inc'),
(2, 'Acer', NULL),
(3, 'ASUS', NULL),
(4, 'Miscroft', NULL),
(5, 'Lenovo', NULL),
(6, 'DELL', NULL),
(7, 'HP', NULL),
(8, 'LG', NULL),
(9, 'MSI', NULL),
(10, '其他', NULL);

-- --------------------------------------------------------

--
-- 資料表結構 `card`
--

CREATE TABLE `card` (
  `card_num` varchar(17) NOT NULL,
  `expiry_date` varchar(5) NOT NULL,
  `security_code` varchar(4) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `card`
--

INSERT INTO `card` (`card_num`, `expiry_date`, `security_code`, `user_id`) VALUES
('1111222233334444', '0523', '999', 6),
('222233344445555', '0524', '999', 6);

-- --------------------------------------------------------

--
-- 資料表結構 `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `category` varchar(50) NOT NULL,
  `content` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `category`
--

INSERT INTO `category` (`category_id`, `category`, `content`) VALUES
(1, '筆電', NULL),
(2, '滑鼠', NULL),
(3, '鍵盤', NULL);

-- --------------------------------------------------------

--
-- 資料表結構 `collect`
--

CREATE TABLE `collect` (
  `user_id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recipient` varchar(100) NOT NULL,
  `recipient_address` varchar(300) NOT NULL,
  `recipient_phone` varchar(50) NOT NULL,
  `state` tinyint(4) NOT NULL DEFAULT '1' COMMENT '訂單取消 0\r\n訂單成立 1\r\n訂單完成 2',
  `pay` tinyint(4) NOT NULL DEFAULT '0' COMMENT '尚未付款 0\r\n付款完成 1',
  `pay_method` tinyint(4) NOT NULL COMMENT '銀行或郵局轉帳 0\r\n信用卡(一次付清)　 1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `order_date`, `recipient`, `recipient_address`, `recipient_phone`, `state`, `pay`, `pay_method`) VALUES
(1, 6, '2023-08-25 00:00:00', '買家一的收件人', '台中市中區臺灣大道一段1號', '0912345678', 2, 1, 0),
(2, 6, '2023-08-25 00:00:00', '買家一的收件人', '台中市中區臺灣大道一段1號', '0912345678', 0, 0, 0),
(3, 7, '2023-08-25 14:12:15', '買家2的收件人', '台中市中區臺灣大道一段1號', '0912345678', 2, 1, 0),
(4, 7, '2023-08-25 14:13:22', '買家2的收件人', '台中市中區臺灣大道一段1號', '0912345678', 1, 1, 1);

-- --------------------------------------------------------

--
-- 資料表結構 `order_product`
--

CREATE TABLE `order_product` (
  `order_id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `comment` varchar(300) DEFAULT NULL,
  `comment_grade` tinyint(4) DEFAULT NULL,
  `comment_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `order_product`
--

INSERT INTO `order_product` (`order_id`, `prod_id`, `spec_id`, `price`, `count`, `comment`, `comment_grade`, `comment_time`) VALUES
(1, 1, 1, 40900, 2, '很棒的產品', 1, '2023-08-25 14:06:46'),
(2, 1, 1, 40900, 2, NULL, NULL, NULL),
(3, 1, 1, 40900, 1, '爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了爛透了', 5, '2023-08-25 14:15:41'),
(4, 1, 1, 40900, 1, '很棒', 3, '2023-08-28 11:18:34');

-- --------------------------------------------------------

--
-- 資料表結構 `product`
--

CREATE TABLE `product` (
  `prod_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `prod_name` varchar(50) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `creat_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `transport` tinyint(4) NOT NULL DEFAULT '2' COMMENT '郵寄寄送 0\r\n宅配/快遞　 1\r\n全部 2',
  `payment` tinyint(4) NOT NULL DEFAULT '2' COMMENT '銀行或郵局轉帳 0\r\n信用卡(一次付清)　 1\r\n全部 2'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `product`
--

INSERT INTO `product` (`prod_id`, `user_id`, `prod_name`, `brand_id`, `category_id`, `creat_time`, `update_time`, `transport`, `payment`) VALUES
(1, 2, 'acer Nitro AN515 i5/RTX4050 12代電競筆電	', 2, 1, '2023-08-24 00:00:00', '2023-08-24 00:00:00', 2, 2),
(4, 2, 'acer Nitro AN515 RTX4060 電競筆電', 2, 1, '2023-08-25 10:31:58', '2023-08-25 10:31:58', 2, 2),
(5, 2, 'acer Swift GO SFG16-71 13代輕薄筆電', 2, 1, '2023-08-25 10:38:56', '2023-08-25 10:38:56', 2, 2),
(6, 2, 'acer Swift5 SF514 纖薄觸控筆電', 2, 1, '2023-08-25 10:55:24', '2023-08-25 10:55:24', 2, 2),
(7, 2, 'acer Predator Helios PH18 13代掠奪者電競', 2, 1, '2023-08-25 11:04:18', '2023-08-25 11:04:18', 2, 2),
(8, 3, 'TUF Gaming A15 FA507NU 軍規電競', 3, 1, '2023-08-25 11:18:22', '2023-08-25 11:18:22', 2, 2),
(9, 3, 'ASUS Vivobook 16 X1605ZA', 3, 1, '2023-08-25 12:46:49', '2023-08-25 12:46:49', 2, 2),
(10, 3, 'ASUS Zenbook Pro 14 OLED UX6404VI', 3, 1, '2023-08-25 12:53:03', '2023-08-25 12:53:03', 2, 2),
(11, 3, 'ASUS ROG Zephyrus G14 GA402XV 西風之神輕薄電競', 3, 1, '2023-08-25 12:58:04', '2023-08-25 12:58:04', 2, 2),
(12, 3, 'ASUS ROG Strix SCAR 17 G733PZ', 3, 1, '2023-08-25 13:05:00', '2023-08-25 13:05:00', 2, 2),
(13, 4, 'LG gram 16 16Z90R 13代輕薄筆電', 8, 1, '2023-08-25 13:12:41', '2023-08-25 13:12:41', 2, 2),
(14, 4, 'LG gram 16 16Z90R', 8, 1, '2023-08-25 13:26:05', '2023-08-25 13:26:05', 2, 2),
(15, 5, 'MSI Stealth16 MercedesAMG 聯名創作者筆電', 9, 1, '2023-08-25 13:40:21', '2023-08-25 13:40:21', 2, 1),
(16, 5, 'MSI Modern 15 B7M 輕薄高效筆電', 9, 1, '2023-08-25 13:46:44', '2023-08-25 13:46:44', 2, 1),
(17, 5, 'MSI Stealth 14Studio A13VE 微星輕薄電競筆電', 9, 1, '2023-08-25 13:54:21', '2023-08-25 13:54:21', 2, 2),
(18, 5, 'DELL Inspiron Gaming G15-5530-R1768BTW', 6, 1, '2023-08-25 14:01:52', '2023-08-25 14:01:52', 2, 2),
(69, 1, '沒設圖片', 2, 1, '2023-09-14 08:16:20', '2023-09-14 16:16:20', 1, 1),
(70, 1, '00000', 2, 1, '2023-09-14 08:17:48', '2023-09-14 16:17:48', 0, 1),
(71, 1, '測試中1055', 5, 1, '2023-09-14 18:25:41', '2023-09-15 02:25:41', 1, 0),
(72, 1, '編輯中______0137', 3, 1, '2023-09-15 02:26:06', '2023-09-15 10:26:06', 1, 0);

-- --------------------------------------------------------

--
-- 資料表結構 `productimg`
--

CREATE TABLE `productimg` (
  `img_id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  `dir` varchar(100) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '產品圖 0\r\n介紹圖 1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `productimg`
--

INSERT INTO `productimg` (`img_id`, `prod_id`, `spec_id`, `dir`, `filename`, `type`) VALUES
(1, 1, 0, '/images/products/', '189823.jpg', 0),
(2, 1, 0, '/images/products_info/', '186419-1.jpg', 1),
(3, 4, 0, '/images/products/', '186420.jpg', 0),
(4, 4, 0, '/images/products_info/', '186420-1.jpg', 1),
(5, 5, 0, '/images/products/', '185606.jpg', 0),
(6, 6, 0, '/images/products/', '171303.jpg', 0),
(7, 6, 0, '/images/products_info/', '167295-1.jpg', 1),
(8, 7, 0, '/images/products/', '185611.jpg', 0),
(9, 7, 0, '/images/products_info/', '185611-1.jpg', 1),
(10, 8, 0, '/images/products/', '190351.jpg', 0),
(11, 8, 0, '/images/products_info/', '190351-1.jpg', 1),
(12, 9, 0, '/images/products/', '190102.jpg', 0),
(13, 9, 0, '/images/products_info/', '184102-1.jpg', 1),
(14, 10, 0, '/images/products/', '187733.jpg', 0),
(15, 10, 0, '/images/products_info/', '187733-1.jpg', 1),
(16, 11, 0, '/images/products/', '186517.jpg', 0),
(17, 11, 0, '/images/products_info/', '186517-1.jpg', 1),
(18, 12, 0, '/images/products/', '185722.jpg', 0),
(19, 12, 0, '/images/products_info/', '185722-1.jpg', 1),
(20, 13, 0, '/images/products/', '187307.jpg', 0),
(21, 13, 0, '/images/products_info/', '185202-1.jpg', 1),
(22, 14, 0, '/images/products/', '185202.jpg', 0),
(23, 14, 0, '/images/products_info/', '185202-1.jpg', 1),
(24, 15, 0, '/images/products/', '190165.jpg', 0),
(25, 15, 0, '/images/products_info/', '190165-1.jpg', 1),
(26, 16, 0, '/images/products/', '190125.jpg', 0),
(27, 16, 0, '/images/products_info/', '190125-1.jpg', 1),
(28, 17, 0, '/images/products/', '189900.jpg', 0),
(29, 17, 0, '/images/products_info/', '189900-1.jpg', 1),
(30, 18, 0, '/images/products/', '189282.jpg', 0),
(31, 18, 0, '/images/products_info/', '189282-1.jpg', 1),
(33, 1, 1, '/images/products/', '189823-1.jpg', 0),
(34, 1, 1, '/images/products_info/', '186419-1.jpg', 1),
(35, 5, 1, '/images/products/', '185606-1.jpg', 0),
(36, 9, 1, '/images/products/', '190102-1.jpg', 0),
(37, 9, 2, '/images/products/', '190102-2.jpg', 0),
(38, 9, 1, '/images/products_info/', '184102-1.jpg', 1),
(39, 9, 2, '/images/products_info/', '184102-1.jpg', 1),
(40, 11, 1, '/images/products/', '186517-1.jpg', 0),
(41, 11, 1, '/images/products_info/', '186517-1.jpg', 1),
(42, 13, 1, '/images/products/', '187307-1.jpg', 0),
(43, 13, 1, '/images/products_info/', '185202-1.jpg', 1),
(44, 13, 2, '/images/products/', '187307-2.jpg', 0),
(45, 13, 2, '/images/products_info/', '185202-1.jpg', 1),
(46, 14, 1, '/images/products/', '185202-1.jpg', 0),
(47, 14, 1, '/images/products_info/', '185202-1.jpg', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `product_images_test`
--

CREATE TABLE `product_images_test` (
  `id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `originalname` varchar(255) NOT NULL,
  `stored_name` varchar(255) NOT NULL,
  `upload_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `file_size` int(11) NOT NULL,
  `mime_type` varchar(50) NOT NULL,
  `img_src` varchar(150) NOT NULL,
  `products_info` tinyint(1) DEFAULT '1',
  `spec_id` tinyint(10) NOT NULL DEFAULT '10'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `product_images_test`
--

INSERT INTO `product_images_test` (`id`, `prod_id`, `originalname`, `stored_name`, `upload_date`, `file_size`, `mime_type`, `img_src`, `products_info`, `spec_id`) VALUES
(59, 69, 'defaultImage.jpg', 'defaultImage.jpg', '2023-09-14 08:16:20', 999, 'image/jpeg', '/images/products/defaultImage.jpg', 0, 10),
(60, 70, 'defaultImage.jpg', 'defaultImage.jpg', '2023-09-14 08:17:49', 999, 'image/jpeg', '/images/products/defaultImage.jpg', 0, 10),
(61, 71, '186420.jpg', '1694715941829-186420.jpg', '2023-09-14 18:25:42', 145292, 'image/jpeg', '../images/products/1694715941829-186420.jpg', 1, 10),
(62, 71, '186517-1.jpg', '1694715941832-186517-1.jpg', '2023-09-14 18:25:42', 133401, 'image/jpeg', '../images/products/1694715941832-186517-1.jpg', 0, 10),
(63, 72, '186517-1.jpg', '1694744766099-186517-1.jpg', '2023-09-15 02:26:06', 133401, 'image/jpeg', '../images/products/1694744766099-186517-1.jpg', 1, 10),
(64, 72, '186420.jpg', '1694744766095-186420.jpg', '2023-09-15 02:26:06', 145292, 'image/jpeg', '../images/products/1694744766095-186420.jpg', 0, 10),
(65, 72, '186517.jpg', '1694744766101-186517.jpg', '2023-09-15 02:26:06', 166267, 'image/jpeg', '../images/products/1694744766101-186517.jpg', 1, 10);

-- --------------------------------------------------------

--
-- 資料表結構 `product_tag`
--

CREATE TABLE `product_tag` (
  `prod_id` int(11) NOT NULL,
  `tag` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `product_tag`
--

INSERT INTO `product_tag` (`prod_id`, `tag`) VALUES
(1, 1),
(10, 1),
(11, 1),
(15, 1),
(17, 1),
(6, 2),
(9, 2),
(13, 2),
(14, 2),
(16, 2),
(1, 3),
(4, 3),
(7, 3),
(8, 3),
(10, 3),
(12, 3),
(17, 3),
(18, 3),
(15, 4),
(5, 5),
(6, 5),
(11, 5),
(13, 5),
(14, 5),
(16, 5),
(17, 5),
(7, 6),
(8, 6),
(10, 6),
(11, 6),
(12, 6),
(16, 6),
(17, 6),
(18, 6);

-- --------------------------------------------------------

--
-- 資料表結構 `sellspec`
--

CREATE TABLE `sellspec` (
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  `spec_name` varchar(21) NOT NULL,
  `contnet` varchar(500) DEFAULT NULL,
  `price` int(11) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT '0',
  `publish` int(11) NOT NULL DEFAULT '0' COMMENT '不公開 0\r\n公開 1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `info_content` varchar(2500) DEFAULT NULL,
  `cpu` varchar(150) DEFAULT NULL,
  `gpu` varchar(150) DEFAULT NULL,
  `ram` varchar(100) DEFAULT NULL,
  `os` varchar(100) DEFAULT NULL,
  `screen` varchar(150) DEFAULT NULL,
  `battery` varchar(100) DEFAULT NULL,
  `warranty` varchar(150) DEFAULT NULL,
  `size` varchar(100) DEFAULT NULL,
  `weight` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `sellspec`
--

INSERT INTO `sellspec` (`prod_id`, `spec_id`, `spec_name`, `contnet`, `price`, `stock`, `publish`, `create_time`, `update_time`, `info_content`, `cpu`, `gpu`, `ram`, `os`, `screen`, `battery`, `warranty`, `size`, `weight`) VALUES
(1, 0, '基本款', '189823', 40900, 1000, 1, '2023-08-25 09:38:59', '2023-08-25 09:38:59', '商品規格\r\n處理器：Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)\r\n記憶體：16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\nSSD硬碟：512GB NVMe PCIe Gen4 SSD / 共2個插槽，已經使用1個\r\n傳統硬碟：無，有一個2.5吋硬碟空間可以擴充\r\n螢幕：15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i Dual Band(2.4 GHz/5 GHz) 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth 5.1\r\n攝影機：HD (1280 x 720)with Temporal Noise Reduction(TNR)Dual Mic\r\nI/O 介面：\r\n1 x Type-C (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)支援影像傳輸\r\n3 x TypeA USB 3.2\r\n1 x HDMI 2.1\r\n1 x Microphone-in/Headphone-out jack\r\n1 x RJ45 (Killer Ethernet E2600)\r\n尺寸：360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm\r\n重量：2.5 kg\r\n變壓器：230W\r\n電池：57Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache', 'NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)', '16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\n', 'Windows 11 家用版', '15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光', '57Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm', '2.5 kg'),
(1, 1, '紅色款', '189823', 40900, 1500, 1, '2023-08-25 09:38:59', '2023-08-25 09:38:59', '商品規格\r\n處理器：Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)\r\n記憶體：16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\nSSD硬碟：512GB NVMe PCIe Gen4 SSD / 共2個插槽，已經使用1個\r\n傳統硬碟：無，有一個2.5吋硬碟空間可以擴充\r\n螢幕：15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i Dual Band(2.4 GHz/5 GHz) 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth 5.1\r\n攝影機：HD (1280 x 720)with Temporal Noise Reduction(TNR)Dual Mic\r\nI/O 介面：\r\n1 x Type-C (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)支援影像傳輸\r\n3 x TypeA USB 3.2\r\n1 x HDMI 2.1\r\n1 x Microphone-in/Headphone-out jack\r\n1 x RJ45 (Killer Ethernet E2600)\r\n尺寸：360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm\r\n重量：2.5 kg\r\n變壓器：230W\r\n電池：57Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache', 'NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)', '16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\n', 'Windows 11 家用版.', '15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光', '57Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm', '2.5 kg'),
(4, 0, '基本款', '186420', 52900, 1000, 1, '2023-08-25 10:33:34', '2023-08-25 10:33:34', '商品規格\r\n處理器：Intel Core i7-12700H 14核心/20緒 2.3 GHz 超頻 4.7 GHz / 24M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4060 8G-GDDR6 MGP 140W滿血版(支援獨顯直連)\r\n記憶體：16GB DDR5-4800 / 共2個插槽，已經使用1個，最高支援32G\r\nSSD硬碟：512GB NVMe PCIe Gen4 SSD / 共2個插槽，已經使用1個\r\n傳統硬碟：無，有一個2.5吋硬碟空間可以擴充\r\n螢幕：15.6吋 165Hz 1920X1080 FHD/IPS/霧面/LED背光\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i Dual Band(2.4 GHz/5 GHz) 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth 5.1\r\n攝影機：HD (1280 x 720)with Temporal Noise Reduction(TNR)Dual Mic\r\nI/O 介面：\r\n1 x Type-C (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)支援影像傳輸\r\n3 x TypeA USB 3.2\r\n1 x HDMI 2.1\r\n1 x Microphone-in/Headphone-out jack\r\n1 x RJ45 (Killer Ethernet E2600)\r\n尺寸：360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm\r\n重量：2.5 kg\r\n變壓器：280W\r\n電池：57Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n', 'Intel Core i7-12700H 14核心/20緒 2.3 GHz 超頻 4.7 GHz / 24M Cache', 'NVIDIA® GeForce RTX™ 4060 8G-GDDR6 MGP 140W滿血版(支援獨顯直連)', '16GB DDR5-4800 / 共2個插槽，已經使用1個，最高支援32G', 'Windows 11 家用版', '15.6吋 165Hz 1920X1080 FHD/IPS/霧面/LED背光', '57Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm', '2.5 kg'),
(5, 0, '基本款', '185606', 40900, 100, 1, '2023-08-25 10:40:02', '2023-08-25 10:40:02', '商品規格\r\n處理器：Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache\r\n顯示卡：intel Iris Xe Graphics\r\n記憶體：16GB LPDDR5 Onboaed / 記憶體無法擴充\r\nSSD硬碟：512G M.2 PCIe SSD / 共2個插槽，已使用1個\r\n傳統硬碟：不可擴充\r\n螢幕：16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits\r\n光碟機： NO\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer Wireless Wi-Fi 6E 1675i 2.4 GHz/5 GHz/6 GHz三頻段 802.11 a/b/g/n/ac/ax 2x2 MU-MIMO+Bluetooth 5.1\r\n視訊鏡頭：QHD (2560 x 1440) with Temporal Noise Reduction(TNR)\r\n其他規格：\r\n1x HDMI 2.1\r\n2x TypeC (USB4®40Gbps)(Thunderbolt 4)(DC-in 20 V; 100 W)支援影像傳輸\r\n2x USB Type-A(USB 3.2 Gen 1)\r\n1x COMBO audio jack\r\n1x Card Reader(microSD Card reader)\r\n1x 指紋辨識\r\n尺寸：356 (W) x 242.6 (D) x 14.9 (H) mm\r\n重量：1.6 kg\r\n變壓器：100W Type-C\r\n電池：65Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache', 'intel Iris Xe Graphics', '16GB LPDDR5 Onboaed / 記憶體無法擴充', 'Windows 11 家用版', '16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits', '65Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '356 (W) x 242.6 (D) x 14.9 (H) mm', '1.6 kg'),
(5, 1, '黑色款', '185606', 40900, 100, 1, '2023-08-25 10:40:02', '2023-08-25 10:40:02', '商品規格\r\n處理器：Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache\r\n顯示卡：intel Iris Xe Graphics\r\n記憶體：16GB LPDDR5 Onboaed / 記憶體無法擴充\r\nSSD硬碟：512G M.2 PCIe SSD / 共2個插槽，已使用1個\r\n傳統硬碟：不可擴充\r\n螢幕：16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits\r\n光碟機： NO\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer Wireless Wi-Fi 6E 1675i 2.4 GHz/5 GHz/6 GHz三頻段 802.11 a/b/g/n/ac/ax 2x2 MU-MIMO+Bluetooth 5.1\r\n視訊鏡頭：QHD (2560 x 1440) with Temporal Noise Reduction(TNR)\r\n其他規格：\r\n1x HDMI 2.1\r\n2x TypeC (USB4®40Gbps)(Thunderbolt 4)(DC-in 20 V; 100 W)支援影像傳輸\r\n2x USB Type-A(USB 3.2 Gen 1)\r\n1x COMBO audio jack\r\n1x Card Reader(microSD Card reader)\r\n1x 指紋辨識\r\n尺寸：356 (W) x 242.6 (D) x 14.9 (H) mm\r\n重量：1.6 kg\r\n變壓器：100W Type-C\r\n電池：65Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache', 'intel Iris Xe Graphics', '16GB LPDDR5 Onboaed / 記憶體無法擴充', 'Windows 11 家用版', '16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits', '65Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '356 (W) x 242.6 (D) x 14.9 (H) mm', '1.6 kg'),
(6, 0, '基本款', '171303', 34900, 1000, 1, '2023-08-25 10:40:02', '2023-08-25 10:40:02', '商品規格\r\n處理器：Intel Core i5-1135G7 4核心/8緒 2.4GHz 超頻 4.2GHz / 8M Cache\r\n顯示卡：Intel® Iris® Xe Graphics\r\n記憶體：16G LPDDR4X Onboard\r\nSSD硬碟：512G M.2 PCIe SSD\r\n傳統硬碟：無法擴充\r\n螢幕：14吋 FHD IPS 觸控康寧玻璃螢幕\r\n光碟機： NO\r\n作業系統：Windows 11 家用版\r\n無線規格：WiFi-6、藍芽5.0\r\n其他規格：\r\n1 X HDMI\r\n1 X USB3.1 TypeC1 (USB 3.2 Gen 1)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)\r\n2 X USB3.0\r\n1 X HD像素網路攝影機\r\n1 X COMBO audio jack\r\n指紋辨識\r\n尺寸：318 (W) x 206 (D) x 14.9/14.9 (H) mm\r\n重量：1.05 Kg\r\n變壓器：65W\r\n電池：56Wh(4-cell)\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-1135G7 4核心/8緒 2.4GHz 超頻 4.2GHz / 8M Cache', 'intel Iris Xe Graphics', '16G LPDDR4X Onboard', 'Windows 11 家用版', '14吋 FHD IPS 觸控康寧玻璃螢幕', '56Wh(4-cell)', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '318 (W) x 206 (D) x 14.9/14.9 (H) mm', '1.05 Kg'),
(7, 0, '基本款', '185611', 116900, 1000, 1, '2023-08-25 11:40:02', '2023-08-25 11:40:02', '商品規格\r\n處理器：Intel® Core™ i9-13900HX 核心處理器 5.4 GHz (36MB Cache, up to 5.4 GHz, 8 P-cores and 16 E- cores)\r\n顯示卡：NVIDIA® GeForce RTX™ 4080 12G-GDDR6 MGP 165W滿血版 (支援獨顯直連、動態顯示切換、G-sync)\r\n記憶體：32GB DDR5-5600MHz/ 共2個插槽，已經使用2個，最高支援32G\r\nSSD硬碟：1T+1T PCIe NVMe SED SSD/ 共2個插槽，已經使用2個\r\n傳統硬碟： 無\r\n螢幕：16\" WQXGA 2560 x 1600/16:10/IPS/165Hz/霧面/LED背光/DCI-P3 100%/500 nits\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i 2.4 GHz/5 GHz 雙頻段 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth® 5.1\r\n攝影機：FHD (1920 x 1080) with Temporal Noise Reduction(TNR)\r\nI/O 介面：\r\n2x (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)\r\n2x USB 3.2 Gen 2\r\n1x USB 3.2 Gen 1\r\n1x HDMI 2.1\r\n1x microSD Card reader\r\n1x Microphone-in/Headphone-out jack\r\n尺寸：405 (W) x 311.61 (D) x 26.9/28.9 (H) mm\r\n重量：3.16 kg\r\n變壓器：330 W\r\n電池：90Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel® Core™ i9-13900HX 核心處理器 5.4 GHz (36MB Cache, up to 5.4 GHz, 8 P-cores and 16 E- cores)', 'NVIDIA® GeForce RTX™ 4080 12G-GDDR6 MGP 165W滿血版 (支援獨顯直連、動態顯示切換、G-sync)', '32GB DDR5-5600MHz/ 共2個插槽，已經使用2個，最高支援32G', 'Windows 11 家用版', '16\" WQXGA 2560 x 1600/16:10/IPS/165Hz/霧面/LED背光/DCI-P3 100%/500 nits', '90Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '405 (W) x 311.61 (D) x 26.9/28.9 (H) mm', '3.16 kg'),
(8, 0, '基本款', '190351', 34999, 1000, 1, '2023-08-25 12:42:21', '2023-08-25 12:42:21', '商品規格\r\n處理器：AMD Ryzen™ 7 7735H (8-core/16-thread, 16MB L3 cache, up to 4.7 GHz max boost)\r\n顯示卡：\'NVIDIA® GeForce RTX™ 4050 6GB GDDR6(具備MUX獨顯直連)\r\n2420MHz* at 140W (2370MHz Boost Clock+50MHz OC, 115W+25W Dynamic Boost)\r\n記憶體：8GB DDR5-4800 / 共2個插槽，已經使用1個，最大支援32G\r\nSSD硬碟：512GB PCIe® 4.0 NVMe™ M.2 SSD / 共2個插槽，已使用1個\r\n傳統硬碟：無法擴充\r\n螢幕：15.6 \"(薄邊框)/FHD (1920 x 1080) 16:9/144Hz/IPS-level/Anti-glare/NTSC 72%/SRGB 100%/G-Sync\r\n光碟機： 無\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6(802.11ax) (Dual band) 2*2 + Bluetooth® 5.2\r\n鍵盤：Backlit Chiclet Keyboard 1-Zone RGB\r\n網路攝影機：720P HD camera\r\nIO PORT :\r\n1x RJ45 LAN port\r\n1x Type C USB 4 support DisplayPort™ / G-SYNC\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™ / power delivery / G-SYNC\r\n2x USB 3.2 Gen 1 Type-A\r\n1x HDMI 2.1 FRL\r\n1x 3.5mm Combo Audio Jack\r\n尺寸：35.4 x 25.1 x 2.24 ~ 2.49 cm\r\n重量：2.20 Kg\r\n電池：90WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 240W AC Adapter, Output: 20V DC, 12A, 240W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'AMD Ryzen™ 7 7735H (8-core/16-thread, 16MB L3 cache, up to 4.7 GHz max boost)', 'NVIDIA® GeForce RTX™ 4050 6GB GDDR6(具備MUX獨顯直連)\r\n2420MHz* at 140W (2370MHz Boost Clock+50MHz OC, 115W+25W Dynamic Boost)', '512GB PCIe® 4.0 NVMe™ M.2 SSD / 共2個插槽，已使用1個', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '15.6 \"(薄邊框)/FHD (1920 x 1080) 16:9/144Hz/IPS-level/Anti-glare/NTSC 72%/SRGB 100%/G-Sync', '90WHrs, 4S1P, 4-cell Li-ion', '二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年', '35.4 x 25.1 x 2.24 ~ 2.49 cm', '2.20 Kg'),
(9, 0, '基本款', '190102', 30900, 1000, 1, '2023-08-25 12:42:21', '2023-08-25 12:42:21', '商品規格\r\n處理器：Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache\r\n顯示卡：Intel Iris Xᵉ Graphics\r\n記憶體：16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G\r\nSSD硬碟：512GB M.2 NVMe™ PCIe® 3.0 SSD / 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio\r\n光碟機：NO\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6 (802.11ax)+Bluetooth 5.0 (Dual band) 2*2\r\n網路攝影機：720p HD 攝影機, 含防窺鏡頭蓋\r\nIO 介面：\r\n1x HDMI 1.4\r\n1x 3.5mm Combo Audio Jack\r\n1x DC-in\r\n1x USB 2.0 Type-A\r\n1x USB 3.2 Gen 1 Type-C\r\n2x USB 3.2 Gen 1 Type-A\r\n尺寸：35.87 x 24.95 x 1.99 ~ 1.99 cm\r\n重量：1.88kg\r\n電池：42WHrs\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n備註：此機型沒有附贈包包、滑鼠', 'Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache', 'Intel Iris Xᵉ Graphics', '16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio', '42WHrs', '二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年', '35.87 x 24.95 x 1.99 ~ 1.99 cm', '1.88kg'),
(9, 1, '銀灰款', '190102', 30900, 1000, 1, '2023-08-25 12:48:21', '2023-08-25 12:48:21', '商品規格\r\n處理器：Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache\r\n顯示卡：Intel Iris Xᵉ Graphics\r\n記憶體：16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G\r\nSSD硬碟：512GB M.2 NVMe™ PCIe® 3.0 SSD / 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio\r\n光碟機：NO\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6 (802.11ax)+Bluetooth 5.0 (Dual band) 2*2\r\n網路攝影機：720p HD 攝影機, 含防窺鏡頭蓋\r\nIO 介面：\r\n1x HDMI 1.4\r\n1x 3.5mm Combo Audio Jack\r\n1x DC-in\r\n1x USB 2.0 Type-A\r\n1x USB 3.2 Gen 1 Type-C\r\n2x USB 3.2 Gen 1 Type-A\r\n尺寸：35.87 x 24.95 x 1.99 ~ 1.99 cm\r\n重量：1.88kg\r\n電池：42WHrs\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n備註：此機型沒有附贈包包、滑鼠', 'Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache', 'Intel Iris Xᵉ Graphics', '16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio', '42WHrs', '二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年', '35.87 x 24.95 x 1.99 ~ 1.99 cm', '1.88kg'),
(9, 2, '炫彩款', '190102', 31900, 1000, 1, '2023-08-25 12:48:21', '2023-08-25 12:48:21', '商品規格\r\n處理器：Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache\r\n顯示卡：Intel Iris Xᵉ Graphics\r\n記憶體：16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G\r\nSSD硬碟：512GB M.2 NVMe™ PCIe® 3.0 SSD / 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio\r\n光碟機：NO\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6 (802.11ax)+Bluetooth 5.0 (Dual band) 2*2\r\n網路攝影機：720p HD 攝影機, 含防窺鏡頭蓋\r\nIO 介面：\r\n1x HDMI 1.4\r\n1x 3.5mm Combo Audio Jack\r\n1x DC-in\r\n1x USB 2.0 Type-A\r\n1x USB 3.2 Gen 1 Type-C\r\n2x USB 3.2 Gen 1 Type-A\r\n尺寸：35.87 x 24.95 x 1.99 ~ 1.99 cm\r\n重量：1.88kg\r\n電池：42WHrs\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n備註：此機型沒有附贈包包、滑鼠', 'Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache', 'Intel Iris Xᵉ Graphics', '16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio', '42WHrs', '二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年', '35.87 x 24.95 x 1.99 ~ 1.99 cm', '1.88kg'),
(10, 0, '基本款', '187733', 84900, 1500, 1, '2023-08-25 12:54:40', '2023-08-25 12:54:40', '商品規格\r\n處理器：Intel® Core™ i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4070 Laptop GPU 8GB GDDR6\r\n顯示卡功耗：35-115 W\r\n記憶體：32GB(16GB*2) DDR5-4800 / 共2個插槽，已使用2個，最高支援48GB\r\nSSD硬碟：1TB M.2 NVMe™ PCIe / 共1個插槽，已使用1個\r\n傳統硬碟：No\r\n螢幕尺寸：14.5 吋, 2.8K (2880 x 1800) OLED 16:10 , 德國萊因 (TÜV Rheinland) 低藍光護眼認證, SGS 認證護眼螢幕, 螢幕佔比 90%\r\n作業系統：Windows 11 Home\r\n光碟機：無,請另購外接式光碟機\r\n網路規格：Wi-Fi 6E(802.11ax) (雙頻) 2*2\r\n藍芽規格：Bluetooth 5\r\n視訊鏡頭：FHD 攝影機加紅外線功能，支援 Windows Hello 含防窺鏡頭蓋\r\n鍵盤規格：背光巧克力鍵盤, 1.4mm 鍵程\r\n指紋辨識：No / Yes\r\nNFC :\r\n喇叭/音效技術：智慧放大技術, 內建喇叭, 內建陣列麥克風, harman/kardon (進階), 支援 Cortana 語音辨識\r\nI/O規格：\r\n1x USB 3.2 Gen 2 Type-A\r\n1x USB 3.2 Gen 2 Type-C 支援顯示/供電\r\n1x Thunderbolt™ 4 支援顯示/供電\r\n1x HDMI 2.1 FRL\r\n1x 3.5mm 複合式音源線插孔\r\n1 x DC 輸入\r\nSD 4.0 讀卡機r\r\n尺寸：32.18 x 22.33 x 1.79 ~ 1.79 cm\r\n重量：1.60 kg (3.53 lbs)\r\n變壓器：ø6.0, 200W AC Adapter, Output: 20V DC, 10A, 200W, Input: 100~240V AC 50/60Hz universal\r\n電池：76WHrs，4S1P，4 芯鋰離子\r\n保固：二年台灣地區保固/一年國際旅約保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel® Core™ i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache', 'NVIDIA® GeForce RTX™ 4070 Laptop GPU 8GB GDDR6', '32GB(16GB*2) DDR5-4800 / 共2個插槽，已使用2個，最高支援48GB', 'Windows 11 Home', '4.5 吋, 2.8K (2880 x 1800) OLED 16:10 , 德國萊因 (TÜV Rheinland) 低藍光護眼認證, SGS 認證護眼螢幕, 螢幕佔比 90%', '76WHrs，4S1P，4 芯鋰離子', '二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年', '32.18 x 22.33 x 1.79 ~ 1.79 cm', '1.60 kg'),
(11, 0, '基本款', '186517', 65999, 1280, 1, '2023-08-25 13:00:33', '2023-08-25 13:00:33', '商品規格\r\n處理器：AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)\r\n顯示卡：NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)\r\n記憶體：16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G\r\n硬碟：1TB PCIe® 4.0 NVMe™ M.2 SSD / 總共2個插槽，已經使用1個\r\n螢幕：14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth® 5.2\r\nI/O:\r\n1x Type C USB 4 support DisplayPort™ / power delivery\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™\r\n2x USB 3.2 Gen 2 Type-A\r\n1x card reader (microSD) (UHS-II)\r\n1x HDMI 2.1 FRL\r\n尺寸：31.2 x 22.7 x 1.95 ~ 2.05 cm\r\n重量：1.72 Kg\r\n電池：76WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 240W AC Adapter, Output: 20V DC, 12A, 240W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)', 'NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)', '16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n', '76WHrs, 4S1P, 4-cell Li-ion', '二年國際保固 / LCD無亮點保固 / 電池保固一年', '31.2 x 22.7 x 1.95 ~ 2.05 cm', '1.72 Kg'),
(11, 1, '限量聯名款', '186517', 69999, 500, 1, '2023-08-25 13:00:33', '2023-08-25 13:00:33', '商品規格\r\n處理器：AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)\r\n顯示卡：NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)\r\n記憶體：16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G\r\n硬碟：1TB PCIe® 4.0 NVMe™ M.2 SSD / 總共2個插槽，已經使用1個\r\n螢幕：14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth® 5.2\r\nI/O:\r\n1x Type C USB 4 support DisplayPort™ / power delivery\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™\r\n2x USB 3.2 Gen 2 Type-A\r\n1x card reader (microSD) (UHS-II)\r\n1x HDMI 2.1 FRL\r\n尺寸：31.2 x 22.7 x 1.95 ~ 2.05 cm\r\n重量：1.72 Kg\r\n電池：76WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 240W AC Adapter, Output: 20V DC, 12A, 240W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)', 'NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)', '16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n', '76WHrs, 4S1P, 4-cell Li-ion', '二年國際保固 / LCD無亮點保固 / 電池保固一年', '31.2 x 22.7 x 1.95 ~ 2.05 cm', '1.72 Kg'),
(12, 0, '基本款', '185722', 99999, 999, 1, '2023-08-25 13:05:42', '2023-08-25 13:05:42', '商品規格\r\n處理器：AMD Ryzen™ 9 7945HX (16-core/32-thread, 64MB L3 cache, up to 5.4 GHz max boost)\r\n顯示卡：NVIDIA® GeForce RTX™ 4080 12GB GDDR6(具備MUX獨顯直連)\r\nROG Boost: 2330MHz* at 175W (2280MHz Boost Clock+50MHz OC, 150W+25W Dynamic Boost)\r\n記憶體：32GB DDR5-4800 / 共2個插槽，已使用2個，最高支援64G\r\n硬碟：1TB PCIe® 4.0 NVMe™ M.2 Performance SSD / 共2個插槽，已使用1個\r\n螢幕：17.3 \"(薄邊框)/WQHD (2560 x 1440) 16:9/240Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Dolby Vision/G-Sync\r\n光碟機： 無\r\n作業系統：Windows11 64Bits\r\n鍵盤：Backlit Chiclet Keyboard Per-Key RGB\r\n無線規格：Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth® 5.2\r\n視訊鏡頭：720P HD camera\r\nI/O：\r\n1x 2.5G LAN port\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™ / G-SYNC\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™ / power delivery / G-SYNC\r\n2x USB 3.2 Gen 1 Type-A\r\n1x HDMI 2.1 FRL\r\n1x 3.5mm Combo Audio Jack\r\n尺寸：39.5 x 28.2 x 2.34 ~ 2.83 cm\r\n重量：3.0Kg\r\n電池：90WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 330W AC Adapter, Output: 20V DC, 16.5A, 330W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'AMD Ryzen™ 9 7945HX (16-core/32-thread, 64MB L3 cache, up to 5.4 GHz max boost)', 'NVIDIA® GeForce RTX™ 4080 12GB GDDR6(具備MUX獨顯直連)\r\nROG Boost: 2330MHz* at 175W (2280MHz Boost Clock+50MHz OC, 150W+25W Dynamic Boost)', '32GB DDR5-4800 / 共2個插槽，已使用2個，最高支援64G', 'Windows11 64Bits', '17.3 \"(薄邊框)/WQHD (2560 x 1440) 16:9/240Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Dolby Vision/G-Sync', '90WHrs, 4S1P, 4-cell Li-ion', '二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年', '39.5 x 28.2 x 2.34 ~ 2.83 cm', '3.0Kg'),
(13, 0, '灰', '187307', 52900, 500, 1, '2023-08-25 13:14:02', '2023-08-25 13:14:02', '商品規格\r\n處理器：Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 6000MHz OnBoard / 不可擴充\r\n硬碟：512G NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 6000MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g'),
(13, 1, '黑', '187307', 52900, 500, 1, '2023-08-25 13:14:02', '2023-08-25 13:14:02', '商品規格\r\n處理器：Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 6000MHz OnBoard / 不可擴充\r\n硬碟：512G NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 6000MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g'),
(13, 2, '白', '187307', 52900, 500, 1, '2023-08-25 13:14:02', '2023-08-25 13:14:02', '商品規格\r\n處理器：Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 6000MHz OnBoard / 不可擴充\r\n硬碟：512G NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 6000MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g'),
(14, 0, '曜石黑', '185202', 52900, 0, 1, '2023-08-25 13:28:02', '2023-08-25 13:28:02', '商品規格\r\n處理器：Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 5200MHz OnBoard / 不可擴充\r\n硬碟：1TB NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 5200MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g'),
(14, 1, '沉靜灰', '185202', 52900, 500, 1, '2023-08-25 13:28:50', '2023-08-25 13:28:50', '商品規格\r\n處理器：Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 5200MHz OnBoard / 不可擴充\r\n硬碟：1TB NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 5200MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g'),
(15, 0, '基本款', '190165', 95900, 720, 1, '2023-08-25 13:41:28', '2023-08-25 13:41:28', '商品規格\r\n處理器：Intel Core i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache\r\n顯示卡：NVIDIA GeForce RTX 4070 Laptop GPU 8GB GDDR6\r\n記憶體：32GB(16G*2) DDR5-5200 / 共2個插槽，已使用2個插槽，最高支援64G\r\n固態硬碟：2TB NVMe PCIe Gen4 / 共2個插槽，已使用1個插槽\r\n傳統硬碟：無\r\n螢幕：16\" UHD+(3840x2400), OLED, VESA DisplayHDR™ 600 Certified, 100% DCI-P3(Typical)\r\n光碟機：無，需另購外接式光碟機\r\n作業系統：Windows 11 Pro\r\n無線規格：Intel® Killer™ Wi-Fi 6E AX1675, Bluetooth v5.3\r\n鍵盤規格：SteelSeries單鍵RGB全彩背光電競鍵盤\r\n視訊鏡頭：IR FHD type (30fps@1080p)\r\n其他規格：\r\n1x Type-C (USB3.2 Gen2 / DP)\r\n1x Type-C (USB / DP / Thunderbolt™ 4) with PD charging\r\n1x Type-A USB3.2 Gen2\r\n1x Micro SD Card Reader\r\n1x HDMI™ 2.1 (8K @ 60Hz / 4K @ 120Hz)\r\n1x RJ45\r\n1x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.8 x 259.7 x 19.95 mm\r\n重量：1.88 kg\r\n變壓器：240W\r\n電池：4-Cell 99.9 Battery (Whr)\r\n保固：二年台灣地區保固/一年國際旅約保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache', 'NVIDIA GeForce RTX 4070 Laptop GPU 8GB GDDR6', '32GB(16G*2) DDR5-5200 / 共2個插槽，已使用2個插槽，最高支援64G', 'Windows 11 Pro', '16\" UHD+(3840x2400), OLED, VESA DisplayHDR™ 600 Certified, 100% DCI-P3(Typical)', '80Wh', '二年台灣地區保固/一年國際旅約保固/電池保固一年', '355.8 x 259.7 x 19.95 mm', '1.88 kg'),
(16, 0, '基本款', '190125', 30900, 600, 1, '2023-08-25 13:48:04', '2023-08-25 13:48:04', '商品規格\r\n處理器：AMD Ryzen7 7730U 8核心/16緒 2.0GHz超頻4.5GHz/ L2快取 4MB+L3快取 16MB\r\n顯示卡：AMD Radeon™ Graphics\r\n記憶體：16GB*1 DDR4-3200 onboard\r\nSSD硬碟： 512GB NVMe PCIe SSD / 共1個插槽，已使用1個\r\n螢幕尺寸：15.6\" FHD (1920x1080), IPS-Level\r\n作業系統：Windows 11 Home\r\n光碟機：無,請另購外接式光碟機\r\n網路規格：AMD RZ608 Wi-Fi 6E\r\n藍芽規格：Bluetooth v5.2\r\n視訊鏡頭：HD type (30fps@720p)\r\n鍵盤規格：白色背光鍵盤\r\n喇叭/音效技術：\r\n2x 2W Speaker\r\n1x Mic-in/Headphone-out Combo Jack\r\nI/O規格：\r\n1x Type-C USB3.2 Gen2 with PD charging\r\n1x Type-A USB3.2 Gen2\r\n2x Type-A USB2.0\r\n1x Micro SD Card Reader\r\n1x HDMI™ 2.1 (4K @ 60Hz)\r\n尺寸：359 x 241 x 19.9 mm\r\n重量：1.75 kg\r\n變壓器：65W adapter\r\n電池：3-Cell 39.3 / 53.8 Battery (Whr)\r\n保固：2年保固 台灣地區2年到府收送 免費客服電話0800-018880', 'AMD Ryzen7 7730U 8核心/16緒 2.0GHz超頻4.5GHz/ L2快取 4MB+L3快取 16MB', 'AMD Radeon™ Graphics', '16GB*1 DDR4-3200 onboard', 'Windows 11 Home', '15.6\" FHD (1920x1080), IPS-Level', '3-Cell 39.3 / 53.8 Battery (Whr)', '2年保固 台灣地區2年到府收送 免費客服電話0800-018880', '359 x 241 x 19.9 mm', '1.75 kg'),
(17, 0, '基本款', '189900', 58900, 450, 1, '2023-08-25 13:56:41', '2023-08-25 13:56:41', '商品規格\r\n處理器：Intel® Core™i7-13620H , 10核心 / 16緒 1.5GHz 超頻4.9GHz / 24M Cache\r\n顯示卡：GeForce RTX™ 4050 筆記型電腦GPU 6GB GDDR6\r\n記憶體：16GB(8G*2) DDR5-5200 / 共2個插槽，已經使用2個，最高64GB\r\nSSD硬碟：512GB M.2 SSD (NVMe PCIe)/ 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：14” FHD+ (1920x1200), 165Hz, IPS-Level\r\n作業系統：Windows 11 Pro\r\n光碟機：無,請另購外接式光碟機\r\n網路規格：Intel® Killer™ AX Wi-Fi 6E\r\n藍芽規格：Bluetooth v5.3\r\n視訊鏡頭：IR HD type (30fps@720p)\r\n鍵盤規格：Per-Key RGB Keyboard\r\n喇叭/音效技術：\r\n2x 2W Woofer\r\n2x 2W Speaker\r\n1x Mic-in/Headphone-out Combo Jack\r\nIO 介面：\r\n1x Type-C (USB / DP / Thunderbolt™ 4)\r\n1x Type-C (USB3.2 Gen2 / DP) with PD charging\r\n1x Type-A USB3.2 Gen2\r\n1x HDMI™ 2.1 (8K @ 60Hz / 4K @ 120Hz)\"\r\n尺寸：315 x 246 x 19 mm\r\n重量：1.7 kg\r\n變壓器：240W adapter\r\n電池：4-Cell 72 Battery (Whr)\r\n保固：2年保固台灣地區2年到府收送 免費客服電話0800-018880\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel® Core™i7-13620H , 10核心 / 16緒 1.5GHz 超頻4.9GHz / 24M Cache', 'GeForce RTX™ 4050 筆記型電腦GPU 6GB GDDR6', '16GB(8G*2) DDR5-5200 / 共2個插槽，已經使用2個，最高64GB', 'Windows 11 Pro', '14” FHD+ (1920x1200), 165Hz, IPS-Level', '4-Cell 72 Battery (Whr)', '2年保固台灣地區2年到府收送 免費客服電話0800-018880', '315 x 246 x 19 mm', '1.7 kg'),
(69, 10, '', '', 111, 1, 0, '2023-09-14 16:16:20', '2023-09-14 16:16:20', NULL, '', '', '', '', '', '', '', '', ''),
(70, 10, '', '', 111, 111, 0, '2023-09-14 16:17:48', '2023-09-14 16:17:48', NULL, '', '', '', '', '', '', '', '', ''),
(71, 10, 'Pro Model', 'aaaaaaaaaaa', 14444, 13, 1, '2023-09-15 02:25:41', '2023-09-15 02:25:41', NULL, 'Intel Core i5-12500H', 'NVIDIA® GeForce RTX™ 4050 6G', '16GB DDR4', 'Windows 11 家用版', '15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光', '5000mAh', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm', '2.5 kg'),
(72, 10, 'Pro Model', '大量的描述內容大量的描述內容大量的描述內容大量的描述內容大量的描述內容大量的描述內容', 69999, 50, 0, '2023-09-15 10:26:06', '2023-09-15 10:26:06', NULL, 'Intel Core i5-12500H', 'NVIDIA® GeForce RTX™ 4050 6G', '116GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G', 'Windows 11 家用版', '15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光', '57Wh Li-ion battery', '', '360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm', '2.5 kg');

-- --------------------------------------------------------

--
-- 資料表結構 `sellspec1`
--

CREATE TABLE `sellspec1` (
  `id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL,
  `spec_name` varchar(21) NOT NULL,
  `contnet` varchar(500) DEFAULT NULL,
  `price` int(11) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT '0',
  `publish` int(11) NOT NULL DEFAULT '0' COMMENT '不公開 0\r\n公開 1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
  `img_src` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `sellspec1`
--

INSERT INTO `sellspec1` (`id`, `prod_id`, `spec_id`, `spec_name`, `contnet`, `price`, `stock`, `publish`, `create_time`, `update_time`, `info_content`, `cpu`, `gpu`, `ram`, `os`, `screen`, `battery`, `warranty`, `size`, `weight`, `img_src`) VALUES
(1, 1, 0, '基本款', '189823', 40900, 1000, 1, '2023-08-25 09:38:59', '2023-08-25 09:38:59', '商品規格\r\n處理器：Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)\r\n記憶體：16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\nSSD硬碟：512GB NVMe PCIe Gen4 SSD / 共2個插槽，已經使用1個\r\n傳統硬碟：無，有一個2.5吋硬碟空間可以擴充\r\n螢幕：15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i Dual Band(2.4 GHz/5 GHz) 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth 5.1\r\n攝影機：HD (1280 x 720)with Temporal Noise Reduction(TNR)Dual Mic\r\nI/O 介面：\r\n1 x Type-C (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)支援影像傳輸\r\n3 x TypeA USB 3.2\r\n1 x HDMI 2.1\r\n1 x Microphone-in/Headphone-out jack\r\n1 x RJ45 (Killer Ethernet E2600)\r\n尺寸：360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm\r\n重量：2.5 kg\r\n變壓器：230W\r\n電池：57Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache', 'NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)', '16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\n', 'Windows 11 家用版', '15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光', '57Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm', '2.5 kg', '/images/products/189823.jpg'),
(2, 1, 1, '紅色款', '189823', 40900, 1500, 1, '2023-08-25 09:38:59', '2023-08-25 09:38:59', '商品規格\r\n處理器：Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)\r\n記憶體：16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\nSSD硬碟：512GB NVMe PCIe Gen4 SSD / 共2個插槽，已經使用1個\r\n傳統硬碟：無，有一個2.5吋硬碟空間可以擴充\r\n螢幕：15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i Dual Band(2.4 GHz/5 GHz) 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth 5.1\r\n攝影機：HD (1280 x 720)with Temporal Noise Reduction(TNR)Dual Mic\r\nI/O 介面：\r\n1 x Type-C (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)支援影像傳輸\r\n3 x TypeA USB 3.2\r\n1 x HDMI 2.1\r\n1 x Microphone-in/Headphone-out jack\r\n1 x RJ45 (Killer Ethernet E2600)\r\n尺寸：360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm\r\n重量：2.5 kg\r\n變壓器：230W\r\n電池：57Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-12500H 12核心/16緒 3.3GHz 超頻 4.50GHz / 18M Cache', 'NVIDIA® GeForce RTX™ 4050 6G-GDDR6 MGP 140W滿血版(支援獨顯直連)', '16GB(8G*2) DDR5-4800 / 共2個插槽，已經使用2個，最高支援32G\r\n', 'Windows 11 家用版.', '15.6吋 144Hz 1920X1080 FHD/IPS/霧面/LED背光', '57Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm', '2.5 kg', '/images/products/189823.jpg'),
(3, 4, 0, '基本款', '186420', 52900, 1000, 0, '2023-08-25 10:33:34', '2023-08-25 10:33:34', '商品規格\r\n處理器：Intel Core i7-12700H 14核心/20緒 2.3 GHz 超頻 4.7 GHz / 24M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4060 8G-GDDR6 MGP 140W滿血版(支援獨顯直連)\r\n記憶體：16GB DDR5-4800 / 共2個插槽，已經使用1個，最高支援32G\r\nSSD硬碟：512GB NVMe PCIe Gen4 SSD / 共2個插槽，已經使用1個\r\n傳統硬碟：無，有一個2.5吋硬碟空間可以擴充\r\n螢幕：15.6吋 165Hz 1920X1080 FHD/IPS/霧面/LED背光\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i Dual Band(2.4 GHz/5 GHz) 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth 5.1\r\n攝影機：HD (1280 x 720)with Temporal Noise Reduction(TNR)Dual Mic\r\nI/O 介面：\r\n1 x Type-C (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)支援影像傳輸\r\n3 x TypeA USB 3.2\r\n1 x HDMI 2.1\r\n1 x Microphone-in/Headphone-out jack\r\n1 x RJ45 (Killer Ethernet E2600)\r\n尺寸：360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm\r\n重量：2.5 kg\r\n變壓器：280W\r\n電池：57Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n', 'Intel Core i7-12700H 14核心/20緒 2.3 GHz 超頻 4.7 GHz / 24M Cache', 'NVIDIA® GeForce RTX™ 4060 8G-GDDR6 MGP 140W滿血版(支援獨顯直連)', '16GB DDR5-4800 / 共2個插槽，已經使用1個，最高支援32G', 'Windows 11 家用版', '15.6吋 165Hz 1920X1080 FHD/IPS/霧面/LED背光', '57Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '360.4 (W) x 271.09 (D) x 25.9/26.9 (H) mm', '2.5 kg', '/images/products/186420.jpg'),
(4, 5, 0, '基本款', '185606', 40900, 100, 1, '2023-08-25 10:40:02', '2023-08-25 10:40:02', '商品規格\r\n處理器：Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache\r\n顯示卡：intel Iris Xe Graphics\r\n記憶體：16GB LPDDR5 Onboaed / 記憶體無法擴充\r\nSSD硬碟：512G M.2 PCIe SSD / 共2個插槽，已使用1個\r\n傳統硬碟：不可擴充\r\n螢幕：16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits\r\n光碟機： NO\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer Wireless Wi-Fi 6E 1675i 2.4 GHz/5 GHz/6 GHz三頻段 802.11 a/b/g/n/ac/ax 2x2 MU-MIMO+Bluetooth 5.1\r\n視訊鏡頭：QHD (2560 x 1440) with Temporal Noise Reduction(TNR)\r\n其他規格：\r\n1x HDMI 2.1\r\n2x TypeC (USB4®40Gbps)(Thunderbolt 4)(DC-in 20 V; 100 W)支援影像傳輸\r\n2x USB Type-A(USB 3.2 Gen 1)\r\n1x COMBO audio jack\r\n1x Card Reader(microSD Card reader)\r\n1x 指紋辨識\r\n尺寸：356 (W) x 242.6 (D) x 14.9 (H) mm\r\n重量：1.6 kg\r\n變壓器：100W Type-C\r\n電池：65Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache', 'intel Iris Xe Graphics', '16GB LPDDR5 Onboaed / 記憶體無法擴充', 'Windows 11 家用版', '16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits', '65Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '356 (W) x 242.6 (D) x 14.9 (H) mm', '1.6 kg', '/images/products/185606.jpg'),
(5, 5, 1, '黑色款', '185606', 40900, 100, 1, '2023-08-25 10:40:02', '2023-08-25 10:40:02', '商品規格\r\n處理器：Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache\r\n顯示卡：intel Iris Xe Graphics\r\n記憶體：16GB LPDDR5 Onboaed / 記憶體無法擴充\r\nSSD硬碟：512G M.2 PCIe SSD / 共2個插槽，已使用1個\r\n傳統硬碟：不可擴充\r\n螢幕：16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits\r\n光碟機： NO\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer Wireless Wi-Fi 6E 1675i 2.4 GHz/5 GHz/6 GHz三頻段 802.11 a/b/g/n/ac/ax 2x2 MU-MIMO+Bluetooth 5.1\r\n視訊鏡頭：QHD (2560 x 1440) with Temporal Noise Reduction(TNR)\r\n其他規格：\r\n1x HDMI 2.1\r\n2x TypeC (USB4®40Gbps)(Thunderbolt 4)(DC-in 20 V; 100 W)支援影像傳輸\r\n2x USB Type-A(USB 3.2 Gen 1)\r\n1x COMBO audio jack\r\n1x Card Reader(microSD Card reader)\r\n1x 指紋辨識\r\n尺寸：356 (W) x 242.6 (D) x 14.9 (H) mm\r\n重量：1.6 kg\r\n變壓器：100W Type-C\r\n電池：65Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-13500H 12核心/16緒 2.6GHz 超頻4.7GHz / 18M Cache', 'intel Iris Xe Graphics', '16GB LPDDR5 Onboaed / 記憶體無法擴充', 'Windows 11 家用版', '16\" WQXGA+ 3200x2000/OLED/16:10/120Hz/鏡面/LED背光/DCI-P3 100%/400 nits', '65Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '356 (W) x 242.6 (D) x 14.9 (H) mm', '1.6 kg', '/images/products/185606.jpg'),
(6, 6, 0, '基本款', '171303', 34900, 1000, 1, '2023-08-25 10:40:02', '2023-08-25 10:40:02', '商品規格\r\n處理器：Intel Core i5-1135G7 4核心/8緒 2.4GHz 超頻 4.2GHz / 8M Cache\r\n顯示卡：Intel® Iris® Xe Graphics\r\n記憶體：16G LPDDR4X Onboard\r\nSSD硬碟：512G M.2 PCIe SSD\r\n傳統硬碟：無法擴充\r\n螢幕：14吋 FHD IPS 觸控康寧玻璃螢幕\r\n光碟機： NO\r\n作業系統：Windows 11 家用版\r\n無線規格：WiFi-6、藍芽5.0\r\n其他規格：\r\n1 X HDMI\r\n1 X USB3.1 TypeC1 (USB 3.2 Gen 1)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)\r\n2 X USB3.0\r\n1 X HD像素網路攝影機\r\n1 X COMBO audio jack\r\n指紋辨識\r\n尺寸：318 (W) x 206 (D) x 14.9/14.9 (H) mm\r\n重量：1.05 Kg\r\n變壓器：65W\r\n電池：56Wh(4-cell)\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-1135G7 4核心/8緒 2.4GHz 超頻 4.2GHz / 8M Cache', 'intel Iris Xe Graphics', '16G LPDDR4X Onboard', 'Windows 11 家用版', '14吋 FHD IPS 觸控康寧玻璃螢幕', '56Wh(4-cell)', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '318 (W) x 206 (D) x 14.9/14.9 (H) mm', '1.05 Kg', '/images/products/171303.jpg'),
(7, 7, 0, '基本款', '185611', 116900, 1000, 1, '2023-08-25 11:40:02', '2023-08-25 11:40:02', '商品規格\r\n處理器：Intel® Core™ i9-13900HX 核心處理器 5.4 GHz (36MB Cache, up to 5.4 GHz, 8 P-cores and 16 E- cores)\r\n顯示卡：NVIDIA® GeForce RTX™ 4080 12G-GDDR6 MGP 165W滿血版 (支援獨顯直連、動態顯示切換、G-sync)\r\n記憶體：32GB DDR5-5600MHz/ 共2個插槽，已經使用2個，最高支援32G\r\nSSD硬碟：1T+1T PCIe NVMe SED SSD/ 共2個插槽，已經使用2個\r\n傳統硬碟： 無\r\n螢幕：16\" WQXGA 2560 x 1600/16:10/IPS/165Hz/霧面/LED背光/DCI-P3 100%/500 nits\r\n光碟機： 無\r\n作業系統：Windows 11 家用版\r\n無線規格：Killer™ Wi-Fi 6 AX 1650i 2.4 GHz/5 GHz 雙頻段 802.11 a/b/g/n+acR2+ax 2x2 MU-MIMO\r\n藍芽規格：Bluetooth® 5.1\r\n攝影機：FHD (1920 x 1080) with Temporal Noise Reduction(TNR)\r\nI/O 介面：\r\n2x (USB 3.2 Gen 2)(DisplayPort)(Thunderbolt 4)(DC-in 20 V; 65 W)\r\n2x USB 3.2 Gen 2\r\n1x USB 3.2 Gen 1\r\n1x HDMI 2.1\r\n1x microSD Card reader\r\n1x Microphone-in/Headphone-out jack\r\n尺寸：405 (W) x 311.61 (D) x 26.9/28.9 (H) mm\r\n重量：3.16 kg\r\n變壓器：330 W\r\n電池：90Wh Li-ion battery\r\n保固：二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel® Core™ i9-13900HX 核心處理器 5.4 GHz (36MB Cache, up to 5.4 GHz, 8 P-cores and 16 E- cores)', 'NVIDIA® GeForce RTX™ 4080 12G-GDDR6 MGP 165W滿血版 (支援獨顯直連、動態顯示切換、G-sync)', '32GB DDR5-5600MHz/ 共2個插槽，已經使用2個，最高支援32G', 'Windows 11 家用版', '16\" WQXGA 2560 x 1600/16:10/IPS/165Hz/霧面/LED背光/DCI-P3 100%/500 nits', '90Wh Li-ion battery', '二年台灣地區完全保固/一年國際旅約保固/電池保固一年/第一年58分鐘快速完修', '405 (W) x 311.61 (D) x 26.9/28.9 (H) mm', '3.16 kg', '/images/products/185611.jpg'),
(8, 8, 0, '基本款', '190351', 34999, 1000, 1, '2023-08-25 12:42:21', '2023-08-25 12:42:21', '商品規格\r\n處理器：AMD Ryzen™ 7 7735H (8-core/16-thread, 16MB L3 cache, up to 4.7 GHz max boost)\r\n顯示卡：\'NVIDIA® GeForce RTX™ 4050 6GB GDDR6(具備MUX獨顯直連)\r\n2420MHz* at 140W (2370MHz Boost Clock+50MHz OC, 115W+25W Dynamic Boost)\r\n記憶體：8GB DDR5-4800 / 共2個插槽，已經使用1個，最大支援32G\r\nSSD硬碟：512GB PCIe® 4.0 NVMe™ M.2 SSD / 共2個插槽，已使用1個\r\n傳統硬碟：無法擴充\r\n螢幕：15.6 \"(薄邊框)/FHD (1920 x 1080) 16:9/144Hz/IPS-level/Anti-glare/NTSC 72%/SRGB 100%/G-Sync\r\n光碟機： 無\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6(802.11ax) (Dual band) 2*2 + Bluetooth® 5.2\r\n鍵盤：Backlit Chiclet Keyboard 1-Zone RGB\r\n網路攝影機：720P HD camera\r\nIO PORT :\r\n1x RJ45 LAN port\r\n1x Type C USB 4 support DisplayPort™ / G-SYNC\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™ / power delivery / G-SYNC\r\n2x USB 3.2 Gen 1 Type-A\r\n1x HDMI 2.1 FRL\r\n1x 3.5mm Combo Audio Jack\r\n尺寸：35.4 x 25.1 x 2.24 ~ 2.49 cm\r\n重量：2.20 Kg\r\n電池：90WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 240W AC Adapter, Output: 20V DC, 12A, 240W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'AMD Ryzen™ 7 7735H (8-core/16-thread, 16MB L3 cache, up to 4.7 GHz max boost)', 'NVIDIA® GeForce RTX™ 4050 6GB GDDR6(具備MUX獨顯直連)\r\n2420MHz* at 140W (2370MHz Boost Clock+50MHz OC, 115W+25W Dynamic Boost)', '512GB PCIe® 4.0 NVMe™ M.2 SSD / 共2個插槽，已使用1個', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '15.6 \"(薄邊框)/FHD (1920 x 1080) 16:9/144Hz/IPS-level/Anti-glare/NTSC 72%/SRGB 100%/G-Sync', '90WHrs, 4S1P, 4-cell Li-ion', '二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年', '35.4 x 25.1 x 2.24 ~ 2.49 cm', '2.20 Kg', '/images/products/190351.jpg'),
(9, 9, 0, '基本款', '190102', 30900, 1000, 1, '2023-08-25 12:42:21', '2023-08-25 12:42:21', '商品規格\r\n處理器：Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache\r\n顯示卡：Intel Iris Xᵉ Graphics\r\n記憶體：16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G\r\nSSD硬碟：512GB M.2 NVMe™ PCIe® 3.0 SSD / 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio\r\n光碟機：NO\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6 (802.11ax)+Bluetooth 5.0 (Dual band) 2*2\r\n網路攝影機：720p HD 攝影機, 含防窺鏡頭蓋\r\nIO 介面：\r\n1x HDMI 1.4\r\n1x 3.5mm Combo Audio Jack\r\n1x DC-in\r\n1x USB 2.0 Type-A\r\n1x USB 3.2 Gen 1 Type-C\r\n2x USB 3.2 Gen 1 Type-A\r\n尺寸：35.87 x 24.95 x 1.99 ~ 1.99 cm\r\n重量：1.88kg\r\n電池：42WHrs\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n備註：此機型沒有附贈包包、滑鼠', 'Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache', 'Intel Iris Xᵉ Graphics', '16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio', '42WHrs', '二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年', '35.87 x 24.95 x 1.99 ~ 1.99 cm', '1.88kg', '/images/products/190102.jpg'),
(10, 9, 1, '銀灰款', '190102', 30900, 1000, 1, '2023-08-25 12:48:21', '2023-08-25 12:48:21', '商品規格\r\n處理器：Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache\r\n顯示卡：Intel Iris Xᵉ Graphics\r\n記憶體：16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G\r\nSSD硬碟：512GB M.2 NVMe™ PCIe® 3.0 SSD / 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio\r\n光碟機：NO\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6 (802.11ax)+Bluetooth 5.0 (Dual band) 2*2\r\n網路攝影機：720p HD 攝影機, 含防窺鏡頭蓋\r\nIO 介面：\r\n1x HDMI 1.4\r\n1x 3.5mm Combo Audio Jack\r\n1x DC-in\r\n1x USB 2.0 Type-A\r\n1x USB 3.2 Gen 1 Type-C\r\n2x USB 3.2 Gen 1 Type-A\r\n尺寸：35.87 x 24.95 x 1.99 ~ 1.99 cm\r\n重量：1.88kg\r\n電池：42WHrs\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n備註：此機型沒有附贈包包、滑鼠', 'Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache', 'Intel Iris Xᵉ Graphics', '16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio', '42WHrs', '二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年', '35.87 x 24.95 x 1.99 ~ 1.99 cm', '1.88kg', '/images/products/190102.jpg'),
(11, 9, 2, '炫彩款', '190102', 31900, 1000, 1, '2023-08-25 12:48:21', '2023-08-25 12:48:21', '商品規格\r\n處理器：Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache\r\n顯示卡：Intel Iris Xᵉ Graphics\r\n記憶體：16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G\r\nSSD硬碟：512GB M.2 NVMe™ PCIe® 3.0 SSD / 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio\r\n光碟機：NO\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6 (802.11ax)+Bluetooth 5.0 (Dual band) 2*2\r\n網路攝影機：720p HD 攝影機, 含防窺鏡頭蓋\r\nIO 介面：\r\n1x HDMI 1.4\r\n1x 3.5mm Combo Audio Jack\r\n1x DC-in\r\n1x USB 2.0 Type-A\r\n1x USB 3.2 Gen 1 Type-C\r\n2x USB 3.2 Gen 1 Type-A\r\n尺寸：35.87 x 24.95 x 1.99 ~ 1.99 cm\r\n重量：1.88kg\r\n電池：42WHrs\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主\r\n備註：此機型沒有附贈包包、滑鼠', 'Intel Core i7-1255U 10核心/12緒 1.7GHz 超頻 4.7GHz / 12M Cache', 'Intel Iris Xᵉ Graphics', '16GB(8G*2) DDR4 on board / 共1個插槽，已經使用1個，最高支援16G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '16\" FHD+ (1920 x 1200) IPS 16:10 aspect ratio', '42WHrs', '二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年', '35.87 x 24.95 x 1.99 ~ 1.99 cm', '1.88kg', '/images/products/190102.jpg'),
(12, 10, 0, '基本款', '187733', 84900, 1500, 1, '2023-08-25 12:54:40', '2023-08-25 12:54:40', '商品規格\r\n處理器：Intel® Core™ i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache\r\n顯示卡：NVIDIA® GeForce RTX™ 4070 Laptop GPU 8GB GDDR6\r\n顯示卡功耗：35-115 W\r\n記憶體：32GB(16GB*2) DDR5-4800 / 共2個插槽，已使用2個，最高支援48GB\r\nSSD硬碟：1TB M.2 NVMe™ PCIe / 共1個插槽，已使用1個\r\n傳統硬碟：No\r\n螢幕尺寸：14.5 吋, 2.8K (2880 x 1800) OLED 16:10 , 德國萊因 (TÜV Rheinland) 低藍光護眼認證, SGS 認證護眼螢幕, 螢幕佔比 90%\r\n作業系統：Windows 11 Home\r\n光碟機：無,請另購外接式光碟機\r\n網路規格：Wi-Fi 6E(802.11ax) (雙頻) 2*2\r\n藍芽規格：Bluetooth 5\r\n視訊鏡頭：FHD 攝影機加紅外線功能，支援 Windows Hello 含防窺鏡頭蓋\r\n鍵盤規格：背光巧克力鍵盤, 1.4mm 鍵程\r\n指紋辨識：No / Yes\r\nNFC :\r\n喇叭/音效技術：智慧放大技術, 內建喇叭, 內建陣列麥克風, harman/kardon (進階), 支援 Cortana 語音辨識\r\nI/O規格：\r\n1x USB 3.2 Gen 2 Type-A\r\n1x USB 3.2 Gen 2 Type-C 支援顯示/供電\r\n1x Thunderbolt™ 4 支援顯示/供電\r\n1x HDMI 2.1 FRL\r\n1x 3.5mm 複合式音源線插孔\r\n1 x DC 輸入\r\nSD 4.0 讀卡機r\r\n尺寸：32.18 x 22.33 x 1.79 ~ 1.79 cm\r\n重量：1.60 kg (3.53 lbs)\r\n變壓器：ø6.0, 200W AC Adapter, Output: 20V DC, 10A, 200W, Input: 100~240V AC 50/60Hz universal\r\n電池：76WHrs，4S1P，4 芯鋰離子\r\n保固：二年台灣地區保固/一年國際旅約保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel® Core™ i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache', 'NVIDIA® GeForce RTX™ 4070 Laptop GPU 8GB GDDR6', '32GB(16GB*2) DDR5-4800 / 共2個插槽，已使用2個，最高支援48GB', 'Windows 11 Home', '4.5 吋, 2.8K (2880 x 1800) OLED 16:10 , 德國萊因 (TÜV Rheinland) 低藍光護眼認證, SGS 認證護眼螢幕, 螢幕佔比 90%', '76WHrs，4S1P，4 芯鋰離子', '二年國際保固 / 首年完美保固 / LCD無亮點保固 / 電池保固一年', '32.18 x 22.33 x 1.79 ~ 1.79 cm', '1.60 kg', '/images/products/187733.jpg'),
(13, 11, 0, '基本款', '186517', 65999, 1280, 1, '2023-08-25 13:00:33', '2023-08-25 13:00:33', '商品規格\r\n處理器：AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)\r\n顯示卡：NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)\r\n記憶體：16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G\r\n硬碟：1TB PCIe® 4.0 NVMe™ M.2 SSD / 總共2個插槽，已經使用1個\r\n螢幕：14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth® 5.2\r\nI/O:\r\n1x Type C USB 4 support DisplayPort™ / power delivery\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™\r\n2x USB 3.2 Gen 2 Type-A\r\n1x card reader (microSD) (UHS-II)\r\n1x HDMI 2.1 FRL\r\n尺寸：31.2 x 22.7 x 1.95 ~ 2.05 cm\r\n重量：1.72 Kg\r\n電池：76WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 240W AC Adapter, Output: 20V DC, 12A, 240W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)', 'NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)', '16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n', '76WHrs, 4S1P, 4-cell Li-ion', '二年國際保固 / LCD無亮點保固 / 電池保固一年', '31.2 x 22.7 x 1.95 ~ 2.05 cm', '1.72 Kg', '/images/products/186517.jpg'),
(14, 11, 1, '限量聯名款', '186517', 69999, 500, 1, '2023-08-25 13:00:33', '2023-08-25 13:00:33', '商品規格\r\n處理器：AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)\r\n顯示卡：NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)\r\n記憶體：16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G\r\n硬碟：1TB PCIe® 4.0 NVMe™ M.2 SSD / 總共2個插槽，已經使用1個\r\n螢幕：14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n作業系統：Windows11 64Bits 英/泰/簡中/印尼/越南/繁中\r\n無線規格：Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth® 5.2\r\nI/O:\r\n1x Type C USB 4 support DisplayPort™ / power delivery\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™\r\n2x USB 3.2 Gen 2 Type-A\r\n1x card reader (microSD) (UHS-II)\r\n1x HDMI 2.1 FRL\r\n尺寸：31.2 x 22.7 x 1.95 ~ 2.05 cm\r\n重量：1.72 Kg\r\n電池：76WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 240W AC Adapter, Output: 20V DC, 12A, 240W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / LCD無亮點保固 / 電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'AMD Ryzen™ 9 7940H (8-core/16-thread, 16MB L3 cache, up to 5.2 GHz max boost)', 'NVIDIA® GeForce RTX™ 4060 8GB GDDR6(具備MUX獨顯直連)\r\n2300MHz* at 125W (2250MHz Boost Clock+50MHz OC, 100W+25W Dynamic Boost)', '16GB DDR5 on board / 總共1個插槽，已經使用1個，最高支援32G', 'Windows11 64Bits 英/泰/簡中/印尼/越南/繁中', '14 \"(薄邊框)/QHD+ 16:10 (2560 x 1600, WQXGA)/165Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Pantone 認證/Dolby Vision/G-Sync\r\n', '76WHrs, 4S1P, 4-cell Li-ion', '二年國際保固 / LCD無亮點保固 / 電池保固一年', '31.2 x 22.7 x 1.95 ~ 2.05 cm', '1.72 Kg', '/images/products/186517.jpg'),
(15, 12, 0, '基本款', '185722', 99999, 999, 1, '2023-08-25 13:05:42', '2023-08-25 13:05:42', '商品規格\r\n處理器：AMD Ryzen™ 9 7945HX (16-core/32-thread, 64MB L3 cache, up to 5.4 GHz max boost)\r\n顯示卡：NVIDIA® GeForce RTX™ 4080 12GB GDDR6(具備MUX獨顯直連)\r\nROG Boost: 2330MHz* at 175W (2280MHz Boost Clock+50MHz OC, 150W+25W Dynamic Boost)\r\n記憶體：32GB DDR5-4800 / 共2個插槽，已使用2個，最高支援64G\r\n硬碟：1TB PCIe® 4.0 NVMe™ M.2 Performance SSD / 共2個插槽，已使用1個\r\n螢幕：17.3 \"(薄邊框)/WQHD (2560 x 1440) 16:9/240Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Dolby Vision/G-Sync\r\n光碟機： 無\r\n作業系統：Windows11 64Bits\r\n鍵盤：Backlit Chiclet Keyboard Per-Key RGB\r\n無線規格：Wi-Fi 6E(802.11ax) (Triple band) 2*2 + Bluetooth® 5.2\r\n視訊鏡頭：720P HD camera\r\nI/O：\r\n1x 2.5G LAN port\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™ / G-SYNC\r\n1x USB 3.2 Gen 2 Type-C support DisplayPort™ / power delivery / G-SYNC\r\n2x USB 3.2 Gen 1 Type-A\r\n1x HDMI 2.1 FRL\r\n1x 3.5mm Combo Audio Jack\r\n尺寸：39.5 x 28.2 x 2.34 ~ 2.83 cm\r\n重量：3.0Kg\r\n電池：90WHrs, 4S1P, 4-cell Li-ion\r\n變壓器：ø6.0, 330W AC Adapter, Output: 20V DC, 16.5A, 330W, Input: 100~240C AC 50/60Hz universal\r\n保固：二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'AMD Ryzen™ 9 7945HX (16-core/32-thread, 64MB L3 cache, up to 5.4 GHz max boost)', 'NVIDIA® GeForce RTX™ 4080 12GB GDDR6(具備MUX獨顯直連)\r\nROG Boost: 2330MHz* at 175W (2280MHz Boost Clock+50MHz OC, 150W+25W Dynamic Boost)', '32GB DDR5-4800 / 共2個插槽，已使用2個，最高支援64G', 'Windows11 64Bits', '17.3 \"(薄邊框)/WQHD (2560 x 1440) 16:9/240Hz/3ms/IPS-level/Anti-glare/DCI-P3 100%/Dolby Vision/G-Sync', '90WHrs, 4S1P, 4-cell Li-ion', '二年國際保固 / 首年完美保固 / LCD無亮點保固/電池保固一年', '39.5 x 28.2 x 2.34 ~ 2.83 cm', '3.0Kg', '/images/products/185722.jpg'),
(16, 13, 0, '灰', '187307', 52900, 500, 1, '2023-08-25 13:14:02', '2023-08-25 13:14:02', '商品規格\r\n處理器：Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 6000MHz OnBoard / 不可擴充\r\n硬碟：512G NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 6000MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g', '/images/products/187307.jpg'),
(17, 13, 1, '黑', '187307', 52900, 500, 0, '2023-08-25 13:14:02', '2023-08-25 13:14:02', '商品規格\r\n處理器：Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 6000MHz OnBoard / 不可擴充\r\n硬碟：512G NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 6000MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g', '/images/products/187307.jpg'),
(18, 13, 2, '白', '187307', 52900, 500, 1, '2023-08-25 13:14:02', '2023-08-25 13:14:02', '商品規格\r\n處理器：Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 6000MHz OnBoard / 不可擴充\r\n硬碟：512G NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i5-1340P 12核心/16緒 1.9GHz 超頻4.6GHz / 12M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 6000MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g', '/images/products/187307.jpg'),
(19, 14, 0, '曜石黑', '185202', 52900, 0, 1, '2023-08-25 13:28:02', '2023-08-25 13:28:02', '商品規格\r\n處理器：Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 5200MHz OnBoard / 不可擴充\r\n硬碟：1TB NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 5200MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g', '/images/products/185202.jpg'),
(20, 14, 1, '沉靜灰', '185202', 52900, 500, 1, '2023-08-25 13:28:50', '2023-08-25 13:28:50', '商品規格\r\n處理器：Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache\r\n顯示卡：Intel Iris Xe 顯示晶片\r\n記憶體：16G LPDDR5 5200MHz OnBoard / 不可擴充\r\n硬碟：1TB NVMe Gen4 SSD / 共2個插槽，已經使用1個\r\n螢幕：16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%\r\n數字鍵盤：YES\r\n光碟機： NO\r\n作業系統：WINDOWS 11 HOME (64BIT)\r\n無線規格：Intel Wi-Fi 6 AX211（BT 5.1）\r\n其他規格：\r\n2 x Thunderbolt 4\r\n2 x USB 3.2 Gen2\r\n1 x HDMI\r\n1 x MicroSD\r\n1 x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.1 x 242.3 x 16.8 mm\r\n重量：1199g\r\n電池瓦數：80Wh\r\n保固：2年保固 / 2年到府收送\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i7-1360P 12核心/16緒 2.2GHz 超頻5.0GHz / 18M Cache', 'Intel Iris Xe 顯示晶片', '16G LPDDR5 5200MHz OnBoard / 不可擴充', 'WINDOWS 11 HOME (64BIT)', '16吋 16:10 WQXGA 2560 x 1600 IPS DCI-P3 99%', '80Wh', '2年保固 / 2年到府收送', '355.1 x 242.3 x 16.8 mm', '1199g', '/images/products/185202.jpg'),
(21, 15, 0, '基本款', '190165', 95900, 720, 1, '2023-08-25 13:41:28', '2023-08-25 13:41:28', '商品規格\r\n處理器：Intel Core i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache\r\n顯示卡：NVIDIA GeForce RTX 4070 Laptop GPU 8GB GDDR6\r\n記憶體：32GB(16G*2) DDR5-5200 / 共2個插槽，已使用2個插槽，最高支援64G\r\n固態硬碟：2TB NVMe PCIe Gen4 / 共2個插槽，已使用1個插槽\r\n傳統硬碟：無\r\n螢幕：16\" UHD+(3840x2400), OLED, VESA DisplayHDR™ 600 Certified, 100% DCI-P3(Typical)\r\n光碟機：無，需另購外接式光碟機\r\n作業系統：Windows 11 Pro\r\n無線規格：Intel® Killer™ Wi-Fi 6E AX1675, Bluetooth v5.3\r\n鍵盤規格：SteelSeries單鍵RGB全彩背光電競鍵盤\r\n視訊鏡頭：IR FHD type (30fps@1080p)\r\n其他規格：\r\n1x Type-C (USB3.2 Gen2 / DP)\r\n1x Type-C (USB / DP / Thunderbolt™ 4) with PD charging\r\n1x Type-A USB3.2 Gen2\r\n1x Micro SD Card Reader\r\n1x HDMI™ 2.1 (8K @ 60Hz / 4K @ 120Hz)\r\n1x RJ45\r\n1x Mic-in/Headphone-out Combo Jack\r\n尺寸：355.8 x 259.7 x 19.95 mm\r\n重量：1.88 kg\r\n變壓器：240W\r\n電池：4-Cell 99.9 Battery (Whr)\r\n保固：二年台灣地區保固/一年國際旅約保固/電池保固一年\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel Core i9-13900H 14核心/20緒 2.6 GHz 超頻 5.4 GHz / 24M Cache', 'NVIDIA GeForce RTX 4070 Laptop GPU 8GB GDDR6', '32GB(16G*2) DDR5-5200 / 共2個插槽，已使用2個插槽，最高支援64G', 'Windows 11 Pro', '16\" UHD+(3840x2400), OLED, VESA DisplayHDR™ 600 Certified, 100% DCI-P3(Typical)', '80Wh', '二年台灣地區保固/一年國際旅約保固/電池保固一年', '355.8 x 259.7 x 19.95 mm', '1.88 kg', '/images/products/190165.jpg'),
(22, 16, 0, '基本款', '190125', 30900, 600, 1, '2023-08-25 13:48:04', '2023-08-25 13:48:04', '商品規格\r\n處理器：AMD Ryzen7 7730U 8核心/16緒 2.0GHz超頻4.5GHz/ L2快取 4MB+L3快取 16MB\r\n顯示卡：AMD Radeon™ Graphics\r\n記憶體：16GB*1 DDR4-3200 onboard\r\nSSD硬碟： 512GB NVMe PCIe SSD / 共1個插槽，已使用1個\r\n螢幕尺寸：15.6\" FHD (1920x1080), IPS-Level\r\n作業系統：Windows 11 Home\r\n光碟機：無,請另購外接式光碟機\r\n網路規格：AMD RZ608 Wi-Fi 6E\r\n藍芽規格：Bluetooth v5.2\r\n視訊鏡頭：HD type (30fps@720p)\r\n鍵盤規格：白色背光鍵盤\r\n喇叭/音效技術：\r\n2x 2W Speaker\r\n1x Mic-in/Headphone-out Combo Jack\r\nI/O規格：\r\n1x Type-C USB3.2 Gen2 with PD charging\r\n1x Type-A USB3.2 Gen2\r\n2x Type-A USB2.0\r\n1x Micro SD Card Reader\r\n1x HDMI™ 2.1 (4K @ 60Hz)\r\n尺寸：359 x 241 x 19.9 mm\r\n重量：1.75 kg\r\n變壓器：65W adapter\r\n電池：3-Cell 39.3 / 53.8 Battery (Whr)\r\n保固：2年保固 台灣地區2年到府收送 免費客服電話0800-018880', 'AMD Ryzen7 7730U 8核心/16緒 2.0GHz超頻4.5GHz/ L2快取 4MB+L3快取 16MB', 'AMD Radeon™ Graphics', '16GB*1 DDR4-3200 onboard', 'Windows 11 Home', '15.6\" FHD (1920x1080), IPS-Level', '3-Cell 39.3 / 53.8 Battery (Whr)', '2年保固 台灣地區2年到府收送 免費客服電話0800-018880', '359 x 241 x 19.9 mm', '1.75 kg', '/images/products/190125.jpg'),
(23, 17, 0, '基本款', '189900', 58900, 450, 1, '2023-08-25 13:56:41', '2023-08-25 13:56:41', '商品規格\r\n處理器：Intel® Core™i7-13620H , 10核心 / 16緒 1.5GHz 超頻4.9GHz / 24M Cache\r\n顯示卡：GeForce RTX™ 4050 筆記型電腦GPU 6GB GDDR6\r\n記憶體：16GB(8G*2) DDR5-5200 / 共2個插槽，已經使用2個，最高64GB\r\nSSD硬碟：512GB M.2 SSD (NVMe PCIe)/ 共1個插槽，已經使用1個\r\n傳統硬碟：無 / 不可擴充\r\n螢幕：14” FHD+ (1920x1200), 165Hz, IPS-Level\r\n作業系統：Windows 11 Pro\r\n光碟機：無,請另購外接式光碟機\r\n網路規格：Intel® Killer™ AX Wi-Fi 6E\r\n藍芽規格：Bluetooth v5.3\r\n視訊鏡頭：IR HD type (30fps@720p)\r\n鍵盤規格：Per-Key RGB Keyboard\r\n喇叭/音效技術：\r\n2x 2W Woofer\r\n2x 2W Speaker\r\n1x Mic-in/Headphone-out Combo Jack\r\nIO 介面：\r\n1x Type-C (USB / DP / Thunderbolt™ 4)\r\n1x Type-C (USB3.2 Gen2 / DP) with PD charging\r\n1x Type-A USB3.2 Gen2\r\n1x HDMI™ 2.1 (8K @ 60Hz / 4K @ 120Hz)\"\r\n尺寸：315 x 246 x 19 mm\r\n重量：1.7 kg\r\n變壓器：240W adapter\r\n電池：4-Cell 72 Battery (Whr)\r\n保固：2年保固台灣地區2年到府收送 免費客服電話0800-018880\r\n備註：以上規格僅供參考，如有任何問題，請依原廠公告為主', 'Intel® Core™i7-13620H , 10核心 / 16緒 1.5GHz 超頻4.9GHz / 24M Cache', 'GeForce RTX™ 4050 筆記型電腦GPU 6GB GDDR6', '16GB(8G*2) DDR5-5200 / 共2個插槽，已經使用2個，最高64GB', 'Windows 11 Pro', '14” FHD+ (1920x1200), 165Hz, IPS-Level', '4-Cell 72 Battery (Whr)', '2年保固台灣地區2年到府收送 免費客服電話0800-018880', '315 x 246 x 19 mm', '1.7 kg', '/images/products/189900.jpg'),
(24, 18, 0, '基本款', '189282', 49900, 750, 1, '2023-08-25 14:03:03', '2023-08-25 14:03:03', '商品規格\r\n處理器：第13代 Intel® Core™ i7-13650HX (24 MB 快取記憶體, 14 核, 最高睿頻 4.90 GHz)\r\n顯示卡：NVIDIA® GeForce® RTX™ 4050, 6 GB GDDR6\r\n記憶體：16GB (8GBx2) DDR5 4800MHz   (2 Slot/ up to 32G)\r\nSSD硬碟：M.2 2230 512GB NVMe Gen 4 Class 35 (擴充第二顆M.2，需要加購螺絲墊片與散热片)\r\n螢幕尺寸：15.6吋 FHD (1920x1080) 165Hz, 3ms, sRGB-100%, ComfortViewPlus, NVIDIA G-SYNC+DDS 顯示器\r\n光碟機：No\r\n作業系統：Windows® 11  家用版 64位元 三國語言版(繁體中文、簡體中文、英文)\r\n網路規格：Intel Wi-Fi 6 AX201, 2x2 802.11ax 1\r\n視訊鏡頭：720p (30 fps) HD RGB 攝影機，單一內建麥克風\r\n音效與喇叭：立體聲喇叭，搭載 Realtek ALC3254，2 x 2.5 W\r\n鍵盤規格：繁體中文 Qwerty 背光 鍵盤 含 數字鍵台 (無 G-Key)\r\nI/O規格：\r\n1x 耳機 (耳機和麥克風組合) 連接埠\r\n1x RJ45 乙太網路連接埠\r\n3x USB 3.2 Gen 1 連接埠\r\n1x HDMI 2.1 連接埠\r\n1x USB-C 3.2 Gen 2 連接埠，具備 DisplayPort™\r\n軟體：Mcafee 12M、Microsoft® Office 試用版\r\n尺寸：高度：25.4 x 368.9 x 289.9 (mm)\r\n重量：2.81 kg\r\n變壓器：330W\r\n電池：鋰離子(86 瓦時)電池 含Alienware 電池防護技術\r\n保固：2年 頂級支援 1-2 營業日 到府服務 含 HW-SW 支援\r\n備註：以上資料僅供參考，如有任何問題，請依原廠公告為主。', '第13代 Intel® Core™ i7-13650HX (24 MB 快取記憶體, 14 核, 最高睿頻 4.90 GHz)', 'NVIDIA® GeForce® RTX™ 4050, 6 GB GDDR6', '16GB (8GBx2) DDR5 4800MHz   (2 Slot/ up to 32G)', 'Windows® 11  家用版 64位元 三國語言版(繁體中文、簡體中文、英文)', '15.6吋 FHD (1920x1080) 165Hz, 3ms, sRGB-100%, ComfortViewPlus, NVIDIA G-SYNC+DDS 顯示器', '鋰離子(86 瓦時)電池 含Alienware 電池防護技術', '2年 頂級支援 1-2 營業日 到府服務 含 HW-SW 支援', '25.4 x 368.9 x 289.9 (mm)', '2.81 kg', '/images/products/189282.jpg');

-- --------------------------------------------------------

--
-- 資料表結構 `shopcart`
--

CREATE TABLE `shopcart` (
  `user_id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `spec_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `shopcart`
--

INSERT INTO `shopcart` (`user_id`, `prod_id`, `spec_id`) VALUES
(6, 1, 1),
(6, 9, 2),
(6, 11, 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tag`
--

CREATE TABLE `tag` (
  `tag` int(11) NOT NULL,
  `content` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `tag`
--

INSERT INTO `tag` (`tag`, `content`) VALUES
(1, 'CP值'),
(2, '文書機'),
(3, '電競機'),
(4, '繪圖效能機'),
(5, '極度輕薄'),
(6, '開學季學生主打');

-- --------------------------------------------------------

--
-- 資料表結構 `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `right` tinyint(4) NOT NULL DEFAULT '2' COMMENT '管理員 0\r\n賣家 1\r\n買家 2\r\n',
  `acc` varchar(20) NOT NULL,
  `pwd` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `birth` date NOT NULL,
  `address` varchar(300) NOT NULL,
  `photo` varchar(300) DEFAULT NULL,
  `change_pwd_time` date NOT NULL,
  `creat_time` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 傾印資料表的資料 `user`
--

INSERT INTO `user` (`user_id`, `right`, `acc`, `pwd`, `name`, `phone`, `email`, `birth`, `address`, `photo`, `change_pwd_time`, `creat_time`) VALUES
(1, 0, 'admin', 'admin', '管理員1號', '0912345678', 'admin01@email.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24'),
(2, 1, 'seller01', 'seller01', '賣家1號', '0912345678', 'seller01@email.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24'),
(3, 1, 'seller02', 'seller02', '賣家2號', '0912345678', 'seller02@email.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24'),
(4, 1, 'seller03', 'seller03', '賣家3號', '0912345678', 'seller03@email.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24'),
(5, 1, 'seller04', 'seller04', '賣家4號', '0912345678', 'seller04@email.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24'),
(6, 2, 'buyer01', 'buyer01', '買家1號', '0912345678', 'buyer01@email.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24'),
(7, 2, 'buyer02', 'buyer02', '買家2號', '0912345678', 'buyer02@email.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24'),
(8, 2, 'buyer03', 'buyer03', '買家3號', '0912345678', 'buyer03@email.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24'),
(9, 2, 'buyer04', 'buyer04', '買家4號', '0912345678', 'buyer04@email.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24'),
(10, 2, 'buyer05', 'buyer05', '買家5號', '0912345678', 'buyer05@gmail.com', '2000-01-01', '台中市南屯區黎明路二段658號', NULL, '2023-08-24', '2023-08-24');

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `vw_all_order_product_count`
-- (請參考以下實際畫面)
--
CREATE TABLE `vw_all_order_product_count` (
`order_id` int(11)
,`prod_id` int(11)
,`spec_id` int(11)
,`counts` int(11)
);

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `vw_comment`
-- (請參考以下實際畫面)
--
CREATE TABLE `vw_comment` (
`prod_id` int(11)
,`spec_id` int(11)
,`user_id` int(11)
,`order_id` int(11)
,`prod_name` varchar(50)
,`spec_name` varchar(21)
,`name` varchar(100)
,`comment` varchar(300)
,`comment_grade` tinyint(4)
,`comment_time` datetime
);

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `vw_products_detail`
-- (請參考以下實際畫面)
--
CREATE TABLE `vw_products_detail` (
`prod_id` int(11)
,`spec_id` int(11)
,`prod_name` varchar(50)
,`spec_name` varchar(21)
,`brand` varchar(50)
,`category` varchar(50)
,`publish` int(11)
,`cpu` varchar(150)
,`gpu` varchar(150)
,`ram` varchar(100)
,`os` varchar(100)
,`screen` varchar(150)
,`battery` varchar(100)
,`size` varchar(100)
,`weight` varchar(100)
,`warranty` varchar(150)
,`info_content` varchar(2500)
,`img_src` varchar(200)
);

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `vw_products_info`
-- (請參考以下實際畫面)
--
CREATE TABLE `vw_products_info` (
`prod_id` int(11)
,`spec_id` int(11)
,`seller_id` int(11)
,`brand_id` int(11)
,`category_id` int(11)
,`prod_name` varchar(50)
,`spec_name` varchar(21)
,`seller_name` varchar(100)
,`brand` varchar(50)
,`category` varchar(50)
,`publish` int(11)
,`price` int(11)
,`stock` int(11)
,`sales` bigint(11)
,`inventory` bigint(12)
,`comment_grade` decimal(5,1)
,`create_time` datetime
,`update_time` datetime
,`img_src` varchar(200)
);

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `vw_product_comment_grade`
-- (請參考以下實際畫面)
--
CREATE TABLE `vw_product_comment_grade` (
`prod_id` int(11)
,`spec_id` int(11)
,`comment_grade` decimal(5,1)
);

-- --------------------------------------------------------

--
-- 檢視表結構 `vw_all_order_product_count`
--
DROP TABLE IF EXISTS `vw_all_order_product_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_all_order_product_count`  AS SELECT `orders`.`order_id` AS `order_id`, `order_product`.`prod_id` AS `prod_id`, `order_product`.`spec_id` AS `spec_id`, `order_product`.`count` AS `counts` FROM (`orders` left join `order_product` on((`orders`.`order_id` = `order_product`.`order_id`))) WHERE ((`orders`.`state` <> 0) AND (`order_product`.`count` is not null)) ORDER BY `orders`.`order_id` ASC, `order_product`.`prod_id` ASC, `order_product`.`spec_id` ASC  ;

-- --------------------------------------------------------

--
-- 檢視表結構 `vw_comment`
--
DROP TABLE IF EXISTS `vw_comment`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_comment`  AS SELECT `order_product`.`prod_id` AS `prod_id`, `order_product`.`spec_id` AS `spec_id`, `user`.`user_id` AS `user_id`, `orders`.`order_id` AS `order_id`, `vw_products_info`.`prod_name` AS `prod_name`, `vw_products_info`.`spec_name` AS `spec_name`, `user`.`name` AS `name`, `order_product`.`comment` AS `comment`, `order_product`.`comment_grade` AS `comment_grade`, `order_product`.`comment_time` AS `comment_time` FROM (((`order_product` left join `orders` on((`order_product`.`order_id` = `orders`.`order_id`))) left join `user` on((`orders`.`user_id` = `user`.`user_id`))) left join `vw_products_info` on(((`order_product`.`prod_id` = `vw_products_info`.`prod_id`) and (`order_product`.`spec_id` = `vw_products_info`.`spec_id`)))) WHERE ((`orders`.`state` <> 0) AND (`order_product`.`comment` is not null)) ORDER BY `vw_products_info`.`prod_id` ASC, `vw_products_info`.`spec_id` ASC, `orders`.`order_id` ASC  ;

-- --------------------------------------------------------

--
-- 檢視表結構 `vw_products_detail`
--
DROP TABLE IF EXISTS `vw_products_detail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_products_detail`  AS SELECT `product`.`prod_id` AS `prod_id`, `sellspec`.`spec_id` AS `spec_id`, `product`.`prod_name` AS `prod_name`, `sellspec`.`spec_name` AS `spec_name`, `brand`.`brand` AS `brand`, `category`.`category` AS `category`, `sellspec`.`publish` AS `publish`, `sellspec`.`cpu` AS `cpu`, `sellspec`.`gpu` AS `gpu`, `sellspec`.`ram` AS `ram`, `sellspec`.`os` AS `os`, `sellspec`.`screen` AS `screen`, `sellspec`.`battery` AS `battery`, `sellspec`.`size` AS `size`, `sellspec`.`weight` AS `weight`, `sellspec`.`warranty` AS `warranty`, `sellspec`.`info_content` AS `info_content`, ifnull(concat(`productimg`.`dir`,`productimg`.`filename`),'') AS `img_src` FROM ((((`product` left join `sellspec` on((`product`.`prod_id` = `sellspec`.`prod_id`))) left join `brand` on((`product`.`brand_id` = `brand`.`brand_id`))) left join `category` on((`category`.`category_id` = `product`.`category_id`))) left join (select `productimg`.`prod_id` AS `prod_id`,`productimg`.`type` AS `TYPE`,`productimg`.`dir` AS `dir`,`productimg`.`filename` AS `filename` from `productimg`) `productimg` on(((`sellspec`.`prod_id` = `productimg`.`prod_id`) and (`productimg`.`TYPE` = 1)))) ORDER BY `sellspec`.`prod_id` ASC, `sellspec`.`spec_id` ASC  ;

-- --------------------------------------------------------

--
-- 檢視表結構 `vw_products_info`
--
DROP TABLE IF EXISTS `vw_products_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_products_info`  AS SELECT `product`.`prod_id` AS `prod_id`, `sellspec1`.`spec_id` AS `spec_id`, `product`.`user_id` AS `seller_id`, `product`.`brand_id` AS `brand_id`, `product`.`category_id` AS `category_id`, `product`.`prod_name` AS `prod_name`, `sellspec1`.`spec_name` AS `spec_name`, `user`.`name` AS `seller_name`, `brand`.`brand` AS `brand`, `category`.`category` AS `category`, `sellspec1`.`publish` AS `publish`, `sellspec1`.`price` AS `price`, `sellspec1`.`stock` AS `stock`, ifnull(`vw_all_order_product_count`.`counts`,0) AS `sales`, (`sellspec1`.`stock` - ifnull(`vw_all_order_product_count`.`counts`,0)) AS `inventory`, ifnull(`vw_product_comment_grade`.`comment_grade`,0) AS `comment_grade`, `sellspec1`.`create_time` AS `create_time`, `sellspec1`.`update_time` AS `update_time`, ifnull(concat(`productimg`.`dir`,`productimg`.`filename`),'/images/products/default.jpg') AS `img_src` FROM (((((((`product` left join `sellspec1` on((`product`.`prod_id` = `sellspec1`.`prod_id`))) left join `user` on((`user`.`user_id` = `product`.`user_id`))) left join `brand` on((`product`.`brand_id` = `brand`.`brand_id`))) left join `category` on((`category`.`category_id` = `product`.`category_id`))) left join `vw_all_order_product_count` on(((`sellspec1`.`prod_id` = `vw_all_order_product_count`.`prod_id`) and (`sellspec1`.`spec_id` = `vw_all_order_product_count`.`spec_id`)))) left join (select `productimg`.`prod_id` AS `prod_id`,`productimg`.`spec_id` AS `spec_id`,`productimg`.`type` AS `TYPE`,`productimg`.`dir` AS `dir`,`productimg`.`filename` AS `filename` from `productimg`) `productimg` on(((`sellspec1`.`prod_id` = `productimg`.`prod_id`) and (`sellspec1`.`spec_id` = `productimg`.`spec_id`) and (`productimg`.`TYPE` = 0)))) left join `vw_product_comment_grade` on(((`sellspec1`.`prod_id` = `vw_product_comment_grade`.`prod_id`) and (`sellspec1`.`spec_id` = `vw_product_comment_grade`.`spec_id`)))) GROUP BY `product`.`prod_id`, `sellspec1`.`spec_id`, `product`.`user_id`, `product`.`brand_id`, `product`.`category_id`, `product`.`prod_name`, `sellspec1`.`spec_name`, `user`.`name`, `brand`.`brand`, `category`.`category`, `sellspec1`.`publish`, `sellspec1`.`price`, `sellspec1`.`stock`, ifnull(`vw_all_order_product_count`.`counts`,0), ifnull(`vw_product_comment_grade`.`comment_grade`,0), `sellspec1`.`create_time`, `sellspec1`.`update_time`, ifnull(concat(`productimg`.`dir`,`productimg`.`filename`),'/images/products/default.jpg'), `vw_all_order_product_count`.`counts` ORDER BY `sellspec1`.`prod_id` ASC, `sellspec1`.`spec_id` ASC  ;

-- --------------------------------------------------------

--
-- 檢視表結構 `vw_product_comment_grade`
--
DROP TABLE IF EXISTS `vw_product_comment_grade`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_product_comment_grade`  AS SELECT `product`.`prod_id` AS `prod_id`, `sellspec`.`spec_id` AS `spec_id`, round(avg(`order_product`.`comment_grade`),1) AS `comment_grade` FROM (((`sellspec` left join `product` on((`sellspec`.`prod_id` = `product`.`prod_id`))) left join `order_product` on(((`sellspec`.`spec_id` = `order_product`.`spec_id`) and (`sellspec`.`prod_id` = `order_product`.`prod_id`)))) left join `orders` on((`order_product`.`order_id` = `orders`.`order_id`))) WHERE ((`orders`.`state` <> 0) AND (`order_product`.`comment_grade` is not null)) GROUP BY `sellspec`.`prod_id`, `sellspec`.`spec_id` ORDER BY `sellspec`.`prod_id` ASC, `sellspec`.`spec_id` ASC  ;

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `bannerimg`
--
ALTER TABLE `bannerimg`
  ADD PRIMARY KEY (`img_id`);

--
-- 資料表索引 `brand`
--
ALTER TABLE `brand`
  ADD PRIMARY KEY (`brand_id`);

--
-- 資料表索引 `card`
--
ALTER TABLE `card`
  ADD PRIMARY KEY (`card_num`),
  ADD KEY `user_id` (`user_id`);

--
-- 資料表索引 `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`);

--
-- 資料表索引 `collect`
--
ALTER TABLE `collect`
  ADD PRIMARY KEY (`user_id`,`prod_id`,`spec_id`) USING BTREE,
  ADD KEY `prod_id` (`prod_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `spec_id` (`spec_id`);

--
-- 資料表索引 `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- 資料表索引 `order_product`
--
ALTER TABLE `order_product`
  ADD PRIMARY KEY (`order_id`,`prod_id`,`spec_id`) USING BTREE,
  ADD KEY `prod_id` (`prod_id`),
  ADD KEY `format_id` (`spec_id`);

--
-- 資料表索引 `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`prod_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `brand_id` (`brand_id`),
  ADD KEY `category_id` (`category_id`);

--
-- 資料表索引 `productimg`
--
ALTER TABLE `productimg`
  ADD PRIMARY KEY (`img_id`),
  ADD KEY `prod_id` (`prod_id`);

--
-- 資料表索引 `product_images_test`
--
ALTER TABLE `product_images_test`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prod_id` (`prod_id`);

--
-- 資料表索引 `product_tag`
--
ALTER TABLE `product_tag`
  ADD PRIMARY KEY (`prod_id`,`tag`),
  ADD KEY `tag` (`tag`);

--
-- 資料表索引 `sellspec`
--
ALTER TABLE `sellspec`
  ADD PRIMARY KEY (`prod_id`,`spec_id`),
  ADD KEY `spec_id` (`spec_id`);

--
-- 資料表索引 `sellspec1`
--
ALTER TABLE `sellspec1`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `prod_spec_unique1` (`prod_id`,`spec_id`),
  ADD KEY `spec_id1` (`spec_id`);

--
-- 資料表索引 `shopcart`
--
ALTER TABLE `shopcart`
  ADD PRIMARY KEY (`user_id`,`prod_id`,`spec_id`) USING BTREE,
  ADD KEY `prod_id` (`prod_id`),
  ADD KEY `spec_id` (`spec_id`);

--
-- 資料表索引 `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`tag`) USING BTREE;

--
-- 資料表索引 `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `right` (`right`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `bannerimg`
--
ALTER TABLE `bannerimg`
  MODIFY `img_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `brand`
--
ALTER TABLE `brand`
  MODIFY `brand_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `product`
--
ALTER TABLE `product`
  MODIFY `prod_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `productimg`
--
ALTER TABLE `productimg`
  MODIFY `img_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `product_images_test`
--
ALTER TABLE `product_images_test`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `sellspec1`
--
ALTER TABLE `sellspec1`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `tag`
--
ALTER TABLE `tag`
  MODIFY `tag` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `card`
--
ALTER TABLE `card`
  ADD CONSTRAINT `card_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;

--
-- 資料表的限制式 `collect`
--
ALTER TABLE `collect`
  ADD CONSTRAINT `collect_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `collect_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`),
  ADD CONSTRAINT `collect_ibfk_3` FOREIGN KEY (`spec_id`) REFERENCES `sellspec` (`spec_id`);

--
-- 資料表的限制式 `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- 資料表的限制式 `order_product`
--
ALTER TABLE `order_product`
  ADD CONSTRAINT `order_product_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_product_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`),
  ADD CONSTRAINT `order_product_ibfk_3` FOREIGN KEY (`spec_id`) REFERENCES `sellspec` (`spec_id`);

--
-- 資料表的限制式 `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `product_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`brand_id`),
  ADD CONSTRAINT `product_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`);

--
-- 資料表的限制式 `productimg`
--
ALTER TABLE `productimg`
  ADD CONSTRAINT `productimg_ibfk_1` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`);

--
-- 資料表的限制式 `product_images_test`
--
ALTER TABLE `product_images_test`
  ADD CONSTRAINT `product_images_test_ibfk_1` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`) ON DELETE CASCADE;

--
-- 資料表的限制式 `product_tag`
--
ALTER TABLE `product_tag`
  ADD CONSTRAINT `product_tag_ibfk_1` FOREIGN KEY (`tag`) REFERENCES `tag` (`tag`),
  ADD CONSTRAINT `product_tag_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`);

--
-- 資料表的限制式 `sellspec`
--
ALTER TABLE `sellspec`
  ADD CONSTRAINT `sellspec_ibfk_1` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`) ON DELETE CASCADE;

--
-- 資料表的限制式 `sellspec1`
--
ALTER TABLE `sellspec1`
  ADD CONSTRAINT `sellspec1_ibfk_1` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `shopcart`
--
ALTER TABLE `shopcart`
  ADD CONSTRAINT `shopcart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `shopcart_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `product` (`prod_id`),
  ADD CONSTRAINT `shopcart_ibfk_3` FOREIGN KEY (`spec_id`) REFERENCES `sellspec` (`spec_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
