-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 05, 2023 at 10:22 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wooxtravel`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMostVisitedCountry` (IN `userId` INT, OUT `mostVisitedCountryId` INT)   BEGIN
    SELECT city.country_id INTO mostVisitedCountryId
    FROM bookings
    JOIN cities city ON bookings.city_id = city.id
    WHERE bookings.user_id = userId
    GROUP BY city.country_id
    ORDER BY COUNT(*) DESC
    LIMIT 1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(4) NOT NULL,
  `adminname` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `mypassword` varchar(200) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `adminname`, `email`, `mypassword`, `created_at`) VALUES
(1, 'Muhammad Naimat ullah Khan', 'muhammadnaimatullahkhan99@gmail.com', '$2y$10$KOUZIHhVCSFPYniD9u4ER.UD6DCqOlko98D0XgaHFFl69tkHr1DHu', '2023-11-28 11:33:39');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(3) NOT NULL,
  `name` varchar(200) NOT NULL,
  `phone_number` int(30) NOT NULL,
  `num_of_geusts` int(10) NOT NULL,
  `checkin_date` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `destination` varchar(200) NOT NULL,
  `status` varchar(200) NOT NULL,
  `city_id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL,
  `payment` varchar(40) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `name`, `phone_number`, `num_of_geusts`, `checkin_date`, `destination`, `status`, `city_id`, `user_id`, `payment`, `created_at`) VALUES
(2, 'Muhammad Naimatullah Khan', 2147483647, 1, '2023-11-28 11:39:58.062704', 'Islamabad', 'Booked Successfully', 2, 1, '150', '2023-11-28 11:37:45'),
(3, 'Muhammad Naimat Ullah Khan', 2147483647, 3, '2023-12-05 16:09:13.177211', 'Karachi', 'Booked Successfully', 1, 1, '300', '2023-12-04 21:28:24'),
(4, 'Muhammad Naimat Ullah Khan', 2147483647, 1, '2023-12-05 16:56:25.167781', 'Rome', 'Pending', 5, 1, '500', '2023-12-04 22:59:40'),
(5, 'Muhammad Naimat Ullah Khan', 2147483647, 1, '2023-12-05 19:00:00.000000', 'Islamabad', 'Pending', 2, 1, '150', '2023-12-05 11:24:41'),
(6, 'Muhammad Naimat Ullah Khan', 2147483647, 1, '2023-12-06 19:00:00.000000', 'Islamabad', 'Pending', 2, 1, '150', '2023-12-05 17:00:29');

--
-- Triggers `bookings`
--
DELIMITER $$
CREATE TRIGGER `after_booking_delete` AFTER DELETE ON `bookings` FOR EACH ROW BEGIN
    -- Set the modification date
    DECLARE modificationDate DATETIME;
    SET modificationDate = NOW();

    -- Insert the deleted booking details into the booking_history table
    -- Ensure that all these columns exist in your booking_history table
    INSERT INTO booking_history (booking_id, user_id, city_id, modification_date, action, num_of_geusts, checkin_date, destination, status, payment)
    VALUES (OLD.id, OLD.user_id, OLD.city_id, modificationDate, 'deleted', OLD.num_of_geusts, OLD.checkin_date, OLD.destination, OLD.status, OLD.payment);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_booking_update` AFTER UPDATE ON `bookings` FOR EACH ROW BEGIN
    -- Set the modification date
    DECLARE modificationDate DATETIME;
    SET modificationDate = NOW();

    -- Insert the modified booking details into the booking_history table
    -- Ensure that all these columns exist in your booking_history table
    INSERT INTO booking_history (booking_id, user_id, city_id, modification_date, action, num_of_geusts, checkin_date, destination, status, payment)
    VALUES (NEW.id, NEW.user_id, NEW.city_id, modificationDate, 'modified', NEW.num_of_geusts, NEW.checkin_date, NEW.destination, NEW.status, NEW.payment);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `booking_history`
--

CREATE TABLE `booking_history` (
  `id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `modification_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `action` varchar(20) NOT NULL,
  `user_id` int(10) NOT NULL,
  `city_id` int(10) NOT NULL,
  `num_of_geusts` int(10) NOT NULL,
  `checkin_date` timestamp(6) NULL DEFAULT NULL,
  `destination` varchar(200) NOT NULL,
  `status` varchar(200) NOT NULL,
  `payment` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking_history`
--

INSERT INTO `booking_history` (`id`, `booking_id`, `modification_date`, `action`, `user_id`, `city_id`, `num_of_geusts`, `checkin_date`, `destination`, `status`, `payment`) VALUES
(1, 1, '2023-12-05 14:11:58', 'modified', 1, 2, 2, '2023-12-05 14:11:58.051820', 'Islamabad', 'Pending', '300'),
(2, 1, '2023-12-05 14:12:48', 'deleted', 1, 2, 2, '2023-12-05 14:11:58.051820', 'Islamabad', 'Pending', '300'),
(3, 3, '2023-12-05 16:09:13', 'modified', 1, 1, 3, '2023-12-05 16:09:13.177211', 'Karachi', 'Booked Successfully', '300'),
(4, 4, '2023-12-05 16:56:20', 'modified', 1, 5, 1, '2023-12-05 16:56:20.693169', 'Rome', 'Booked Successfully', '500'),
(5, 4, '2023-12-05 16:56:25', 'modified', 1, 5, 1, '2023-12-05 16:56:25.167781', 'Rome', 'Pending', '500');

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `id` int(3) NOT NULL,
  `name` varchar(200) NOT NULL,
  `image` varchar(200) NOT NULL,
  `trip_days` int(4) NOT NULL,
  `price` varchar(4) NOT NULL,
  `country_id` int(4) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`id`, `name`, `image`, `trip_days`, `price`, `country_id`, `created_at`) VALUES
(1, 'Karachi', 'cities-01.jpg', 3, '100', 1, '2023-11-28 10:50:10'),
(2, 'Islamabad', 'cities-02.jpg', 4, '150', 1, '2023-11-28 10:51:19'),
(3, 'Istanbul', 'cities-03.jpg', 4, '300', 2, '2023-11-28 10:55:54'),
(4, 'Ankara', 'cities-04.jpg', 4, '350', 2, '2023-11-28 10:56:17'),
(5, 'Rome', 'cities-05.jpg', 5, '500', 3, '2023-11-28 10:58:06');

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` int(3) NOT NULL,
  `name` varchar(200) NOT NULL,
  `image` varchar(200) NOT NULL,
  `continent` varchar(200) NOT NULL,
  `population` varchar(30) NOT NULL,
  `territory` varchar(30) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `name`, `image`, `continent`, `population`, `territory`, `description`, `created_at`) VALUES
(1, 'Pakistan', 'country-01.jpg', 'Asia', '2.5', '881,913', 'The Islamic Republic of Pakistan is the thirty third largest country in terms of area and fifth-most populous with a population of over 210 million. The country has a huge reservoir of young people, with 64% of the population below the age of 29 and 30% between 15 and 29 years.', '2023-11-28 10:31:30'),
(2, 'Turkey', 'country-02.jpg', 'Europe', '84.78', '783.356 ', 'Turkey is a large peninsula that bridges the continents of Europe and Asia. Turkey is surrounded on three sides by the Black Sea, the Mediterranean Sea, and the Aegean Sea. Istanbul, the largest city in Turkey, is built on land in the Bosporus seaway. The city is partly in Europe and partly in Asia.', '2023-11-28 10:39:02'),
(3, 'Italy', 'country-03.jpg', 'Europe', '59.11', '301,230 ', 'Italy is a boot-shaped peninsula that juts out of southern Europe into the Adriatic Sea, Tyrrhenian Sea, Mediterranean Sea, and other waters. Its location has played an important role in its history. The sea surrounds Italy, and mountains crisscross the interior, dividing it into regions.', '2023-11-28 10:40:25');

--
-- Triggers `countries`
--
DELIMITER $$
CREATE TRIGGER `countries_to_cities_deletion` BEFORE DELETE ON `countries` FOR EACH ROW DELETE FROM cities WHERE country_id = OLD.id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(3) NOT NULL,
  `email` varchar(200) NOT NULL,
  `username` varchar(200) NOT NULL,
  `mypassword` varchar(200) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `username`, `mypassword`, `created_at`) VALUES
(1, 'muhammadnaimatullahkhan99@gmail.com', 'Muhammad Naimat Ullah Khan', '$2y$10$0mIAXzcGkZILO1fmw8GOUeWATS.rjEbcCL5zRKR2UO/wB7ZwqKg7C', '2023-11-28 11:34:59');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `User_Deletion_Cascade_Trigger` BEFORE DELETE ON `users` FOR EACH ROW DELETE FROM bookings WHERE user_id = OLD.id
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `booking_history`
--
ALTER TABLE `booking_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `booking_history`
--
ALTER TABLE `booking_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `cities`
--
ALTER TABLE `cities`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
