-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 21-10-2026 a las 23:12:00
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `encuestas_mc`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `brand`
--

CREATE TABLE `brand` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `change_logs`
--

CREATE TABLE `change_logs` (
  `action_id` bigint(20) UNSIGNED NOT NULL,
  `module` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `action_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `survey_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `change_logs`
--

INSERT INTO `change_logs` (`action_id`, `module`, `action`, `description`, `action_date`, `user_id`, `survey_id`) VALUES
(1, 'Survey', 'Creación', 'Se creó la encuesta \"Solicitudes de Becas 2026\".', '2026-08-25 00:12:19', 2, 4),
(2, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-25 00:13:49', 2, 4),
(3, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-08-25 00:15:22', 1, 4),
(4, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-08-25 00:15:44', 2, 4),
(5, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-25 00:20:45', 1, 4),
(6, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-08-25 00:24:37', 1, 1),
(7, 'Survey', 'Creación', 'Se creó la encuesta \"encuestas 2\".', '2026-08-25 00:34:14', 2, 5),
(8, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-25 00:34:52', 2, 5),
(9, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-08-25 00:36:49', 1, 5),
(10, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-25 00:38:20', 2, 5),
(11, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-08-25 00:38:57', 2, 5),
(12, 'Survey', 'Duplicación', 'Duplicada a partir de la encuesta \"Satisfacción de atención al ciudadano\" (ID 3).', '2026-08-27 18:26:16', 1, 6),
(13, 'Survey', 'Duplicación', 'Duplicada a partir de la encuesta \"encuestas 2\" (ID 5).', '2026-08-27 18:31:35', 1, 7),
(14, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-08-27 18:33:32', 1, 6),
(15, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-08-27 18:33:40', 1, 6),
(16, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-08-27 18:33:43', 1, 6),
(17, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-27 20:12:39', 2, 4),
(18, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-08-27 20:22:28', 2, 7),
(19, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-08-27 20:24:12', 1, 1),
(20, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-27 20:27:15', 1, 1),
(21, 'Survey', 'Creación', 'Se creó la encuesta \"hhhhhhhhhhhhhhhhhhh\".', '2026-08-27 20:28:26', 2, 8),
(22, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-27 20:28:40', 2, 8),
(23, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-08-27 20:28:48', 2, 8),
(24, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-08-27 20:29:19', 1, 8),
(25, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-27 20:29:22', 1, 8),
(26, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-08-27 20:31:07', 2, 8),
(27, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-27 20:32:55', 2, 8),
(28, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-27 20:33:50', 2, 8),
(29, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-27 20:34:05', 2, 8),
(30, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Clima Laboral 2026\".', '2026-08-30 00:27:58', 2, 9),
(31, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-30 00:37:07', 2, 9),
(32, 'Section', 'Creación', 'Se agregó la sección \"Información general\".', '2026-08-30 00:37:09', 2, 9),
(33, 'Question', 'Creación', 'Se agregó la pregunta \"¿En qué colonia o barrio vives?\".', '2026-08-30 00:37:10', 2, 9),
(34, 'Question', 'Creación', 'Se agregó la pregunta \"¿Cuál es tu rango de edad?\".', '2026-08-30 00:37:12', 2, 9),
(35, 'Question', 'Creación', 'Se agregó la pregunta \"¿Cuál es tu nivel educativo?\".', '2026-08-30 00:37:17', 2, 9),
(36, 'Question', 'Creación', 'Se agregó la pregunta \"¿Has utilizado algún servicio municipal en los últimos 6 meses?\".', '2026-08-30 00:37:22', 2, 9),
(37, 'Section', 'Creación', 'Se agregó la sección \"Evaluación de servicios municipales\".', '2026-08-30 00:37:22', 2, 9),
(38, 'Question', 'Creación', 'Se agregó la pregunta \"¿Cómo calificarías la atención recibida en ventanillas?\".', '2026-08-30 00:37:23', 2, 9),
(39, 'Question', 'Creación', 'Se agregó la pregunta \"¿Qué servicios municipales has utilizado? (puedes marcar varios)\".', '2026-08-30 00:37:24', 2, 9),
(40, 'Question', 'Creación', 'Se agregó la pregunta \"¿Qué tan satisfecho estás con la limpieza de calles y espacios públicos?\".', '2026-08-30 00:37:30', 2, 9),
(41, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-30 00:44:41', 2, 9),
(42, 'Section', 'Edición', 'Se editó la sección \"Información general\".', '2026-08-30 00:44:42', 2, 9),
(43, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué colonia o barrio vives?\".', '2026-08-30 00:44:43', 2, 9),
(44, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es tu rango de edad?\".', '2026-08-30 00:44:44', 2, 9),
(45, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es tu nivel educativo?\".', '2026-08-30 00:44:49', 2, 9),
(46, 'Question', 'Edición', 'Se editó la pregunta \"¿Has utilizado algún servicio municipal en los últimos 6 meses?\".', '2026-08-30 00:44:54', 2, 9),
(47, 'Section', 'Edición', 'Se editó la sección \"Evaluación de servicios municipales\".', '2026-08-30 00:44:55', 2, 9),
(48, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo calificarías la atención recibida en ventanillas?\".', '2026-08-30 00:44:56', 2, 9),
(49, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué servicios municipales has utilizado? (puedes marcar varios)\".', '2026-08-30 00:44:57', 2, 9),
(50, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tan satisfecho estás con la limpieza de calles y espacios públicos?\".', '2026-08-30 00:45:01', 2, 9),
(51, 'Question', 'Creación', 'Se agregó la pregunta \"Describe brevemente algún problema que hayas tenido con un servicio municipal.\".', '2026-08-30 00:45:02', 2, 9),
(52, 'Section', 'Creación', 'Se agregó la sección \"Comunicación y participación ciudadana\".', '2026-08-30 00:45:03', 2, 9),
(53, 'Question', 'Creación', 'Se agregó la pregunta \"¿Cómo te enteras de las actividades y servicios del municipio?\".', '2026-08-30 00:45:04', 2, 9),
(54, 'Question', 'Creación', 'Se agregó la pregunta \"¿En qué espacios de participación te gustaría involucrarte?\".', '2026-08-30 00:45:10', 2, 9),
(55, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-30 00:45:14', 2, 9),
(56, 'Section', 'Edición', 'Se editó la sección \"Información general\".', '2026-08-30 00:45:16', 2, 9),
(57, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué colonia o barrio vives?\".', '2026-08-30 00:45:17', 2, 9),
(58, 'Question', 'Creación', 'Se agregó la pregunta \"¿Sientes que tus opiniones son tomadas en cuenta por el municipio?\".', '2026-08-30 00:45:18', 2, 9),
(59, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es tu rango de edad?\".', '2026-08-30 00:45:19', 2, 9),
(60, 'Question', 'Creación', 'Se agregó la pregunta \"¿Qué canal de comunicación mejorarías para recibir información municipal?\".', '2026-08-30 00:45:19', 2, 9),
(61, 'Section', 'Creación', 'Se agregó la sección \"Sugerencias y comentarios finales\".', '2026-08-30 00:45:20', 2, 9),
(62, 'Question', 'Creación', 'Se agregó la pregunta \"¿Qué áreas consideras que necesitan mejora inmediata? (selecciona todas las que apliquen)\".', '2026-08-30 00:45:21', 2, 9),
(63, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es tu nivel educativo?\".', '2026-08-30 00:45:25', 2, 9),
(64, 'Question', 'Creación', 'Se agregó la pregunta \"¿Qué tan probable es que recomiendes este municipio como un buen lugar para vivir?\".', '2026-08-30 00:45:29', 2, 9),
(65, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-30 00:46:17', 2, 9),
(66, 'Section', 'Edición', 'Se editó la sección \"Información general\".', '2026-08-30 00:46:18', 2, 9),
(67, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué colonia o barrio vives?\".', '2026-08-30 00:46:19', 2, 9),
(68, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es tu rango de edad?\".', '2026-08-30 00:46:19', 2, 9),
(69, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es tu nivel educativo?\".', '2026-08-30 00:46:24', 2, 9),
(70, 'Question', 'Edición', 'Se editó la pregunta \"¿Has utilizado algún servicio municipal en los últimos 6 meses?\".', '2026-08-30 00:46:28', 2, 9),
(71, 'Section', 'Edición', 'Se editó la sección \"Evaluación de servicios municipales\".', '2026-08-30 00:46:29', 2, 9),
(72, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo calificarías la atención recibida en ventanillas?\".', '2026-08-30 00:46:30', 2, 9),
(73, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué servicios municipales has utilizado? (puedes marcar varios)\".', '2026-08-30 00:46:32', 2, 9),
(74, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tan satisfecho estás con la limpieza de calles y espacios públicos?\".', '2026-08-30 00:46:42', 2, 9),
(75, 'Question', 'Edición', 'Se editó la pregunta \"Describe brevemente algún problema que hayas tenido con un servicio municipal.\".', '2026-08-30 00:46:46', 2, 9),
(76, 'Section', 'Edición', 'Se editó la sección \"Comunicación y participación ciudadana\".', '2026-08-30 00:46:48', 2, 9),
(77, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo te enteras de las actividades y servicios del municipio?\".', '2026-08-30 00:46:49', 2, 9),
(78, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué espacios de participación te gustaría involucrarte?\".', '2026-08-30 00:46:55', 2, 9),
(79, 'Question', 'Edición', 'Se editó la pregunta \"¿Sientes que tus opiniones son tomadas en cuenta por el municipio?\".', '2026-08-30 00:47:06', 2, 9),
(80, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué canal de comunicación mejorarías para recibir información municipal?\".', '2026-08-30 00:47:07', 2, 9),
(81, 'Section', 'Edición', 'Se editó la sección \"Sugerencias y comentarios finales\".', '2026-08-30 00:47:08', 2, 9),
(82, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué áreas consideras que necesitan mejora inmediata? (selecciona todas las que apliquen)\".', '2026-08-30 00:47:09', 2, 9),
(83, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-30 00:47:14', 2, 9),
(84, 'Section', 'Edición', 'Se editó la sección \"Información general\".', '2026-08-30 00:47:15', 2, 9),
(85, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué colonia o barrio vives?\".', '2026-08-30 00:47:17', 2, 9),
(86, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tan probable es que recomiendes este municipio como un buen lugar para vivir?\".', '2026-08-30 00:47:18', 2, 9),
(87, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-08-30 00:47:19', 2, 9),
(88, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es tu rango de edad?\".', '2026-08-30 00:47:20', 2, 9),
(89, 'Question', 'Creación', 'Se agregó la pregunta \"Texto largo\".', '2026-08-30 00:47:21', 2, 9),
(90, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es tu nivel educativo?\".', '2026-08-30 00:47:30', 2, 9),
(91, 'Question', 'Edición', 'Se editó la pregunta \"¿Has utilizado algún servicio municipal en los últimos 6 meses?\".', '2026-08-30 00:47:37', 1, 9),
(92, 'Section', 'Edición', 'Se editó la sección \"Evaluación de servicios municipales\".', '2026-08-30 00:47:39', 1, 9),
(93, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo calificarías la atención recibida en ventanillas?\".', '2026-08-30 00:47:41', 1, 9),
(94, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué servicios municipales has utilizado? (puedes marcar varios)\".', '2026-08-30 00:47:42', 1, 9),
(95, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tan satisfecho estás con la limpieza de calles y espacios públicos?\".', '2026-08-30 00:47:47', 1, 9),
(96, 'Question', 'Edición', 'Se editó la pregunta \"Describe brevemente algún problema que hayas tenido con un servicio municipal.\".', '2026-08-30 00:47:48', 1, 9),
(97, 'Section', 'Edición', 'Se editó la sección \"Comunicación y participación ciudadana\".', '2026-08-30 00:47:49', 1, 9),
(98, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo te enteras de las actividades y servicios del municipio?\".', '2026-08-30 00:47:50', 1, 9),
(99, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué espacios de participación te gustaría involucrarte?\".', '2026-08-30 00:47:58', 1, 9),
(100, 'Question', 'Edición', 'Se editó la pregunta \"¿Sientes que tus opiniones son tomadas en cuenta por el municipio?\".', '2026-08-30 00:48:04', 1, 9),
(101, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué canal de comunicación mejorarías para recibir información municipal?\".', '2026-08-30 00:48:05', 1, 9),
(102, 'Section', 'Edición', 'Se editó la sección \"Sugerencias y comentarios finales\".', '2026-08-30 00:48:06', 1, 9),
(103, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué áreas consideras que necesitan mejora inmediata? (selecciona todas las que apliquen)\".', '2026-08-30 00:48:07', 1, 9),
(104, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tan probable es que recomiendes este municipio como un buen lugar para vivir?\".', '2026-08-30 00:48:13', 1, 9),
(105, 'Question', 'Edición', 'Se editó la pregunta \"Texto largo\".', '2026-08-30 00:48:14', 1, 9),
(106, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-08-30 00:49:10', 1, 9),
(107, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-08-30 00:50:54', 2, 9),
(108, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Rechazada\".', '2026-08-30 04:23:17', 1, 7),
(109, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Evaluación de Taller de Capacitación\".', '2026-08-30 04:29:28', 2, 10),
(110, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-08-30 04:33:26', 2, 10),
(111, 'Survey', 'Creación', 'Se creó la encuesta \"Clima organizacional\" a partir de la plantilla \"Clima organizacional\".', '2026-08-30 04:36:59', 1, 11),
(112, 'Survey', 'Creación', 'Se creó la encuesta \"Satisfacción ciudadana\" a partir de la plantilla \"Satisfacción ciudadana\".', '2026-08-30 04:37:44', 1, 12),
(113, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Rechazada\".', '2026-08-30 04:41:47', 1, 10),
(114, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Sección Inicial Principal\".', '2026-08-30 04:49:48', 1, 10),
(115, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-30 04:51:53', 2, 10),
(116, 'Section', 'Edición', 'Se editó la sección \"Sección Inicial Principal\".', '2026-08-30 04:51:54', 2, 10),
(117, 'Section', 'Creación', 'Se agregó la sección \"gh\".', '2026-08-30 04:51:55', 2, 10),
(118, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-30 04:51:58', 2, 10),
(119, 'Section', 'Edición', 'Se editó la sección \"Sección Inicial Principal\".', '2026-08-30 04:51:59', 2, 10),
(120, 'Section', 'Edición', 'Se editó la sección \"gh\".', '2026-08-30 04:51:59', 2, 10),
(121, 'Survey', 'Creación', 'Se creó la encuesta \"Evaluación de eventos\" a partir de la plantilla \"Evaluación de eventos\".', '2026-08-31 00:55:51', 2, 13),
(122, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-31 00:58:31', 2, 13),
(123, 'Section', 'Edición', 'Se editó la sección \"Sección General\".', '2026-08-31 00:58:31', 2, 13),
(124, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué te pareció la organización?\".', '2026-08-31 00:58:32', 2, 13),
(125, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-08-31 00:58:51', 2, 13),
(126, 'Section', 'Edición', 'Se editó la sección \"Sección General\".', '2026-08-31 00:58:51', 2, 13),
(127, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué te pareció la organización?\".', '2026-08-31 00:58:52', 2, 13),
(128, 'Question', 'Creación', 'Se agregó la pregunta \"jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj\".', '2026-08-31 00:58:54', 2, 13),
(129, 'Question', 'Creación', 'Se agregó la pregunta \"llllllllllllllllll\".', '2026-08-31 00:58:55', 2, 13),
(130, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-08-31 00:59:11', 2, 13),
(131, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Sección General\".', '2026-08-31 01:00:13', 1, 13),
(132, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Satisfacción de Servicios 2025\".', '2026-08-31 01:20:11', 1, 14),
(133, 'Survey', 'Creación', 'Se creó la encuesta \"Evaluación del Festival Cultural 2025\".', '2026-08-31 01:20:11', 2, 15),
(134, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Clima Organizacional\".', '2026-08-31 01:20:11', 1, 16),
(135, 'Survey', 'Creación', 'Se creó la encuesta \"Evaluación de Capacitación en Gestión Cultural\".', '2026-08-31 01:20:11', 4, 17),
(136, 'Survey', 'Creación', 'Se creó la encuesta \"Atención al Ciudadano - Anónima\".', '2026-08-31 01:20:11', 5, 18),
(137, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Satisfacción de Biblioteca\".', '2026-08-31 01:20:11', 1, 19),
(138, 'Survey', 'Creación', 'Se creó la encuesta \"Evaluación de Exposición Temporal\".', '2026-08-31 01:20:11', 2, 20),
(139, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Retroalimentación de Taller\".', '2026-08-31 01:20:11', 4, 21),
(140, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Percepción de Seguridad en Museos\".', '2026-08-31 01:20:11', 1, 22),
(141, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Usuarios de Plataforma Digital\".', '2026-08-31 01:20:11', 5, 23),
(142, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Satisfacción de Proveedores\".', '2026-08-31 01:20:11', 1, 24),
(143, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Evaluación de Servicio de Transporte Cultural\".', '2026-08-31 01:20:11', 2, 25),
(144, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Opinión sobre Política Cultural\".', '2026-08-31 01:20:11', 1, 26),
(145, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Ambiente Laboral en Sede Central\".', '2026-08-31 01:20:11', 5, 27),
(146, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Satisfacción con Trámites en Línea\".', '2026-08-31 01:20:11', 1, 28),
(147, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Satisfacción del Personal de Museos\".', '2026-08-31 01:22:00', 1, 29),
(148, 'Survey', 'Creación', 'Se creó la encuesta \"Evaluación de Taller de Danza Folklórica\".', '2026-08-31 01:22:00', 2, 30),
(149, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Impacto del Programa de Becas Artísticas\".', '2026-08-31 01:22:00', 1, 31),
(150, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Clima Laboral en Bibliotecas\".', '2026-08-31 01:22:00', 3, 32),
(151, 'Survey', 'Creación', 'Se creó la encuesta \"Evaluación del Servicio de Cafetería en Teatros\".', '2026-08-31 01:22:00', 4, 33),
(152, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Percepción de la Programación Cultural\".', '2026-08-31 01:22:00', 1, 34),
(153, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Satisfacción de Visitantes del Palacio Nacional\".', '2026-08-31 01:22:00', 2, 35),
(154, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Evaluación de la Orquesta Sinfónica\".', '2026-08-31 01:22:00', 4, 36),
(155, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Opinión sobre la Reforma Cultural\".', '2026-08-31 01:22:00', 1, 37),
(156, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Ambiente Laboral en la Dirección de Teatros\".', '2026-08-31 01:22:00', 4, 38),
(157, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Satisfacción del Servicio de Archivo General\".', '2026-08-31 01:22:00', 3, 39),
(158, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Evaluación de la Escuela Nacional de Música\".', '2026-08-31 01:22:00', 4, 40),
(159, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Impacto de los Centros Culturales\".', '2026-08-31 01:22:00', 2, 41),
(160, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Satisfacción de Usuarios de la Biblioteca Digital\".', '2026-08-31 01:22:00', 3, 42),
(161, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Evaluación del Programa de Formación Artística\".', '2026-08-31 01:22:00', 4, 43),
(162, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Evaluación de Servicios Culturales en Línea\".', '2026-08-31 01:26:24', 1, 44),
(163, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Clima Organizacional Ampliada\".', '2026-08-31 01:26:24', 1, 45),
(164, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Impacto del Programa de Formación Artística\".', '2026-08-31 01:26:24', 4, 46),
(165, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Satisfacción de Visitantes de Museos\".', '2026-08-31 01:26:24', 2, 47),
(166, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta de Evaluación de Eventos Culturales Masivos\".', '2026-08-31 01:26:24', 2, 48),
(167, 'Survey', 'Eliminación', 'Se eliminó la encuesta \"Encuesta de Clima Organizacional\" (ID 16).', '2026-09-16 18:27:51', 1, 16),
(168, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-09-16 18:28:14', 1, 7),
(169, 'Section', 'Edición', 'Se editó la sección \"Sección Inicial Principal\".', '2026-09-16 18:28:15', 1, 7),
(170, 'Section', 'Edición', 'Se editó la sección \"seccion 1\".', '2026-09-16 18:28:16', 1, 7),
(171, 'Question', 'Edición', 'Se editó la pregunta \"cual opcion elige\".', '2026-09-16 18:28:16', 1, 7),
(172, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-09-16 18:53:40', 1, 13),
(173, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-09-16 18:54:18', 1, 13),
(174, 'Section', 'Edición', 'Se editó la sección \"Sección General\".', '2026-09-16 18:54:19', 1, 13),
(175, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué te pareció la organización?\".', '2026-09-16 18:54:20', 1, 13),
(176, 'Question', 'Edición', 'Se editó la pregunta \"jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj\".', '2026-09-16 18:54:23', 1, 13),
(177, 'Question', 'Edición', 'Se editó la pregunta \"llllllllllllllllll\".', '2026-09-16 18:54:24', 1, 13),
(178, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-09-16 18:54:40', 1, 13),
(179, 'Section', 'Edición', 'Se editó la sección \"Sección General\".', '2026-09-16 18:54:41', 1, 13),
(180, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué te pareció la organización?\".', '2026-09-16 18:54:42', 1, 13),
(181, 'Question', 'Edición', 'Se editó la pregunta \"jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj\".', '2026-09-16 18:54:44', 1, 13),
(182, 'Question', 'Edición', 'Se editó la pregunta \"llllllllllllllllll\".', '2026-09-16 18:54:44', 1, 13),
(183, 'Section', 'Creación', 'Se agregó la sección \"kkkkkkkkk\".', '2026-09-16 18:54:45', 1, 13),
(184, 'Question', 'Creación', 'Se agregó la pregunta \"kkkkkkkkk\".', '2026-09-16 18:54:46', 1, 13),
(185, 'Survey', 'Creación', 'Se creó la encuesta \"Horas Sociales Sociales por Encuesta\".', '2026-09-29 03:08:42', 1, 49),
(186, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, el modo anónimo, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-09-29 03:13:27', 1, 49),
(187, 'Section', 'Creación', 'Se agregó la sección \"Relación con la Formación Académica\".', '2026-09-29 03:13:28', 1, 49),
(188, 'Question', 'Creación', 'Se agregó la pregunta \"¿En qué medida las actividades del proyecto te permitieron aplicar los conocimientos técnicos adquiridos en tu carrera?\".', '2026-09-29 03:13:28', 1, 49),
(189, 'Question', 'Creación', 'Se agregó la pregunta \"Menciona al menos una habilidad técnica o blanda que hayas desarrollado o mejorado significativamente gracias a este proyecto.\".', '2026-09-29 03:13:29', 1, 49),
(190, 'Section', 'Creación', 'Se agregó la sección \"Impacto y Desempeño en el Proyecto\".', '2026-09-29 03:13:29', 1, 49),
(191, 'Question', 'Creación', 'Se agregó la pregunta \"¿Consideras que los resultados o entregables de tu proyecto resolvieron una necesidad real de la institución beneficiada?\".', '2026-09-29 03:13:30', 1, 49),
(192, 'Question', 'Creación', 'Se agregó la pregunta \"¿Cuál fue el principal reto o dificultad que enfrentaste durante la ejecución de las horas sociales y cómo lo solucionaste?\".', '2026-09-29 03:13:30', 1, 49),
(193, 'Section', 'Creación', 'Se agregó la sección \"Evaluación del Acompañamiento Institucional\".', '2026-09-29 03:13:30', 1, 49),
(194, 'Question', 'Creación', 'Se agregó la pregunta \"¿Cómo calificas la claridad de las instrucciones y el apoyo brindado por el coordinador o docente encargado durante el proceso?\".', '2026-09-29 03:13:31', 1, 49),
(195, 'Question', 'Creación', 'Se agregó la pregunta \"¿Qué sugerencia específica darías para agilizar o mejorar el proceso de asignación y revisión de las horas sociales para futuros estudiantes?\".', '2026-09-29 03:13:33', 1, 49),
(196, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-09-29 03:13:39', 1, 49),
(197, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-09-29 03:13:42', 1, 49),
(198, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Relación con la Formación Académica\".', '2026-09-29 03:14:15', 1, 49),
(199, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, el modo anónimo, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-09-29 03:15:02', 1, 49),
(200, 'Section', 'Edición', 'Se editó la sección \"Sección Inicial Principal\".', '2026-09-29 03:15:03', 1, 49),
(201, 'Section', 'Edición', 'Se editó la sección \"Relación con la Formación Académica\".', '2026-09-29 03:15:03', 1, 49),
(202, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué medida las actividades del proyecto te permitieron aplicar los conocimientos técnicos adquiridos en tu carrera?\".', '2026-09-29 03:15:04', 1, 49),
(203, 'Question', 'Edición', 'Se editó la pregunta \"Menciona al menos una habilidad técnica o blanda que hayas desarrollado o mejorado significativamente gracias a este proyecto.\".', '2026-09-29 03:15:04', 1, 49),
(204, 'Section', 'Edición', 'Se editó la sección \"Impacto y Desempeño en el Proyecto\".', '2026-09-29 03:15:04', 1, 49),
(205, 'Question', 'Edición', 'Se editó la pregunta \"¿Consideras que los resultados o entregables de tu proyecto resolvieron una necesidad real de la institución beneficiada?\".', '2026-09-29 03:15:05', 1, 49),
(206, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál fue el principal reto o dificultad que enfrentaste durante la ejecución de las horas sociales y cómo lo solucionaste?\".', '2026-09-29 03:15:05', 1, 49),
(207, 'Section', 'Edición', 'Se editó la sección \"Evaluación del Acompañamiento Institucional\".', '2026-09-29 03:15:06', 1, 49),
(208, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo calificas la claridad de las instrucciones y el apoyo brindado por el coordinador o docente encargado durante el proceso?\".', '2026-09-29 03:15:06', 1, 49),
(209, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué sugerencia específica darías para agilizar o mejorar el proceso de asignación y revisión de las horas sociales para futuros estudiantes?\".', '2026-09-29 03:15:08', 1, 49),
(210, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-09-29 03:25:00', 1, 49),
(211, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-09-29 03:25:03', 1, 49),
(212, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"Aprobada\".', '2026-09-29 03:25:08', 1, 49),
(213, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-09-29 03:25:10', 1, 49),
(214, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-09-29 18:19:19', 1, 21),
(215, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-09-29 18:19:23', 1, 21),
(216, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-09-29 18:19:26', 1, 21),
(217, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Portada\".', '2026-09-29 18:19:45', 1, 21),
(218, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Portada\".', '2026-10-05 04:12:02', 1, 37),
(219, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Reforma\".', '2026-10-05 04:26:47', 1, 37),
(220, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Sección General\".', '2026-10-05 17:40:34', 2, 13),
(221, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-10-05 17:40:47', 2, 13),
(222, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-08 03:15:12', 1, 13),
(223, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-10-08 03:15:14', 1, 13),
(224, 'Survey', 'Creación', 'Se creó la encuesta \"Esta es una nueva encuesta\".', '2026-10-08 03:16:32', 1, 50),
(225, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-08 03:16:53', 1, 50),
(226, 'Section', 'Creación', 'Se agregó la sección \"ffffffffffffffffffffffffffffffff\".', '2026-10-08 03:16:54', 1, 50),
(227, 'Question', 'Creación', 'Se agregó la pregunta \"fffffffffffffffffffffffffffffffffffffff\".', '2026-10-08 03:16:54', 1, 50),
(228, 'Section', 'Creación', 'Se agregó la sección \"ffffffffffffff\".', '2026-10-08 03:16:54', 1, 50),
(229, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-08 03:16:57', 1, 50),
(230, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-08 03:17:02', 1, 50),
(231, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-10-08 03:17:03', 1, 50),
(232, 'Template', 'Creación', 'Se guardó la encuesta \"Evaluación Festival Nacional de las Artes 2026\" como plantilla \"Evaluación Festival Nacional de las Artes 2026\".', '2026-10-08 16:09:37', 1, NULL),
(233, 'Template', 'Creación', 'Se guardó la encuesta \"Evaluación de Exposición Temporal\" como plantilla \"Evaluación de Exposición Temporal\".', '2026-10-08 16:09:59', 1, NULL),
(234, 'Survey', 'Creación', 'Se creó la encuesta \"Capacitación\" a partir de la plantilla \"Capacitación\".', '2026-10-08 16:10:19', 1, 51),
(235, 'Template', 'Creación', 'Se guardó la encuesta \"Encuesta de Evaluación de Servicios Culturales en Línea\" como plantilla \"Encuesta de Evaluación de Servicios Culturales en Línea\".', '2026-10-08 16:10:39', 1, NULL),
(236, 'Survey', 'Creación', 'Se creó la encuesta \"Evaluación Festival Nacional de las Artes 2026\" a partir de la plantilla \"Evaluación Festival Nacional de las Artes 2026\".', '2026-10-08 16:11:29', 1, 52),
(237, 'Template', 'Creación', 'Se guardó la encuesta \"Encuesta de Evaluación de Eventos Culturales Masivos\" como plantilla \"Encuesta Nueva\".', '2026-10-08 16:12:12', 1, NULL),
(238, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta Nueva\" a partir de la plantilla \"Encuesta Nueva\".', '2026-10-08 16:12:29', 1, 53),
(239, 'Survey', 'Publicación automática', 'La encuesta \"Clima organizacional\" se publicó automáticamente al llegar su fecha de inicio (2026-08-28 00:00:00).', '2026-10-08 22:08:01', NULL, 11),
(240, 'Survey', 'Publicación automática', 'La encuesta \"Evaluación de Capacitación en Gestión Cultural\" se publicó automáticamente al llegar su fecha de inicio (2025-06-01 00:00:00).', '2026-10-08 22:08:01', NULL, 17),
(241, 'Survey', 'Publicación automática', 'La encuesta \"Encuesta de Opinión sobre Política Cultural\" se publicó automáticamente al llegar su fecha de inicio (2025-09-01 00:00:00).', '2026-10-08 22:08:01', NULL, 26),
(242, 'Survey', 'Publicación automática', 'La encuesta \"Encuesta de Impacto del Programa de Becas Artísticas\" se publicó automáticamente al llegar su fecha de inicio (2025-09-01 00:00:00).', '2026-10-08 22:08:01', NULL, 31),
(243, 'Survey', 'Publicación automática', 'La encuesta \"Encuesta de Impacto del Programa de Formación Artística\" se publicó automáticamente al llegar su fecha de inicio (2025-06-01 00:00:00).', '2026-10-08 22:08:01', NULL, 46),
(244, 'Survey', 'Cierre automático', 'La encuesta \"Clima organizacional 2do semestre\" se cerró automáticamente al vencer su fecha de fin (2026-06-15 00:00:00).', '2026-10-08 22:08:01', NULL, 2),
(245, 'Survey', 'Cierre automático', 'La encuesta \"Solicitudes de Becas 2026\" se cerró automáticamente al vencer su fecha de fin (2026-08-26 00:00:00).', '2026-10-08 22:08:01', NULL, 4),
(246, 'Survey', 'Cierre automático', 'La encuesta \"encuestas 2\" se cerró automáticamente al vencer su fecha de fin (2026-08-26 00:00:00).', '2026-10-08 22:08:01', NULL, 5),
(247, 'Survey', 'Cierre automático', 'La encuesta \"Satisfacción de atención al ciudadano (Copia)\" se cerró automáticamente al vencer su fecha de fin (2026-02-28 00:00:00).', '2026-10-08 22:08:01', NULL, 6),
(248, 'Survey', 'Cierre automático', 'La encuesta \"hhhhhhhhhhhhhhhhhhh\" se cerró automáticamente al vencer su fecha de fin (2026-08-28 00:00:00).', '2026-10-08 22:08:01', NULL, 8),
(249, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Clima Laboral 2026\" se cerró automáticamente al vencer su fecha de fin (2026-08-30 00:00:00).', '2026-10-08 22:08:01', NULL, 9),
(250, 'Survey', 'Cierre automático', 'La encuesta \"Clima organizacional\" se cerró automáticamente al vencer su fecha de fin (2026-08-30 00:00:00).', '2026-10-08 22:08:01', NULL, 11),
(251, 'Survey', 'Cierre automático', 'La encuesta \"Evaluación de eventos\" se cerró automáticamente al vencer su fecha de fin (2026-08-31 00:00:00).', '2026-10-08 22:08:01', NULL, 13),
(252, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Satisfacción de Servicios 2025\" se cerró automáticamente al vencer su fecha de fin (2025-12-31 23:59:59).', '2026-10-08 22:08:01', NULL, 14),
(253, 'Survey', 'Cierre automático', 'La encuesta \"Evaluación de Capacitación en Gestión Cultural\" se cerró automáticamente al vencer su fecha de fin (2025-06-15 23:59:59).', '2026-10-08 22:08:01', NULL, 17),
(254, 'Survey', 'Cierre automático', 'La encuesta \"Atención al Ciudadano - Anónima\" se cerró automáticamente al vencer su fecha de fin (2025-12-31 23:59:59).', '2026-10-08 22:08:01', NULL, 18),
(255, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Satisfacción de Biblioteca\" se cerró automáticamente al vencer su fecha de fin (2025-11-30 23:59:59).', '2026-10-08 22:08:01', NULL, 19),
(256, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Percepción de Seguridad en Museos\" se cerró automáticamente al vencer su fecha de fin (2025-10-31 23:59:59).', '2026-10-08 22:08:01', NULL, 22),
(257, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Evaluación de Servicio de Transporte Cultural\" se cerró automáticamente al vencer su fecha de fin (2025-12-20 23:59:59).', '2026-10-08 22:08:01', NULL, 25),
(258, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Opinión sobre Política Cultural\" se cerró automáticamente al vencer su fecha de fin (2025-09-30 23:59:59).', '2026-10-08 22:08:01', NULL, 26),
(259, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Satisfacción con Trámites en Línea\" se cerró automáticamente al vencer su fecha de fin (2025-12-31 23:59:59).', '2026-10-08 22:08:01', NULL, 28),
(260, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Satisfacción del Personal de Museos\" se cerró automáticamente al vencer su fecha de fin (2025-07-31 23:59:59).', '2026-10-08 22:08:01', NULL, 29),
(261, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Impacto del Programa de Becas Artísticas\" se cerró automáticamente al vencer su fecha de fin (2025-09-30 23:59:59).', '2026-10-08 22:08:01', NULL, 31),
(262, 'Survey', 'Cierre automático', 'La encuesta \"Evaluación del Servicio de Cafetería en Teatros\" se cerró automáticamente al vencer su fecha de fin (2025-12-31 23:59:59).', '2026-10-08 22:08:01', NULL, 33),
(263, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Ambiente Laboral en la Dirección de Teatros\" se cerró automáticamente al vencer su fecha de fin (2025-09-30 23:59:59).', '2026-10-08 22:08:01', NULL, 38),
(264, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Impacto de los Centros Culturales\" se cerró automáticamente al vencer su fecha de fin (2025-10-31 23:59:59).', '2026-10-08 22:08:01', NULL, 41),
(265, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Satisfacción de Usuarios de la Biblioteca Digital\" se cerró automáticamente al vencer su fecha de fin (2025-12-31 23:59:59).', '2026-10-08 22:08:01', NULL, 42),
(266, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Evaluación de Servicios Culturales en Línea\" se cerró automáticamente al vencer su fecha de fin (2025-12-31 23:59:59).', '2026-10-08 22:08:01', NULL, 44),
(267, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Impacto del Programa de Formación Artística\" se cerró automáticamente al vencer su fecha de fin (2025-08-31 23:59:59).', '2026-10-08 22:08:01', NULL, 46),
(268, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de Satisfacción de Visitantes de Museos\" se cerró automáticamente al vencer su fecha de fin (2025-11-30 23:59:59).', '2026-10-08 22:08:01', NULL, 47),
(269, 'Survey', 'Cierre automático', 'La encuesta \"Horas Sociales Sociales por Encuesta\" se cerró automáticamente al vencer su fecha de fin (2026-09-30 00:00:00).', '2026-10-08 22:08:01', NULL, 49),
(270, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta Nueva\" a partir de la plantilla \"Encuesta Nueva\".', '2026-10-08 22:15:36', 1, 54),
(271, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-08 22:18:05', 1, 54),
(272, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-08 22:18:08', 1, 54),
(273, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-10-08 22:18:11', 1, 54),
(274, 'Survey', 'Cambio de estado', 'El estado cambió de \"Publicada / Activa\" a \"Cerrada\".', '2026-10-08 22:22:17', 1, 54),
(275, 'Survey', 'Eliminación', 'Se eliminó la encuesta \"Encuesta Nueva\" (ID 54).', '2026-10-08 22:22:30', 1, 54),
(276, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-08 22:24:03', 1, 53),
(277, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-08 22:24:05', 1, 53),
(278, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-10-08 22:24:07', 1, 53),
(279, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta Nueva\" a partir de la plantilla \"Encuesta Nueva\".', '2026-10-08 22:28:18', 1, 55),
(280, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-08 22:29:08', 1, 55),
(281, 'Section', 'Edición', 'Se editó la sección \"Información previa al evento\".', '2026-10-08 22:29:08', 1, 55),
(282, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo se enteró del evento?\".', '2026-10-08 22:29:08', 1, 55),
(283, 'Question', 'Edición', 'Se editó la pregunta \"¿La información previa fue clara?\".', '2026-10-08 22:29:10', 1, 55),
(284, 'Question', 'Edición', 'Se editó la pregunta \"¿Considera que la difusión del evento fue adecuada?\".', '2026-10-08 22:29:10', 1, 55),
(285, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué medio de difusión le pareció más efectivo?\".', '2026-10-08 22:29:10', 1, 55),
(286, 'Question', 'Edición', 'Se editó la pregunta \"Sugerencias para mejorar la difusión\".', '2026-10-08 22:29:12', 1, 55),
(287, 'Section', 'Edición', 'Se editó la sección \"Logística y organización\".', '2026-10-08 22:29:13', 1, 55),
(288, 'Question', 'Edición', 'Se editó la pregunta \"¿El acceso al evento fue rápido?\".', '2026-10-08 22:29:13', 1, 55),
(289, 'Question', 'Edición', 'Se editó la pregunta \"Califique la organización de las filas y accesos\".', '2026-10-08 22:29:14', 1, 55),
(290, 'Question', 'Edición', 'Se editó la pregunta \"¿Había suficiente personal de seguridad?\".', '2026-10-08 22:29:14', 1, 55),
(291, 'Question', 'Edición', 'Se editó la pregunta \"Califique la limpieza de las instalaciones\".', '2026-10-08 22:29:15', 1, 55),
(292, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué problema logístico encontró?\".', '2026-10-08 22:29:15', 1, 55),
(293, 'Section', 'Edición', 'Se editó la sección \"Contenido y artistas\".', '2026-10-08 22:29:16', 1, 55),
(294, 'Question', 'Edición', 'Se editó la pregunta \"¿El contenido del evento cumplió sus expectativas?\".', '2026-10-08 22:29:16', 1, 55),
(295, 'Question', 'Edición', 'Se editó la pregunta \"Califique la calidad de los artistas\".', '2026-10-08 22:29:16', 1, 55),
(296, 'Question', 'Edición', 'Se editó la pregunta \"¿La duración del evento fue adecuada?\".', '2026-10-08 22:29:17', 1, 55),
(297, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué presentación le gustó más?\".', '2026-10-08 22:29:17', 1, 55),
(298, 'Question', 'Edición', 'Se editó la pregunta \"Comentarios sobre el contenido artístico\".', '2026-10-08 22:29:17', 1, 55),
(299, 'Section', 'Edición', 'Se editó la sección \"Opinión final\".', '2026-10-08 22:29:18', 1, 55),
(300, 'Question', 'Edición', 'Se editó la pregunta \"¿Recomendaría asistir a futuros eventos organizados por el ministerio?\".', '2026-10-08 22:29:18', 1, 55),
(301, 'Question', 'Edición', 'Se editó la pregunta \"Califique su satisfacción general con el evento\".', '2026-10-08 22:29:19', 1, 55),
(302, 'Question', 'Edición', 'Se editó la pregunta \"¿Asistiría nuevamente a un evento similar?\".', '2026-10-08 22:29:19', 1, 55),
(303, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué fue lo más destacado del evento?\".', '2026-10-08 22:29:19', 1, 55),
(304, 'Question', 'Edición', 'Se editó la pregunta \"Comentario final\".', '2026-10-08 22:29:20', 1, 55),
(305, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-08 22:29:22', 1, 55),
(306, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-08 22:29:25', 1, 55),
(307, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-10-08 22:29:26', 1, 55),
(308, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta Nueva\" se cerró automáticamente al vencer su fecha de fin (2026-10-08 16:33:00).', '2026-10-08 22:33:01', NULL, 55),
(309, 'Template', 'Creación', 'Se guardó la encuesta \"Encuesta de Evaluación de Servicios Culturales en Línea\" como plantilla \"Nueva encuesta de prueba\".', '2026-10-10 00:23:30', 1, NULL),
(310, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-10 00:24:01', 1, 56),
(311, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-10 00:25:04', 1, 56),
(312, 'Section', 'Edición', 'Se editó la sección \"Información general del participante\".', '2026-10-10 00:25:05', 1, 56),
(313, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su rango de edad?\".', '2026-10-10 00:25:05', 1, 56),
(314, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué departamento reside?\".', '2026-10-10 00:25:08', 1, 56),
(315, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su nivel educativo?\".', '2026-10-10 00:25:08', 1, 56),
(316, 'Question', 'Edición', 'Se editó la pregunta \"¿Con qué frecuencia asiste a eventos culturales?\".', '2026-10-10 00:25:11', 1, 56),
(317, 'Question', 'Edición', 'Se editó la pregunta \"¿Se considera un usuario habitual de los servicios culturales en línea?\".', '2026-10-10 00:25:13', 1, 56),
(318, 'Section', 'Edición', 'Se editó la sección \"Uso de servicios culturales\".', '2026-10-10 00:25:14', 1, 56),
(319, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tipo de servicios culturales utiliza con más frecuencia?\".', '2026-10-10 00:25:14', 1, 56),
(320, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo se entera de las actividades culturales?\".', '2026-10-10 00:25:17', 1, 56),
(321, 'Question', 'Edición', 'Se editó la pregunta \"¿Utiliza la plataforma digital del ministerio para acceder a eventos?\".', '2026-10-10 00:25:19', 1, 56),
(322, 'Question', 'Edición', 'Se editó la pregunta \"Califique la variedad de la oferta cultural\".', '2026-10-10 00:25:20', 1, 56),
(323, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué obstáculos encuentra para asistir a eventos presenciales?\".', '2026-10-10 00:25:20', 1, 56),
(324, 'Section', 'Edición', 'Se editó la sección \"Evaluación de servicios en línea\".', '2026-10-10 00:25:21', 1, 56),
(325, 'Question', 'Edición', 'Se editó la pregunta \"¿La plataforma en línea es fácil de navegar?\".', '2026-10-10 00:25:21', 1, 56),
(326, 'Question', 'Edición', 'Se editó la pregunta \"Califique la calidad de la transmisión en vivo\".', '2026-10-10 00:25:22', 1, 56),
(327, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué mejoraría de la experiencia en línea?\".', '2026-10-10 00:25:23', 1, 56),
(328, 'Question', 'Edición', 'Se editó la pregunta \"¿Recomendaría el uso de la plataforma a otras personas?\".', '2026-10-10 00:25:25', 1, 56),
(329, 'Question', 'Edición', 'Se editó la pregunta \"Comentarios sobre la plataforma digital\".', '2026-10-10 00:25:26', 1, 56),
(330, 'Section', 'Edición', 'Se editó la sección \"Sugerencias finales\".', '2026-10-10 00:25:26', 1, 56),
(331, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tipo de eventos le gustaría que se ofrecieran más?\".', '2026-10-10 00:25:27', 1, 56),
(332, 'Question', 'Edición', 'Se editó la pregunta \"¿Considera que los precios son accesibles?\".', '2026-10-10 00:25:29', 1, 56),
(333, 'Question', 'Edición', 'Se editó la pregunta \"Califique su satisfacción general con los servicios culturales\".', '2026-10-10 00:25:30', 1, 56),
(334, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué sugerencia principal daría para mejorar?\".', '2026-10-10 00:25:30', 1, 56),
(335, 'Question', 'Edición', 'Se editó la pregunta \"¿Desea agregar algún comentario adicional?\".', '2026-10-10 00:25:31', 1, 56),
(336, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-10 00:25:40', 1, 56),
(337, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Información general del participante\".', '2026-10-10 00:26:05', 1, 56),
(338, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Información general del participante\".', '2026-10-10 00:26:23', 1, 56),
(339, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-10-10 00:26:31', 1, 56);
INSERT INTO `change_logs` (`action_id`, `module`, `action`, `description`, `action_date`, `user_id`, `survey_id`) VALUES
(340, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-10-10 00:26:52', 1, 56),
(341, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-10 00:26:55', 1, 56),
(342, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Publicada / Activa\".', '2026-10-10 00:27:01', 1, 56),
(343, 'Survey', 'Cierre automático', 'La encuesta \"Esta es una nueva encuesta\" se cerró automáticamente al vencer su fecha de fin (2026-10-09 00:00:00).', '2026-10-10 00:41:22', NULL, 50),
(344, 'Survey', 'Cierre automático', 'La encuesta \"Nueva encuesta de prueba\" se cerró automáticamente al vencer su fecha de fin (2026-10-09 18:30:00).', '2026-10-10 00:41:22', NULL, 56),
(345, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-10 15:12:29', 1, 57),
(346, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-10 15:13:52', 1, 57),
(347, 'Section', 'Edición', 'Se editó la sección \"Información general del participante\".', '2026-10-10 15:13:53', 1, 57),
(348, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su rango de edad?\".', '2026-10-10 15:13:53', 1, 57),
(349, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué departamento reside?\".', '2026-10-10 15:13:55', 1, 57),
(350, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su nivel educativo?\".', '2026-10-10 15:13:55', 1, 57),
(351, 'Question', 'Edición', 'Se editó la pregunta \"¿Con qué frecuencia asiste a eventos culturales?\".', '2026-10-10 15:13:57', 1, 57),
(352, 'Question', 'Edición', 'Se editó la pregunta \"¿Se considera un usuario habitual de los servicios culturales en línea?\".', '2026-10-10 15:13:59', 1, 57),
(353, 'Section', 'Edición', 'Se editó la sección \"Uso de servicios culturales\".', '2026-10-10 15:14:00', 1, 57),
(354, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tipo de servicios culturales utiliza con más frecuencia?\".', '2026-10-10 15:14:00', 1, 57),
(355, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo se entera de las actividades culturales?\".', '2026-10-10 15:14:02', 1, 57),
(356, 'Question', 'Edición', 'Se editó la pregunta \"¿Utiliza la plataforma digital del ministerio para acceder a eventos?\".', '2026-10-10 15:14:05', 1, 57),
(357, 'Question', 'Edición', 'Se editó la pregunta \"Califique la variedad de la oferta cultural\".', '2026-10-10 15:14:05', 1, 57),
(358, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué obstáculos encuentra para asistir a eventos presenciales?\".', '2026-10-10 15:14:05', 1, 57),
(359, 'Section', 'Edición', 'Se editó la sección \"Evaluación de servicios en línea\".', '2026-10-10 15:14:06', 1, 57),
(360, 'Question', 'Edición', 'Se editó la pregunta \"¿La plataforma en línea es fácil de navegar?\".', '2026-10-10 15:14:06', 1, 57),
(361, 'Question', 'Edición', 'Se editó la pregunta \"Califique la calidad de la transmisión en vivo\".', '2026-10-10 15:14:06', 1, 57),
(362, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué mejoraría de la experiencia en línea?\".', '2026-10-10 15:14:07', 1, 57),
(363, 'Question', 'Edición', 'Se editó la pregunta \"¿Recomendaría el uso de la plataforma a otras personas?\".', '2026-10-10 15:14:09', 1, 57),
(364, 'Question', 'Edición', 'Se editó la pregunta \"Comentarios sobre la plataforma digital\".', '2026-10-10 15:14:09', 1, 57),
(365, 'Section', 'Eliminación', 'Se eliminó la sección \"Sugerencias finales\".', '2026-10-10 15:14:09', 1, 57),
(366, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-10 15:14:17', 1, 57),
(367, 'Section', 'Edición', 'Se editó la sección \"Información general del participante\".', '2026-10-10 15:14:17', 1, 57),
(368, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su rango de edad?\".', '2026-10-10 15:14:17', 1, 57),
(369, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué departamento reside?\".', '2026-10-10 15:14:19', 1, 57),
(370, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su nivel educativo?\".', '2026-10-10 15:14:19', 1, 57),
(371, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-10 15:15:21', 1, 57),
(372, 'Section', 'Edición', 'Se editó la sección \"Información general del participante\".', '2026-10-10 15:15:21', 1, 57),
(373, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su rango de edad?\".', '2026-10-10 15:15:22', 1, 57),
(374, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué departamento reside?\".', '2026-10-10 15:15:24', 1, 57),
(375, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su nivel educativo?\".', '2026-10-10 15:15:24', 1, 57),
(376, 'Question', 'Edición', 'Se editó la pregunta \"¿Con qué frecuencia asiste a eventos culturales?\".', '2026-10-10 15:15:26', 1, 57),
(377, 'Question', 'Edición', 'Se editó la pregunta \"¿Se considera un usuario habitual de los servicios culturales en línea?\".', '2026-10-10 15:15:28', 1, 57),
(378, 'Section', 'Edición', 'Se editó la sección \"Uso de servicios culturales\".', '2026-10-10 15:15:28', 1, 57),
(379, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tipo de servicios culturales utiliza con más frecuencia?\".', '2026-10-10 15:15:29', 1, 57),
(380, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo se entera de las actividades culturales?\".', '2026-10-10 15:15:31', 1, 57),
(381, 'Question', 'Edición', 'Se editó la pregunta \"¿Utiliza la plataforma digital del ministerio para acceder a eventos?\".', '2026-10-10 15:15:34', 1, 57),
(382, 'Question', 'Edición', 'Se editó la pregunta \"Califique la variedad de la oferta cultural\".', '2026-10-10 15:15:35', 1, 57),
(383, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué obstáculos encuentra para asistir a eventos presenciales?\".', '2026-10-10 15:15:35', 1, 57),
(384, 'Section', 'Edición', 'Se editó la sección \"Evaluación de servicios en línea\".', '2026-10-10 15:15:36', 1, 57),
(385, 'Question', 'Edición', 'Se editó la pregunta \"¿La plataforma en línea es fácil de navegar?\".', '2026-10-10 15:15:36', 1, 57),
(386, 'Question', 'Edición', 'Se editó la pregunta \"Califique la calidad de la transmisión en vivo\".', '2026-10-10 15:15:37', 1, 57),
(387, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué mejoraría de la experiencia en línea?\".', '2026-10-10 15:15:37', 1, 57),
(388, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-10 15:15:39', 1, 57),
(389, 'Section', 'Edición', 'Se editó la sección \"Información general del participante\".', '2026-10-10 15:15:40', 1, 57),
(390, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su rango de edad?\".', '2026-10-10 15:15:41', 1, 57),
(391, 'Question', 'Edición', 'Se editó la pregunta \"¿Recomendaría el uso de la plataforma a otras personas?\".', '2026-10-10 15:15:41', 1, 57),
(392, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-10 15:16:21', 1, 57),
(393, 'Section', 'Edición', 'Se editó la sección \"Información general del participante\".', '2026-10-10 15:16:21', 1, 57),
(394, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su rango de edad?\".', '2026-10-10 15:16:21', 1, 57),
(395, 'Question', 'Edición', 'Se editó la pregunta \"¿En qué departamento reside?\".', '2026-10-10 15:16:23', 1, 57),
(396, 'Question', 'Edición', 'Se editó la pregunta \"¿Cuál es su nivel educativo?\".', '2026-10-10 15:16:23', 1, 57),
(397, 'Question', 'Edición', 'Se editó la pregunta \"¿Con qué frecuencia asiste a eventos culturales?\".', '2026-10-10 15:16:25', 1, 57),
(398, 'Question', 'Edición', 'Se editó la pregunta \"¿Se considera un usuario habitual de los servicios culturales en línea?\".', '2026-10-10 15:16:27', 1, 57),
(399, 'Section', 'Edición', 'Se editó la sección \"Uso de servicios culturales\".', '2026-10-10 15:16:27', 1, 57),
(400, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué tipo de servicios culturales utiliza con más frecuencia?\".', '2026-10-10 15:16:28', 1, 57),
(401, 'Question', 'Edición', 'Se editó la pregunta \"¿Cómo se entera de las actividades culturales?\".', '2026-10-10 15:16:30', 1, 57),
(402, 'Question', 'Edición', 'Se editó la pregunta \"¿Utiliza la plataforma digital del ministerio para acceder a eventos?\".', '2026-10-10 15:16:32', 1, 57),
(403, 'Question', 'Edición', 'Se editó la pregunta \"Califique la variedad de la oferta cultural\".', '2026-10-10 15:16:32', 1, 57),
(404, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué obstáculos encuentra para asistir a eventos presenciales?\".', '2026-10-10 15:16:33', 1, 57),
(405, 'Section', 'Edición', 'Se editó la sección \"Evaluación de servicios en línea\".', '2026-10-10 15:16:33', 1, 57),
(406, 'Question', 'Edición', 'Se editó la pregunta \"¿La plataforma en línea es fácil de navegar?\".', '2026-10-10 15:16:34', 1, 57),
(407, 'Question', 'Edición', 'Se editó la pregunta \"Califique la calidad de la transmisión en vivo\".', '2026-10-10 15:16:34', 1, 57),
(408, 'Question', 'Edición', 'Se editó la pregunta \"¿Qué mejoraría de la experiencia en línea?\".', '2026-10-10 15:16:34', 1, 57),
(409, 'Question', 'Edición', 'Se editó la pregunta \"¿Recomendaría el uso de la plataforma a otras personas?\".', '2026-10-10 15:16:36', 1, 57),
(410, 'Question', 'Edición', 'Se editó la pregunta \"Comentarios sobre la plataforma digital\".', '2026-10-10 15:16:37', 1, 57),
(411, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-10 15:16:41', 1, 57),
(412, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-10 15:16:45', 1, 57),
(413, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Programada\".', '2026-10-10 15:16:49', 1, 57),
(414, 'Survey', 'Publicación automática', 'La encuesta \"Nueva encuesta para probar\" se publicó automáticamente al llegar su fecha de inicio (2026-10-10 09:19:00).', '2026-10-10 15:19:12', NULL, 57),
(415, 'Survey', 'Cierre automático', 'La encuesta \"Nueva encuesta para probar\" se cerró automáticamente al vencer su fecha de fin (2026-10-10 09:22:00).', '2026-10-10 15:22:27', NULL, 57),
(416, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-10 15:52:03', 1, 58),
(417, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-10 15:52:45', 1, 58),
(418, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-10 15:52:46', 1, 58),
(419, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-10 15:52:51', 1, 58),
(420, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-10 15:52:53', 1, 58),
(421, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Programada\".', '2026-10-10 15:52:55', 1, 58),
(422, 'Survey', 'Publicación automática', 'La encuesta \"Nueva encuesta de prueba\" se publicó automáticamente al llegar su fecha de inicio (2026-10-10 09:54:00).', '2026-10-10 15:55:34', NULL, 58),
(423, 'Survey', 'Cierre automático', 'La encuesta \"Nueva encuesta de prueba\" se cerró automáticamente al vencer su fecha de fin (2026-10-10 09:58:00).', '2026-10-10 15:58:27', NULL, 58),
(424, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-10 16:02:32', 1, 59),
(425, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-10 16:03:37', 1, 59),
(426, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-10 16:03:38', 1, 59),
(427, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-10 16:03:46', 1, 59),
(428, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-10 16:03:58', 1, 59),
(429, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Programada\".', '2026-10-10 16:04:00', 1, 59),
(430, 'Survey', 'Publicación automática', 'La encuesta \"Nueva encuesta con daniel\" se publicó automáticamente al llegar su fecha de inicio (2026-10-10 10:05:00).', '2026-10-10 16:05:16', NULL, 59),
(431, 'Survey', 'Cierre automático', 'La encuesta \"Nueva encuesta con daniel\" se cerró automáticamente al vencer su fecha de fin (2026-10-10 10:07:00).', '2026-10-10 16:07:35', NULL, 59),
(432, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-12 15:19:14', 2, 60),
(433, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-12 15:20:30', 2, 60),
(434, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-12 15:20:31', 2, 60),
(435, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-12 15:20:33', 2, 60),
(436, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Información general del participante\".', '2026-10-12 15:21:15', 1, 60),
(437, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-10-12 15:21:30', 1, 60),
(438, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"Aprobada\".', '2026-10-12 15:21:48', 1, 60),
(439, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Programada\".', '2026-10-12 15:21:58', 2, 60),
(440, 'Survey', 'Publicación automática', 'La encuesta \"Nueva encuesta de prueba\" se publicó automáticamente al llegar su fecha de inicio (2026-10-12 09:22:00).', '2026-10-12 15:22:07', NULL, 60),
(441, 'Survey', 'Cierre automático', 'La encuesta \"Nueva encuesta de prueba\" se cerró automáticamente al vencer su fecha de fin (2026-10-12 09:25:00).', '2026-10-12 15:25:06', NULL, 60),
(442, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-12 15:40:09', 2, 61),
(443, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-12 15:41:27', 2, 61),
(444, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-12 15:41:27', 2, 61),
(445, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-12 15:41:33', 2, 61),
(446, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Información general del participante\".', '2026-10-12 15:42:21', 1, 61),
(447, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-10-12 15:42:30', 1, 61),
(448, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-10-12 15:42:52', 2, 61),
(449, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-12 15:43:09', 1, 61),
(450, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Programada\".', '2026-10-12 15:43:23', 2, 61),
(451, 'Survey', 'Publicación automática', 'La encuesta \"Encuesta de día lunes\" se publicó automáticamente al llegar su fecha de inicio (2026-10-12 09:45:00).', '2026-10-12 15:45:36', NULL, 61),
(452, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta de día lunes\" se cerró automáticamente al vencer su fecha de fin (2026-10-12 09:50:00).', '2026-10-12 15:53:25', NULL, 61),
(453, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-12 19:54:03', 2, 62),
(454, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-12 19:56:19', 2, 62),
(455, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-12 19:56:21', 2, 62),
(456, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-12 19:56:30', 2, 62),
(457, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Uso de servicios culturales\".', '2026-10-12 19:58:07', 1, 62),
(458, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-10-12 19:58:20', 1, 62),
(459, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-10-12 20:00:28', 2, 62),
(460, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-12 20:01:01', 1, 62),
(461, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Activa\".', '2026-10-12 20:01:17', 2, 62),
(462, 'Survey', 'Cierre automático', 'La encuesta \"Nueva encuesta de prueba para el día de hoy\" se cerró automáticamente al vencer su fecha de fin (2026-10-12 14:05:00).', '2026-10-12 20:05:51', NULL, 62),
(463, 'Survey', 'Creación', 'Se creó la encuesta \"Diagnóstico de bibliotecas\" a partir de la plantilla \"Diagnóstico de bibliotecas\".', '2026-10-12 21:42:11', 1, 63),
(464, 'Survey', 'Creación', 'Se creó la encuesta \"Encuesta Nueva\" a partir de la plantilla \"Encuesta Nueva\".', '2026-10-12 21:54:51', 2, 64),
(465, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-12 21:56:33', 1, 65),
(466, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-12 21:59:42', 2, 64),
(467, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-12 21:59:43', 2, 64),
(468, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-12 21:59:45', 2, 64),
(469, 'Template', 'Creación', 'Se guardó la encuesta \"encuestas 2\" como plantilla \"encuestas 2\".', '2026-10-12 22:18:06', 1, NULL),
(470, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-12 22:36:08', 1, 66),
(471, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-12 22:37:22', 2, 67),
(472, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-12 22:38:59', 2, 67),
(473, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-12 22:39:00', 2, 67),
(474, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-12 22:39:02', 2, 67),
(475, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Evaluación de servicios en línea\".', '2026-10-12 22:39:50', 1, 67),
(476, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-12 22:40:21', 2, 67),
(477, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-12 22:40:21', 2, 67),
(478, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-12 22:40:34', 2, 67),
(479, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-12 22:40:35', 2, 67),
(480, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-10-12 22:40:49', 1, 67),
(481, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-10-12 22:41:02', 2, 67),
(482, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-12 22:41:13', 1, 67),
(483, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Activa\".', '2026-10-12 22:41:20', 2, 67),
(484, 'Template', 'Creación', 'Se guardó la encuesta \"HOLA ESTA ES UNA ENCUESTA\" como plantilla \"HOLA ESTA ES UNA ENCUESTA\".', '2026-10-12 22:41:50', 2, NULL),
(485, 'Survey', 'Creación', 'Se creó la encuesta \"HOLA ESTA ES UNA ENCUESTA\" a partir de la plantilla \"HOLA ESTA ES UNA ENCUESTA\".', '2026-10-13 03:02:03', 2, 68),
(486, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-13 03:03:06', 2, 68),
(487, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-13 03:03:07', 2, 68),
(488, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-13 03:03:11', 2, 68),
(489, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Evaluación de servicios en línea\".', '2026-10-13 03:07:18', 1, 68),
(490, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-10-13 03:07:38', 1, 68),
(491, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-10-13 03:07:47', 2, 68),
(492, 'Survey', 'Cierre automático', 'La encuesta \"HOLA ESTA ES UNA ENCUESTA\" se cerró automáticamente al vencer su fecha de fin (2026-10-12 16:47:00).', '2026-10-13 03:14:13', NULL, 67),
(493, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-13 03:14:59', 2, 69),
(494, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-13 03:16:57', 2, 69),
(495, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Información general del participante\".', '2026-10-13 03:17:49', 1, 69),
(496, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-10-13 03:18:16', 1, 69),
(497, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-10-13 03:18:35', 2, 69),
(498, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-13 03:18:50', 1, 69),
(499, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Activa\".', '2026-10-13 03:19:02', 2, 69),
(500, 'Survey', 'Cierre automático', 'La encuesta \"Nueva encuesta de prueba\" se cerró automáticamente al vencer su fecha de fin (2026-10-12 00:00:00).', '2026-10-13 03:19:11', NULL, 69),
(501, 'Survey', 'Creación', 'Se creó la encuesta \"Nueva encuesta de prueba\" a partir de la plantilla \"Nueva encuesta de prueba\".', '2026-10-13 03:22:58', 2, 70),
(502, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-13 03:24:50', 2, 70),
(503, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio y la fecha de fin.', '2026-10-13 03:24:57', 2, 70),
(504, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-13 03:24:58', 2, 70),
(505, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio, la fecha de fin y la dependencia.', '2026-10-13 03:25:24', 1, 70),
(506, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-13 03:25:26', 1, 70),
(507, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Información general del participante\".', '2026-10-13 03:26:01', 1, 70),
(508, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Corregida\".', '2026-10-13 03:26:30', 1, 70),
(509, 'Survey', 'Cambio de estado', 'El estado cambió de \"Corregida\" a \"En revisión\".', '2026-10-13 03:26:49', 2, 70),
(510, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio, la fecha de fin y la dependencia.', '2026-10-13 03:27:01', 1, 70),
(511, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-13 03:27:02', 1, 70),
(512, 'Survey', 'Cambio de estado', 'El estado cambió de \"En revisión\" a \"Aprobada\".', '2026-10-13 03:27:07', 1, 70),
(513, 'Survey', 'Cambio de estado', 'El estado cambió de \"Aprobada\" a \"Programada\".', '2026-10-13 03:27:16', 2, 70),
(514, 'Survey', 'Publicación automática', 'La encuesta \"Encuesta 2 ---2026 --noche\" se publicó automáticamente al llegar su fecha de inicio (2026-10-12 21:30:00).', '2026-10-13 03:30:34', NULL, 70),
(515, 'Survey', 'Cierre automático', 'La encuesta \"Encuesta 2 ---2026 --noche\" se cerró automáticamente al vencer su fecha de fin (2026-10-12 21:33:00).', '2026-10-13 03:33:02', NULL, 70),
(516, 'Template', 'Creación', 'Se guardó la encuesta \"Encuesta 2 ---2026 --noche\" como plantilla \"Encuesta 2 ---2026 --noche\".', '2026-10-13 03:34:49', 2, NULL),
(517, 'Survey', 'Creación', 'Se creó la encuesta \"Evaluación de eventos\" a partir de la plantilla \"Evaluación de eventos\".', '2026-10-15 02:40:05', 1, 71),
(518, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio, la fecha de fin y la dependencia.', '2026-10-15 02:40:39', 1, 71),
(519, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-15 02:40:40', 1, 71),
(520, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio, la fecha de fin y la dependencia.', '2026-10-15 02:40:42', 1, 71),
(521, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-15 02:40:42', 1, 71),
(522, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio, la fecha de fin y la dependencia.', '2026-10-15 02:44:42', 1, 71),
(523, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-15 02:44:42', 1, 71),
(524, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-15 02:44:42', 1, 71),
(525, 'Survey', 'Creación', 'Se creó la encuesta \"Clima organizacional\" a partir de la plantilla \"Clima organizacional\".', '2026-10-15 02:45:05', 1, 72),
(526, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio, la fecha de fin y la dependencia.', '2026-10-15 02:45:20', 1, 72),
(527, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-15 02:45:21', 1, 72),
(528, 'Survey', 'Edición', 'Se actualizaron el título, la descripción, la restricción de respuesta única, la privacidad de los encuestados, la categoría, el tipo de acceso, la fecha de inicio, la fecha de fin y la dependencia.', '2026-10-15 02:45:23', 1, 72),
(529, 'Survey', 'Edición de estructura', 'Se actualizaron las secciones y preguntas de la encuesta.', '2026-10-15 02:45:24', 1, 72),
(530, 'Survey', 'Cambio de estado', 'El estado cambió de \"Borrador\" a \"En revisión\".', '2026-10-15 02:45:24', 1, 72),
(531, 'SectionComment', 'Comentario agregado', 'Se agregó un comentario de corrección en la sección \"Portada\".', '2026-10-17 15:44:00', 1, 45);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `department`
--

CREATE TABLE `department` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `department_name` varchar(255) NOT NULL,
  `min_dpto` varchar(255) NOT NULL,
  `may_dpto` varchar(255) NOT NULL,
  `cod_dpto` varchar(255) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `department`
--

INSERT INTO `department` (`id`, `department_name`, `min_dpto`, `may_dpto`, `cod_dpto`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Ahuachapán', 'Ahuachapan', 'AHUACHAPAN', '01', NULL, NULL, NULL),
(2, 'Santa Ana', 'Santa Ana', 'SANTA ANA', '02', NULL, NULL, NULL),
(3, 'Sonsonate', 'Sonsonate', 'SONSONATE', '03', NULL, NULL, NULL),
(4, 'Chalatenango', 'Chalatenango', 'CHALATENANGO', '04', NULL, NULL, NULL),
(5, 'La Libertad', 'La Libertad', 'LA LIBERTAD', '05', NULL, NULL, NULL),
(6, 'San Salvador', 'San Salvador', 'SAN SALVADOR', '06', NULL, NULL, NULL),
(7, 'Cuscatlán', 'Cuscatlan', 'CUSCATLAN', '07', NULL, NULL, NULL),
(8, 'La Paz', 'La Paz', 'LA PAZ', '08', NULL, NULL, NULL),
(9, 'Cabañas', 'Cabañas', 'CABAÑAS', '09', NULL, NULL, NULL),
(10, 'San Vicente', 'San Vicente', 'SAN VICENTE', '10', NULL, NULL, NULL),
(11, 'Usulután', 'Usulutan', 'USULUTAN', '11', NULL, NULL, NULL),
(12, 'San Miguel', 'San Miguel', 'SAN MIGUEL', '12', NULL, NULL, NULL),
(13, 'Morazán', 'Morazan', 'MORAZAN', '13', NULL, NULL, NULL),
(14, 'La Unión', 'La Union', 'LA UNION', '14', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `email_notifications`
--

CREATE TABLE `email_notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `destination_email` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pendiente',
  `sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `survey_id` bigint(20) UNSIGNED NOT NULL,
  `participant_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `email_notifications`
--

INSERT INTO `email_notifications` (`id`, `destination_email`, `subject`, `status`, `sent_at`, `created_at`, `survey_id`, `participant_id`) VALUES
(1, 'luis.portillo@cultura.gob.sv', 'Invitación a encuesta institucional', 'pendiente', NULL, '2026-08-25 00:01:14', 2, 1),
(2, 'mario.cruz@cultura.gob.sv', 'Invitación a encuesta institucional', 'pendiente', NULL, '2026-08-25 00:01:47', 2, 2),
(3, 'diana.flores@cultura.gob.sv', 'Invitación a encuesta institucional', 'pendiente', NULL, '2026-08-25 00:01:47', 2, 3),
(4, 'luis.portillo@cultura.gob.sv', 'Invitación a encuesta institucional', 'fallido', NULL, '2026-08-25 00:17:22', 4, 4),
(5, 'mario.cruz@cultura.gob.sv', 'Invitación a encuesta institucional', 'fallido', NULL, '2026-08-25 00:29:02', 4, 5),
(6, 'diana.flores@cultura.gob.sv', 'Invitación a encuesta institucional', 'fallido', NULL, '2026-08-25 00:29:22', 4, 6),
(7, 'carlos@cultura.gob.sv', 'Invitación a encuesta institucional', 'fallido', NULL, '2026-08-25 00:29:48', 4, 7),
(8, 'luis.portillo@cultura.gob.sv', 'Invitación a encuesta institucional', 'pendiente', NULL, '2026-08-30 00:51:11', 9, 10),
(9, 'pedro.sanchez@mail.com', 'Invitación a encuesta', 'enviado', '2026-08-31 01:20:11', '2026-08-31 01:20:11', 14, 11),
(10, 'roberto.diaz@mail.com', 'Invitación a encuesta', 'pendiente', NULL, '2026-08-31 01:20:11', 15, 13),
(11, 'gabriela.torres@cultura.gob', 'Invitación a encuesta interna', 'enviado', '2026-08-31 01:20:11', '2026-08-31 01:20:11', 27, 27),
(12, 'ricardo.salazar@cultura.gob', 'Invitación a encuesta institucional', 'enviado', '2026-08-31 01:22:00', '2026-08-31 01:22:00', 29, 29),
(13, 'fernando.rojas@mail.com', 'Invitación a encuesta pública', 'pendiente', NULL, '2026-08-31 01:22:00', 30, 31),
(14, 'monica.fuentes@mail.com', 'Invitación a encuesta cultural', 'enviado', '2026-08-31 01:22:00', '2026-08-31 01:22:00', 34, 35),
(15, 'alberto.rivas@mail.com', 'Invitación a encuesta de servicios culturales', 'enviado', '2026-08-31 01:26:24', '2026-08-31 01:26:24', 44, 46),
(16, 'daniela.alvarado@cultura.gob', 'Invitación a encuesta de clima organizacional', 'enviado', '2026-08-31 01:26:24', '2026-08-31 01:26:24', 45, 48),
(17, 'fabiola.castro@mail.com', 'Invitación a encuesta de formación artística', 'pendiente', NULL, '2026-08-31 01:26:24', 46, 50),
(18, 'carlos@gmail.com', 'Invitación a encuesta institucional', 'pendiente', NULL, '2026-09-29 03:25:50', 49, 56);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `extend`
--

CREATE TABLE `extend` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` varchar(255) NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `groups`
--

CREATE TABLE `groups` (
  `group_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `dependency_id` bigint(20) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `group_participants`
--

CREATE TABLE `group_participants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `external_email` varchar(255) DEFAULT NULL,
  `group_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` smallint(5) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `material`
--

CREATE TABLE `material` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000001_create_cache_table', 1),
(2, '0001_01_01_000002_create_jobs_table', 1),
(3, '2014_03_22_140358_create_roles_table', 1),
(4, '2014_10_12_000000_create_users_table', 1),
(5, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(6, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(7, '2023_04_16_132227_create_departments_table', 1),
(8, '2024_08_22_145613_create_brand_table', 1),
(9, '2024_08_22_145618_create_model_table', 1),
(10, '2024_08_22_145645_create_ubication_table', 1),
(11, '2024_08_22_145658_create_type_table', 1),
(12, '2024_08_22_145706_create_extend_table', 1),
(13, '2024_08_22_145717_create_material_table', 1),
(14, '2024_08_22_145803_create_resource_table', 1),
(15, '2024_08_22_145943_create_supplier_table', 1),
(16, '2024_08_22_145957_create_movement_table', 1),
(17, '2024_08_22_150006_create_movement_detail_table', 1),
(18, '2025_01_01_000001_create_organizational_units_table', 1),
(19, '2025_01_01_000002_create_survey_roles_table', 1),
(20, '2025_01_01_000003_create_survey_users_table', 1),
(21, '2025_01_01_000004_create_verifications_table', 1),
(22, '2025_01_01_000005_create_session_logs_table', 1),
(23, '2025_01_01_000006_create_change_logs_table', 1),
(24, '2025_01_01_000007_create_survey_categories_table', 1),
(25, '2025_01_01_000008_create_types_table', 1),
(26, '2025_01_01_000009_create_statuses_table', 1),
(27, '2025_01_01_000010_create_templates_table', 1),
(28, '2025_01_01_000011_create_surveys_table', 1),
(29, '2025_01_01_000012_create_sections_table', 1),
(30, '2025_01_01_000013_add_section_foreign_key_to_surveys_table', 1),
(31, '2025_01_01_000014_create_questions_table', 1),
(32, '2025_01_01_000015_create_question_options_table', 1),
(33, '2025_01_01_000016_create_groups_table', 1),
(34, '2025_01_01_000017_create_group_participants_table', 1),
(35, '2025_01_01_000018_create_participants_table', 1),
(36, '2025_01_01_000019_create_email_notifications_table', 1),
(37, '2025_01_01_000020_create_qr_codes_table', 1),
(38, '2025_01_01_000021_create_responses_table', 1),
(39, '2025_01_01_000022_create_multiple_choise_responses_table', 1),
(40, '2025_02_01_000001_add_soft_deletes_to_admin_tables', 1),
(41, '2026_08_09_000001_add_slug_to_statuses_table', 1),
(42, '2026_08_14_211525_add_slug_and_soft_deletes_to_encuestas_tables', 1),
(43, '2026_08_23_000001_add_permissions_to_survey_roles_table', 1),
(44, '2026_08_23_000002_add_survey_id_to_change_logs_table', 1),
(45, '2026_08_24_000001_create_section_comments_table', 2),
(46, '2026_08_25_000001_add_max_length_to_questions_table', 3),
(47, '2026_09_05_112622_add_type_to_sections_table', 4),
(48, '2026_09_28_000001_add_is_anonymous_to_surveys_table', 4),
(49, '2026_09_28_000002_add_performance_indexes', 4),
(50, '2026_10_06_000001_replace_is_anonymous_with_anonymity_mode', 5),
(51, '2026_10_07_000001_add_template_section_name_to_questions_table', 6),
(52, '2026_10_12_000001_add_dependency_category_to_templates', 7),
(53, '2026_10_12_000002_create_survey_notifications_table', 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `model`
--

CREATE TABLE `model` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `brand_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movement`
--

CREATE TABLE `movement` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `num_invoice` varchar(255) NOT NULL,
  `total_cost` double NOT NULL,
  `description` varchar(255) NOT NULL,
  `observation` varchar(255) NOT NULL,
  `movement_type` varchar(255) NOT NULL,
  `date_movement` timestamp NULL DEFAULT NULL,
  `supplier_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movement_detail`
--

CREATE TABLE `movement_detail` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quanty` int(11) NOT NULL,
  `unit_cost` double NOT NULL,
  `sub_total_item` double NOT NULL,
  `resource_id` bigint(20) UNSIGNED NOT NULL,
  `movement_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `multiple_choise_responses`
--

CREATE TABLE `multiple_choise_responses` (
  `response_id` bigint(20) UNSIGNED NOT NULL,
  `question_option_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `multiple_choise_responses`
--

INSERT INTO `multiple_choise_responses` (`response_id`, `question_option_id`) VALUES
(7, 14),
(10, 23),
(10, 24),
(12, 28),
(13, 32),
(16, 39),
(19, 42),
(20, 45),
(20, 46),
(28, 61),
(28, 62),
(32, 62),
(32, 63),
(36, 65),
(40, 67),
(44, 69),
(48, 68),
(52, 72),
(52, 73),
(56, 74),
(61, 76),
(65, 77),
(84, 93),
(88, 94),
(97, 97),
(100, 99),
(104, 100),
(104, 101),
(108, 102),
(112, 104),
(116, 106),
(118, 109),
(130, 112),
(139, 123),
(139, 124),
(143, 127),
(143, 128),
(147, 129),
(155, 131),
(157, 138),
(158, 141),
(160, 144),
(160, 146),
(161, 149),
(161, 151),
(167, 154),
(167, 155),
(170, 160),
(175, 133),
(177, 139),
(178, 142),
(180, 145),
(180, 147),
(181, 150),
(187, 156),
(190, 161),
(203, 164),
(208, 168),
(208, 169),
(213, 173),
(223, 165),
(228, 169),
(228, 171),
(233, 172),
(236, 177),
(237, 181),
(237, 183),
(243, 185),
(256, 178),
(257, 182),
(263, 186),
(276, 191),
(277, 196),
(277, 197),
(278, 199),
(296, 190),
(297, 194),
(298, 200),
(315, 202),
(315, 205),
(318, 207),
(335, 203),
(338, 208),
(359, 212),
(361, 282),
(364, 286),
(381, 324),
(383, 327),
(384, 335),
(386, 336),
(387, 343),
(393, 346),
(396, 352),
(401, 358),
(403, 360),
(404, 366),
(406, 370),
(407, 374),
(413, 379),
(416, 422),
(418, 426),
(419, 432),
(421, 435),
(422, 443),
(428, 445),
(431, 489),
(433, 492),
(434, 498),
(436, 502),
(437, 507),
(441, 521),
(443, 525),
(444, 530),
(446, 534),
(447, 539),
(453, 544),
(456, 550),
(461, 718),
(463, 722),
(464, 727),
(466, 731),
(467, 737),
(473, 741),
(476, 746);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `organizational_units`
--

CREATE TABLE `organizational_units` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `organizational_units`
--

INSERT INTO `organizational_units` (`id`, `name`, `code`, `description`, `status`, `parent_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Despacho Ministerial de Cultura', 'DM', NULL, 1, NULL, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(2, 'Dirección General Ejecutiva', 'DGE', NULL, 1, 1, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(3, 'Oficial de Cumplimiento', 'OC', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(4, 'Dirección General de Multiculturalidad', 'DGMC', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(5, 'Dirección General de Proyectos de Inversión e Infraestructura', 'DGPII', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(6, 'Dirección General de Planificación y Desarrollo Institucional', 'DGPDI', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(7, 'Dirección General de Informática y Sistemas', 'DGIS', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(8, 'Dirección General Ambiental', 'DGAM', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(9, 'Dirección General de Relaciones Internacionales y Cooperación', 'DGRIC', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(10, 'Dirección General Financiera Institucional', 'DGFI', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(11, 'Dirección General de Asuntos Jurídicos', 'DGAJ', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(12, 'Unidad de Género', 'UG', NULL, 1, 11, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(13, 'Dirección General de Auditoría Interna', 'DGAI', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(14, 'Dirección General de Comunicaciones Institucionales', 'DGCI', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(15, 'Dirección General de Administración', 'DGAD', NULL, 1, 2, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(16, 'Unidad de Talento Humano', 'UTH', NULL, 1, 15, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(17, 'Unidad de Activo Fijo', 'UAF', NULL, 1, 15, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(18, 'Unidad de Compras Públicas', 'UCP', NULL, 1, 15, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(19, 'Unidad de Logística', 'ULOG', NULL, 1, 15, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(20, 'Unidad de Acceso a la Información Pública', 'UAIP', NULL, 1, 15, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(21, 'Unidad de Gestión Documental y Archivos', 'UGDA', NULL, 1, 15, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(22, 'Biblioteca Nacional de El Salvador', 'BINAES', NULL, 1, 1, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(23, 'Bibliotecas', 'BIB', NULL, 1, 22, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(24, 'Editorial El Salvador', 'EES', NULL, 1, 22, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(25, 'Archivo General de la Nación', 'AGN', NULL, 1, 22, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(26, 'Dirección Nacional de Artes', 'DNA', NULL, 1, 1, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(27, 'Dirección de Teatros', 'DT', NULL, 1, 26, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(28, 'Teatro Nacional de San Salvador', 'TNSS', NULL, 1, 27, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(29, 'Teatro Nacional de Santa Ana', 'TNSA', NULL, 1, 27, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(30, 'Teatro Nacional Francisco Gavidia de San Miguel', 'TNFG', NULL, 1, 27, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(31, 'Teatro Presidente', 'TP', NULL, 1, 27, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(32, 'Programación Cultural', 'PC', NULL, 1, 27, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(33, 'Ballet Nacional de El Salvador', 'BNES', NULL, 1, 26, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(34, 'Ballet Folklórico Nacional', 'BFN', NULL, 1, 26, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(35, 'Compañía Nacional de Danza', 'CND', NULL, 1, 26, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(36, 'Orquesta Sinfónica de El Salvador', 'OSES', NULL, 1, 26, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(37, 'Dirección Nacional de Formación en Artes', 'DNFA', NULL, 1, 1, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(38, 'Escuela Nacional de Música', 'ENM', NULL, 1, 37, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(39, 'Coro El Salvador', 'CES', NULL, 1, 37, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(40, 'Banda El Salvador', 'BES', NULL, 1, 37, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(41, 'Escuela Nacional de Danza Morena Celarié', 'ENDMC', NULL, 1, 37, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(42, 'Centro Nacional de Artes (CENAR)', 'CENAR', NULL, 1, 37, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(43, 'Centros de Formación en Artes', 'CFA', NULL, 1, 37, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(44, 'Dirección Nacional de Espacios Culturales', 'DNEC', NULL, 1, 1, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(45, 'Dirección de Museos y Salas de Exposiciones', 'DMSE', NULL, 1, 44, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(46, 'Museo Nacional de Antropología Dr. David J. Guzmán', 'MUNA', NULL, 1, 45, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(47, 'Museo de Historia Natural de El Salvador', 'MUHNES', NULL, 1, 45, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(48, 'Museo Regional de Occidente', 'MRO', NULL, 1, 45, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(49, 'Museo Regional de Oriente', 'MRTE', NULL, 1, 45, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(50, 'Centro de Memorias El Mozote', 'CMEM', NULL, 1, 45, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(51, 'Salas de Exposiciones', 'SE', NULL, 1, 45, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(52, 'Dirección de Centros Culturales', 'DCC', NULL, 1, 44, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(53, 'Centros Culturales', 'CC', NULL, 1, 52, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(54, 'Palacio Nacional', 'PN', NULL, 1, 52, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(55, 'Ex Casa Presidencial', 'ECP', NULL, 1, 52, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(56, 'Dirección Nacional de Patrimonio Cultural', 'DNPC', NULL, 1, 1, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(57, 'Dirección de Antropología Cultural', 'DAC', NULL, 1, 56, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(58, 'Unidad de Investigaciones Antropológicas', 'UIAN', NULL, 1, 57, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(59, 'Dirección de Conservación de Bienes Culturales Muebles', 'DCBCM', NULL, 1, 56, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(60, 'Dirección de Registro de Bienes Culturales', 'DRBC', NULL, 1, 56, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(61, 'Dirección de Arqueología', 'DARQ', NULL, 1, 56, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(62, 'Unidad de Investigación Arqueológica', 'UIA', NULL, 1, 61, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(63, 'Unidad de Parques y Sitios Arqueológicos', 'UPSA', NULL, 1, 61, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(64, 'Dirección de Asistencia Técnica en Patrimonio Edificado y Contexto Urbano', 'DATPECU', NULL, 1, 56, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL),
(65, 'Unidad de Inventarios de Bienes Culturales Inmuebles', 'UIBCI', NULL, 1, 64, '2026-08-24 23:56:00', '2026-08-24 23:56:00', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `participants`
--

CREATE TABLE `participants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('anonimo','identificado','invitado') NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `access_token` char(36) DEFAULT NULL,
  `invitation_status` varchar(255) DEFAULT NULL,
  `registered_at` timestamp NULL DEFAULT NULL,
  `responded_at` timestamp NULL DEFAULT NULL,
  `survey_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `participants`
--

INSERT INTO `participants` (`id`, `type`, `name`, `email`, `phone`, `access_token`, `invitation_status`, `registered_at`, `responded_at`, `survey_id`) VALUES
(1, 'invitado', NULL, 'luis.portillo@cultura.gob.sv', NULL, 'c7deaa18-4eb4-4eaf-a3ce-f17977fa3c60', 'pendiente', '2026-08-25 00:01:12', NULL, 2),
(2, 'invitado', NULL, 'mario.cruz@cultura.gob.sv', NULL, '5a20789f-6efe-4f06-87dc-5af6ea598863', 'pendiente', '2026-08-25 00:01:47', NULL, 2),
(3, 'invitado', NULL, 'diana.flores@cultura.gob.sv', NULL, '1eea46b2-fff5-408c-a92e-723c70ae4016', 'pendiente', '2026-08-25 00:01:47', NULL, 2),
(4, 'invitado', NULL, 'luis.portillo@cultura.gob.sv', NULL, 'c94671f4-7579-42cf-911f-43168bad58ce', 'respondido', '2026-08-25 00:17:22', '2026-08-25 00:21:38', 4),
(5, 'invitado', NULL, 'mario.cruz@cultura.gob.sv', NULL, 'ab7de5e6-329c-4845-a699-31d054b71cc1', 'pendiente', '2026-08-25 00:29:02', NULL, 4),
(6, 'invitado', NULL, 'diana.flores@cultura.gob.sv', NULL, '5ce0ea2e-013f-48bb-8f19-1ccc685b42c3', 'respondido', '2026-08-25 00:29:22', '2026-08-25 00:32:31', 4),
(7, 'invitado', NULL, 'carlos@cultura.gob.sv', NULL, 'b00f851c-f178-4123-bd8f-1718b41319b6', 'respondido', '2026-08-25 00:29:48', '2026-08-25 00:30:47', 4),
(8, 'anonimo', NULL, NULL, NULL, '9694f25a-7577-4527-824e-9fe930cdff6c', NULL, '2026-08-25 00:39:33', '2026-08-25 00:39:33', 5),
(9, 'anonimo', NULL, NULL, NULL, '1c3c54a2-40a7-4bfb-8eec-aff8fe8102da', NULL, '2026-08-27 20:34:57', '2026-08-27 20:35:00', 8),
(10, 'invitado', NULL, 'luis.portillo@cultura.gob.sv', NULL, '688c6d37-3a4a-426a-a37a-a8ba09e129ba', 'respondido', '2026-08-30 00:51:09', '2026-08-30 00:53:19', 9),
(11, 'identificado', 'Pedro Sánchez', 'pedro.sanchez@mail.com', '555-1234', '1c79afa0-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 14),
(12, 'identificado', 'Lucía Fernández', 'lucia.fernandez@mail.com', NULL, '1c79c4aa-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 14),
(13, 'identificado', 'Roberto Díaz', 'roberto.diaz@mail.com', '555-5678', '1c79c5d3-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 15),
(14, 'invitado', NULL, 'invitado1@mail.com', NULL, '1c79c6e9-a4da-11f1-ae23-b00cd12c59f9', 'enviado', '2026-08-31 01:20:11', NULL, 15),
(15, 'anonimo', NULL, NULL, NULL, '1c79c7f2-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 18),
(16, 'anonimo', NULL, NULL, NULL, '1c79c8c6-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 18),
(17, 'identificado', 'Carmen Ruiz', 'carmen.ruiz@mail.com', NULL, '1c79c997-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 19),
(18, 'identificado', 'Jorge Herrera', 'jorge.herrera@mail.com', NULL, '1c79ca6a-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 19),
(19, 'identificado', 'Isabel Castro', 'isabel.castro@mail.com', NULL, '1c79cb3a-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 20),
(20, 'identificado', 'Andrés Morales', 'andres.morales@mail.com', NULL, '1c79cbf1-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 20),
(21, 'identificado', 'Patricia Vega', 'patricia.vega@mail.com', NULL, '1c79ccc2-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 22),
(22, 'identificado', 'Mario Ríos', 'mario.rios@mail.com', NULL, '1c79cd96-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 22),
(23, 'identificado', 'Silvia Paredes', 'silvia.paredes@mail.com', NULL, '1c79ce67-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 25),
(24, 'identificado', 'Raúl Soto', 'raul.soto@mail.com', NULL, '1c79cf2b-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 25),
(25, 'identificado', 'Elena Núñez', 'elena.nunez@mail.com', NULL, '1c79cfeb-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 28),
(26, 'identificado', 'Diego Salas', 'diego.salas@mail.com', NULL, '1c79d0ae-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 28),
(27, 'identificado', 'Gabriela Torres', 'gabriela.torres@cultura.gob', NULL, '1c79d172-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 27),
(28, 'identificado', 'Hugo Campos', 'hugo.campos@cultura.gob', NULL, '1c79d24f-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:20:11', '2026-08-31 01:20:11', 27),
(29, 'identificado', 'Ricardo Salazar', 'ricardo.salazar@cultura.gob', NULL, '5dc62da3-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 29),
(30, 'identificado', 'Verónica Pineda', 'veronica.pineda@cultura.gob', NULL, '5dc65893-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 29),
(31, 'identificado', 'Fernando Rojas', 'fernando.rojas@mail.com', '555-1111', '5dc6598c-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 30),
(32, 'identificado', 'Gloria Martínez', 'gloria.martinez@mail.com', NULL, '5dc65a28-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 30),
(33, 'identificado', 'Alejandro Vargas', 'alejandro.vargas@mail.com', NULL, '5dc65ac3-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 33),
(34, 'invitado', NULL, 'invitado.cafeteria@mail.com', NULL, '5dc65b8c-a4da-11f1-ae23-b00cd12c59f9', 'enviado', '2026-08-31 01:22:00', NULL, 33),
(35, 'identificado', 'Mónica Fuentes', 'monica.fuentes@mail.com', NULL, '5dc65c23-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 34),
(36, 'identificado', 'Julio César', 'julio.cesar@mail.com', NULL, '5dc65ca2-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 35),
(37, 'identificado', 'Rosa Elvira', 'rosa.elvira@mail.com', NULL, '5dc65d23-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 35),
(38, 'identificado', 'Manuel Sorto', 'manuel.sorto@mail.com', NULL, '5dc65dd8-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 36),
(39, 'identificado', 'Carolina Paz', 'carolina.paz@mail.com', NULL, '5dc65e7f-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 38),
(40, 'identificado', 'Esteban Guzmán', 'esteban.guzman@cultura.gob', NULL, '5dc65f2c-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 39),
(41, 'identificado', 'Lorena Castillo', 'lorena.castillo@mail.com', NULL, '5dc65fe6-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 41),
(42, 'identificado', 'Óscar Torres', 'oscar.torres@mail.com', NULL, '5dc66079-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 42),
(43, 'identificado', 'Patricia Salas', 'patricia.salas@mail.com', NULL, '5dc71bb2-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 42),
(44, 'identificado', 'Rafael Menjívar', 'rafael.menjivar@cultura.gob', NULL, '5dc71ca5-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 43),
(45, 'identificado', 'Sonia López', 'sonia.lopez@cultura.gob', NULL, '5dc71d2f-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:22:00', '2026-08-31 01:22:00', 43),
(46, 'identificado', 'Alberto Rivas', 'alberto.rivas@mail.com', NULL, 'fabb3aa3-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 44),
(47, 'identificado', 'Cecilia Gómez', 'cecilia.gomez@mail.com', NULL, 'fabb3ca5-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 44),
(48, 'identificado', 'Daniela Alvarado', 'daniela.alvarado@cultura.gob', NULL, 'fabb3d23-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 45),
(49, 'identificado', 'Ernesto Solís', 'ernesto.solis@cultura.gob', NULL, 'fabb3d8d-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 45),
(50, 'identificado', 'Fabiola Castro', 'fabiola.castro@mail.com', NULL, 'fabb3de9-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 46),
(51, 'identificado', 'Gustavo Mejía', 'gustavo.mejia@mail.com', NULL, 'fabb3e3d-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 46),
(52, 'identificado', 'Hilda Ramos', 'hilda.ramos@mail.com', NULL, 'fabb3e87-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 47),
(53, 'identificado', 'Ignacio Fuentes', 'ignacio.fuentes@mail.com', NULL, 'fabb3f35-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 47),
(54, 'identificado', 'Julia Herrera', 'julia.herrera@mail.com', NULL, 'fabb3fbf-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 48),
(55, 'identificado', 'Kevin López', 'kevin.lopez@mail.com', NULL, 'fabb4032-a4da-11f1-ae23-b00cd12c59f9', NULL, '2026-08-31 01:26:24', '2026-08-31 01:26:24', 48),
(56, 'invitado', 'Carlos Francisco Hernández Villalta', 'carlos@gmail.com', '76087547', '6d00c08b-9fc1-4892-90b6-d86483006f8b', 'respondido', '2026-09-29 03:25:50', '2026-09-29 03:26:46', 49),
(57, 'identificado', 'hhhh', 'c4rtlosvo@gmail.com', '4444', 'e44d46cf-76ae-46c8-bd77-e89835dfbeaf', NULL, '2026-10-08 22:31:48', '2026-10-08 22:31:49', 55),
(58, 'identificado', 'Carlos Francisco Hernández Villalta', 'c4rlosvillalta19@gmail.com', '76087547', '431134dc-524b-4004-92e8-e2d4937dcb33', NULL, '2026-10-10 00:29:56', '2026-10-10 00:29:56', 56),
(59, 'anonimo', NULL, NULL, NULL, '6ac5ab35-6485-48ea-ada7-54b756bfbc28', NULL, '2026-10-10 15:19:55', '2026-10-10 15:19:57', 57),
(60, 'anonimo', NULL, NULL, NULL, '2272dd1e-8e61-49fd-b289-afae674746ed', NULL, '2026-10-10 16:06:16', '2026-10-10 16:06:19', 59),
(61, 'anonimo', NULL, NULL, NULL, '55757348-4792-4d08-b57b-cb9d8c7d5895', NULL, '2026-10-12 15:46:22', '2026-10-12 15:46:24', 61),
(62, 'anonimo', NULL, NULL, NULL, '35d43855-9e3e-4974-b8fb-17fdfa4b6bae', NULL, '2026-10-12 20:03:10', '2026-10-12 20:03:12', 62),
(63, 'anonimo', NULL, NULL, NULL, 'c3530593-b7b6-4228-a411-d897d4dfd919', NULL, '2026-10-13 03:31:47', '2026-10-13 03:31:51', 70);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `qr_codes`
--

CREATE TABLE `qr_codes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `public_url` varchar(255) NOT NULL,
  `generated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `survey_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `qr_codes`
--

INSERT INTO `qr_codes` (`id`, `public_url`, `generated_at`, `survey_id`) VALUES
(1, 'http://localhost:5173/survey/14/answer', '2026-08-31 01:20:11', 14),
(2, 'https://encuestas.cultura.gob/responder/def456', '2026-08-31 01:20:11', 18),
(3, 'https://encuestas.cultura.gob/responder/ghi789', '2026-08-31 01:20:11', 19),
(4, 'https://encuestas.cultura.gob/responder/jkl012', '2026-08-31 01:20:11', 22),
(5, 'https://encuestas.cultura.gob/responder/mno345', '2026-08-31 01:20:11', 25),
(6, 'https://encuestas.cultura.gob/responder/pqr678', '2026-08-31 01:20:11', 28),
(7, 'https://encuestas.cultura.gob/responder/qr29', '2026-08-31 01:22:00', 29),
(8, 'https://encuestas.cultura.gob/responder/qr30', '2026-08-31 01:22:00', 30),
(9, 'https://encuestas.cultura.gob/responder/qr33', '2026-08-31 01:22:00', 33),
(10, 'https://encuestas.cultura.gob/responder/qr34', '2026-08-31 01:22:00', 34),
(11, 'https://encuestas.cultura.gob/responder/qr35', '2026-08-31 01:22:00', 35),
(12, 'https://encuestas.cultura.gob/responder/qr36', '2026-08-31 01:22:00', 36),
(13, 'https://encuestas.cultura.gob/responder/qr41', '2026-08-31 01:22:00', 41),
(14, 'https://encuestas.cultura.gob/responder/qr42', '2026-08-31 01:22:00', 42),
(15, 'https://encuestas.cultura.gob/responder/qr44', '2026-08-31 01:26:24', 44),
(16, 'https://encuestas.cultura.gob/responder/qr47', '2026-08-31 01:26:24', 47),
(17, 'https://encuestas.cultura.gob/responder/qr48', '2026-08-31 01:26:24', 48),
(18, 'http://localhost:5173/survey/61/answer', '2026-10-12 15:45:43', 61),
(19, 'http://localhost:5173/survey/62/answer', '2026-10-12 20:01:46', 62);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `questions`
--

CREATE TABLE `questions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `statement` text NOT NULL,
  `type` enum('texto','opcion_unica','opcion_multiple','escala','si_no','casilla') NOT NULL,
  `is_mandatory` tinyint(1) NOT NULL DEFAULT 0,
  `max_length` int(10) UNSIGNED DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `section_id` bigint(20) UNSIGNED DEFAULT NULL,
  `template_id` bigint(20) UNSIGNED DEFAULT NULL,
  `template_section_name` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `questions`
--

INSERT INTO `questions` (`id`, `statement`, `type`, `is_mandatory`, `max_length`, `sort_order`, `section_id`, `template_id`, `template_section_name`, `deleted_at`) VALUES
(1, 'Nombre completo', 'texto', 1, NULL, 1, 1, NULL, NULL, NULL),
(2, 'Género', 'opcion_unica', 1, NULL, 2, 1, NULL, NULL, NULL),
(3, 'Calificación general del festival (1-5)', 'escala', 1, NULL, 3, 2, NULL, NULL, NULL),
(4, '¿Cómo calificarías la comunicación interna?', 'escala', 1, NULL, 1, 3, NULL, NULL, NULL),
(5, '¿Recomendarías la institución como lugar de trabajo?', 'si_no', 0, NULL, 2, 3, NULL, NULL, NULL),
(6, '¿Cómo fue la amabilidad del personal?', 'opcion_multiple', 1, NULL, 1, 4, NULL, NULL, NULL),
(7, '¿Qué te pareció la organización?', 'opcion_unica', 1, NULL, 1, NULL, 1, NULL, NULL),
(8, '¿Cómo calificarías el liderazgo de tu jefe?', 'escala', 1, NULL, 1, NULL, 2, NULL, NULL),
(9, '¿Tienes las herramientas necesarias para tu trabajo?', 'si_no', 0, NULL, 2, NULL, 2, NULL, NULL),
(10, '¿El servicio cumplió con tus expectativas?', 'opcion_multiple', 1, NULL, 1, NULL, 3, NULL, NULL),
(11, '¿Cómo valoras la variedad de libros?', 'texto', 0, NULL, 1, NULL, 4, NULL, NULL),
(12, '¿Recomendarías este curso a otros?', 'si_no', 1, NULL, 1, NULL, 5, NULL, NULL),
(13, '¿Le entregaron en tiempo y forma la beca?', 'si_no', 1, NULL, 1, 6, NULL, NULL, NULL),
(14, 'responda si o no', 'si_no', 1, NULL, 2, 6, NULL, NULL, NULL),
(15, 'cual opcion elige', 'opcion_unica', 1, NULL, 1, 8, NULL, NULL, NULL),
(16, '¿Cómo fue la amabilidad del personal?', 'opcion_multiple', 1, NULL, 1, 9, NULL, NULL, NULL),
(17, 'cual opcion elige', 'opcion_unica', 1, NULL, 1, 11, NULL, NULL, NULL),
(18, 'ffffffffffffffffffffff', 'texto', 0, NULL, 1, 13, NULL, NULL, NULL),
(19, 'fdfffffffffff', 'texto', 0, NULL, 1, 14, NULL, NULL, NULL),
(20, 'hdhdhdhhdhd', 'opcion_multiple', 1, NULL, 1, 15, NULL, NULL, NULL),
(21, '¿En qué colonia o barrio vives?', 'texto', 1, NULL, 1, 17, NULL, NULL, NULL),
(22, '¿Cuál es tu rango de edad?', 'opcion_unica', 1, NULL, 2, 17, NULL, NULL, NULL),
(23, '¿Cuál es tu nivel educativo?', 'opcion_unica', 1, NULL, 3, 17, NULL, NULL, NULL),
(24, '¿Has utilizado algún servicio municipal en los últimos 6 meses?', 'si_no', 1, NULL, 4, 17, NULL, NULL, NULL),
(25, '¿Cómo calificarías la atención recibida en ventanillas?', 'escala', 1, NULL, 1, 18, NULL, NULL, NULL),
(26, '¿Qué servicios municipales has utilizado? (puedes marcar varios)', 'opcion_multiple', 1, NULL, 2, 18, NULL, NULL, NULL),
(27, '¿Qué tan satisfecho estás con la limpieza de calles y espacios públicos?', 'escala', 1, NULL, 3, 18, NULL, NULL, NULL),
(28, 'Describe brevemente algún problema que hayas tenido con un servicio municipal.', 'texto', 1, NULL, 4, 18, NULL, NULL, NULL),
(29, '¿Cómo te enteras de las actividades y servicios del municipio?', 'opcion_unica', 0, NULL, 1, 19, NULL, NULL, NULL),
(30, '¿En qué espacios de participación te gustaría involucrarte?', 'opcion_multiple', 0, NULL, 2, 19, NULL, NULL, NULL),
(31, '¿Sientes que tus opiniones son tomadas en cuenta por el municipio?', 'si_no', 0, NULL, 3, 19, NULL, NULL, NULL),
(32, '¿Qué canal de comunicación mejorarías para recibir información municipal?', 'texto', 0, NULL, 4, 19, NULL, NULL, NULL),
(33, '¿Qué áreas consideras que necesitan mejora inmediata? (selecciona todas las que apliquen)', 'casilla', 0, NULL, 1, 20, NULL, NULL, NULL),
(34, '¿Qué tan probable es que recomiendes este municipio como un buen lugar para vivir?', 'escala', 0, NULL, 2, 20, NULL, NULL, NULL),
(35, 'Texto largo', 'texto', 1, NULL, 3, 20, NULL, NULL, NULL),
(36, '¿Cómo calificarías el liderazgo de tu jefe?', 'escala', 1, NULL, 1, 22, NULL, NULL, NULL),
(37, '¿Tienes las herramientas necesarias para tu trabajo?', 'si_no', 0, NULL, 2, 22, NULL, NULL, NULL),
(38, '¿El servicio cumplió con tus expectativas?', 'opcion_multiple', 1, NULL, 1, 23, NULL, NULL, NULL),
(39, '¿Qué te pareció la organización?', 'opcion_unica', 1, NULL, 1, 25, NULL, NULL, NULL),
(40, 'jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj', 'texto', 1, 150, 2, 25, NULL, NULL, NULL),
(41, 'llllllllllllllllll', 'texto', 1, 1000, 3, 25, NULL, NULL, NULL),
(42, '¿Cómo califica la amabilidad del personal?', 'escala', 1, NULL, 1, 27, NULL, NULL, NULL),
(43, '¿El servicio fue rápido?', 'si_no', 1, NULL, 2, 27, NULL, NULL, NULL),
(44, '¿Qué servicios utilizó?', 'opcion_multiple', 0, NULL, 3, 27, NULL, NULL, NULL),
(45, '¿Tiene algún comentario adicional?', 'texto', 0, NULL, 4, 27, NULL, NULL, NULL),
(46, '¿Cómo califica la organización del evento?', 'escala', 1, NULL, 1, 29, NULL, NULL, NULL),
(47, '¿Qué le pareció la calidad de los artistas?', 'escala', 1, NULL, 2, 29, NULL, NULL, NULL),
(48, '¿Recomendaría este festival?', 'opcion_unica', 1, NULL, 3, 29, NULL, NULL, NULL),
(49, 'Sugerencias para próximas ediciones', 'texto', 0, NULL, 4, 29, NULL, NULL, NULL),
(50, '¿Se siente valorado en su equipo?', 'si_no', 1, NULL, 1, 31, NULL, NULL, NULL),
(51, '¿Cómo evalúa la comunicación con su jefe directo?', 'escala', 1, NULL, 2, 31, NULL, NULL, NULL),
(52, '¿Qué mejoraría del ambiente laboral?', 'texto', 0, NULL, 3, 31, NULL, NULL, NULL),
(53, '¿El contenido fue relevante para su trabajo?', 'si_no', 1, NULL, 1, 33, NULL, NULL, NULL),
(54, 'Califique la claridad del material', 'escala', 1, NULL, 2, 33, NULL, NULL, NULL),
(55, '¿Qué temas le gustaría profundizar?', 'texto', 0, NULL, 3, 33, NULL, NULL, NULL),
(56, '¿Cómo califica la atención recibida?', 'escala', 1, NULL, 1, 35, NULL, NULL, NULL),
(57, '¿El personal le brindó información clara?', 'si_no', 1, NULL, 2, 35, NULL, NULL, NULL),
(58, '¿Qué área visitó?', 'opcion_unica', 0, NULL, 3, 35, NULL, NULL, NULL),
(59, 'Comentarios o sugerencias', 'texto', 0, NULL, 4, 35, NULL, NULL, NULL),
(60, '¿Cómo califica la disponibilidad de libros?', 'escala', 1, NULL, 1, 37, NULL, NULL, NULL),
(61, '¿El personal de biblioteca fue atento?', 'si_no', 1, NULL, 2, 37, NULL, NULL, NULL),
(62, '¿Qué servicios utiliza con más frecuencia?', 'opcion_multiple', 0, NULL, 3, 37, NULL, NULL, NULL),
(63, 'Sugerencias para la biblioteca', 'texto', 0, NULL, 4, 37, NULL, NULL, NULL),
(64, '¿La exposición cumplió sus expectativas?', 'si_no', 1, NULL, 1, 39, NULL, NULL, NULL),
(65, 'Califique la iluminación de las obras', 'escala', 1, NULL, 2, 39, NULL, NULL, NULL),
(66, '¿Qué obra le gustó más?', 'texto', 0, NULL, 3, 39, NULL, NULL, NULL),
(67, '¿Recomendaría esta exposición?', 'opcion_unica', 1, NULL, 4, 39, NULL, NULL, NULL),
(68, '¿El taller fue de su agrado?', 'si_no', 1, NULL, 1, 41, NULL, NULL, NULL),
(69, 'Califique la calidad del instructor', 'escala', 1, NULL, 2, 41, NULL, NULL, NULL),
(70, '¿Qué aprendió en el taller?', 'texto', 0, NULL, 3, 41, NULL, NULL, NULL),
(71, '¿Volvería a participar?', 'opcion_unica', 1, NULL, 4, 41, NULL, NULL, NULL),
(72, '¿Se sintió seguro durante su visita?', 'si_no', 1, NULL, 1, 43, NULL, NULL, NULL),
(73, 'Califique la visibilidad del personal de seguridad', 'escala', 1, NULL, 2, 43, NULL, NULL, NULL),
(74, '¿Observó salidas de emergencia claramente señalizadas?', 'si_no', 1, NULL, 3, 43, NULL, NULL, NULL),
(75, 'Comentarios sobre seguridad', 'texto', 0, NULL, 4, 43, NULL, NULL, NULL),
(76, '¿La plataforma es fácil de usar?', 'si_no', 1, NULL, 1, 45, NULL, NULL, NULL),
(77, 'Califique la velocidad de carga', 'escala', 1, NULL, 2, 45, NULL, NULL, NULL),
(78, '¿Qué funciones utiliza más?', 'opcion_multiple', 0, NULL, 3, 45, NULL, NULL, NULL),
(79, 'Sugerencias de mejora', 'texto', 0, NULL, 4, 45, NULL, NULL, NULL),
(80, '¿Cómo califica la puntualidad del proveedor?', 'escala', 1, NULL, 1, 47, NULL, NULL, NULL),
(81, '¿La calidad del servicio fue la esperada?', 'si_no', 1, NULL, 2, 47, NULL, NULL, NULL),
(82, 'Comentarios sobre el proveedor', 'texto', 0, NULL, 3, 47, NULL, NULL, NULL),
(83, '¿El transporte fue puntual?', 'si_no', 1, NULL, 1, 49, NULL, NULL, NULL),
(84, 'Califique la comodidad del vehículo', 'escala', 1, NULL, 2, 49, NULL, NULL, NULL),
(85, '¿El conductor fue amable?', 'si_no', 1, NULL, 3, 49, NULL, NULL, NULL),
(86, 'Sugerencias para el servicio de transporte', 'texto', 0, NULL, 4, 49, NULL, NULL, NULL),
(87, '¿Está de acuerdo con la nueva política cultural?', 'opcion_unica', 1, NULL, 1, 51, NULL, NULL, NULL),
(88, '¿Qué aspectos considera más importantes?', 'opcion_multiple', 0, NULL, 2, 51, NULL, NULL, NULL),
(89, 'Comentarios sobre la política', 'texto', 0, NULL, 3, 51, NULL, NULL, NULL),
(90, '¿Se siente motivado en su trabajo?', 'si_no', 1, NULL, 1, 53, NULL, NULL, NULL),
(91, 'Califique el ambiente de trabajo', 'escala', 1, NULL, 2, 53, NULL, NULL, NULL),
(92, '¿Qué cambiaría del clima laboral?', 'texto', 0, NULL, 3, 53, NULL, NULL, NULL),
(93, '¿Los trámites en línea son fáciles de realizar?', 'si_no', 1, NULL, 1, 55, NULL, NULL, NULL),
(94, 'Califique la claridad de las instrucciones', 'escala', 1, NULL, 2, 55, NULL, NULL, NULL),
(95, '¿Qué trámite realizó?', 'opcion_unica', 0, NULL, 3, 55, NULL, NULL, NULL),
(96, 'Sugerencias para mejorar los trámites', 'texto', 0, NULL, 4, 55, NULL, NULL, NULL),
(97, '¿Cómo califica el ambiente de trabajo en su museo?', 'escala', 1, NULL, 1, 57, NULL, NULL, NULL),
(98, '¿Qué aspecto considera más importante para mejorar?', 'opcion_unica', 1, NULL, 2, 57, NULL, NULL, NULL),
(99, 'Comentarios adicionales', 'texto', 0, NULL, 3, 57, NULL, NULL, NULL),
(100, '¿El taller cumplió sus expectativas?', 'si_no', 1, NULL, 1, 59, NULL, NULL, NULL),
(101, 'Califique la calidad del instructor', 'escala', 1, NULL, 2, 59, NULL, NULL, NULL),
(102, '¿Qué aspectos del taller le gustaron más?', 'opcion_multiple', 0, NULL, 3, 59, NULL, NULL, NULL),
(103, 'Sugerencias para futuros talleres', 'texto', 0, NULL, 4, 59, NULL, NULL, NULL),
(104, '¿La beca le permitió dedicarse a su arte?', 'si_no', 1, NULL, 1, 61, NULL, NULL, NULL),
(105, '¿Cómo califica el apoyo recibido?', 'escala', 1, NULL, 2, 61, NULL, NULL, NULL),
(106, '¿Qué mejoraría del programa de becas?', 'texto', 0, NULL, 3, 61, NULL, NULL, NULL),
(107, '¿Se siente valorado en su trabajo?', 'si_no', 1, NULL, 1, 63, NULL, NULL, NULL),
(108, 'Califique la comunicación con su supervisor', 'escala', 1, NULL, 2, 63, NULL, NULL, NULL),
(109, '¿Qué cambiaría del ambiente laboral?', 'texto', 0, NULL, 3, 63, NULL, NULL, NULL),
(110, '¿Cómo califica la calidad de los alimentos?', 'escala', 1, NULL, 1, 65, NULL, NULL, NULL),
(111, '¿El precio le parece adecuado?', 'si_no', 1, NULL, 2, 65, NULL, NULL, NULL),
(112, '¿Qué productos consume con más frecuencia?', 'opcion_multiple', 0, NULL, 3, 65, NULL, NULL, NULL),
(113, 'Sugerencias para la cafetería', 'texto', 0, NULL, 4, 65, NULL, NULL, NULL),
(114, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 1, 67, NULL, NULL, NULL),
(115, '¿Cómo califica la variedad de la programación?', 'escala', 1, NULL, 2, 67, NULL, NULL, NULL),
(116, '¿Qué tipo de eventos le gustaría ver más?', 'texto', 0, NULL, 3, 67, NULL, NULL, NULL),
(117, '¿La visita guiada fue informativa?', 'si_no', 1, NULL, 1, 69, NULL, NULL, NULL),
(118, 'Califique la atención del guía', 'escala', 1, NULL, 2, 69, NULL, NULL, NULL),
(119, '¿Qué parte del Palacio le impresionó más?', 'texto', 0, NULL, 3, 69, NULL, NULL, NULL),
(120, '¿El concierto cumplió sus expectativas?', 'si_no', 1, NULL, 1, 71, NULL, NULL, NULL),
(121, 'Califique la interpretación musical', 'escala', 1, NULL, 2, 71, NULL, NULL, NULL),
(122, '¿Qué obra le gustó más?', 'texto', 0, NULL, 3, 71, NULL, NULL, NULL),
(123, '¿Recomendaría asistir a la orquesta?', 'opcion_unica', 1, NULL, 4, 71, NULL, NULL, NULL),
(124, '¿Está de acuerdo con la reforma propuesta?', 'opcion_unica', 1, NULL, 1, 73, NULL, NULL, NULL),
(125, '¿Qué áreas deberían priorizarse?', 'opcion_multiple', 0, NULL, 2, 73, NULL, NULL, NULL),
(126, 'Comentarios adicionales', 'texto', 0, NULL, 3, 73, NULL, NULL, NULL),
(127, '¿Se siente motivado en su trabajo?', 'si_no', 1, NULL, 1, 75, NULL, NULL, NULL),
(128, 'Califique el ambiente de trabajo', 'escala', 1, NULL, 2, 75, NULL, NULL, NULL),
(129, '¿Qué cambiaría del clima laboral?', 'texto', 0, NULL, 3, 75, NULL, NULL, NULL),
(130, '¿El servicio de archivo fue eficiente?', 'si_no', 1, NULL, 1, 77, NULL, NULL, NULL),
(131, 'Califique la atención del personal', 'escala', 1, NULL, 2, 77, NULL, NULL, NULL),
(132, 'Sugerencias para el archivo', 'texto', 0, NULL, 3, 77, NULL, NULL, NULL),
(133, '¿La formación recibida es de calidad?', 'si_no', 1, NULL, 1, 79, NULL, NULL, NULL),
(134, 'Califique la calidad de los docentes', 'escala', 1, NULL, 2, 79, NULL, NULL, NULL),
(135, '¿Qué aspectos mejorarías de la escuela?', 'texto', 0, NULL, 3, 79, NULL, NULL, NULL),
(136, '¿Participa activamente en las actividades del centro cultural?', 'si_no', 1, NULL, 1, 81, NULL, NULL, NULL),
(137, '¿Cómo califica el impacto del centro en la comunidad?', 'escala', 1, NULL, 2, 81, NULL, NULL, NULL),
(138, '¿Qué tipo de actividades le gustaría que se ofrecieran?', 'opcion_multiple', 0, NULL, 3, 81, NULL, NULL, NULL),
(139, 'Comentarios adicionales', 'texto', 0, NULL, 4, 81, NULL, NULL, NULL),
(140, '¿La plataforma digital es fácil de usar?', 'si_no', 1, NULL, 1, 83, NULL, NULL, NULL),
(141, 'Califique la velocidad de carga', 'escala', 1, NULL, 2, 83, NULL, NULL, NULL),
(142, '¿Qué funciones utiliza más?', 'opcion_multiple', 0, NULL, 3, 83, NULL, NULL, NULL),
(143, 'Sugerencias para la biblioteca digital', 'texto', 0, NULL, 4, 83, NULL, NULL, NULL),
(144, '¿El programa cumplió sus expectativas?', 'si_no', 1, NULL, 1, 85, NULL, NULL, NULL),
(145, 'Califique la calidad de los instructores', 'escala', 1, NULL, 2, 85, NULL, NULL, NULL),
(146, '¿Qué le gustaría aprender en futuros cursos?', 'texto', 0, NULL, 3, 85, NULL, NULL, NULL),
(147, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 87, NULL, NULL, NULL),
(148, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 87, NULL, NULL, NULL),
(149, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 87, NULL, NULL, NULL),
(150, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 87, NULL, NULL, NULL),
(151, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 87, NULL, NULL, NULL),
(152, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 1, 88, NULL, NULL, NULL),
(153, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 2, 88, NULL, NULL, NULL),
(154, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 3, 88, NULL, NULL, NULL),
(155, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 4, 88, NULL, NULL, NULL),
(156, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 5, 88, NULL, NULL, NULL),
(157, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 1, 89, NULL, NULL, NULL),
(158, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 2, 89, NULL, NULL, NULL),
(159, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 3, 89, NULL, NULL, NULL),
(160, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 4, 89, NULL, NULL, NULL),
(161, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 5, 89, NULL, NULL, NULL),
(162, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 1, 90, NULL, NULL, NULL),
(163, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 2, 90, NULL, NULL, NULL),
(164, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 3, 90, NULL, NULL, NULL),
(165, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 4, 90, NULL, NULL, NULL),
(166, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 5, 90, NULL, NULL, NULL),
(167, '¿Se siente valorado en su trabajo?', 'si_no', 1, NULL, 1, 92, NULL, NULL, NULL),
(168, 'Califique el ambiente físico de su lugar de trabajo', 'escala', 1, NULL, 2, 92, NULL, NULL, NULL),
(169, '¿Dispone de las herramientas necesarias para realizar su trabajo?', 'si_no', 1, NULL, 3, 92, NULL, NULL, NULL),
(170, '¿Cómo califica la relación con sus compañeros?', 'escala', 1, NULL, 4, 92, NULL, NULL, NULL),
(171, '¿Qué mejoraría del ambiente laboral?', 'texto', 0, NULL, 5, 92, NULL, NULL, NULL),
(172, '¿Recibe información clara sobre los objetivos institucionales?', 'si_no', 1, NULL, 1, 93, NULL, NULL, NULL),
(173, 'Califique la comunicación con su jefe directo', 'escala', 1, NULL, 2, 93, NULL, NULL, NULL),
(174, '¿Siente que puede expresar sus opiniones libremente?', 'si_no', 1, NULL, 3, 93, NULL, NULL, NULL),
(175, '¿Qué canal de comunicación prefiere para recibir información?', 'opcion_unica', 0, NULL, 4, 93, NULL, NULL, NULL),
(176, 'Comentarios sobre la comunicación interna', 'texto', 0, NULL, 5, 93, NULL, NULL, NULL),
(177, '¿Considera que tiene oportunidades de crecimiento profesional?', 'si_no', 1, NULL, 1, 94, NULL, NULL, NULL),
(178, 'Califique las oportunidades de capacitación ofrecidas', 'escala', 1, NULL, 2, 94, NULL, NULL, NULL),
(179, '¿Ha participado en algún programa de formación en el último año?', 'si_no', 1, NULL, 3, 94, NULL, NULL, NULL),
(180, '¿Qué tipo de capacitación le interesaría recibir?', 'opcion_multiple', 0, NULL, 4, 94, NULL, NULL, NULL),
(181, 'Sugerencias para mejorar el desarrollo profesional', 'texto', 0, NULL, 5, 94, NULL, NULL, NULL),
(182, '¿Recomendaría esta institución como lugar de trabajo?', 'si_no', 1, NULL, 1, 95, NULL, NULL, NULL),
(183, 'Califique su satisfacción general con su empleo', 'escala', 1, NULL, 2, 95, NULL, NULL, NULL),
(184, '¿Piensa permanecer en la institución a mediano plazo?', 'si_no', 1, NULL, 3, 95, NULL, NULL, NULL),
(185, '¿Qué es lo que más valora de su trabajo?', 'opcion_unica', 1, NULL, 4, 95, NULL, NULL, NULL),
(186, 'Comentario final sobre su experiencia laboral', 'texto', 0, NULL, 5, 95, NULL, NULL, NULL),
(187, '¿Tenía experiencia previa en el área artística del programa?', 'si_no', 1, NULL, 1, 97, NULL, NULL, NULL),
(188, '¿Cuánto tiempo lleva participando en actividades artísticas?', 'opcion_unica', 1, NULL, 2, 97, NULL, NULL, NULL),
(189, '¿Cómo se enteró de este programa?', 'opcion_multiple', 0, NULL, 3, 97, NULL, NULL, NULL),
(190, '¿Qué lo motivó a inscribirse?', 'texto', 1, NULL, 4, 97, NULL, NULL, NULL),
(191, '¿Había participado antes en programas similares?', 'si_no', 0, NULL, 5, 97, NULL, NULL, NULL),
(192, '¿El contenido del programa fue relevante para su formación?', 'si_no', 1, NULL, 1, 98, NULL, NULL, NULL),
(193, 'Califique la estructura del programa', 'escala', 1, NULL, 2, 98, NULL, NULL, NULL),
(194, '¿El programa cumplió con sus expectativas?', 'si_no', 1, NULL, 3, 98, NULL, NULL, NULL),
(195, '¿Qué módulo le pareció más útil?', 'opcion_unica', 0, NULL, 4, 98, NULL, NULL, NULL),
(196, '¿Qué temas le hubiera gustado profundizar más?', 'texto', 0, NULL, 5, 98, NULL, NULL, NULL),
(197, '¿Los instructores dominaban los temas?', 'si_no', 1, NULL, 1, 99, NULL, NULL, NULL),
(198, 'Califique la claridad de las explicaciones', 'escala', 1, NULL, 2, 99, NULL, NULL, NULL),
(199, '¿Los instructores fomentaron la participación?', 'si_no', 1, NULL, 3, 99, NULL, NULL, NULL),
(200, 'Califique la disponibilidad de los instructores para resolver dudas', 'escala', 1, NULL, 4, 99, NULL, NULL, NULL),
(201, 'Comentarios sobre los instructores', 'texto', 0, NULL, 5, 99, NULL, NULL, NULL),
(202, '¿El programa contribuyó a su desarrollo artístico personal?', 'si_no', 1, NULL, 1, 100, NULL, NULL, NULL),
(203, 'Califique el impacto del programa en su vida profesional', 'escala', 1, NULL, 2, 100, NULL, NULL, NULL),
(204, '¿Aplicó lo aprendido en su trabajo o proyectos?', 'si_no', 1, NULL, 3, 100, NULL, NULL, NULL),
(205, '¿Recomendaría este programa a otros artistas?', 'si_no', 1, NULL, 4, 100, NULL, NULL, NULL),
(206, 'Comentario final sobre el programa', 'texto', 0, NULL, 5, 100, NULL, NULL, NULL),
(207, '¿Es la primera vez que visita este museo?', 'si_no', 1, NULL, 1, 102, NULL, NULL, NULL),
(208, '¿Con quién realizó la visita?', 'opcion_unica', 1, NULL, 2, 102, NULL, NULL, NULL),
(209, '¿Cómo se enteró de este museo?', 'opcion_multiple', 0, NULL, 3, 102, NULL, NULL, NULL),
(210, '¿Cuánto tiempo duró su visita?', 'opcion_unica', 0, NULL, 4, 102, NULL, NULL, NULL),
(211, '¿Utilizó algún servicio adicional (cafetería, tienda, etc.)?', 'si_no', 0, NULL, 5, 102, NULL, NULL, NULL),
(212, '¿Las exposiciones le parecieron interesantes?', 'si_no', 1, NULL, 1, 103, NULL, NULL, NULL),
(213, 'Califique la calidad de las obras expuestas', 'escala', 1, NULL, 2, 103, NULL, NULL, NULL),
(214, '¿La información de las obras era clara?', 'si_no', 1, NULL, 3, 103, NULL, NULL, NULL),
(215, '¿Qué exposición le gustó más?', 'texto', 0, NULL, 4, 103, NULL, NULL, NULL),
(216, '¿Considera que faltó algún tipo de contenido?', 'texto', 0, NULL, 5, 103, NULL, NULL, NULL),
(217, 'Califique la limpieza de las instalaciones', 'escala', 1, NULL, 1, 104, NULL, NULL, NULL),
(218, '¿Los baños estaban en buen estado?', 'si_no', 1, NULL, 2, 104, NULL, NULL, NULL),
(219, '¿El personal de seguridad fue atento?', 'si_no', 1, NULL, 3, 104, NULL, NULL, NULL),
(220, 'Califique la accesibilidad para personas con movilidad reducida', 'escala', 0, NULL, 4, 104, NULL, NULL, NULL),
(221, 'Sugerencias para mejorar las instalaciones', 'texto', 0, NULL, 5, 104, NULL, NULL, NULL),
(222, '¿Recomendaría este museo a otras personas?', 'si_no', 1, NULL, 1, 105, NULL, NULL, NULL),
(223, 'Califique su experiencia general', 'escala', 1, NULL, 2, 105, NULL, NULL, NULL),
(224, '¿Volvería a visitar este museo?', 'si_no', 1, NULL, 3, 105, NULL, NULL, NULL),
(225, '¿Qué fue lo mejor de su visita?', 'texto', 0, NULL, 4, 105, NULL, NULL, NULL),
(226, 'Comentario final', 'texto', 0, NULL, 5, 105, NULL, NULL, NULL),
(227, '¿Cómo se enteró del evento?', 'opcion_multiple', 1, NULL, 1, 107, NULL, NULL, NULL),
(228, '¿La información previa fue clara?', 'si_no', 1, NULL, 2, 107, NULL, NULL, NULL),
(229, '¿Considera que la difusión del evento fue adecuada?', 'si_no', 1, NULL, 3, 107, NULL, NULL, NULL),
(230, '¿Qué medio de difusión le pareció más efectivo?', 'opcion_unica', 0, NULL, 4, 107, NULL, NULL, NULL),
(231, 'Sugerencias para mejorar la difusión', 'texto', 0, NULL, 5, 107, NULL, NULL, NULL),
(232, '¿El acceso al evento fue rápido?', 'si_no', 1, NULL, 1, 108, NULL, NULL, NULL),
(233, 'Califique la organización de las filas y accesos', 'escala', 1, NULL, 2, 108, NULL, NULL, NULL),
(234, '¿Había suficiente personal de seguridad?', 'si_no', 1, NULL, 3, 108, NULL, NULL, NULL),
(235, 'Califique la limpieza de las instalaciones', 'escala', 1, NULL, 4, 108, NULL, NULL, NULL),
(236, '¿Qué problema logístico encontró?', 'texto', 0, NULL, 5, 108, NULL, NULL, NULL),
(237, '¿El contenido del evento cumplió sus expectativas?', 'si_no', 1, NULL, 1, 109, NULL, NULL, NULL),
(238, 'Califique la calidad de los artistas', 'escala', 1, NULL, 2, 109, NULL, NULL, NULL),
(239, '¿La duración del evento fue adecuada?', 'si_no', 1, NULL, 3, 109, NULL, NULL, NULL),
(240, '¿Qué presentación le gustó más?', 'texto', 0, NULL, 4, 109, NULL, NULL, NULL),
(241, 'Comentarios sobre el contenido artístico', 'texto', 0, NULL, 5, 109, NULL, NULL, NULL),
(242, '¿Recomendaría asistir a futuros eventos organizados por el ministerio?', 'si_no', 1, NULL, 1, 110, NULL, NULL, NULL),
(243, 'Califique su satisfacción general con el evento', 'escala', 1, NULL, 2, 110, NULL, NULL, NULL),
(244, '¿Asistiría nuevamente a un evento similar?', 'si_no', 1, NULL, 3, 110, NULL, NULL, NULL),
(245, '¿Qué fue lo más destacado del evento?', 'texto', 0, NULL, 4, 110, NULL, NULL, NULL),
(246, 'Comentario final', 'texto', 0, NULL, 5, 110, NULL, NULL, NULL),
(247, 'kkkkkkkkk', 'texto', 0, 150, 1, 111, NULL, NULL, NULL),
(248, '¿En qué medida las actividades del proyecto te permitieron aplicar los conocimientos técnicos adquiridos en tu carrera?', 'escala', 1, NULL, 1, 113, NULL, NULL, NULL),
(249, 'Menciona al menos una habilidad técnica o blanda que hayas desarrollado o mejorado significativamente gracias a este proyecto.', 'texto', 1, 150, 2, 113, NULL, NULL, NULL),
(250, '¿Consideras que los resultados o entregables de tu proyecto resolvieron una necesidad real de la institución beneficiada?', 'si_no', 1, NULL, 1, 114, NULL, NULL, NULL),
(251, '¿Cuál fue el principal reto o dificultad que enfrentaste durante la ejecución de las horas sociales y cómo lo solucionaste?', 'texto', 1, 1000, 2, 114, NULL, NULL, NULL),
(252, '¿Cómo calificas la claridad de las instrucciones y el apoyo brindado por el coordinador o docente encargado durante el proceso?', 'opcion_unica', 0, NULL, 1, 115, NULL, NULL, NULL),
(253, '¿Qué sugerencia específica darías para agilizar o mejorar el proceso de asignación y revisión de las horas sociales para futuros estudiantes?', 'texto', 1, 1000, 2, 115, NULL, NULL, NULL),
(254, 'fffffffffffffffffffffffffffffffffffffff', 'texto', 1, 150, 1, 117, NULL, NULL, NULL),
(255, 'Nombre completo', 'texto', 1, NULL, 1, NULL, 6, 'Datos generales', NULL),
(256, 'Género', 'opcion_unica', 1, NULL, 2, NULL, 6, 'Datos generales', NULL),
(257, 'Calificación general del festival (1-5)', 'escala', 1, NULL, 3, NULL, 6, 'Evaluación del evento', NULL),
(258, '¿La exposición cumplió sus expectativas?', 'si_no', 1, NULL, 1, NULL, 7, 'Exposición', NULL),
(259, 'Califique la iluminación de las obras', 'escala', 1, NULL, 2, NULL, 7, 'Exposición', NULL),
(260, '¿Qué obra le gustó más?', 'texto', 0, NULL, 3, NULL, 7, 'Exposición', NULL),
(261, '¿Recomendaría esta exposición?', 'opcion_unica', 1, NULL, 4, NULL, 7, 'Exposición', NULL),
(262, '¿Recomendarías este curso a otros?', 'si_no', 1, NULL, 1, 119, NULL, NULL, NULL),
(263, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, NULL, 8, 'Información general del participante', NULL),
(264, '¿En qué departamento reside?', 'texto', 1, NULL, 2, NULL, 8, 'Información general del participante', NULL),
(265, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, NULL, 8, 'Información general del participante', NULL),
(266, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, NULL, 8, 'Información general del participante', NULL),
(267, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, NULL, 8, 'Información general del participante', NULL),
(268, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 6, NULL, 8, 'Uso de servicios culturales', NULL),
(269, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 7, NULL, 8, 'Uso de servicios culturales', NULL),
(270, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 8, NULL, 8, 'Uso de servicios culturales', NULL),
(271, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 9, NULL, 8, 'Uso de servicios culturales', NULL),
(272, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 10, NULL, 8, 'Uso de servicios culturales', NULL),
(273, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, NULL, 8, 'Evaluación de servicios en línea', NULL),
(274, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, NULL, 8, 'Evaluación de servicios en línea', NULL),
(275, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, NULL, 8, 'Evaluación de servicios en línea', NULL),
(276, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, NULL, 8, 'Evaluación de servicios en línea', NULL),
(277, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, NULL, 8, 'Evaluación de servicios en línea', NULL),
(278, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, NULL, 8, 'Sugerencias finales', NULL),
(279, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, NULL, 8, 'Sugerencias finales', NULL),
(280, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, NULL, 8, 'Sugerencias finales', NULL),
(281, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, NULL, 8, 'Sugerencias finales', NULL),
(282, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, NULL, 8, 'Sugerencias finales', NULL),
(283, 'Nombre completo', 'texto', 1, NULL, 1, 120, NULL, NULL, NULL),
(284, 'Género', 'opcion_unica', 1, NULL, 2, 120, NULL, NULL, NULL),
(285, 'Calificación general del festival (1-5)', 'escala', 1, NULL, 3, 121, NULL, NULL, NULL),
(286, '¿Cómo se enteró del evento?', 'opcion_multiple', 1, NULL, 1, NULL, 9, 'Información previa al evento', NULL),
(287, '¿La información previa fue clara?', 'si_no', 1, NULL, 2, NULL, 9, 'Información previa al evento', NULL),
(288, '¿Considera que la difusión del evento fue adecuada?', 'si_no', 1, NULL, 3, NULL, 9, 'Información previa al evento', NULL),
(289, '¿Qué medio de difusión le pareció más efectivo?', 'opcion_unica', 0, NULL, 4, NULL, 9, 'Información previa al evento', NULL),
(290, 'Sugerencias para mejorar la difusión', 'texto', 0, NULL, 5, NULL, 9, 'Información previa al evento', NULL),
(291, '¿El acceso al evento fue rápido?', 'si_no', 1, NULL, 6, NULL, 9, 'Logística y organización', NULL),
(292, 'Califique la organización de las filas y accesos', 'escala', 1, NULL, 7, NULL, 9, 'Logística y organización', NULL),
(293, '¿Había suficiente personal de seguridad?', 'si_no', 1, NULL, 8, NULL, 9, 'Logística y organización', NULL),
(294, 'Califique la limpieza de las instalaciones', 'escala', 1, NULL, 9, NULL, 9, 'Logística y organización', NULL),
(295, '¿Qué problema logístico encontró?', 'texto', 0, NULL, 10, NULL, 9, 'Logística y organización', NULL),
(296, '¿El contenido del evento cumplió sus expectativas?', 'si_no', 1, NULL, 11, NULL, 9, 'Contenido y artistas', NULL),
(297, 'Califique la calidad de los artistas', 'escala', 1, NULL, 12, NULL, 9, 'Contenido y artistas', NULL),
(298, '¿La duración del evento fue adecuada?', 'si_no', 1, NULL, 13, NULL, 9, 'Contenido y artistas', NULL),
(299, '¿Qué presentación le gustó más?', 'texto', 0, NULL, 14, NULL, 9, 'Contenido y artistas', NULL),
(300, 'Comentarios sobre el contenido artístico', 'texto', 0, NULL, 15, NULL, 9, 'Contenido y artistas', NULL),
(301, '¿Recomendaría asistir a futuros eventos organizados por el ministerio?', 'si_no', 1, NULL, 16, NULL, 9, 'Opinión final', NULL),
(302, 'Califique su satisfacción general con el evento', 'escala', 1, NULL, 17, NULL, 9, 'Opinión final', NULL),
(303, '¿Asistiría nuevamente a un evento similar?', 'si_no', 1, NULL, 18, NULL, 9, 'Opinión final', NULL),
(304, '¿Qué fue lo más destacado del evento?', 'texto', 0, NULL, 19, NULL, 9, 'Opinión final', NULL),
(305, 'Comentario final', 'texto', 0, NULL, 20, NULL, 9, 'Opinión final', NULL),
(306, '¿Cómo se enteró del evento?', 'opcion_multiple', 1, NULL, 1, 122, NULL, NULL, NULL),
(307, '¿La información previa fue clara?', 'si_no', 1, NULL, 2, 122, NULL, NULL, NULL),
(308, '¿Considera que la difusión del evento fue adecuada?', 'si_no', 1, NULL, 3, 122, NULL, NULL, NULL),
(309, '¿Qué medio de difusión le pareció más efectivo?', 'opcion_unica', 0, NULL, 4, 122, NULL, NULL, NULL),
(310, 'Sugerencias para mejorar la difusión', 'texto', 0, NULL, 5, 122, NULL, NULL, NULL),
(311, '¿El acceso al evento fue rápido?', 'si_no', 1, NULL, 6, 123, NULL, NULL, NULL),
(312, 'Califique la organización de las filas y accesos', 'escala', 1, NULL, 7, 123, NULL, NULL, NULL),
(313, '¿Había suficiente personal de seguridad?', 'si_no', 1, NULL, 8, 123, NULL, NULL, NULL),
(314, 'Califique la limpieza de las instalaciones', 'escala', 1, NULL, 9, 123, NULL, NULL, NULL),
(315, '¿Qué problema logístico encontró?', 'texto', 0, NULL, 10, 123, NULL, NULL, NULL),
(316, '¿El contenido del evento cumplió sus expectativas?', 'si_no', 1, NULL, 11, 124, NULL, NULL, NULL),
(317, 'Califique la calidad de los artistas', 'escala', 1, NULL, 12, 124, NULL, NULL, NULL),
(318, '¿La duración del evento fue adecuada?', 'si_no', 1, NULL, 13, 124, NULL, NULL, NULL),
(319, '¿Qué presentación le gustó más?', 'texto', 0, NULL, 14, 124, NULL, NULL, NULL),
(320, 'Comentarios sobre el contenido artístico', 'texto', 0, NULL, 15, 124, NULL, NULL, NULL),
(321, '¿Recomendaría asistir a futuros eventos organizados por el ministerio?', 'si_no', 1, NULL, 16, 125, NULL, NULL, NULL),
(322, 'Califique su satisfacción general con el evento', 'escala', 1, NULL, 17, 125, NULL, NULL, NULL),
(323, '¿Asistiría nuevamente a un evento similar?', 'si_no', 1, NULL, 18, 125, NULL, NULL, NULL),
(324, '¿Qué fue lo más destacado del evento?', 'texto', 0, NULL, 19, 125, NULL, NULL, NULL),
(325, 'Comentario final', 'texto', 0, NULL, 20, 125, NULL, NULL, NULL),
(326, '¿Cómo se enteró del evento?', 'opcion_multiple', 1, NULL, 1, 126, NULL, NULL, NULL),
(327, '¿La información previa fue clara?', 'si_no', 1, NULL, 2, 126, NULL, NULL, NULL),
(328, '¿Considera que la difusión del evento fue adecuada?', 'si_no', 1, NULL, 3, 126, NULL, NULL, NULL),
(329, '¿Qué medio de difusión le pareció más efectivo?', 'opcion_unica', 0, NULL, 4, 126, NULL, NULL, NULL),
(330, 'Sugerencias para mejorar la difusión', 'texto', 0, NULL, 5, 126, NULL, NULL, NULL),
(331, '¿El acceso al evento fue rápido?', 'si_no', 1, NULL, 6, 127, NULL, NULL, NULL),
(332, 'Califique la organización de las filas y accesos', 'escala', 1, NULL, 7, 127, NULL, NULL, NULL),
(333, '¿Había suficiente personal de seguridad?', 'si_no', 1, NULL, 8, 127, NULL, NULL, NULL),
(334, 'Califique la limpieza de las instalaciones', 'escala', 1, NULL, 9, 127, NULL, NULL, NULL),
(335, '¿Qué problema logístico encontró?', 'texto', 0, NULL, 10, 127, NULL, NULL, NULL),
(336, '¿El contenido del evento cumplió sus expectativas?', 'si_no', 1, NULL, 11, 128, NULL, NULL, NULL),
(337, 'Califique la calidad de los artistas', 'escala', 1, NULL, 12, 128, NULL, NULL, NULL),
(338, '¿La duración del evento fue adecuada?', 'si_no', 1, NULL, 13, 128, NULL, NULL, NULL),
(339, '¿Qué presentación le gustó más?', 'texto', 0, NULL, 14, 128, NULL, NULL, NULL),
(340, 'Comentarios sobre el contenido artístico', 'texto', 0, NULL, 15, 128, NULL, NULL, NULL),
(341, '¿Recomendaría asistir a futuros eventos organizados por el ministerio?', 'si_no', 1, NULL, 16, 129, NULL, NULL, NULL),
(342, 'Califique su satisfacción general con el evento', 'escala', 1, NULL, 17, 129, NULL, NULL, NULL),
(343, '¿Asistiría nuevamente a un evento similar?', 'si_no', 1, NULL, 18, 129, NULL, NULL, NULL),
(344, '¿Qué fue lo más destacado del evento?', 'texto', 0, NULL, 19, 129, NULL, NULL, NULL),
(345, 'Comentario final', 'texto', 0, NULL, 20, 129, NULL, NULL, NULL),
(346, '¿Cómo se enteró del evento?', 'opcion_multiple', 1, NULL, 1, 130, NULL, NULL, NULL),
(347, '¿La información previa fue clara?', 'si_no', 1, NULL, 2, 130, NULL, NULL, NULL),
(348, '¿Considera que la difusión del evento fue adecuada?', 'si_no', 1, NULL, 3, 130, NULL, NULL, NULL),
(349, '¿Qué medio de difusión le pareció más efectivo?', 'opcion_unica', 0, NULL, 4, 130, NULL, NULL, NULL),
(350, 'Sugerencias para mejorar la difusión', 'texto', 0, NULL, 5, 130, NULL, NULL, NULL),
(351, '¿El acceso al evento fue rápido?', 'si_no', 1, NULL, 6, 131, NULL, NULL, NULL),
(352, 'Califique la organización de las filas y accesos', 'escala', 1, NULL, 7, 131, NULL, NULL, NULL),
(353, '¿Había suficiente personal de seguridad?', 'si_no', 1, NULL, 8, 131, NULL, NULL, NULL),
(354, 'Califique la limpieza de las instalaciones', 'escala', 1, NULL, 9, 131, NULL, NULL, NULL),
(355, '¿Qué problema logístico encontró?', 'texto', 0, NULL, 10, 131, NULL, NULL, NULL),
(356, '¿El contenido del evento cumplió sus expectativas?', 'si_no', 1, NULL, 11, 132, NULL, NULL, NULL),
(357, 'Califique la calidad de los artistas', 'escala', 1, NULL, 12, 132, NULL, NULL, NULL),
(358, '¿La duración del evento fue adecuada?', 'si_no', 1, NULL, 13, 132, NULL, NULL, NULL),
(359, '¿Qué presentación le gustó más?', 'texto', 0, NULL, 14, 132, NULL, NULL, NULL),
(360, 'Comentarios sobre el contenido artístico', 'texto', 0, NULL, 15, 132, NULL, NULL, NULL),
(361, '¿Recomendaría asistir a futuros eventos organizados por el ministerio?', 'si_no', 1, NULL, 16, 133, NULL, NULL, NULL),
(362, 'Califique su satisfacción general con el evento', 'escala', 1, NULL, 17, 133, NULL, NULL, NULL),
(363, '¿Asistiría nuevamente a un evento similar?', 'si_no', 1, NULL, 18, 133, NULL, NULL, NULL),
(364, '¿Qué fue lo más destacado del evento?', 'texto', 0, NULL, 19, 133, NULL, NULL, NULL),
(365, 'Comentario final', 'texto', 0, NULL, 20, 133, NULL, NULL, NULL),
(366, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, NULL, 10, 'Información general del participante', NULL),
(367, '¿En qué departamento reside?', 'texto', 1, NULL, 2, NULL, 10, 'Información general del participante', NULL),
(368, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, NULL, 10, 'Información general del participante', NULL),
(369, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, NULL, 10, 'Información general del participante', NULL),
(370, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, NULL, 10, 'Información general del participante', NULL),
(371, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 6, NULL, 10, 'Uso de servicios culturales', NULL),
(372, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 7, NULL, 10, 'Uso de servicios culturales', NULL),
(373, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 8, NULL, 10, 'Uso de servicios culturales', NULL),
(374, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 9, NULL, 10, 'Uso de servicios culturales', NULL),
(375, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 10, NULL, 10, 'Uso de servicios culturales', NULL),
(376, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, NULL, 10, 'Evaluación de servicios en línea', NULL),
(377, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, NULL, 10, 'Evaluación de servicios en línea', NULL),
(378, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, NULL, 10, 'Evaluación de servicios en línea', NULL),
(379, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, NULL, 10, 'Evaluación de servicios en línea', NULL),
(380, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, NULL, 10, 'Evaluación de servicios en línea', NULL),
(381, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, NULL, 10, 'Sugerencias finales', NULL),
(382, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, NULL, 10, 'Sugerencias finales', NULL),
(383, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, NULL, 10, 'Sugerencias finales', NULL),
(384, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, NULL, 10, 'Sugerencias finales', NULL),
(385, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, NULL, 10, 'Sugerencias finales', NULL),
(386, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 134, NULL, NULL, NULL),
(387, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 134, NULL, NULL, NULL),
(388, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 134, NULL, NULL, NULL),
(389, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 134, NULL, NULL, NULL),
(390, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 134, NULL, NULL, NULL),
(391, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 6, 135, NULL, NULL, NULL),
(392, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 7, 135, NULL, NULL, NULL),
(393, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 8, 135, NULL, NULL, NULL),
(394, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 9, 135, NULL, NULL, NULL),
(395, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 10, 135, NULL, NULL, NULL),
(396, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, 136, NULL, NULL, NULL),
(397, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, 136, NULL, NULL, NULL),
(398, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, 136, NULL, NULL, NULL),
(399, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, 136, NULL, NULL, NULL),
(400, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, 136, NULL, NULL, NULL),
(401, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, 137, NULL, NULL, NULL),
(402, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, 137, NULL, NULL, NULL),
(403, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, 137, NULL, NULL, NULL),
(404, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, 137, NULL, NULL, NULL),
(405, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, 137, NULL, NULL, NULL),
(406, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 138, NULL, NULL, NULL),
(407, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 138, NULL, NULL, NULL),
(408, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 138, NULL, NULL, NULL),
(409, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 138, NULL, NULL, NULL),
(410, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 138, NULL, NULL, NULL),
(411, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 6, 139, NULL, NULL, NULL),
(412, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 7, 139, NULL, NULL, NULL),
(413, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 8, 139, NULL, NULL, NULL),
(414, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 9, 139, NULL, NULL, NULL),
(415, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 10, 139, NULL, NULL, NULL),
(416, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, 140, NULL, NULL, NULL),
(417, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, 140, NULL, NULL, NULL),
(418, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, 140, NULL, NULL, NULL),
(419, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, 140, NULL, NULL, NULL),
(420, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, 140, NULL, NULL, NULL),
(421, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, 141, NULL, NULL, NULL),
(422, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, 141, NULL, NULL, NULL),
(423, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, 141, NULL, NULL, NULL),
(424, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, 141, NULL, NULL, NULL),
(425, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, 141, NULL, NULL, NULL),
(426, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 142, NULL, NULL, NULL),
(427, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 142, NULL, NULL, NULL),
(428, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 142, NULL, NULL, NULL),
(429, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 142, NULL, NULL, NULL),
(430, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 142, NULL, NULL, NULL),
(431, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 1, 143, NULL, NULL, NULL),
(432, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 2, 143, NULL, NULL, NULL),
(433, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 3, 143, NULL, NULL, NULL),
(434, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 4, 143, NULL, NULL, NULL),
(435, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 5, 143, NULL, NULL, NULL),
(436, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 1, 144, NULL, NULL, NULL),
(437, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 2, 144, NULL, NULL, NULL),
(438, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 3, 144, NULL, NULL, NULL),
(439, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 4, 144, NULL, NULL, NULL),
(440, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 5, 144, NULL, NULL, NULL),
(441, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 1, 145, NULL, NULL, NULL),
(442, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 2, 145, NULL, NULL, NULL),
(443, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 3, 145, NULL, NULL, NULL),
(444, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 4, 145, NULL, NULL, NULL),
(445, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 5, 145, NULL, NULL, NULL),
(446, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 146, NULL, NULL, NULL),
(447, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 146, NULL, NULL, NULL),
(448, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 146, NULL, NULL, NULL),
(449, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 146, NULL, NULL, NULL),
(450, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 146, NULL, NULL, NULL),
(451, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 1, 147, NULL, NULL, NULL),
(452, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 2, 147, NULL, NULL, NULL),
(453, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 3, 147, NULL, NULL, NULL),
(454, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 4, 147, NULL, NULL, NULL),
(455, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 5, 147, NULL, NULL, NULL),
(456, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 1, 148, NULL, NULL, NULL),
(457, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 2, 148, NULL, NULL, NULL),
(458, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 3, 148, NULL, NULL, NULL),
(459, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 4, 148, NULL, NULL, NULL),
(460, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 5, 148, NULL, NULL, NULL),
(461, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, 149, NULL, NULL, NULL),
(462, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, 149, NULL, NULL, NULL),
(463, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, 149, NULL, NULL, NULL),
(464, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, 149, NULL, NULL, NULL),
(465, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, 149, NULL, NULL, NULL),
(466, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 150, NULL, NULL, NULL),
(467, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 150, NULL, NULL, NULL),
(468, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 150, NULL, NULL, NULL),
(469, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 150, NULL, NULL, NULL),
(470, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 150, NULL, NULL, NULL),
(471, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 1, 151, NULL, NULL, NULL),
(472, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 2, 151, NULL, NULL, NULL),
(473, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 3, 151, NULL, NULL, NULL),
(474, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 4, 151, NULL, NULL, NULL),
(475, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 5, 151, NULL, NULL, NULL),
(476, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, 152, NULL, NULL, NULL),
(477, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, 152, NULL, NULL, NULL),
(478, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, 152, NULL, NULL, NULL),
(479, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, 152, NULL, NULL, NULL),
(480, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, 152, NULL, NULL, NULL),
(481, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, 153, NULL, NULL, NULL),
(482, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, 153, NULL, NULL, NULL),
(483, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, 153, NULL, NULL, NULL),
(484, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, 153, NULL, NULL, NULL),
(485, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, 153, NULL, NULL, NULL),
(486, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 154, NULL, NULL, NULL),
(487, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 154, NULL, NULL, NULL),
(488, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 154, NULL, NULL, NULL),
(489, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 154, NULL, NULL, NULL),
(490, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 154, NULL, NULL, NULL),
(491, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 1, 155, NULL, NULL, NULL),
(492, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 2, 155, NULL, NULL, NULL),
(493, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 3, 155, NULL, NULL, NULL),
(494, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 4, 155, NULL, NULL, NULL),
(495, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 5, 155, NULL, NULL, NULL);
INSERT INTO `questions` (`id`, `statement`, `type`, `is_mandatory`, `max_length`, `sort_order`, `section_id`, `template_id`, `template_section_name`, `deleted_at`) VALUES
(496, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, 156, NULL, NULL, NULL),
(497, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, 156, NULL, NULL, NULL),
(498, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, 156, NULL, NULL, NULL),
(499, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, 156, NULL, NULL, NULL),
(500, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, 156, NULL, NULL, NULL),
(501, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, 157, NULL, NULL, NULL),
(502, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, 157, NULL, NULL, NULL),
(503, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, 157, NULL, NULL, NULL),
(504, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, 157, NULL, NULL, NULL),
(505, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, 157, NULL, NULL, NULL),
(506, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 158, NULL, NULL, NULL),
(507, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 158, NULL, NULL, NULL),
(508, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 158, NULL, NULL, NULL),
(509, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 158, NULL, NULL, NULL),
(510, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 158, NULL, NULL, NULL),
(511, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 1, 159, NULL, NULL, NULL),
(512, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 2, 159, NULL, NULL, NULL),
(513, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 3, 159, NULL, NULL, NULL),
(514, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 4, 159, NULL, NULL, NULL),
(515, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 5, 159, NULL, NULL, NULL),
(516, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 1, 160, NULL, NULL, NULL),
(517, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 2, 160, NULL, NULL, NULL),
(518, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 3, 160, NULL, NULL, NULL),
(519, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 4, 160, NULL, NULL, NULL),
(520, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 5, 160, NULL, NULL, NULL),
(521, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 1, 161, NULL, NULL, NULL),
(522, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 2, 161, NULL, NULL, NULL),
(523, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 3, 161, NULL, NULL, NULL),
(524, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 4, 161, NULL, NULL, NULL),
(525, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 5, 161, NULL, NULL, NULL),
(526, '¿Cómo valoras la variedad de libros?', 'texto', 0, NULL, 1, 162, NULL, NULL, NULL),
(527, '¿Cómo se enteró del evento?', 'opcion_multiple', 1, NULL, 1, 163, NULL, NULL, NULL),
(528, '¿La información previa fue clara?', 'si_no', 1, NULL, 2, 163, NULL, NULL, NULL),
(529, '¿Considera que la difusión del evento fue adecuada?', 'si_no', 1, NULL, 3, 163, NULL, NULL, NULL),
(530, '¿Qué medio de difusión le pareció más efectivo?', 'opcion_unica', 0, NULL, 4, 163, NULL, NULL, NULL),
(531, 'Sugerencias para mejorar la difusión', 'texto', 0, NULL, 5, 163, NULL, NULL, NULL),
(532, '¿El acceso al evento fue rápido?', 'si_no', 1, NULL, 1, 164, NULL, NULL, NULL),
(533, 'Califique la organización de las filas y accesos', 'escala', 1, NULL, 2, 164, NULL, NULL, NULL),
(534, '¿Había suficiente personal de seguridad?', 'si_no', 1, NULL, 3, 164, NULL, NULL, NULL),
(535, 'Califique la limpieza de las instalaciones', 'escala', 1, NULL, 4, 164, NULL, NULL, NULL),
(536, '¿Qué problema logístico encontró?', 'texto', 0, NULL, 5, 164, NULL, NULL, NULL),
(537, '¿El contenido del evento cumplió sus expectativas?', 'si_no', 1, NULL, 1, 165, NULL, NULL, NULL),
(538, 'Califique la calidad de los artistas', 'escala', 1, NULL, 2, 165, NULL, NULL, NULL),
(539, '¿La duración del evento fue adecuada?', 'si_no', 1, NULL, 3, 165, NULL, NULL, NULL),
(540, '¿Qué presentación le gustó más?', 'texto', 0, NULL, 4, 165, NULL, NULL, NULL),
(541, 'Comentarios sobre el contenido artístico', 'texto', 0, NULL, 5, 165, NULL, NULL, NULL),
(542, '¿Recomendaría asistir a futuros eventos organizados por el ministerio?', 'si_no', 1, NULL, 1, 166, NULL, NULL, NULL),
(543, 'Califique su satisfacción general con el evento', 'escala', 1, NULL, 2, 166, NULL, NULL, NULL),
(544, '¿Asistiría nuevamente a un evento similar?', 'si_no', 1, NULL, 3, 166, NULL, NULL, NULL),
(545, '¿Qué fue lo más destacado del evento?', 'texto', 0, NULL, 4, 166, NULL, NULL, NULL),
(546, 'Comentario final', 'texto', 0, NULL, 5, 166, NULL, NULL, NULL),
(547, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 167, NULL, NULL, NULL),
(548, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 167, NULL, NULL, NULL),
(549, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 167, NULL, NULL, NULL),
(550, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 167, NULL, NULL, NULL),
(551, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 167, NULL, NULL, NULL),
(552, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 6, 168, NULL, NULL, NULL),
(553, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 7, 168, NULL, NULL, NULL),
(554, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 8, 168, NULL, NULL, NULL),
(555, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 9, 168, NULL, NULL, NULL),
(556, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 10, 168, NULL, NULL, NULL),
(557, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, 169, NULL, NULL, NULL),
(558, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, 169, NULL, NULL, NULL),
(559, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, 169, NULL, NULL, NULL),
(560, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, 169, NULL, NULL, NULL),
(561, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, 169, NULL, NULL, NULL),
(562, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, 170, NULL, NULL, NULL),
(563, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, 170, NULL, NULL, NULL),
(564, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, 170, NULL, NULL, NULL),
(565, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, 170, NULL, NULL, NULL),
(566, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, 170, NULL, NULL, NULL),
(567, 'cual opcion elige', 'opcion_unica', 1, NULL, 1, NULL, 11, 'seccion 1', NULL),
(568, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 171, NULL, NULL, NULL),
(569, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 171, NULL, NULL, NULL),
(570, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 171, NULL, NULL, NULL),
(571, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 171, NULL, NULL, NULL),
(572, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 171, NULL, NULL, NULL),
(573, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 6, 172, NULL, NULL, NULL),
(574, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 7, 172, NULL, NULL, NULL),
(575, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 8, 172, NULL, NULL, NULL),
(576, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 9, 172, NULL, NULL, NULL),
(577, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 10, 172, NULL, NULL, NULL),
(578, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, 173, NULL, NULL, NULL),
(579, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, 173, NULL, NULL, NULL),
(580, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, 173, NULL, NULL, NULL),
(581, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, 173, NULL, NULL, NULL),
(582, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, 173, NULL, NULL, NULL),
(583, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, 174, NULL, NULL, NULL),
(584, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, 174, NULL, NULL, NULL),
(585, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, 174, NULL, NULL, NULL),
(586, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, 174, NULL, NULL, NULL),
(587, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, 174, NULL, NULL, NULL),
(588, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 175, NULL, NULL, NULL),
(589, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 175, NULL, NULL, NULL),
(590, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 175, NULL, NULL, NULL),
(591, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 175, NULL, NULL, NULL),
(592, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 175, NULL, NULL, NULL),
(593, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 6, 176, NULL, NULL, NULL),
(594, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 7, 176, NULL, NULL, NULL),
(595, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 8, 176, NULL, NULL, NULL),
(596, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 9, 176, NULL, NULL, NULL),
(597, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 10, 176, NULL, NULL, NULL),
(598, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 1, 177, NULL, NULL, NULL),
(599, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 2, 177, NULL, NULL, NULL),
(600, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 3, 177, NULL, NULL, NULL),
(601, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 4, 177, NULL, NULL, NULL),
(602, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 5, 177, NULL, NULL, NULL),
(603, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 1, 178, NULL, NULL, NULL),
(604, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 2, 178, NULL, NULL, NULL),
(605, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 3, 178, NULL, NULL, NULL),
(606, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 4, 178, NULL, NULL, NULL),
(607, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 5, 178, NULL, NULL, NULL),
(608, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 1, NULL, 12, 'Evaluación de servicios en línea', NULL),
(609, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 2, NULL, 12, 'Evaluación de servicios en línea', NULL),
(610, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 3, NULL, 12, 'Evaluación de servicios en línea', NULL),
(611, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 4, NULL, 12, 'Evaluación de servicios en línea', NULL),
(612, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 5, NULL, 12, 'Evaluación de servicios en línea', NULL),
(613, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 6, NULL, 12, 'Sugerencias finales', NULL),
(614, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 7, NULL, 12, 'Sugerencias finales', NULL),
(615, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 8, NULL, 12, 'Sugerencias finales', NULL),
(616, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 9, NULL, 12, 'Sugerencias finales', NULL),
(617, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 10, NULL, 12, 'Sugerencias finales', NULL),
(618, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 1, 179, NULL, NULL, NULL),
(619, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 2, 179, NULL, NULL, NULL),
(620, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 3, 179, NULL, NULL, NULL),
(621, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 4, 179, NULL, NULL, NULL),
(622, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 5, 179, NULL, NULL, NULL),
(623, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 1, 180, NULL, NULL, NULL),
(624, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 2, 180, NULL, NULL, NULL),
(625, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 3, 180, NULL, NULL, NULL),
(626, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 4, 180, NULL, NULL, NULL),
(627, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 5, 180, NULL, NULL, NULL),
(628, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 181, NULL, NULL, NULL),
(629, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 181, NULL, NULL, NULL),
(630, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 181, NULL, NULL, NULL),
(631, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 181, NULL, NULL, NULL),
(632, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 181, NULL, NULL, NULL),
(633, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 6, 182, NULL, NULL, NULL),
(634, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 7, 182, NULL, NULL, NULL),
(635, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 8, 182, NULL, NULL, NULL),
(636, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 9, 182, NULL, NULL, NULL),
(637, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 10, 182, NULL, NULL, NULL),
(638, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, 183, NULL, NULL, NULL),
(639, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, 183, NULL, NULL, NULL),
(640, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, 183, NULL, NULL, NULL),
(641, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, 183, NULL, NULL, NULL),
(642, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, 183, NULL, NULL, NULL),
(643, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, 184, NULL, NULL, NULL),
(644, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, 184, NULL, NULL, NULL),
(645, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, 184, NULL, NULL, NULL),
(646, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, 184, NULL, NULL, NULL),
(647, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, 184, NULL, NULL, NULL),
(648, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, 185, NULL, NULL, NULL),
(649, '¿En qué departamento reside?', 'texto', 1, NULL, 2, 185, NULL, NULL, NULL),
(650, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, 185, NULL, NULL, NULL),
(651, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, 185, NULL, NULL, NULL),
(652, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, 185, NULL, NULL, NULL),
(653, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 1, 186, NULL, NULL, NULL),
(654, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 2, 186, NULL, NULL, NULL),
(655, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 3, 186, NULL, NULL, NULL),
(656, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 4, 186, NULL, NULL, NULL),
(657, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 5, 186, NULL, NULL, NULL),
(658, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 1, 187, NULL, NULL, NULL),
(659, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 2, 187, NULL, NULL, NULL),
(660, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 3, 187, NULL, NULL, NULL),
(661, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 4, 187, NULL, NULL, NULL),
(662, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 5, 187, NULL, NULL, NULL),
(663, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 1, 188, NULL, NULL, NULL),
(664, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 2, 188, NULL, NULL, NULL),
(665, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 3, 188, NULL, NULL, NULL),
(666, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 4, 188, NULL, NULL, NULL),
(667, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 5, 188, NULL, NULL, NULL),
(668, '¿Cuál es su rango de edad?', 'opcion_unica', 1, NULL, 1, NULL, 13, 'Información general del participante', NULL),
(669, '¿En qué departamento reside?', 'texto', 1, NULL, 2, NULL, 13, 'Información general del participante', NULL),
(670, '¿Cuál es su nivel educativo?', 'opcion_unica', 1, NULL, 3, NULL, 13, 'Información general del participante', NULL),
(671, '¿Con qué frecuencia asiste a eventos culturales?', 'opcion_unica', 1, NULL, 4, NULL, 13, 'Información general del participante', NULL),
(672, '¿Se considera un usuario habitual de los servicios culturales en línea?', 'si_no', 1, NULL, 5, NULL, 13, 'Información general del participante', NULL),
(673, '¿Qué tipo de servicios culturales utiliza con más frecuencia?', 'opcion_multiple', 1, NULL, 6, NULL, 13, 'Uso de servicios culturales', NULL),
(674, '¿Cómo se entera de las actividades culturales?', 'opcion_multiple', 0, NULL, 7, NULL, 13, 'Uso de servicios culturales', NULL),
(675, '¿Utiliza la plataforma digital del ministerio para acceder a eventos?', 'si_no', 1, NULL, 8, NULL, 13, 'Uso de servicios culturales', NULL),
(676, 'Califique la variedad de la oferta cultural', 'escala', 1, NULL, 9, NULL, 13, 'Uso de servicios culturales', NULL),
(677, '¿Qué obstáculos encuentra para asistir a eventos presenciales?', 'texto', 0, NULL, 10, NULL, 13, 'Uso de servicios culturales', NULL),
(678, '¿La plataforma en línea es fácil de navegar?', 'si_no', 1, NULL, 11, NULL, 13, 'Evaluación de servicios en línea', NULL),
(679, 'Califique la calidad de la transmisión en vivo', 'escala', 1, NULL, 12, NULL, 13, 'Evaluación de servicios en línea', NULL),
(680, '¿Qué mejoraría de la experiencia en línea?', 'opcion_multiple', 0, NULL, 13, NULL, 13, 'Evaluación de servicios en línea', NULL),
(681, '¿Recomendaría el uso de la plataforma a otras personas?', 'si_no', 1, NULL, 14, NULL, 13, 'Evaluación de servicios en línea', NULL),
(682, 'Comentarios sobre la plataforma digital', 'texto', 0, NULL, 15, NULL, 13, 'Evaluación de servicios en línea', NULL),
(683, '¿Qué tipo de eventos le gustaría que se ofrecieran más?', 'opcion_unica', 1, NULL, 16, NULL, 13, 'Sugerencias finales', NULL),
(684, '¿Considera que los precios son accesibles?', 'si_no', 0, NULL, 17, NULL, 13, 'Sugerencias finales', NULL),
(685, 'Califique su satisfacción general con los servicios culturales', 'escala', 1, NULL, 18, NULL, 13, 'Sugerencias finales', NULL),
(686, '¿Qué sugerencia principal daría para mejorar?', 'texto', 1, NULL, 19, NULL, 13, 'Sugerencias finales', NULL),
(687, '¿Desea agregar algún comentario adicional?', 'texto', 0, NULL, 20, NULL, 13, 'Sugerencias finales', NULL),
(688, '¿Qué te pareció la organización?', 'opcion_unica', 1, NULL, 1, 189, NULL, NULL, NULL),
(689, '¿Cómo calificarías el liderazgo de tu jefe?', 'escala', 1, NULL, 1, 190, NULL, NULL, NULL),
(690, '¿Tienes las herramientas necesarias para tu trabajo?', 'si_no', 0, NULL, 2, 190, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `question_options`
--

CREATE TABLE `question_options` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `question_id` bigint(20) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `question_options`
--

INSERT INTO `question_options` (`id`, `option_text`, `sort_order`, `question_id`, `deleted_at`) VALUES
(1, 'Masculino', 1, 2, NULL),
(2, 'Femenino', 2, 2, NULL),
(3, 'Excelente', 1, 6, NULL),
(4, 'Buena', 2, 6, NULL),
(5, 'Regular', 3, 6, NULL),
(6, 'Mala', 4, 6, NULL),
(7, 'Muy buena', 1, 7, NULL),
(8, 'Buena', 2, 7, NULL),
(9, 'Regular', 3, 7, NULL),
(10, 'Sí, totalmente', 1, 10, NULL),
(11, 'En parte', 2, 10, NULL),
(12, 'No', 3, 10, NULL),
(13, '1', 1, 15, NULL),
(14, '2', 2, 15, NULL),
(15, '3', 3, 15, NULL),
(16, 'Excelente', 1, 16, NULL),
(17, 'Buena', 2, 16, NULL),
(18, 'Regular', 3, 16, NULL),
(19, 'Mala', 4, 16, NULL),
(20, '1', 1, 17, NULL),
(21, '2', 2, 17, NULL),
(22, '3', 3, 17, NULL),
(23, 'b', 1, 20, NULL),
(24, 'c', 2, 20, NULL),
(25, 'a', 3, 20, NULL),
(26, '18 - 25', 1, 22, NULL),
(27, '25 -35', 2, 22, NULL),
(28, '36 - 50', 3, 22, NULL),
(29, 'Más de 65', 4, 22, NULL),
(30, 'Primaria', 1, 23, NULL),
(31, 'Secundaria', 2, 23, NULL),
(32, 'Bachillerato', 3, 23, NULL),
(33, 'Licenciatura', 4, 23, NULL),
(34, 'Posgrado', 5, 23, NULL),
(35, 'Agua potable', 1, 26, NULL),
(36, 'Recolección de basura', 2, 26, NULL),
(37, 'Alumbrado público', 3, 26, NULL),
(38, 'Seguridad pública', 4, 26, NULL),
(39, 'Trámites administrativos', 5, 26, NULL),
(40, 'Redes sociales', 1, 29, NULL),
(41, 'Página web', 2, 29, NULL),
(42, 'Perifoneo', 3, 29, NULL),
(43, 'Prensa local', 4, 29, NULL),
(44, 'Volantes', 5, 29, NULL),
(45, 'Asambleas vecinales', 1, 30, NULL),
(46, 'Comités de obra', 2, 30, NULL),
(47, 'Presupuesto participativo', 3, 30, NULL),
(48, 'Encuestas ciudadanas', 4, 30, NULL),
(49, 'Ninguno', 5, 30, NULL),
(50, 'Seguridad', 1, 33, NULL),
(51, 'Limpieza', 2, 33, NULL),
(52, 'Alumbrado', 3, 33, NULL),
(53, 'Pavimentación', 4, 33, NULL),
(54, 'Áreas verdes', 5, 33, NULL),
(55, 'Sí, totalmente', 1, 38, NULL),
(56, 'En parte', 2, 38, NULL),
(57, 'No', 3, 38, NULL),
(58, 'Muy buena', 1, 39, NULL),
(59, 'Buena', 2, 39, NULL),
(60, 'Regular', 3, 39, '2026-08-31 00:58:55'),
(61, 'Registro', 1, 44, NULL),
(62, 'Consultas', 2, 44, NULL),
(63, 'Trámites', 3, 44, NULL),
(64, 'Otro', 4, 44, NULL),
(65, 'Sí', 1, 48, NULL),
(66, 'No', 2, 48, NULL),
(67, 'Tal vez', 3, 48, NULL),
(68, 'Registro', 1, 58, NULL),
(69, 'Atención al ciudadano', 2, 58, NULL),
(70, 'Archivo', 3, 58, NULL),
(71, 'Otra', 4, 58, NULL),
(72, 'Préstamo de libros', 1, 62, NULL),
(73, 'Sala de lectura', 2, 62, NULL),
(74, 'Acceso a internet', 3, 62, NULL),
(75, 'Actividades culturales', 4, 62, NULL),
(76, 'Sí', 1, 67, NULL),
(77, 'No', 2, 67, NULL),
(78, 'Sí', 1, 71, NULL),
(79, 'No', 2, 71, NULL),
(80, 'Tal vez', 3, 71, NULL),
(81, 'Consulta de eventos', 1, 78, NULL),
(82, 'Compra de boletos', 2, 78, NULL),
(83, 'Información cultural', 3, 78, NULL),
(84, 'Trámites', 4, 78, NULL),
(85, 'Totalmente de acuerdo', 1, 87, NULL),
(86, 'De acuerdo', 2, 87, NULL),
(87, 'En desacuerdo', 3, 87, NULL),
(88, 'Totalmente en desacuerdo', 4, 87, NULL),
(89, 'Fomento a las artes', 1, 88, NULL),
(90, 'Protección del patrimonio', 2, 88, NULL),
(91, 'Acceso a la cultura', 3, 88, NULL),
(92, 'Educación cultural', 4, 88, NULL),
(93, 'Registro de obra', 1, 95, NULL),
(94, 'Permisos', 2, 95, NULL),
(95, 'Consultas', 3, 95, NULL),
(96, 'Otro', 4, 95, NULL),
(97, 'Infraestructura', 1, 98, NULL),
(98, 'Recursos', 2, 98, NULL),
(99, 'Comunicación', 3, 98, NULL),
(100, 'Coreografía', 1, 102, NULL),
(101, 'Música', 2, 102, NULL),
(102, 'Vestuario', 3, 102, NULL),
(103, 'Ambiente', 4, 102, NULL),
(104, 'Café', 1, 112, NULL),
(105, 'Refrescos', 2, 112, NULL),
(106, 'Snacks', 3, 112, NULL),
(107, 'Comida', 4, 112, NULL),
(108, 'Semanalmente', 1, 114, NULL),
(109, 'Mensualmente', 2, 114, NULL),
(110, 'Ocasionalmente', 3, 114, NULL),
(111, 'Nunca', 4, 114, NULL),
(112, 'Sí', 1, 123, NULL),
(113, 'No', 2, 123, NULL),
(114, 'Tal vez', 3, 123, NULL),
(115, 'Totalmente de acuerdo', 1, 124, NULL),
(116, 'De acuerdo', 2, 124, NULL),
(117, 'En desacuerdo', 3, 124, NULL),
(118, 'Totalmente en desacuerdo', 4, 124, NULL),
(119, 'Fomento a las artes', 1, 125, NULL),
(120, 'Protección del patrimonio', 2, 125, NULL),
(121, 'Educación cultural', 3, 125, NULL),
(122, 'Acceso a la cultura', 4, 125, NULL),
(123, 'Talleres', 1, 138, NULL),
(124, 'Conciertos', 2, 138, NULL),
(125, 'Exposiciones', 3, 138, NULL),
(126, 'Cine', 4, 138, NULL),
(127, 'Consulta de catálogo', 1, 142, NULL),
(128, 'Descarga de libros', 2, 142, NULL),
(129, 'Reservas', 3, 142, NULL),
(130, 'Acceso a bases de datos', 4, 142, NULL),
(131, '18-25', 1, 147, NULL),
(132, '26-40', 2, 147, NULL),
(133, '41-60', 3, 147, NULL),
(134, 'Más de 60', 4, 147, NULL),
(135, 'Primaria', 1, 149, NULL),
(136, 'Secundaria', 2, 149, NULL),
(137, 'Bachillerato', 3, 149, NULL),
(138, 'Universidad', 4, 149, NULL),
(139, 'Posgrado', 5, 149, NULL),
(140, 'Semanalmente', 1, 150, NULL),
(141, 'Mensualmente', 2, 150, NULL),
(142, 'Ocasionalmente', 3, 150, NULL),
(143, 'Nunca', 4, 150, NULL),
(144, 'Conciertos', 1, 152, NULL),
(145, 'Teatro', 2, 152, NULL),
(146, 'Exposiciones', 3, 152, NULL),
(147, 'Talleres', 4, 152, NULL),
(148, 'Cine', 5, 152, NULL),
(149, 'Redes sociales', 1, 153, NULL),
(150, 'Página web', 2, 153, NULL),
(151, 'Correo electrónico', 3, 153, NULL),
(152, 'Perifoneo', 4, 153, NULL),
(153, 'Prensa', 5, 153, NULL),
(154, 'Velocidad de carga', 1, 159, NULL),
(155, 'Calidad de video', 2, 159, NULL),
(156, 'Interacción en vivo', 3, 159, NULL),
(157, 'Variedad de contenido', 4, 159, NULL),
(158, 'Facilidad de pago', 5, 159, NULL),
(159, 'Música', 1, 162, NULL),
(160, 'Teatro', 2, 162, NULL),
(161, 'Danza', 3, 162, NULL),
(162, 'Artes visuales', 4, 162, NULL),
(163, 'Literatura', 5, 162, NULL),
(164, 'Correo institucional', 1, 175, NULL),
(165, 'Reuniones presenciales', 2, 175, NULL),
(166, 'Intranet', 3, 175, NULL),
(167, 'Mensajería instantánea', 4, 175, NULL),
(168, 'Liderazgo', 1, 180, NULL),
(169, 'Tecnología', 2, 180, NULL),
(170, 'Idiomas', 3, 180, NULL),
(171, 'Habilidades blandas', 4, 180, NULL),
(172, 'Estabilidad laboral', 1, 185, NULL),
(173, 'Ambiente de trabajo', 2, 185, NULL),
(174, 'Oportunidades de crecimiento', 3, 185, NULL),
(175, 'Salario', 4, 185, NULL),
(176, 'Misión institucional', 5, 185, NULL),
(177, 'Menos de 1 año', 1, 188, NULL),
(178, '1-3 años', 2, 188, NULL),
(179, '4-6 años', 3, 188, NULL),
(180, 'Más de 6 años', 4, 188, NULL),
(181, 'Redes sociales', 1, 189, NULL),
(182, 'Recomendación', 2, 189, NULL),
(183, 'Página web', 3, 189, NULL),
(184, 'Escuela/universidad', 4, 189, NULL),
(185, 'Técnica artística', 1, 195, NULL),
(186, 'Teoría', 2, 195, NULL),
(187, 'Gestión cultural', 3, 195, NULL),
(188, 'Práctica', 4, 195, NULL),
(189, 'Solo', 1, 208, NULL),
(190, 'En pareja', 2, 208, NULL),
(191, 'Con familia', 3, 208, NULL),
(192, 'Con amigos', 4, 208, NULL),
(193, 'Excursión', 5, 208, NULL),
(194, 'Redes sociales', 1, 209, NULL),
(195, 'Recomendación', 2, 209, NULL),
(196, 'Página web', 3, 209, NULL),
(197, 'Publicidad', 4, 209, NULL),
(198, 'Menos de 1 hora', 1, 210, NULL),
(199, '1-2 horas', 2, 210, NULL),
(200, '2-3 horas', 3, 210, NULL),
(201, 'Más de 3 horas', 4, 210, NULL),
(202, 'Redes sociales', 1, 227, NULL),
(203, 'Radio', 2, 227, NULL),
(204, 'Televisión', 3, 227, NULL),
(205, 'Prensa escrita', 4, 227, NULL),
(206, 'Recomendación', 5, 227, NULL),
(207, 'Redes sociales', 1, 230, NULL),
(208, 'Radio', 2, 230, NULL),
(209, 'Televisión', 3, 230, NULL),
(210, 'Prensa escrita', 4, 230, NULL),
(211, 'Excelente', 1, 252, NULL),
(212, 'Bueno', 2, 252, NULL),
(213, 'Regular', 3, 252, NULL),
(214, 'Deficiente', 4, 252, NULL),
(215, 'Masculino', 1, 256, NULL),
(216, 'Femenino', 2, 256, NULL),
(217, 'Sí', 1, 261, NULL),
(218, 'No', 2, 261, NULL),
(219, '18-25', 1, 263, NULL),
(220, '26-40', 2, 263, NULL),
(221, '41-60', 3, 263, NULL),
(222, 'Más de 60', 4, 263, NULL),
(223, 'Primaria', 1, 265, NULL),
(224, 'Secundaria', 2, 265, NULL),
(225, 'Bachillerato', 3, 265, NULL),
(226, 'Universidad', 4, 265, NULL),
(227, 'Posgrado', 5, 265, NULL),
(228, 'Semanalmente', 1, 266, NULL),
(229, 'Mensualmente', 2, 266, NULL),
(230, 'Ocasionalmente', 3, 266, NULL),
(231, 'Nunca', 4, 266, NULL),
(232, 'Conciertos', 1, 268, NULL),
(233, 'Teatro', 2, 268, NULL),
(234, 'Exposiciones', 3, 268, NULL),
(235, 'Talleres', 4, 268, NULL),
(236, 'Cine', 5, 268, NULL),
(237, 'Redes sociales', 1, 269, NULL),
(238, 'Página web', 2, 269, NULL),
(239, 'Correo electrónico', 3, 269, NULL),
(240, 'Perifoneo', 4, 269, NULL),
(241, 'Prensa', 5, 269, NULL),
(242, 'Velocidad de carga', 1, 275, NULL),
(243, 'Calidad de video', 2, 275, NULL),
(244, 'Interacción en vivo', 3, 275, NULL),
(245, 'Variedad de contenido', 4, 275, NULL),
(246, 'Facilidad de pago', 5, 275, NULL),
(247, 'Música', 1, 278, NULL),
(248, 'Teatro', 2, 278, NULL),
(249, 'Danza', 3, 278, NULL),
(250, 'Artes visuales', 4, 278, NULL),
(251, 'Literatura', 5, 278, NULL),
(252, 'Masculino', 1, 284, NULL),
(253, 'Femenino', 2, 284, NULL),
(254, 'Redes sociales', 1, 286, NULL),
(255, 'Radio', 2, 286, NULL),
(256, 'Televisión', 3, 286, NULL),
(257, 'Prensa escrita', 4, 286, NULL),
(258, 'Recomendación', 5, 286, NULL),
(259, 'Redes sociales', 1, 289, NULL),
(260, 'Radio', 2, 289, NULL),
(261, 'Televisión', 3, 289, NULL),
(262, 'Prensa escrita', 4, 289, NULL),
(263, 'Redes sociales', 1, 306, NULL),
(264, 'Radio', 2, 306, NULL),
(265, 'Televisión', 3, 306, NULL),
(266, 'Prensa escrita', 4, 306, NULL),
(267, 'Recomendación', 5, 306, NULL),
(268, 'Redes sociales', 1, 309, NULL),
(269, 'Radio', 2, 309, NULL),
(270, 'Televisión', 3, 309, NULL),
(271, 'Prensa escrita', 4, 309, NULL),
(272, 'Redes sociales', 1, 326, NULL),
(273, 'Radio', 2, 326, NULL),
(274, 'Televisión', 3, 326, NULL),
(275, 'Prensa escrita', 4, 326, NULL),
(276, 'Recomendación', 5, 326, NULL),
(277, 'Redes sociales', 1, 329, NULL),
(278, 'Radio', 2, 329, NULL),
(279, 'Televisión', 3, 329, NULL),
(280, 'Prensa escrita', 4, 329, NULL),
(281, 'Redes sociales', 1, 346, NULL),
(282, 'Radio', 2, 346, NULL),
(283, 'Televisión', 3, 346, NULL),
(284, 'Prensa escrita', 4, 346, NULL),
(285, 'Recomendación', 5, 346, NULL),
(286, 'Redes sociales', 1, 349, NULL),
(287, 'Radio', 2, 349, NULL),
(288, 'Televisión', 3, 349, NULL),
(289, 'Prensa escrita', 4, 349, NULL),
(290, '18-25', 1, 366, NULL),
(291, '26-40', 2, 366, NULL),
(292, '41-60', 3, 366, NULL),
(293, 'Más de 60', 4, 366, NULL),
(294, 'Primaria', 1, 368, NULL),
(295, 'Secundaria', 2, 368, NULL),
(296, 'Bachillerato', 3, 368, NULL),
(297, 'Universidad', 4, 368, NULL),
(298, 'Posgrado', 5, 368, NULL),
(299, 'Semanalmente', 1, 369, NULL),
(300, 'Mensualmente', 2, 369, NULL),
(301, 'Ocasionalmente', 3, 369, NULL),
(302, 'Nunca', 4, 369, NULL),
(303, 'Conciertos', 1, 371, NULL),
(304, 'Teatro', 2, 371, NULL),
(305, 'Exposiciones', 3, 371, NULL),
(306, 'Talleres', 4, 371, NULL),
(307, 'Cine', 5, 371, NULL),
(308, 'Redes sociales', 1, 372, NULL),
(309, 'Página web', 2, 372, NULL),
(310, 'Correo electrónico', 3, 372, NULL),
(311, 'Perifoneo', 4, 372, NULL),
(312, 'Prensa', 5, 372, NULL),
(313, 'Velocidad de carga', 1, 378, NULL),
(314, 'Calidad de video', 2, 378, NULL),
(315, 'Interacción en vivo', 3, 378, NULL),
(316, 'Variedad de contenido', 4, 378, NULL),
(317, 'Facilidad de pago', 5, 378, NULL),
(318, 'Música', 1, 381, NULL),
(319, 'Teatro', 2, 381, NULL),
(320, 'Danza', 3, 381, NULL),
(321, 'Artes visuales', 4, 381, NULL),
(322, 'Literatura', 5, 381, NULL),
(323, '18-25', 1, 386, NULL),
(324, '26-40', 2, 386, NULL),
(325, '41-60', 3, 386, NULL),
(326, 'Más de 60', 4, 386, NULL),
(327, 'Primaria', 1, 388, NULL),
(328, 'Secundaria', 2, 388, NULL),
(329, 'Bachillerato', 3, 388, NULL),
(330, 'Universidad', 4, 388, NULL),
(331, 'Posgrado', 5, 388, NULL),
(332, 'Semanalmente', 1, 389, NULL),
(333, 'Mensualmente', 2, 389, NULL),
(334, 'Ocasionalmente', 3, 389, NULL),
(335, 'Nunca', 4, 389, NULL),
(336, 'Conciertos', 1, 391, NULL),
(337, 'Teatro', 2, 391, NULL),
(338, 'Exposiciones', 3, 391, NULL),
(339, 'Talleres', 4, 391, NULL),
(340, 'Cine', 5, 391, NULL),
(341, 'Redes sociales', 1, 392, NULL),
(342, 'Página web', 2, 392, NULL),
(343, 'Correo electrónico', 3, 392, NULL),
(344, 'Perifoneo', 4, 392, NULL),
(345, 'Prensa', 5, 392, NULL),
(346, 'Velocidad de carga', 1, 398, NULL),
(347, 'Calidad de video', 2, 398, NULL),
(348, 'Interacción en vivo', 3, 398, NULL),
(349, 'Variedad de contenido', 4, 398, NULL),
(350, 'Facilidad de pago', 5, 398, NULL),
(351, 'Música', 1, 401, NULL),
(352, 'Teatro', 2, 401, NULL),
(353, 'Danza', 3, 401, NULL),
(354, 'Artes visuales', 4, 401, NULL),
(355, 'Literatura', 5, 401, NULL),
(356, '18-25', 1, 406, NULL),
(357, '26-40', 2, 406, NULL),
(358, '41-60', 3, 406, NULL),
(359, 'Más de 60', 4, 406, NULL),
(360, 'Primaria', 1, 408, NULL),
(361, 'Secundaria', 2, 408, NULL),
(362, 'Bachillerato', 3, 408, NULL),
(363, 'Universidad', 4, 408, NULL),
(364, 'Posgrado', 5, 408, NULL),
(365, 'Semanalmente', 1, 409, NULL),
(366, 'Mensualmente', 2, 409, NULL),
(367, 'Ocasionalmente', 3, 409, NULL),
(368, 'Nunca', 4, 409, NULL),
(369, 'Conciertos', 1, 411, NULL),
(370, 'Teatro', 2, 411, NULL),
(371, 'Exposiciones', 3, 411, NULL),
(372, 'Talleres', 4, 411, NULL),
(373, 'Cine', 5, 411, NULL),
(374, 'Redes sociales', 1, 412, NULL),
(375, 'Página web', 2, 412, NULL),
(376, 'Correo electrónico', 3, 412, NULL),
(377, 'Perifoneo', 4, 412, NULL),
(378, 'Prensa', 5, 412, NULL),
(379, 'Velocidad de carga', 1, 418, NULL),
(380, 'Calidad de video', 2, 418, NULL),
(381, 'Interacción en vivo', 3, 418, NULL),
(382, 'Variedad de contenido', 4, 418, NULL),
(383, 'Facilidad de pago', 5, 418, NULL),
(384, 'Música', 1, 421, NULL),
(385, 'Teatro', 2, 421, NULL),
(386, 'Danza', 3, 421, NULL),
(387, 'Artes visuales', 4, 421, NULL),
(388, 'Literatura', 5, 421, NULL),
(389, '18-25', 1, 426, NULL),
(390, '26-40', 2, 426, NULL),
(391, '41-60', 3, 426, NULL),
(392, 'Más de 60', 4, 426, NULL),
(393, 'Primaria', 1, 428, NULL),
(394, 'Secundaria', 2, 428, NULL),
(395, 'Bachillerato', 3, 428, NULL),
(396, 'Universidad', 4, 428, NULL),
(397, 'Posgrado', 5, 428, NULL),
(398, 'Semanalmente', 1, 429, NULL),
(399, 'Mensualmente', 2, 429, NULL),
(400, 'Ocasionalmente', 3, 429, NULL),
(401, 'Nunca', 4, 429, NULL),
(402, 'Conciertos', 1, 431, NULL),
(403, 'Teatro', 2, 431, NULL),
(404, 'Exposiciones', 3, 431, NULL),
(405, 'Talleres', 4, 431, NULL),
(406, 'Cine', 5, 431, NULL),
(407, 'Redes sociales', 1, 432, NULL),
(408, 'Página web', 2, 432, NULL),
(409, 'Correo electrónico', 3, 432, NULL),
(410, 'Perifoneo', 4, 432, NULL),
(411, 'Prensa', 5, 432, NULL),
(412, 'Velocidad de carga', 1, 438, NULL),
(413, 'Calidad de video', 2, 438, NULL),
(414, 'Interacción en vivo', 3, 438, NULL),
(415, 'Variedad de contenido', 4, 438, NULL),
(416, 'Facilidad de pago', 5, 438, NULL),
(417, 'Música', 1, 441, NULL),
(418, 'Teatro', 2, 441, NULL),
(419, 'Danza', 3, 441, NULL),
(420, 'Artes visuales', 4, 441, NULL),
(421, 'Literatura', 5, 441, NULL),
(422, '18-25', 1, 446, NULL),
(423, '26-40', 2, 446, NULL),
(424, '41-60', 3, 446, NULL),
(425, 'Más de 60', 4, 446, NULL),
(426, 'Primaria', 1, 448, NULL),
(427, 'Secundaria', 2, 448, NULL),
(428, 'Bachillerato', 3, 448, NULL),
(429, 'Universidad', 4, 448, NULL),
(430, 'Posgrado', 5, 448, NULL),
(431, 'Semanalmente', 1, 449, NULL),
(432, 'Mensualmente', 2, 449, NULL),
(433, 'Ocasionalmente', 3, 449, NULL),
(434, 'Nunca', 4, 449, NULL),
(435, 'Conciertos', 1, 451, NULL),
(436, 'Teatro', 2, 451, NULL),
(437, 'Exposiciones', 3, 451, NULL),
(438, 'Talleres', 4, 451, NULL),
(439, 'Cine', 5, 451, NULL),
(440, 'Redes sociales', 1, 452, NULL),
(441, 'Página web', 2, 452, NULL),
(442, 'Correo electrónico', 3, 452, NULL),
(443, 'Perifoneo', 4, 452, NULL),
(444, 'Prensa', 5, 452, NULL),
(445, 'Velocidad de carga', 1, 458, NULL),
(446, 'Calidad de video', 2, 458, NULL),
(447, 'Interacción en vivo', 3, 458, NULL),
(448, 'Variedad de contenido', 4, 458, NULL),
(449, 'Facilidad de pago', 5, 458, NULL),
(450, 'Música', 1, 461, NULL),
(451, 'Teatro', 2, 461, NULL),
(452, 'Danza', 3, 461, NULL),
(453, 'Artes visuales', 4, 461, NULL),
(454, 'Literatura', 5, 461, NULL),
(455, '18-25', 1, 466, NULL),
(456, '26-40', 2, 466, NULL),
(457, '41-60', 3, 466, NULL),
(458, 'Más de 60', 4, 466, NULL),
(459, 'Primaria', 1, 468, NULL),
(460, 'Secundaria', 2, 468, NULL),
(461, 'Bachillerato', 3, 468, NULL),
(462, 'Universidad', 4, 468, NULL),
(463, 'Posgrado', 5, 468, NULL),
(464, 'Semanalmente', 1, 469, NULL),
(465, 'Mensualmente', 2, 469, NULL),
(466, 'Ocasionalmente', 3, 469, NULL),
(467, 'Nunca', 4, 469, NULL),
(468, 'Conciertos', 1, 471, NULL),
(469, 'Teatro', 2, 471, NULL),
(470, 'Exposiciones', 3, 471, NULL),
(471, 'Talleres', 4, 471, NULL),
(472, 'Cine', 5, 471, NULL),
(473, 'Redes sociales', 1, 472, NULL),
(474, 'Página web', 2, 472, NULL),
(475, 'Correo electrónico', 3, 472, NULL),
(476, 'Perifoneo', 4, 472, NULL),
(477, 'Prensa', 5, 472, NULL),
(478, 'Velocidad de carga', 1, 478, NULL),
(479, 'Calidad de video', 2, 478, NULL),
(480, 'Interacción en vivo', 3, 478, NULL),
(481, 'Variedad de contenido', 4, 478, NULL),
(482, 'Facilidad de pago', 5, 478, NULL),
(483, 'Música', 1, 481, NULL),
(484, 'Teatro', 2, 481, NULL),
(485, 'Danza', 3, 481, NULL),
(486, 'Artes visuales', 4, 481, NULL),
(487, 'Literatura', 5, 481, NULL),
(488, '18-25', 1, 486, NULL),
(489, '26-40', 2, 486, NULL),
(490, '41-60', 3, 486, NULL),
(491, 'Más de 60', 4, 486, NULL),
(492, 'Primaria', 1, 488, NULL),
(493, 'Secundaria', 2, 488, NULL),
(494, 'Bachillerato', 3, 488, NULL),
(495, 'Universidad', 4, 488, NULL),
(496, 'Posgrado', 5, 488, NULL),
(497, 'Semanalmente', 1, 489, NULL),
(498, 'Mensualmente', 2, 489, NULL),
(499, 'Ocasionalmente', 3, 489, NULL),
(500, 'Nunca', 4, 489, NULL),
(501, 'Conciertos', 1, 491, NULL),
(502, 'Teatro', 2, 491, NULL),
(503, 'Exposiciones', 3, 491, NULL),
(504, 'Talleres', 4, 491, NULL),
(505, 'Cine', 5, 491, NULL),
(506, 'Redes sociales', 1, 492, NULL),
(507, 'Página web', 2, 492, NULL),
(508, 'Correo electrónico', 3, 492, NULL),
(509, 'Perifoneo', 4, 492, NULL),
(510, 'Prensa', 5, 492, NULL),
(511, 'Velocidad de carga', 1, 498, NULL),
(512, 'Calidad de video', 2, 498, NULL),
(513, 'Interacción en vivo', 3, 498, NULL),
(514, 'Variedad de contenido', 4, 498, NULL),
(515, 'Facilidad de pago', 5, 498, NULL),
(516, 'Música', 1, 501, NULL),
(517, 'Teatro', 2, 501, NULL),
(518, 'Danza', 3, 501, NULL),
(519, 'Artes visuales', 4, 501, NULL),
(520, 'Literatura', 5, 501, NULL),
(521, '18-25', 1, 506, NULL),
(522, '26-40', 2, 506, NULL),
(523, '41-60', 3, 506, NULL),
(524, 'Más de 60', 4, 506, NULL),
(525, 'Primaria', 1, 508, NULL),
(526, 'Secundaria', 2, 508, NULL),
(527, 'Bachillerato', 3, 508, NULL),
(528, 'Universidad', 4, 508, NULL),
(529, 'Posgrado', 5, 508, NULL),
(530, 'Semanalmente', 1, 509, NULL),
(531, 'Mensualmente', 2, 509, NULL),
(532, 'Ocasionalmente', 3, 509, NULL),
(533, 'Nunca', 4, 509, NULL),
(534, 'Conciertos', 1, 511, NULL),
(535, 'Teatro', 2, 511, NULL),
(536, 'Exposiciones', 3, 511, NULL),
(537, 'Talleres', 4, 511, NULL),
(538, 'Cine', 5, 511, NULL),
(539, 'Redes sociales', 1, 512, NULL),
(540, 'Página web', 2, 512, NULL),
(541, 'Correo electrónico', 3, 512, NULL),
(542, 'Perifoneo', 4, 512, NULL),
(543, 'Prensa', 5, 512, NULL),
(544, 'Velocidad de carga', 1, 518, NULL),
(545, 'Calidad de video', 2, 518, NULL),
(546, 'Interacción en vivo', 3, 518, NULL),
(547, 'Variedad de contenido', 4, 518, NULL),
(548, 'Facilidad de pago', 5, 518, NULL),
(549, 'Música', 1, 521, NULL),
(550, 'Teatro', 2, 521, NULL),
(551, 'Danza', 3, 521, NULL),
(552, 'Artes visuales', 4, 521, NULL),
(553, 'Literatura', 5, 521, NULL),
(554, 'Redes sociales', 1, 527, NULL),
(555, 'Radio', 2, 527, NULL),
(556, 'Televisión', 3, 527, NULL),
(557, 'Prensa escrita', 4, 527, NULL),
(558, 'Recomendación', 5, 527, NULL),
(559, 'Redes sociales', 1, 530, NULL),
(560, 'Radio', 2, 530, NULL),
(561, 'Televisión', 3, 530, NULL),
(562, 'Prensa escrita', 4, 530, NULL),
(563, '18-25', 1, 547, NULL),
(564, '26-40', 2, 547, NULL),
(565, '41-60', 3, 547, NULL),
(566, 'Más de 60', 4, 547, NULL),
(567, 'Primaria', 1, 549, NULL),
(568, 'Secundaria', 2, 549, NULL),
(569, 'Bachillerato', 3, 549, NULL),
(570, 'Universidad', 4, 549, NULL),
(571, 'Posgrado', 5, 549, NULL),
(572, 'Semanalmente', 1, 550, NULL),
(573, 'Mensualmente', 2, 550, NULL),
(574, 'Ocasionalmente', 3, 550, NULL),
(575, 'Nunca', 4, 550, NULL),
(576, 'Conciertos', 1, 552, NULL),
(577, 'Teatro', 2, 552, NULL),
(578, 'Exposiciones', 3, 552, NULL),
(579, 'Talleres', 4, 552, NULL),
(580, 'Cine', 5, 552, NULL),
(581, 'Redes sociales', 1, 553, NULL),
(582, 'Página web', 2, 553, NULL),
(583, 'Correo electrónico', 3, 553, NULL),
(584, 'Perifoneo', 4, 553, NULL),
(585, 'Prensa', 5, 553, NULL),
(586, 'Velocidad de carga', 1, 559, NULL),
(587, 'Calidad de video', 2, 559, NULL),
(588, 'Interacción en vivo', 3, 559, NULL),
(589, 'Variedad de contenido', 4, 559, NULL),
(590, 'Facilidad de pago', 5, 559, NULL),
(591, 'Música', 1, 562, NULL),
(592, 'Teatro', 2, 562, NULL),
(593, 'Danza', 3, 562, NULL),
(594, 'Artes visuales', 4, 562, NULL),
(595, 'Literatura', 5, 562, NULL),
(596, '1', 1, 567, NULL),
(597, '2', 2, 567, NULL),
(598, '3', 3, 567, NULL),
(599, '18-25', 1, 568, NULL),
(600, '26-40', 2, 568, NULL),
(601, '41-60', 3, 568, NULL),
(602, 'Más de 60', 4, 568, NULL),
(603, 'Primaria', 1, 570, NULL),
(604, 'Secundaria', 2, 570, NULL),
(605, 'Bachillerato', 3, 570, NULL),
(606, 'Universidad', 4, 570, NULL),
(607, 'Posgrado', 5, 570, NULL),
(608, 'Semanalmente', 1, 571, NULL),
(609, 'Mensualmente', 2, 571, NULL),
(610, 'Ocasionalmente', 3, 571, NULL),
(611, 'Nunca', 4, 571, NULL),
(612, 'Conciertos', 1, 573, NULL),
(613, 'Teatro', 2, 573, NULL),
(614, 'Exposiciones', 3, 573, NULL),
(615, 'Talleres', 4, 573, NULL),
(616, 'Cine', 5, 573, NULL),
(617, 'Redes sociales', 1, 574, NULL),
(618, 'Página web', 2, 574, NULL),
(619, 'Correo electrónico', 3, 574, NULL),
(620, 'Perifoneo', 4, 574, NULL),
(621, 'Prensa', 5, 574, NULL),
(622, 'Velocidad de carga', 1, 580, NULL),
(623, 'Calidad de video', 2, 580, NULL),
(624, 'Interacción en vivo', 3, 580, NULL),
(625, 'Variedad de contenido', 4, 580, NULL),
(626, 'Facilidad de pago', 5, 580, NULL),
(627, 'Música', 1, 583, NULL),
(628, 'Teatro', 2, 583, NULL),
(629, 'Danza', 3, 583, NULL),
(630, 'Artes visuales', 4, 583, NULL),
(631, 'Literatura', 5, 583, NULL),
(632, '18-25', 1, 588, NULL),
(633, '26-40', 2, 588, NULL),
(634, '41-60', 3, 588, NULL),
(635, 'Más de 60', 4, 588, NULL),
(636, 'Primaria', 1, 590, NULL),
(637, 'Secundaria', 2, 590, NULL),
(638, 'Bachillerato', 3, 590, NULL),
(639, 'Universidad', 4, 590, NULL),
(640, 'Posgrado', 5, 590, NULL),
(641, 'Semanalmente', 1, 591, NULL),
(642, 'Mensualmente', 2, 591, NULL),
(643, 'Ocasionalmente', 3, 591, NULL),
(644, 'Nunca', 4, 591, NULL),
(645, 'Conciertos', 1, 593, NULL),
(646, 'Teatro', 2, 593, NULL),
(647, 'Exposiciones', 3, 593, NULL),
(648, 'Talleres', 4, 593, NULL),
(649, 'Cine', 5, 593, NULL),
(650, 'Redes sociales', 1, 594, NULL),
(651, 'Página web', 2, 594, NULL),
(652, 'Correo electrónico', 3, 594, NULL),
(653, 'Perifoneo', 4, 594, NULL),
(654, 'Prensa', 5, 594, NULL),
(655, 'Velocidad de carga', 1, 600, NULL),
(656, 'Calidad de video', 2, 600, NULL),
(657, 'Interacción en vivo', 3, 600, NULL),
(658, 'Variedad de contenido', 4, 600, NULL),
(659, 'Facilidad de pago', 5, 600, NULL),
(660, 'Música', 1, 603, NULL),
(661, 'Teatro', 2, 603, NULL),
(662, 'Danza', 3, 603, NULL),
(663, 'Artes visuales', 4, 603, NULL),
(664, 'Literatura', 5, 603, NULL),
(665, 'Velocidad de carga', 1, 610, NULL),
(666, 'Calidad de video', 2, 610, NULL),
(667, 'Interacción en vivo', 3, 610, NULL),
(668, 'Variedad de contenido', 4, 610, NULL),
(669, 'Facilidad de pago', 5, 610, NULL),
(670, 'Música', 1, 613, NULL),
(671, 'Teatro', 2, 613, NULL),
(672, 'Danza', 3, 613, NULL),
(673, 'Artes visuales', 4, 613, NULL),
(674, 'Literatura', 5, 613, NULL),
(675, 'Velocidad de carga', 1, 620, NULL),
(676, 'Calidad de video', 2, 620, NULL),
(677, 'Interacción en vivo', 3, 620, NULL),
(678, 'Variedad de contenido', 4, 620, NULL),
(679, 'Facilidad de pago', 5, 620, NULL),
(680, 'Música', 1, 623, NULL),
(681, 'Teatro', 2, 623, NULL),
(682, 'Danza', 3, 623, NULL),
(683, 'Artes visuales', 4, 623, NULL),
(684, 'Literatura', 5, 623, NULL),
(685, '18-25', 1, 628, NULL),
(686, '26-40', 2, 628, NULL),
(687, '41-60', 3, 628, NULL),
(688, 'Más de 60', 4, 628, NULL),
(689, 'Primaria', 1, 630, NULL),
(690, 'Secundaria', 2, 630, NULL),
(691, 'Bachillerato', 3, 630, NULL),
(692, 'Universidad', 4, 630, NULL),
(693, 'Posgrado', 5, 630, NULL),
(694, 'Semanalmente', 1, 631, NULL),
(695, 'Mensualmente', 2, 631, NULL),
(696, 'Ocasionalmente', 3, 631, NULL),
(697, 'Nunca', 4, 631, NULL),
(698, 'Conciertos', 1, 633, NULL),
(699, 'Teatro', 2, 633, NULL),
(700, 'Exposiciones', 3, 633, NULL),
(701, 'Talleres', 4, 633, NULL),
(702, 'Cine', 5, 633, NULL),
(703, 'Redes sociales', 1, 634, NULL),
(704, 'Página web', 2, 634, NULL),
(705, 'Correo electrónico', 3, 634, NULL),
(706, 'Perifoneo', 4, 634, NULL),
(707, 'Prensa', 5, 634, NULL),
(708, 'Velocidad de carga', 1, 640, NULL),
(709, 'Calidad de video', 2, 640, NULL),
(710, 'Interacción en vivo', 3, 640, NULL),
(711, 'Variedad de contenido', 4, 640, NULL),
(712, 'Facilidad de pago', 5, 640, NULL),
(713, 'Música', 1, 643, NULL),
(714, 'Teatro', 2, 643, NULL),
(715, 'Danza', 3, 643, NULL),
(716, 'Artes visuales', 4, 643, NULL),
(717, 'Literatura', 5, 643, NULL),
(718, '18-25', 1, 648, NULL),
(719, '26-40', 2, 648, NULL),
(720, '41-60', 3, 648, NULL),
(721, 'Más de 60', 4, 648, NULL),
(722, 'Primaria', 1, 650, NULL),
(723, 'Secundaria', 2, 650, NULL),
(724, 'Bachillerato', 3, 650, NULL),
(725, 'Universidad', 4, 650, NULL),
(726, 'Posgrado', 5, 650, NULL),
(727, 'Semanalmente', 1, 651, NULL),
(728, 'Mensualmente', 2, 651, NULL),
(729, 'Ocasionalmente', 3, 651, NULL),
(730, 'Nunca', 4, 651, NULL),
(731, 'Conciertos', 1, 653, NULL),
(732, 'Teatro', 2, 653, NULL),
(733, 'Exposiciones', 3, 653, NULL),
(734, 'Talleres', 4, 653, NULL),
(735, 'Cine', 5, 653, NULL),
(736, 'Redes sociales', 1, 654, NULL),
(737, 'Página web', 2, 654, NULL),
(738, 'Correo electrónico', 3, 654, NULL),
(739, 'Perifoneo', 4, 654, NULL),
(740, 'Prensa', 5, 654, NULL),
(741, 'Velocidad de carga', 1, 660, NULL),
(742, 'Calidad de video', 2, 660, NULL),
(743, 'Interacción en vivo', 3, 660, NULL),
(744, 'Variedad de contenido', 4, 660, NULL),
(745, 'Facilidad de pago', 5, 660, NULL),
(746, 'Música', 1, 663, NULL),
(747, 'Teatro', 2, 663, NULL),
(748, 'Danza', 3, 663, NULL),
(749, 'Artes visuales', 4, 663, NULL),
(750, 'Literatura', 5, 663, NULL),
(751, '18-25', 1, 668, NULL),
(752, '26-40', 2, 668, NULL),
(753, '41-60', 3, 668, NULL),
(754, 'Más de 60', 4, 668, NULL),
(755, 'Primaria', 1, 670, NULL),
(756, 'Secundaria', 2, 670, NULL),
(757, 'Bachillerato', 3, 670, NULL),
(758, 'Universidad', 4, 670, NULL),
(759, 'Posgrado', 5, 670, NULL),
(760, 'Semanalmente', 1, 671, NULL),
(761, 'Mensualmente', 2, 671, NULL),
(762, 'Ocasionalmente', 3, 671, NULL),
(763, 'Nunca', 4, 671, NULL),
(764, 'Conciertos', 1, 673, NULL),
(765, 'Teatro', 2, 673, NULL),
(766, 'Exposiciones', 3, 673, NULL),
(767, 'Talleres', 4, 673, NULL),
(768, 'Cine', 5, 673, NULL),
(769, 'Redes sociales', 1, 674, NULL),
(770, 'Página web', 2, 674, NULL),
(771, 'Correo electrónico', 3, 674, NULL),
(772, 'Perifoneo', 4, 674, NULL),
(773, 'Prensa', 5, 674, NULL),
(774, 'Velocidad de carga', 1, 680, NULL),
(775, 'Calidad de video', 2, 680, NULL),
(776, 'Interacción en vivo', 3, 680, NULL),
(777, 'Variedad de contenido', 4, 680, NULL),
(778, 'Facilidad de pago', 5, 680, NULL),
(779, 'Música', 1, 683, NULL),
(780, 'Teatro', 2, 683, NULL),
(781, 'Danza', 3, 683, NULL),
(782, 'Artes visuales', 4, 683, NULL),
(783, 'Literatura', 5, 683, NULL),
(784, 'Muy buena', 1, 688, NULL),
(785, 'Buena', 2, 688, NULL),
(786, 'Regular', 3, 688, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resource`
--

CREATE TABLE `resource` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `stock` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `date_expired` timestamp NULL DEFAULT NULL,
  `active_num` varchar(255) NOT NULL,
  `serial_num` varchar(255) NOT NULL,
  `brand_id` bigint(20) UNSIGNED NOT NULL,
  `ubication_id` bigint(20) UNSIGNED NOT NULL,
  `type_id` bigint(20) UNSIGNED NOT NULL,
  `extend_id` bigint(20) UNSIGNED NOT NULL,
  `material_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `responses`
--

CREATE TABLE `responses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `anonymous_identifier` char(36) DEFAULT NULL,
  `source_ip` varchar(255) DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `text_value` text DEFAULT NULL,
  `scale_value` int(11) DEFAULT NULL,
  `boolean_value` tinyint(1) DEFAULT NULL,
  `question_id` bigint(20) UNSIGNED NOT NULL,
  `survey_id` bigint(20) UNSIGNED NOT NULL,
  `participant_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `responses`
--

INSERT INTO `responses` (`id`, `anonymous_identifier`, `source_ip`, `submitted_at`, `is_completed`, `text_value`, `scale_value`, `boolean_value`, `question_id`, `survey_id`, `participant_id`) VALUES
(1, NULL, '127.0.0.1', '2026-08-25 00:21:38', 1, NULL, NULL, 1, 13, 4, 4),
(2, NULL, '127.0.0.1', '2026-08-25 00:21:38', 1, NULL, NULL, 0, 14, 4, 4),
(3, NULL, '127.0.0.1', '2026-08-25 00:30:47', 1, NULL, NULL, 0, 13, 4, 7),
(4, NULL, '127.0.0.1', '2026-08-25 00:30:47', 1, NULL, NULL, 0, 14, 4, 7),
(5, NULL, '127.0.0.1', '2026-08-25 00:32:31', 1, NULL, NULL, 1, 13, 4, 6),
(6, NULL, '127.0.0.1', '2026-08-25 00:32:31', 1, NULL, NULL, 1, 14, 4, 6),
(7, 'd7367de0-7b5d-47a8-b68c-eb209c1ce445', '127.0.0.1', '2026-08-25 00:39:33', 1, NULL, NULL, NULL, 15, 5, NULL),
(8, '5f1170fa-0b9b-4bf9-9677-9bcddcfda3e4', '127.0.0.1', '2026-08-27 20:35:00', 1, 'ghhghgfj', NULL, NULL, 18, 8, NULL),
(9, '7df855a9-8922-48f5-bf9c-f57212a543c8', '127.0.0.1', '2026-08-27 20:35:00', 1, 'gnghhg', NULL, NULL, 19, 8, NULL),
(10, 'c47daab1-b674-4dae-bc71-19a2e81e567b', '127.0.0.1', '2026-08-27 20:35:00', 1, NULL, NULL, NULL, 20, 8, NULL),
(11, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, 'dddddddddddddddd', NULL, NULL, 21, 9, 10),
(12, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, NULL, NULL, 22, 9, 10),
(13, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, NULL, NULL, 23, 9, 10),
(14, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, NULL, 0, 24, 9, 10),
(15, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, 4, NULL, 25, 9, 10),
(16, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, NULL, NULL, 26, 9, 10),
(17, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, 2, NULL, 27, 9, 10),
(18, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, 'cccccc', NULL, NULL, 28, 9, 10),
(19, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, NULL, NULL, 29, 9, 10),
(20, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, NULL, NULL, 30, 9, 10),
(21, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, NULL, 1, 31, 9, 10),
(22, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, 'ccc', NULL, NULL, 32, 9, 10),
(23, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, NULL, 1, 33, 9, 10),
(24, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, NULL, 3, NULL, 34, 9, 10),
(25, NULL, '127.0.0.1', '2026-08-30 00:53:19', 1, 'dsddddddddd', NULL, NULL, 35, 9, 10),
(26, NULL, '192.168.1.10', '2026-08-31 01:20:11', 1, NULL, 4, NULL, 42, 14, 11),
(27, NULL, '192.168.1.10', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 43, 14, 11),
(28, NULL, '192.168.1.10', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 44, 14, 11),
(29, NULL, '192.168.1.10', '2026-08-31 01:20:11', 1, 'Muy buena atención', NULL, NULL, 45, 14, 11),
(30, NULL, '192.168.1.11', '2026-08-31 01:20:11', 1, NULL, 5, NULL, 42, 14, 12),
(31, NULL, '192.168.1.11', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 43, 14, 12),
(32, NULL, '192.168.1.11', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 44, 14, 12),
(33, NULL, '192.168.1.11', '2026-08-31 01:20:11', 1, 'Excelente servicio', NULL, NULL, 45, 14, 12),
(34, NULL, '10.0.0.5', '2026-08-31 01:20:11', 1, NULL, 5, NULL, 46, 15, 13),
(35, NULL, '10.0.0.5', '2026-08-31 01:20:11', 1, NULL, 4, NULL, 47, 15, 13),
(36, NULL, '10.0.0.5', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 48, 15, 13),
(37, NULL, '10.0.0.5', '2026-08-31 01:20:11', 1, 'Muy buen festival', NULL, NULL, 49, 15, 13),
(38, NULL, '10.0.0.6', '2026-08-31 01:20:11', 1, NULL, 3, NULL, 46, 15, 14),
(39, NULL, '10.0.0.6', '2026-08-31 01:20:11', 1, NULL, 5, NULL, 47, 15, 14),
(40, NULL, '10.0.0.6', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 48, 15, 14),
(41, NULL, '10.0.0.6', '2026-08-31 01:20:11', 1, 'Mejorar sonido', NULL, NULL, 49, 15, 14),
(42, 'aaaa1111-1111-1111-1111-111111111111', '200.100.50.1', '2026-08-31 01:20:11', 1, NULL, 5, NULL, 56, 18, NULL),
(43, 'aaaa1111-1111-1111-1111-111111111111', '200.100.50.1', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 57, 18, NULL),
(44, 'aaaa1111-1111-1111-1111-111111111111', '200.100.50.1', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 58, 18, NULL),
(45, 'aaaa1111-1111-1111-1111-111111111111', '200.100.50.1', '2026-08-31 01:20:11', 1, 'Muy buena atención', NULL, NULL, 59, 18, NULL),
(46, 'bbbb2222-2222-2222-2222-222222222222', '200.100.50.2', '2026-08-31 01:20:11', 1, NULL, 3, NULL, 56, 18, NULL),
(47, 'bbbb2222-2222-2222-2222-222222222222', '200.100.50.2', '2026-08-31 01:20:11', 1, NULL, NULL, 0, 57, 18, NULL),
(48, 'bbbb2222-2222-2222-2222-222222222222', '200.100.50.2', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 58, 18, NULL),
(49, 'bbbb2222-2222-2222-2222-222222222222', '200.100.50.2', '2026-08-31 01:20:11', 1, 'Poca claridad en información', NULL, NULL, 59, 18, NULL),
(50, NULL, '192.168.2.10', '2026-08-31 01:20:11', 1, NULL, 5, NULL, 60, 19, 17),
(51, NULL, '192.168.2.10', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 61, 19, 17),
(52, NULL, '192.168.2.10', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 62, 19, 17),
(53, NULL, '192.168.2.10', '2026-08-31 01:20:11', 1, 'Me encanta la biblioteca', NULL, NULL, 63, 19, 17),
(54, NULL, '192.168.2.11', '2026-08-31 01:20:11', 1, NULL, 4, NULL, 60, 19, 18),
(55, NULL, '192.168.2.11', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 61, 19, 18),
(56, NULL, '192.168.2.11', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 62, 19, 18),
(57, NULL, '192.168.2.11', '2026-08-31 01:20:11', 1, 'Ampliar horario', NULL, NULL, 63, 19, 18),
(58, NULL, '10.1.0.10', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 64, 20, 19),
(59, NULL, '10.1.0.10', '2026-08-31 01:20:11', 1, NULL, 5, NULL, 65, 20, 19),
(60, NULL, '10.1.0.10', '2026-08-31 01:20:11', 1, 'La obra abstracta fue la mejor', NULL, NULL, 66, 20, 19),
(61, NULL, '10.1.0.10', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 67, 20, 19),
(62, NULL, '10.1.0.11', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 64, 20, 20),
(63, NULL, '10.1.0.11', '2026-08-31 01:20:11', 1, NULL, 4, NULL, 65, 20, 20),
(64, NULL, '10.1.0.11', '2026-08-31 01:20:11', 1, 'Me gustó la instalación de luces', NULL, NULL, 66, 20, 20),
(65, NULL, '10.1.0.11', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 67, 20, 20),
(66, NULL, '10.2.0.10', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 72, 22, 21),
(67, NULL, '10.2.0.10', '2026-08-31 01:20:11', 1, NULL, 5, NULL, 73, 22, 21),
(68, NULL, '10.2.0.10', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 74, 22, 21),
(69, NULL, '10.2.0.10', '2026-08-31 01:20:11', 1, 'Muy seguro', NULL, NULL, 75, 22, 21),
(70, NULL, '10.2.0.11', '2026-08-31 01:20:11', 1, NULL, NULL, 0, 72, 22, 22),
(71, NULL, '10.2.0.11', '2026-08-31 01:20:11', 1, NULL, 3, NULL, 73, 22, 22),
(72, NULL, '10.2.0.11', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 74, 22, 22),
(73, NULL, '10.2.0.11', '2026-08-31 01:20:11', 1, 'Faltan más guardias en la noche', NULL, NULL, 75, 22, 22),
(74, NULL, '10.3.0.10', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 83, 25, 23),
(75, NULL, '10.3.0.10', '2026-08-31 01:20:11', 1, NULL, 4, NULL, 84, 25, 23),
(76, NULL, '10.3.0.10', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 85, 25, 23),
(77, NULL, '10.3.0.10', '2026-08-31 01:20:11', 1, 'Buen servicio', NULL, NULL, 86, 25, 23),
(78, NULL, '10.3.0.11', '2026-08-31 01:20:11', 1, NULL, NULL, 0, 83, 25, 24),
(79, NULL, '10.3.0.11', '2026-08-31 01:20:11', 1, NULL, 2, NULL, 84, 25, 24),
(80, NULL, '10.3.0.11', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 85, 25, 24),
(81, NULL, '10.3.0.11', '2026-08-31 01:20:11', 1, 'Vehículo incómodo', NULL, NULL, 86, 25, 24),
(82, NULL, '10.4.0.10', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 93, 28, 25),
(83, NULL, '10.4.0.10', '2026-08-31 01:20:11', 1, NULL, 5, NULL, 94, 28, 25),
(84, NULL, '10.4.0.10', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 95, 28, 25),
(85, NULL, '10.4.0.10', '2026-08-31 01:20:11', 1, 'Muy claro', NULL, NULL, 96, 28, 25),
(86, NULL, '10.4.0.11', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 93, 28, 26),
(87, NULL, '10.4.0.11', '2026-08-31 01:20:11', 1, NULL, 4, NULL, 94, 28, 26),
(88, NULL, '10.4.0.11', '2026-08-31 01:20:11', 1, NULL, NULL, NULL, 95, 28, 26),
(89, NULL, '10.4.0.11', '2026-08-31 01:20:11', 1, 'Podrían simplificar pasos', NULL, NULL, 96, 28, 26),
(90, NULL, '192.168.10.1', '2026-08-31 01:20:11', 1, NULL, NULL, 1, 90, 27, 27),
(91, NULL, '192.168.10.1', '2026-08-31 01:20:11', 1, NULL, 4, NULL, 91, 27, 27),
(92, NULL, '192.168.10.1', '2026-08-31 01:20:11', 1, 'Falta más comunicación interna', NULL, NULL, 92, 27, 27),
(93, NULL, '192.168.10.2', '2026-08-31 01:20:11', 1, NULL, NULL, 0, 90, 27, 28),
(94, NULL, '192.168.10.2', '2026-08-31 01:20:11', 1, NULL, 3, NULL, 91, 27, 28),
(95, NULL, '192.168.10.2', '2026-08-31 01:20:11', 1, 'Mejorar espacios de descanso', NULL, NULL, 92, 27, 28),
(96, NULL, '192.168.3.1', '2026-08-31 01:22:00', 1, NULL, 4, NULL, 97, 29, 29),
(97, NULL, '192.168.3.1', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 98, 29, 29),
(98, NULL, '192.168.3.1', '2026-08-31 01:22:00', 1, 'Mejorar iluminación', NULL, NULL, 99, 29, 29),
(99, NULL, '192.168.3.2', '2026-08-31 01:22:00', 1, NULL, 5, NULL, 97, 29, 30),
(100, NULL, '192.168.3.2', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 98, 29, 30),
(101, NULL, '192.168.3.2', '2026-08-31 01:22:00', 1, 'Excelente ambiente', NULL, NULL, 99, 29, 30),
(102, NULL, '10.0.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 100, 30, 31),
(103, NULL, '10.0.1.5', '2026-08-31 01:22:00', 1, NULL, 5, NULL, 101, 30, 31),
(104, NULL, '10.0.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 102, 30, 31),
(105, NULL, '10.0.1.5', '2026-08-31 01:22:00', 1, 'Muy completo', NULL, NULL, 103, 30, 31),
(106, NULL, '10.0.1.6', '2026-08-31 01:22:00', 1, NULL, NULL, 0, 100, 30, 32),
(107, NULL, '10.0.1.6', '2026-08-31 01:22:00', 1, NULL, 4, NULL, 101, 30, 32),
(108, NULL, '10.0.1.6', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 102, 30, 32),
(109, NULL, '10.0.1.6', '2026-08-31 01:22:00', 1, 'Faltó más práctica', NULL, NULL, 103, 30, 32),
(110, NULL, '10.2.1.5', '2026-08-31 01:22:00', 1, NULL, 4, NULL, 110, 33, 33),
(111, NULL, '10.2.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 111, 33, 33),
(112, NULL, '10.2.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 112, 33, 33),
(113, NULL, '10.2.1.5', '2026-08-31 01:22:00', 1, 'Buen café', NULL, NULL, 113, 33, 33),
(114, NULL, '10.2.1.6', '2026-08-31 01:22:00', 1, NULL, 3, NULL, 110, 33, 34),
(115, NULL, '10.2.1.6', '2026-08-31 01:22:00', 1, NULL, NULL, 0, 111, 33, 34),
(116, NULL, '10.2.1.6', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 112, 33, 34),
(117, NULL, '10.2.1.6', '2026-08-31 01:22:00', 1, 'Precios altos', NULL, NULL, 113, 33, 34),
(118, NULL, '10.3.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 114, 34, 35),
(119, NULL, '10.3.1.5', '2026-08-31 01:22:00', 1, NULL, 4, NULL, 115, 34, 35),
(120, NULL, '10.3.1.5', '2026-08-31 01:22:00', 1, 'Más teatro', NULL, NULL, 116, 34, 35),
(121, NULL, '10.4.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 117, 35, 36),
(122, NULL, '10.4.1.5', '2026-08-31 01:22:00', 1, NULL, 5, NULL, 118, 35, 36),
(123, NULL, '10.4.1.5', '2026-08-31 01:22:00', 1, 'El salón principal', NULL, NULL, 119, 35, 36),
(124, NULL, '10.4.1.6', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 117, 35, 37),
(125, NULL, '10.4.1.6', '2026-08-31 01:22:00', 1, NULL, 4, NULL, 118, 35, 37),
(126, NULL, '10.4.1.6', '2026-08-31 01:22:00', 1, 'La vista desde el balcón', NULL, NULL, 119, 35, 37),
(127, NULL, '10.5.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 120, 36, 38),
(128, NULL, '10.5.1.5', '2026-08-31 01:22:00', 1, NULL, 5, NULL, 121, 36, 38),
(129, NULL, '10.5.1.5', '2026-08-31 01:22:00', 1, 'La sinfonía de Beethoven', NULL, NULL, 122, 36, 38),
(130, NULL, '10.5.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 123, 36, 38),
(131, NULL, '192.168.4.1', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 127, 38, 39),
(132, NULL, '192.168.4.1', '2026-08-31 01:22:00', 1, NULL, 4, NULL, 128, 38, 39),
(133, NULL, '192.168.4.1', '2026-08-31 01:22:00', 1, 'Más espacios de descanso', NULL, NULL, 129, 38, 39),
(134, NULL, '10.6.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 130, 39, 40),
(135, NULL, '10.6.1.5', '2026-08-31 01:22:00', 1, NULL, 5, NULL, 131, 39, 40),
(136, NULL, '10.6.1.5', '2026-08-31 01:22:00', 1, 'Muy eficiente', NULL, NULL, 132, 39, 40),
(137, NULL, '10.7.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 136, 41, 41),
(138, NULL, '10.7.1.5', '2026-08-31 01:22:00', 1, NULL, 5, NULL, 137, 41, 41),
(139, NULL, '10.7.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 138, 41, 41),
(140, NULL, '10.7.1.5', '2026-08-31 01:22:00', 1, 'Me encantan los talleres', NULL, NULL, 139, 41, 41),
(141, NULL, '10.8.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 140, 42, 42),
(142, NULL, '10.8.1.5', '2026-08-31 01:22:00', 1, NULL, 4, NULL, 141, 42, 42),
(143, NULL, '10.8.1.5', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 142, 42, 42),
(144, NULL, '10.8.1.5', '2026-08-31 01:22:00', 1, 'Excelente plataforma', NULL, NULL, 143, 42, 42),
(145, NULL, '10.8.1.6', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 140, 42, 43),
(146, NULL, '10.8.1.6', '2026-08-31 01:22:00', 1, NULL, 5, NULL, 141, 42, 43),
(147, NULL, '10.8.1.6', '2026-08-31 01:22:00', 1, NULL, NULL, NULL, 142, 42, 43),
(148, NULL, '10.8.1.6', '2026-08-31 01:22:00', 1, 'Añadir más libros digitales', NULL, NULL, 143, 42, 43),
(149, NULL, '192.168.5.1', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 144, 43, 44),
(150, NULL, '192.168.5.1', '2026-08-31 01:22:00', 1, NULL, 5, NULL, 145, 43, 44),
(151, NULL, '192.168.5.1', '2026-08-31 01:22:00', 1, 'Pintura y escultura', NULL, NULL, 146, 43, 44),
(152, NULL, '192.168.5.2', '2026-08-31 01:22:00', 1, NULL, NULL, 1, 144, 43, 45),
(153, NULL, '192.168.5.2', '2026-08-31 01:22:00', 1, NULL, 4, NULL, 145, 43, 45),
(154, NULL, '192.168.5.2', '2026-08-31 01:22:00', 1, 'Fotografía', NULL, NULL, 146, 43, 45),
(155, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 147, 44, 46),
(156, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, 'San Salvador', NULL, NULL, 148, 44, 46),
(157, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 149, 44, 46),
(158, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 150, 44, 46),
(159, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 151, 44, 46),
(160, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 152, 44, 46),
(161, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 153, 44, 46),
(162, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 154, 44, 46),
(163, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 155, 44, 46),
(164, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, 'Falta de tiempo', NULL, NULL, 156, 44, 46),
(165, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 157, 44, 46),
(166, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 158, 44, 46),
(167, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 159, 44, 46),
(168, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 160, 44, 46),
(169, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, 'Excelente plataforma', NULL, NULL, 161, 44, 46),
(170, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 162, 44, 46),
(171, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 163, 44, 46),
(172, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 164, 44, 46),
(173, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, 'Mejorar difusión', NULL, NULL, 165, 44, 46),
(174, NULL, '192.168.11.1', '2026-08-31 01:26:24', 1, 'Ninguno', NULL, NULL, 166, 44, 46),
(175, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 147, 44, 47),
(176, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, 'La Libertad', NULL, NULL, 148, 44, 47),
(177, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 149, 44, 47),
(178, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 150, 44, 47),
(179, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 151, 44, 47),
(180, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 152, 44, 47),
(181, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 153, 44, 47),
(182, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 154, 44, 47),
(183, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, 3, NULL, 155, 44, 47),
(184, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, 'Poca oferta en mi zona', NULL, NULL, 156, 44, 47),
(185, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 157, 44, 47),
(186, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 158, 44, 47),
(187, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 159, 44, 47),
(188, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 160, 44, 47),
(189, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, 'Mejorar acceso', NULL, NULL, 161, 44, 47),
(190, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 162, 44, 47),
(191, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 163, 44, 47),
(192, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 164, 44, 47),
(193, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, 'Ampliar horarios', NULL, NULL, 165, 44, 47),
(194, NULL, '192.168.11.2', '2026-08-31 01:26:24', 1, 'Gracias', NULL, NULL, 166, 44, 47),
(195, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 167, 45, 48),
(196, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 168, 45, 48),
(197, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 169, 45, 48),
(198, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 170, 45, 48),
(199, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, 'Mejorar iluminación', NULL, NULL, 171, 45, 48),
(200, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 172, 45, 48),
(201, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 173, 45, 48),
(202, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 174, 45, 48),
(203, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 175, 45, 48),
(204, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, 'Buena comunicación', NULL, NULL, 176, 45, 48),
(205, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 177, 45, 48),
(206, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 178, 45, 48),
(207, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 179, 45, 48),
(208, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 180, 45, 48),
(209, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, 'Más cursos de liderazgo', NULL, NULL, 181, 45, 48),
(210, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 182, 45, 48),
(211, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 183, 45, 48),
(212, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 184, 45, 48),
(213, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 185, 45, 48),
(214, NULL, '192.168.12.1', '2026-08-31 01:26:24', 1, 'Excelente institución', NULL, NULL, 186, 45, 48),
(215, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 167, 45, 49),
(216, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, 3, NULL, 168, 45, 49),
(217, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 169, 45, 49),
(218, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 170, 45, 49),
(219, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, 'Mejorar espacios', NULL, NULL, 171, 45, 49),
(220, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 172, 45, 49),
(221, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, 3, NULL, 173, 45, 49),
(222, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 174, 45, 49),
(223, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 175, 45, 49),
(224, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, 'Falta más transparencia', NULL, NULL, 176, 45, 49),
(225, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 177, 45, 49),
(226, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, 2, NULL, 178, 45, 49),
(227, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 179, 45, 49),
(228, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 180, 45, 49),
(229, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, 'Cursos de actualización', NULL, NULL, 181, 45, 49),
(230, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 182, 45, 49),
(231, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, 3, NULL, 183, 45, 49),
(232, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 184, 45, 49),
(233, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 185, 45, 49),
(234, NULL, '192.168.12.2', '2026-08-31 01:26:24', 1, 'Espero mejoras', NULL, NULL, 186, 45, 49),
(235, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 187, 46, 50),
(236, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 188, 46, 50),
(237, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 189, 46, 50),
(238, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, 'Mejorar mi técnica', NULL, NULL, 190, 46, 50),
(239, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 191, 46, 50),
(240, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 192, 46, 50),
(241, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 193, 46, 50),
(242, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 194, 46, 50),
(243, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 195, 46, 50),
(244, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, 'Profundizar en gestión', NULL, NULL, 196, 46, 50),
(245, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 197, 46, 50),
(246, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 198, 46, 50),
(247, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 199, 46, 50),
(248, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 200, 46, 50),
(249, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, 'Muy buenos instructores', NULL, NULL, 201, 46, 50),
(250, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 202, 46, 50),
(251, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 203, 46, 50),
(252, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 204, 46, 50),
(253, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 205, 46, 50),
(254, NULL, '192.168.13.1', '2026-08-31 01:26:24', 1, 'Excelente programa', NULL, NULL, 206, 46, 50),
(255, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 187, 46, 51),
(256, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 188, 46, 51),
(257, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 189, 46, 51),
(258, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, 'Aprender nuevas disciplinas', NULL, NULL, 190, 46, 51),
(259, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 191, 46, 51),
(260, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 192, 46, 51),
(261, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 193, 46, 51),
(262, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 194, 46, 51),
(263, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 195, 46, 51),
(264, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, 'Más práctica', NULL, NULL, 196, 46, 51),
(265, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 197, 46, 51),
(266, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 198, 46, 51),
(267, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 199, 46, 51),
(268, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 200, 46, 51),
(269, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, 'Bien', NULL, NULL, 201, 46, 51),
(270, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 202, 46, 51),
(271, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 203, 46, 51),
(272, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 204, 46, 51),
(273, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 205, 46, 51),
(274, NULL, '192.168.13.2', '2026-08-31 01:26:24', 1, 'Muy bueno', NULL, NULL, 206, 46, 51),
(275, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 207, 47, 52),
(276, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 208, 47, 52),
(277, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 209, 47, 52),
(278, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 210, 47, 52),
(279, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 211, 47, 52),
(280, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 212, 47, 52),
(281, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 213, 47, 52),
(282, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 214, 47, 52),
(283, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, 'Arte contemporáneo', NULL, NULL, 215, 47, 52),
(284, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, 'Nada', NULL, NULL, 216, 47, 52),
(285, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 217, 47, 52),
(286, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 218, 47, 52),
(287, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 219, 47, 52),
(288, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 220, 47, 52),
(289, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, 'Todo excelente', NULL, NULL, 221, 47, 52),
(290, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 222, 47, 52),
(291, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 223, 47, 52),
(292, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 224, 47, 52),
(293, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, 'La guía', NULL, NULL, 225, 47, 52),
(294, NULL, '192.168.14.1', '2026-08-31 01:26:24', 1, 'Volveré', NULL, NULL, 226, 47, 52),
(295, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 207, 47, 53),
(296, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 208, 47, 53),
(297, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 209, 47, 53),
(298, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 210, 47, 53),
(299, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 211, 47, 53),
(300, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 212, 47, 53),
(301, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 213, 47, 53),
(302, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 214, 47, 53),
(303, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, 'Historia precolombina', NULL, NULL, 215, 47, 53),
(304, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, 'Más información en inglés', NULL, NULL, 216, 47, 53),
(305, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 217, 47, 53),
(306, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 218, 47, 53),
(307, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 219, 47, 53),
(308, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, 3, NULL, 220, 47, 53),
(309, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, 'Mejorar accesos', NULL, NULL, 221, 47, 53),
(310, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 222, 47, 53),
(311, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 223, 47, 53),
(312, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 224, 47, 53),
(313, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, 'Las piezas arqueológicas', NULL, NULL, 225, 47, 53),
(314, NULL, '192.168.14.2', '2026-08-31 01:26:24', 1, 'Buena experiencia', NULL, NULL, 226, 47, 53),
(315, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 227, 48, 54),
(316, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 228, 48, 54),
(317, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 229, 48, 54),
(318, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 230, 48, 54),
(319, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, 'Ampliar difusión en redes', NULL, NULL, 231, 48, 54),
(320, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 232, 48, 54),
(321, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 233, 48, 54),
(322, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 234, 48, 54),
(323, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 235, 48, 54),
(324, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, 'Ninguno', NULL, NULL, 236, 48, 54),
(325, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 237, 48, 54),
(326, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 238, 48, 54),
(327, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 239, 48, 54),
(328, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, 'Orquesta sinfónica', NULL, NULL, 240, 48, 54),
(329, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, 'Excelente calidad', NULL, NULL, 241, 48, 54),
(330, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 242, 48, 54),
(331, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, 5, NULL, 243, 48, 54),
(332, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 244, 48, 54),
(333, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, 'El cierre con fuegos artificiales', NULL, NULL, 245, 48, 54),
(334, NULL, '192.168.15.1', '2026-08-31 01:26:24', 1, 'Felicitaciones', NULL, NULL, 246, 48, 54),
(335, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 227, 48, 55),
(336, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 228, 48, 55),
(337, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 229, 48, 55),
(338, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, NULL, 230, 48, 55),
(339, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, 'Poca difusión en mi zona', NULL, NULL, 231, 48, 55),
(340, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 232, 48, 55),
(341, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, 3, NULL, 233, 48, 55),
(342, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, 0, 234, 48, 55),
(343, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 235, 48, 55),
(344, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, 'Mucha fila para entrar', NULL, NULL, 236, 48, 55),
(345, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 237, 48, 55),
(346, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 238, 48, 55),
(347, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 239, 48, 55),
(348, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, 'Grupo de danza', NULL, NULL, 240, 48, 55),
(349, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, 'Muy bueno', NULL, NULL, 241, 48, 55),
(350, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 242, 48, 55),
(351, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, 4, NULL, 243, 48, 55),
(352, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, NULL, NULL, 1, 244, 48, 55),
(353, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, 'La energía del público', NULL, NULL, 245, 48, 55),
(354, NULL, '192.168.15.2', '2026-08-31 01:26:24', 1, 'Buen evento', NULL, NULL, 246, 48, 55),
(355, NULL, '127.0.0.1', '2026-09-29 03:26:46', 1, NULL, 3, NULL, 248, 49, 56),
(356, NULL, '127.0.0.1', '2026-09-29 03:26:46', 1, 'gggggggggggg', NULL, NULL, 249, 49, 56),
(357, NULL, '127.0.0.1', '2026-09-29 03:26:46', 1, NULL, NULL, 0, 250, 49, 56),
(358, NULL, '127.0.0.1', '2026-09-29 03:26:46', 1, 'gggggggggg', NULL, NULL, 251, 49, 56),
(359, NULL, '127.0.0.1', '2026-09-29 03:26:46', 1, NULL, NULL, NULL, 252, 49, 56),
(360, NULL, '127.0.0.1', '2026-09-29 03:26:46', 1, 'ggggggggggg', NULL, NULL, 253, 49, 56),
(361, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, NULL, 346, 55, 57),
(362, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, 1, 347, 55, 57),
(363, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, 1, 348, 55, 57),
(364, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, NULL, 349, 55, 57),
(365, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, 'hhhhhhhhhhh', NULL, NULL, 350, 55, 57),
(366, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, 0, 351, 55, 57),
(367, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, 2, NULL, 352, 55, 57),
(368, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, 0, 353, 55, 57),
(369, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, 3, NULL, 354, 55, 57),
(370, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, 'hhhhhhhhhh', NULL, NULL, 355, 55, 57),
(371, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, 0, 356, 55, 57),
(372, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, 3, NULL, 357, 55, 57),
(373, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, 0, 358, 55, 57),
(374, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, 'hh', NULL, NULL, 359, 55, 57),
(375, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, 'hh', NULL, NULL, 360, 55, 57),
(376, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, 0, 361, 55, 57),
(377, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, 4, NULL, 362, 55, 57),
(378, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, NULL, NULL, 0, 363, 55, 57),
(379, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, 'h', NULL, NULL, 364, 55, 57),
(380, NULL, '127.0.0.1', '2026-10-08 22:31:49', 1, 'h', NULL, NULL, 365, 55, 57),
(381, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, NULL, 386, 56, 58),
(382, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, 'bh', NULL, NULL, 387, 56, 58),
(383, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, NULL, 388, 56, 58),
(384, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, NULL, 389, 56, 58),
(385, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, 1, 390, 56, 58),
(386, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, NULL, 391, 56, 58),
(387, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, NULL, 392, 56, 58),
(388, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, 1, 393, 56, 58),
(389, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, 2, NULL, 394, 56, 58),
(390, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, 'n', NULL, NULL, 395, 56, 58),
(391, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, 0, 396, 56, 58),
(392, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, 3, NULL, 397, 56, 58),
(393, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, NULL, 398, 56, 58),
(394, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, 1, 399, 56, 58),
(395, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, 'nn', NULL, NULL, 400, 56, 58),
(396, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, NULL, 401, 56, 58),
(397, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, NULL, 0, 402, 56, 58),
(398, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, NULL, 4, NULL, 403, 56, 58),
(399, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, 'n', NULL, NULL, 404, 56, 58),
(400, NULL, '127.0.0.1', '2026-10-10 00:29:56', 1, 'n', NULL, NULL, 405, 56, 58),
(401, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, NULL, 406, 57, NULL),
(402, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, 'hhhh', NULL, NULL, 407, 57, NULL),
(403, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, NULL, 408, 57, NULL),
(404, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, NULL, 409, 57, NULL),
(405, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, 0, 410, 57, NULL),
(406, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, NULL, 411, 57, NULL),
(407, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, NULL, 412, 57, NULL),
(408, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, 0, 413, 57, NULL),
(409, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, 3, NULL, 414, 57, NULL),
(410, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, 'hh', NULL, NULL, 415, 57, NULL),
(411, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, 0, 416, 57, NULL),
(412, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, 3, NULL, 417, 57, NULL),
(413, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, NULL, 418, 57, NULL),
(414, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, NULL, NULL, 1, 419, 57, NULL),
(415, '87e07469-5e31-4e86-a755-0a700b6ec090', '127.0.0.1', '2026-10-10 15:19:57', 1, 'h', NULL, NULL, 420, 57, NULL),
(416, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:18', 1, NULL, NULL, NULL, 446, 59, NULL),
(417, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, 'jj', NULL, NULL, 447, 59, NULL),
(418, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, NULL, NULL, 448, 59, NULL),
(419, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, NULL, NULL, 449, 59, NULL),
(420, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, NULL, 0, 450, 59, NULL),
(421, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, NULL, NULL, 451, 59, NULL),
(422, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, NULL, NULL, 452, 59, NULL),
(423, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, NULL, 0, 453, 59, NULL),
(424, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, 3, NULL, 454, 59, NULL),
(425, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, 'jjjjjjjjjjjjjjjj', NULL, NULL, 455, 59, NULL),
(426, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, NULL, 0, 456, 59, NULL),
(427, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, 3, NULL, 457, 59, NULL),
(428, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, NULL, NULL, 458, 59, NULL),
(429, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, NULL, NULL, 0, 459, 59, NULL),
(430, '389ce08f-dcb1-45e5-bbe2-ee2279e85c61', '127.0.0.1', '2026-10-10 16:06:19', 1, 'j', NULL, NULL, 460, 59, NULL),
(431, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, NULL, NULL, NULL, 486, 61, NULL),
(432, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, 'gggg', NULL, NULL, 487, 61, NULL),
(433, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, NULL, NULL, NULL, 488, 61, NULL),
(434, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, NULL, NULL, NULL, 489, 61, NULL),
(435, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, NULL, NULL, 0, 490, 61, NULL),
(436, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, NULL, NULL, NULL, 491, 61, NULL),
(437, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, NULL, NULL, NULL, 492, 61, NULL),
(438, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, NULL, NULL, 1, 493, 61, NULL),
(439, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, NULL, 3, NULL, 494, 61, NULL),
(440, '690c611c-a4a9-4e62-9e97-9f15016aa915', '127.0.0.1', '2026-10-12 15:46:24', 1, 'g', NULL, NULL, 495, 61, NULL),
(441, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, NULL, 506, 62, NULL),
(442, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, 'gggg', NULL, NULL, 507, 62, NULL),
(443, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, NULL, 508, 62, NULL),
(444, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, NULL, 509, 62, NULL),
(445, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, 1, 510, 62, NULL),
(446, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, NULL, 511, 62, NULL),
(447, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, NULL, 512, 62, NULL),
(448, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, 1, 513, 62, NULL),
(449, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, 2, NULL, 514, 62, NULL),
(450, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, 'gggg', NULL, NULL, 515, 62, NULL),
(451, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, 0, 516, 62, NULL),
(452, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, 3, NULL, 517, 62, NULL),
(453, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, NULL, 518, 62, NULL),
(454, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, 0, 519, 62, NULL),
(455, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, 'ggg', NULL, NULL, 520, 62, NULL),
(456, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, NULL, 521, 62, NULL),
(457, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, NULL, 0, 522, 62, NULL),
(458, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, NULL, 3, NULL, 523, 62, NULL),
(459, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, 'g', NULL, NULL, 524, 62, NULL),
(460, '8895f6a7-4724-4b8d-9950-1fbaedd53e45', '127.0.0.1', '2026-10-12 20:03:12', 1, 'g', NULL, NULL, 525, 62, NULL),
(461, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, NULL, 648, 70, NULL),
(462, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, 'gggg', NULL, NULL, 649, 70, NULL),
(463, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, NULL, 650, 70, NULL),
(464, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, NULL, 651, 70, NULL),
(465, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, 1, 652, 70, NULL),
(466, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, NULL, 653, 70, NULL),
(467, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, NULL, 654, 70, NULL),
(468, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, 0, 655, 70, NULL),
(469, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, 2, NULL, 656, 70, NULL),
(470, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, 'ggg', NULL, NULL, 657, 70, NULL),
(471, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, 0, 658, 70, NULL),
(472, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, 3, NULL, 659, 70, NULL),
(473, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, NULL, 660, 70, NULL),
(474, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, NULL, NULL, 0, 661, 70, NULL),
(475, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:50', 1, 'g', NULL, NULL, 662, 70, NULL),
(476, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:51', 1, NULL, NULL, NULL, 663, 70, NULL),
(477, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:51', 1, NULL, NULL, 1, 664, 70, NULL),
(478, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:51', 1, NULL, 2, NULL, 665, 70, NULL),
(479, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:51', 1, 'g', NULL, NULL, 666, 70, NULL),
(480, 'c70e51bb-136e-46d6-aacb-55382224fb21', '127.0.0.1', '2026-10-13 03:31:51', 1, 'g', NULL, NULL, 667, 70, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role`
--

CREATE TABLE `role` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `role`
--

INSERT INTO `role` (`id`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Usuario', NULL, NULL, NULL),
(2, 'Jefe', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sections`
--

CREATE TABLE `sections` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'general',
  `survey_id` bigint(20) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sections`
--

INSERT INTO `sections` (`id`, `name`, `description`, `type`, `survey_id`, `deleted_at`) VALUES
(1, 'Datos generales', 'Información básica del participante', 'general', 1, NULL),
(2, 'Evaluación del evento', 'Preguntas sobre el festival', 'general', 1, NULL),
(3, 'Ambiente laboral', 'Percepción del espacio de trabajo', 'general', 2, NULL),
(4, 'Atención recibida', 'Evalúa la calidad del servicio', 'general', 3, NULL),
(5, 'Sección Inicial Principal', 'Bloque introductorio generado automáticamente por el sistema.', 'general', 4, NULL),
(6, 'Preguntas cerradas', 'responda sinceramente', 'general', 4, '2026-08-27 20:12:42'),
(7, 'Sección Inicial Principal', 'Bloque introductorio generado automáticamente por el sistema.', 'general', 5, NULL),
(8, 'seccion 1', 'hola hola', 'general', 5, NULL),
(9, 'Atención recibida', 'Evalúa la calidad del servicio', 'general', 6, NULL),
(10, 'Sección Inicial Principal', 'Bloque introductorio generado automáticamente por el sistema.', 'general', 7, NULL),
(11, 'seccion 1', 'hola hola', 'general', 7, NULL),
(12, 'Sección Inicial Principal', 'Bloque introductorio generado automáticamente por el sistema.', 'general', 8, NULL),
(13, 'fffffffffffffff', 'fffffffffffffffffff', 'general', 8, NULL),
(14, 'fffffffffff', 'ffffffffffffff', 'general', 8, NULL),
(15, 'opcion', 'hghhhhhhhhhhhhhhhh', 'general', 8, NULL),
(16, 'Sección Inicial Principal', 'Bloque introductorio generado automáticamente por el sistema.', 'general', 9, NULL),
(17, 'Información general', '\"En esta sección recopilamos información general para entender el perfil de los ciudadanos que evalúan los servicios.\"', 'general', 9, NULL),
(18, 'Evaluación de servicios municipales', '\"Califica la calidad de los servicios que has utilizado recientemente en el municipio.\"', 'general', 9, NULL),
(19, 'Comunicación y participación ciudadana', '\"Queremos saber qué tan informado y tomado en cuenta te sientes por parte del municipio.\"', 'general', 9, NULL),
(20, 'Sugerencias y comentarios finales', '\"Tu opinión es muy importante. Déjanos tus sugerencias para mejorar los servicios y la atención en el municipio.\"', 'general', 9, NULL),
(21, 'Sección Inicial Principal', 'Bloque introductorio generado automáticamente por el sistema.', 'general', 10, NULL),
(22, 'Sección General', 'Preguntas importadas de la plantilla: Clima organizacional', 'general', 11, NULL),
(23, 'Sección General', 'Preguntas importadas de la plantilla: Satisfacción ciudadana', 'general', 12, NULL),
(24, 'gh', 'gggggg', 'general', 10, NULL),
(25, 'Sección General', 'Preguntas importadas de la plantilla: Evaluación de eventos', 'general', 13, NULL),
(26, 'Portada', 'Bienvenida', 'general', 14, NULL),
(27, 'Preguntas generales', 'Evaluación principal', 'general', 14, NULL),
(28, 'Portada', 'Bienvenida', 'general', 15, NULL),
(29, 'Evaluación', 'Preguntas del festival', 'general', 15, NULL),
(30, 'Portada', 'Bienvenida', 'general', 16, NULL),
(31, 'Ambiente laboral', 'Percepción del entorno', 'general', 16, NULL),
(32, 'Portada', 'Bienvenida', 'general', 17, NULL),
(33, 'Contenido del curso', 'Temario y material', 'general', 17, NULL),
(34, 'Portada', 'Bienvenida', 'general', 18, NULL),
(35, 'Atención recibida', 'Calidad del servicio', 'general', 18, NULL),
(36, 'Portada', 'Bienvenida', 'general', 19, NULL),
(37, 'Biblioteca', 'Servicios bibliotecarios', 'general', 19, NULL),
(38, 'Portada', 'Bienvenida', 'general', 20, NULL),
(39, 'Exposición', 'Opinión sobre la exposición', 'general', 20, NULL),
(40, 'Portada', 'Bienvenida', 'general', 21, NULL),
(41, 'Taller', 'Retroalimentación', 'general', 21, NULL),
(42, 'Portada', 'Bienvenida', 'general', 22, NULL),
(43, 'Seguridad', 'Percepción de seguridad', 'general', 22, NULL),
(44, 'Portada', 'Bienvenida', 'general', 23, NULL),
(45, 'Plataforma', 'Usabilidad', 'general', 23, NULL),
(46, 'Portada', 'Bienvenida', 'general', 24, NULL),
(47, 'Proveedores', 'Evaluación de proveedores', 'general', 24, NULL),
(48, 'Portada', 'Bienvenida', 'general', 25, NULL),
(49, 'Transporte', 'Evaluación', 'general', 25, NULL),
(50, 'Portada', 'Bienvenida', 'general', 26, NULL),
(51, 'Política', 'Opinión', 'general', 26, NULL),
(52, 'Portada', 'Bienvenida', 'general', 27, NULL),
(53, 'Ambiente laboral', 'Clima', 'general', 27, NULL),
(54, 'Portada', 'Bienvenida', 'general', 28, NULL),
(55, 'Trámites', 'Satisfacción', 'general', 28, NULL),
(56, 'Portada', 'Bienvenida', 'general', 29, NULL),
(57, 'Evaluación', 'Preguntas sobre el ambiente laboral', 'general', 29, NULL),
(58, 'Portada', 'Bienvenida', 'general', 30, NULL),
(59, 'Opinión', 'Retroalimentación del taller', 'general', 30, NULL),
(60, 'Portada', 'Bienvenida', 'general', 31, NULL),
(61, 'Impacto', 'Medición del impacto de las becas', 'general', 31, NULL),
(62, 'Portada', 'Bienvenida', 'general', 32, NULL),
(63, 'Ambiente', 'Clima laboral en bibliotecas', 'general', 32, NULL),
(64, 'Portada', 'Bienvenida', 'general', 33, NULL),
(65, 'Cafetería', 'Servicio de cafetería', 'general', 33, NULL),
(66, 'Portada', 'Bienvenida', 'general', 34, NULL),
(67, 'Programación', 'Percepción de la programación', 'general', 34, NULL),
(68, 'Portada', 'Bienvenida', 'general', 35, NULL),
(69, 'Palacio', 'Satisfacción con la visita', 'general', 35, NULL),
(70, 'Portada', 'Bienvenida', 'general', 36, NULL),
(71, 'Orquesta', 'Evaluación del concierto', 'general', 36, NULL),
(72, 'Portada', 'Bienvenida', 'general', 37, NULL),
(73, 'Reforma', 'Opinión sobre la reforma', 'general', 37, NULL),
(74, 'Portada', 'Bienvenida', 'general', 38, NULL),
(75, 'Dirección Teatros', 'Clima organizacional', 'general', 38, NULL),
(76, 'Portada', 'Bienvenida', 'general', 39, NULL),
(77, 'Archivo', 'Servicio de archivo', 'general', 39, NULL),
(78, 'Portada', 'Bienvenida', 'general', 40, NULL),
(79, 'Escuela Música', 'Evaluación de la formación', 'general', 40, NULL),
(80, 'Portada', 'Bienvenida', 'general', 41, NULL),
(81, 'Centros Culturales', 'Impacto comunitario', 'general', 41, NULL),
(82, 'Portada', 'Bienvenida', 'general', 42, NULL),
(83, 'Biblioteca Digital', 'Plataforma digital', 'general', 42, NULL),
(84, 'Portada', 'Bienvenida', 'general', 43, NULL),
(85, 'Formación Artística', 'Evaluación del programa', 'general', 43, NULL),
(86, 'Portada', 'Bienvenida a la encuesta', 'general', 44, NULL),
(87, 'Información general del participante', 'Datos demográficos básicos', 'general', 44, NULL),
(88, 'Uso de servicios culturales', 'Frecuencia y tipo de servicios utilizados', 'general', 44, NULL),
(89, 'Evaluación de servicios en línea', 'Opinión sobre la plataforma digital', 'general', 44, NULL),
(90, 'Sugerencias finales', 'Comentarios y recomendaciones', 'general', 44, NULL),
(91, 'Portada', 'Bienvenida a la encuesta', 'general', 45, NULL),
(92, 'Ambiente laboral', 'Percepción del entorno de trabajo', 'general', 45, NULL),
(93, 'Comunicación interna', 'Flujo de información y comunicación', 'general', 45, NULL),
(94, 'Desarrollo profesional', 'Oportunidades de crecimiento', 'general', 45, NULL),
(95, 'Satisfacción general', 'Nivel de satisfacción global', 'general', 45, NULL),
(96, 'Portada', 'Bienvenida a la encuesta', 'general', 46, NULL),
(97, 'Experiencia previa', 'Formación artística anterior', 'general', 46, NULL),
(98, 'Contenido del programa', 'Relevancia y calidad del contenido', 'general', 46, NULL),
(99, 'Instructores', 'Desempeño de los instructores', 'general', 46, NULL),
(100, 'Impacto personal', 'Efecto en el desarrollo personal y profesional', 'general', 46, NULL),
(101, 'Portada', 'Bienvenida a la encuesta', 'general', 47, NULL),
(102, 'Datos de la visita', 'Información sobre la visita al museo', 'general', 47, NULL),
(103, 'Exposiciones y contenido', 'Opinión sobre las exposiciones', 'general', 47, NULL),
(104, 'Instalaciones y servicios', 'Evaluación de infraestructura', 'general', 47, NULL),
(105, 'Experiencia general', 'Valoración global de la visita', 'general', 47, NULL),
(106, 'Portada', 'Bienvenida a la encuesta', 'general', 48, NULL),
(107, 'Información previa al evento', 'Comunicación y difusión', 'general', 48, NULL),
(108, 'Logística y organización', 'Accesos, seguridad, instalaciones', 'general', 48, NULL),
(109, 'Contenido y artistas', 'Calidad del espectáculo', 'general', 48, NULL),
(110, 'Opinión final', 'Satisfacción global y recomendaciones', 'general', 48, NULL),
(111, 'kkkkkkkkk', 'kkkkkkkkkk', 'general', 13, NULL),
(112, 'Sección Inicial Principal', 'Bloque introductorio generado automáticamente por el sistema.', 'general', 49, NULL),
(113, 'Relación con la Formación Académica', 'Esta sección busca evaluar cómo las actividades realizadas durante el proyecto se conectan con tu plan de estudios y en qué medida contribuyeron a tu desarrollo profesional, permitiéndote poner en práctica la teoría aprendida en clases.', 'general', 49, NULL),
(114, 'Impacto y Desempeño en el Proyecto', 'El objetivo de este apartado es medir el beneficio y la utilidad real que los resultados de tu trabajo aportaron a la comunidad o institución receptora, así como identificar tu capacidad de adaptación y resolución de problemas ante desafíos prácticos.', 'general', 49, NULL),
(115, 'Evaluación del Acompañamiento Institucional', 'En esta sección queremos conocer tu nivel de satisfacción respecto a la orientación, supervisión y apoyo logístico recibido por parte de los coordinadores para garantizar que el proceso de horas sociales se desarrollara sin contratiempos.', 'general', 49, NULL),
(116, 'Sección Inicial Principal', 'Bloque introductorio generado automáticamente por el sistema.', 'general', 50, NULL),
(117, 'ffffffffffffffffffffffffffffffff', 'fffffffffffffffffffffffffffff', 'general', 50, NULL),
(118, 'ffffffffffffff', 'ffffffffffffffffffffff', 'general', 50, NULL),
(119, 'Sección General', 'Preguntas importadas de la plantilla: Capacitación', 'general', 51, NULL),
(120, 'Datos generales', NULL, 'general', 52, NULL),
(121, 'Evaluación del evento', NULL, 'general', 52, NULL),
(122, 'Información previa al evento', NULL, 'general', 53, NULL),
(123, 'Logística y organización', NULL, 'general', 53, NULL),
(124, 'Contenido y artistas', NULL, 'general', 53, NULL),
(125, 'Opinión final', NULL, 'general', 53, NULL),
(126, 'Información previa al evento', NULL, 'general', 54, NULL),
(127, 'Logística y organización', NULL, 'general', 54, NULL),
(128, 'Contenido y artistas', NULL, 'general', 54, NULL),
(129, 'Opinión final', NULL, 'general', 54, NULL),
(130, 'Información previa al evento', NULL, 'general', 55, NULL),
(131, 'Logística y organización', NULL, 'general', 55, NULL),
(132, 'Contenido y artistas', NULL, 'general', 55, NULL),
(133, 'Opinión final', NULL, 'general', 55, NULL),
(134, 'Información general del participante', NULL, 'general', 56, NULL),
(135, 'Uso de servicios culturales', NULL, 'general', 56, NULL),
(136, 'Evaluación de servicios en línea', NULL, 'general', 56, NULL),
(137, 'Sugerencias finales', NULL, 'general', 56, NULL),
(138, 'Información general del participante', NULL, 'general', 57, NULL),
(139, 'Uso de servicios culturales', NULL, 'general', 57, NULL),
(140, 'Evaluación de servicios en línea', NULL, 'general', 57, NULL),
(141, 'Sugerencias finales', NULL, 'general', 57, '2026-10-10 15:14:09'),
(142, 'Información general del participante', NULL, 'general', 58, NULL),
(143, 'Uso de servicios culturales', NULL, 'general', 58, NULL),
(144, 'Evaluación de servicios en línea', NULL, 'general', 58, NULL),
(145, 'Sugerencias finales', NULL, 'general', 58, NULL),
(146, 'Información general del participante', NULL, 'general', 59, NULL),
(147, 'Uso de servicios culturales', NULL, 'general', 59, NULL),
(148, 'Evaluación de servicios en línea', NULL, 'general', 59, NULL),
(149, 'Sugerencias finales', NULL, 'general', 59, '2026-10-10 16:03:38'),
(150, 'Información general del participante', NULL, 'general', 60, NULL),
(151, 'Uso de servicios culturales', NULL, 'general', 60, NULL),
(152, 'Evaluación de servicios en línea', NULL, 'general', 60, '2026-10-12 15:20:31'),
(153, 'Sugerencias finales', NULL, 'general', 60, '2026-10-12 15:20:31'),
(154, 'Información general del participante', NULL, 'general', 61, NULL),
(155, 'Uso de servicios culturales', NULL, 'general', 61, NULL),
(156, 'Evaluación de servicios en línea', NULL, 'general', 61, '2026-10-12 15:41:27'),
(157, 'Sugerencias finales', NULL, 'general', 61, '2026-10-12 15:41:27'),
(158, 'Información general del participante', NULL, 'general', 62, NULL),
(159, 'Uso de servicios culturales', NULL, 'general', 62, NULL),
(160, 'Evaluación de servicios en línea', NULL, 'general', 62, NULL),
(161, 'Sugerencias finales', NULL, 'general', 62, NULL),
(162, 'Sección General', 'Preguntas importadas de la plantilla: Diagnóstico de bibliotecas', 'general', 63, NULL),
(163, 'Información previa al evento', NULL, 'general', 64, NULL),
(164, 'Logística y organización', NULL, 'general', 64, NULL),
(165, 'Contenido y artistas', NULL, 'general', 64, NULL),
(166, 'Opinión final', NULL, 'general', 64, NULL),
(167, 'Información general del participante', NULL, 'general', 65, NULL),
(168, 'Uso de servicios culturales', NULL, 'general', 65, NULL),
(169, 'Evaluación de servicios en línea', NULL, 'general', 65, NULL),
(170, 'Sugerencias finales', NULL, 'general', 65, NULL),
(171, 'Información general del participante', NULL, 'general', 66, NULL),
(172, 'Uso de servicios culturales', NULL, 'general', 66, NULL),
(173, 'Evaluación de servicios en línea', NULL, 'general', 66, NULL),
(174, 'Sugerencias finales', NULL, 'general', 66, NULL),
(175, 'Información general del participante', NULL, 'general', 67, '2026-10-12 22:39:00'),
(176, 'Uso de servicios culturales', NULL, 'general', 67, '2026-10-12 22:39:00'),
(177, 'Evaluación de servicios en línea', 'GGGG', 'general', 67, NULL),
(178, 'Sugerencias finales', 'GGG', 'general', 67, NULL),
(179, 'Evaluación de servicios en línea', NULL, 'general', 68, NULL),
(180, 'Sugerencias finales', NULL, 'general', 68, NULL),
(181, 'Información general del participante', NULL, 'general', 69, NULL),
(182, 'Uso de servicios culturales', NULL, 'general', 69, NULL),
(183, 'Evaluación de servicios en línea', NULL, 'general', 69, NULL),
(184, 'Sugerencias finales', NULL, 'general', 69, NULL),
(185, 'Información general del participante', NULL, 'general', 70, NULL),
(186, 'Uso de servicios culturales', NULL, 'general', 70, NULL),
(187, 'Evaluación de servicios en línea', NULL, 'general', 70, NULL),
(188, 'Sugerencias finales', NULL, 'general', 70, NULL),
(189, 'Sección General', 'Preguntas importadas de la plantilla: Evaluación de eventos', 'general', 71, NULL),
(190, 'Sección General', 'Preguntas importadas de la plantilla: Clima organizacional', 'general', 72, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `section_comments`
--

CREATE TABLE `section_comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `section_id` bigint(20) UNSIGNED NOT NULL,
  `survey_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `section_comments`
--

INSERT INTO `section_comments` (`id`, `section_id`, `survey_id`, `user_id`, `comment`, `created_at`, `updated_at`) VALUES
(1, 21, 10, 1, 'Tienen que mejorar esta encuesta', '2026-08-30 04:49:48', '2026-08-30 04:49:48'),
(2, 25, 13, 1, 'Necesitamos que mejoren esta seccion', '2026-08-31 01:00:13', '2026-08-31 01:00:13'),
(3, 113, 49, 1, 'Aquí me gustaria que hubiera otra pregunta o que se redacte de diferente manera', '2026-09-29 03:14:15', '2026-09-29 03:14:15'),
(4, 40, 21, 1, 'Esta pregunta no me gusta para nada', '2026-09-29 18:19:45', '2026-09-29 18:19:45'),
(5, 72, 37, 1, 'Hola Hola', '2026-10-05 04:12:02', '2026-10-05 04:12:02'),
(6, 73, 37, 1, 'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\nfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\nfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff', '2026-10-05 04:26:47', '2026-10-05 04:26:47'),
(7, 25, 13, 2, 'Cual seria la correción que necesita ?\n\nSolo me especifica como desea que sea la correción por favor', '2026-10-05 17:40:34', '2026-10-05 17:40:34'),
(8, 134, 56, 1, 'Esta sección no me gusta', '2026-10-10 00:26:05', '2026-10-10 00:26:05'),
(9, 134, 56, 1, 'ggggggg', '2026-10-10 00:26:23', '2026-10-10 00:26:23'),
(10, 150, 60, 1, 'Mejora esta sección por favor', '2026-10-12 15:21:15', '2026-10-12 15:21:15'),
(11, 154, 61, 1, 'Necesito que mejoren la redacción de esta pregunta', '2026-10-12 15:42:21', '2026-10-12 15:42:21'),
(12, 159, 62, 1, 'Esta sección no tenia descripción', '2026-10-12 19:58:07', '2026-10-12 19:58:07'),
(13, 177, 67, 1, 'mejoren la descripción de las secciones', '2026-10-12 22:39:50', '2026-10-12 22:39:50'),
(14, 179, 68, 1, 'Me gusttaria que mejorenn los enunciados', '2026-10-13 03:07:18', '2026-10-13 03:07:18'),
(15, 181, 69, 1, 'Esta sección no tiene descripción', '2026-10-13 03:17:48', '2026-10-13 03:17:48'),
(16, 185, 70, 1, 'Me gustaría que agreguen descripciones', '2026-10-13 03:26:01', '2026-10-13 03:26:01'),
(17, 91, 45, 1, 'Mejoren esta seccion', '2026-10-17 15:44:00', '2026-10-17 15:44:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `session_logs`
--

CREATE TABLE `session_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `device` varchar(255) DEFAULT NULL,
  `access_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `statuses`
--

CREATE TABLE `statuses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `statuses`
--

INSERT INTO `statuses` (`id`, `name`, `slug`, `description`, `deleted_at`) VALUES
(1, 'Borrador', 'draft', 'Creación y edición', NULL),
(2, 'En revisión', 'review', 'Pendiente de validación por otros', NULL),
(3, 'Aprobada', 'approved', 'Validada y lista para publicar', NULL),
(4, 'Rechazada', 'rejected', 'Devuelta a borrador para corregir', NULL),
(5, 'Programada', 'scheduled', 'Aprobada pero esperando fecha de publicación', NULL),
(6, 'Activa', 'published', 'Recibiendo respuestas', NULL),
(7, 'En pausa', 'paused', 'Detenida temporalmente, se puede reanudar', NULL),
(8, 'Cerrada', 'closed', 'Recogida de datos finalizada', NULL),
(9, 'Archivada', 'archived', 'Almacenada para consulta futura', NULL),
(10, 'Eliminada / Desechada', 'deleted', 'Borrada del sistema', NULL),
(11, 'Corregida', 'needs_correction', 'El Administrador solicitó correcciones puntuales; revisar los comentarios por sección', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `supplier`
--

CREATE TABLE `supplier` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `telephone` varchar(255) NOT NULL,
  `web_site` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `surveys`
--

CREATE TABLE `surveys` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `is_single_response` tinyint(1) NOT NULL DEFAULT 0,
  `anonymity_mode` varchar(20) NOT NULL DEFAULT 'identified',
  `start_date` timestamp NULL DEFAULT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `section_id` bigint(20) UNSIGNED DEFAULT NULL,
  `dependency_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `template_id` bigint(20) UNSIGNED DEFAULT NULL,
  `survey_category_id` bigint(20) UNSIGNED NOT NULL,
  `type_id` bigint(20) UNSIGNED NOT NULL,
  `status_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `surveys`
--

INSERT INTO `surveys` (`id`, `title`, `description`, `is_single_response`, `anonymity_mode`, `start_date`, `end_date`, `section_id`, `dependency_id`, `user_id`, `template_id`, `survey_category_id`, `type_id`, `status_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Evaluación Festival Nacional de las Artes 2026', 'Encuesta de satisfacción general del festival.', 0, 'identified', '2026-04-01 06:00:00', '2026-04-30 06:00:00', 1, 1, 8, NULL, 2, 1, 3, '2026-08-24 23:56:01', '2026-08-27 20:24:12', NULL),
(2, 'Clima organizacional 2do semestre', 'Evaluación del ambiente laboral y satisfacción interna.', 1, 'identified', '2026-05-15 06:00:00', '2026-06-15 06:00:00', 3, 1, 8, NULL, 3, 2, 8, '2026-08-24 23:56:01', '2026-10-08 22:08:01', NULL),
(3, 'Satisfacción de atención al ciudadano', 'Medición de calidad en atención al ciudadano.', 0, 'identified', '2026-02-01 06:00:00', '2026-02-28 06:00:00', 4, 1, 8, NULL, 1, 1, 8, '2026-08-24 23:56:01', '2026-08-24 23:56:01', NULL),
(4, 'Solicitudes de Becas 2026', 'En esta encuesta usted podrá dar a conocer sus opiniones acerca del procedimiento de entrega de becas a todo el país', 0, 'identified', '2026-08-23 06:00:00', '2026-08-26 06:00:00', 5, 2, 2, NULL, 1, 2, 8, '2026-08-25 00:12:19', '2026-10-08 22:08:01', NULL),
(5, 'encuestas 2', 'jsjjsjsjss', 0, 'identified', '2026-08-22 06:00:00', '2026-08-26 06:00:00', 7, 2, 2, NULL, 2, 1, 8, '2026-08-25 00:34:14', '2026-10-08 22:08:01', NULL),
(6, 'Satisfacción de atención al ciudadano (Copia)', 'Medición de calidad en atención al ciudadano.', 0, 'identified', '2026-02-01 06:00:00', '2026-02-28 06:00:00', 9, 1, 1, NULL, 1, 1, 8, '2026-08-27 18:26:16', '2026-10-08 22:08:01', NULL),
(7, 'encuestas 2 (Copia)', 'jsjjsjsjss', 0, 'identified', '2026-08-22 06:00:00', '2026-08-26 06:00:00', 10, 2, 1, NULL, 2, 1, 4, '2026-08-27 18:31:35', '2026-08-30 04:23:17', NULL),
(8, 'hhhhhhhhhhhhhhhhhhh', 'hhhhhhhhhhhhhh', 0, 'identified', '2026-08-26 06:00:00', '2026-08-28 06:00:00', 12, 2, 2, NULL, 1, 1, 8, '2026-08-27 20:28:26', '2026-10-08 22:08:01', NULL),
(9, 'Encuesta de Clima Laboral 2026', 'Queremos conocer tu percepción sobre el ambiente de trabajo, liderazgo y condiciones para implementar mejoras.', 0, 'identified', '2026-08-28 06:00:00', '2026-08-30 06:00:00', 16, 2, 2, NULL, 1, 2, 8, '2026-08-30 00:27:58', '2026-10-08 22:08:01', NULL),
(10, 'Encuesta de Evaluación de Taller de Capacitación', 'Queremos conocer tu opinión sobre el taller para mejorar futuras capacitaciones.', 0, 'identified', '2026-08-28 06:00:00', '2026-08-30 06:00:00', 21, 2, 2, NULL, 3, 1, 4, '2026-08-30 04:29:28', '2026-08-30 04:41:47', NULL),
(11, 'Clima organizacional', 'Evaluación del ambiente laboral y satisfacción interna.', 0, 'identified', '2026-08-28 06:00:00', '2026-08-30 06:00:00', 22, 2, 1, NULL, 2, 1, 8, '2026-08-30 04:36:59', '2026-10-08 22:08:01', NULL),
(12, 'Satisfacción ciudadana', 'Medición de calidad en atención al ciudadano.', 0, 'identified', '2026-08-30 06:00:00', '2026-08-30 06:00:00', 23, 3, 1, NULL, 1, 2, 1, '2026-08-30 04:37:44', '2026-08-30 04:37:44', NULL),
(13, 'Evaluación de eventos', 'Plantilla para evaluar eventos culturales y festivales.', 0, 'identified', '2026-08-29 06:00:00', '2026-08-31 06:00:00', 25, 2, 2, NULL, 1, 1, 8, '2026-08-31 00:55:50', '2026-10-08 22:08:01', NULL),
(14, 'Encuesta de Satisfacción de Servicios 2025', 'Evaluación de la atención en la oficina central', 1, 'identified', '2025-01-01 06:00:00', '2026-01-01 05:59:59', 26, 1, 1, 1, 1, 1, 8, '2026-08-31 01:20:11', '2026-10-08 22:08:01', NULL),
(15, 'Evaluación del Festival Cultural 2025', 'Encuesta para asistentes al festival', 0, 'identified', '2025-03-01 06:00:00', '2025-05-01 05:59:59', 28, 2, 2, 2, 2, 1, 8, '2026-08-31 01:20:11', '2026-08-31 01:20:11', NULL),
(16, 'Encuesta de Clima Organizacional', 'Medición interna de ambiente laboral', 1, 'identified', NULL, NULL, 30, 1, 1, NULL, 3, 2, 1, '2026-08-31 01:20:11', '2026-09-16 18:27:51', '2026-09-16 18:27:51'),
(17, 'Evaluación de Capacitación en Gestión Cultural', 'Encuesta posterior a la capacitación', 1, 'identified', '2025-06-01 06:00:00', '2025-06-16 05:59:59', 32, 2, 4, NULL, 3, 2, 8, '2026-08-31 01:20:11', '2026-10-08 22:08:01', NULL),
(18, 'Atención al Ciudadano - Anónima', 'Encuesta anónima sobre atención en ventanilla', 0, 'identified', '2025-02-01 06:00:00', '2026-01-01 05:59:59', 34, 3, 5, NULL, 1, 1, 8, '2026-08-31 01:20:11', '2026-10-08 22:08:01', NULL),
(19, 'Encuesta de Satisfacción de Biblioteca', 'Evaluación de servicios bibliotecarios', 1, 'identified', '2025-01-15 06:00:00', '2025-12-01 05:59:59', 36, 1, 1, 1, 1, 1, 8, '2026-08-31 01:20:11', '2026-10-08 22:08:01', NULL),
(20, 'Evaluación de Exposición Temporal', 'Encuesta sobre la exposición de arte moderno', 0, 'identified', '2025-05-01 06:00:00', '2025-07-01 05:59:59', 38, 2, 2, 2, 2, 1, 8, '2026-08-31 01:20:11', '2026-08-31 01:20:11', NULL),
(21, 'Encuesta de Retroalimentación de Taller', 'Opiniones sobre el taller de cerámica', 1, 'identified', '2025-04-01 06:00:00', '2025-04-11 05:59:59', 40, 1, 4, NULL, 2, 1, 11, '2026-08-31 01:20:11', '2026-09-29 18:19:26', NULL),
(22, 'Encuesta de Percepción de Seguridad en Museos', 'Percepción de los visitantes sobre seguridad', 0, 'identified', '2025-03-01 06:00:00', '2025-11-01 05:59:59', 42, 2, 1, NULL, 1, 1, 8, '2026-08-31 01:20:11', '2026-10-08 22:08:01', NULL),
(23, 'Encuesta de Usuarios de Plataforma Digital', 'Satisfacción con la plataforma web', 1, 'identified', '2025-02-01 06:00:00', '2025-09-01 05:59:59', 44, 1, 5, NULL, 1, 1, 7, '2026-08-31 01:20:11', '2026-08-31 01:20:11', NULL),
(24, 'Encuesta de Satisfacción de Proveedores', 'Evaluación de proveedores de servicios', 1, 'identified', NULL, NULL, 46, 1, 1, NULL, 1, 2, 1, '2026-08-31 01:20:11', '2026-08-31 01:20:11', NULL),
(25, 'Encuesta de Evaluación de Servicio de Transporte Cultural', 'Transporte para eventos culturales', 0, 'identified', '2025-01-20 06:00:00', '2025-12-21 05:59:59', 48, 2, 2, NULL, 1, 1, 8, '2026-08-31 01:20:11', '2026-10-08 22:08:01', NULL),
(26, 'Encuesta de Opinión sobre Política Cultural', 'Consulta pública sobre nuevas políticas', 0, 'identified', '2025-09-01 06:00:00', '2025-10-01 05:59:59', 50, 1, 1, NULL, 4, 1, 8, '2026-08-31 01:20:11', '2026-10-08 22:08:01', NULL),
(27, 'Encuesta de Ambiente Laboral en Sede Central', 'Clima organizacional interno', 1, 'identified', '2025-01-05 06:00:00', '2025-03-01 05:59:59', 52, 1, 5, NULL, 3, 2, 8, '2026-08-31 01:20:11', '2026-08-31 01:20:11', NULL),
(28, 'Encuesta de Satisfacción con Trámites en Línea', 'Trámites digitales', 1, 'identified', '2025-04-01 06:00:00', '2026-01-01 05:59:59', 54, 1, 1, NULL, 1, 1, 8, '2026-08-31 01:20:11', '2026-10-08 22:08:01', NULL),
(29, 'Encuesta de Satisfacción del Personal de Museos', 'Evaluación del clima laboral y condiciones en los museos.', 1, 'identified', '2025-07-01 06:00:00', '2025-08-01 05:59:59', 56, 2, 1, NULL, 3, 2, 8, '2026-08-31 01:22:00', '2026-10-08 22:08:01', NULL),
(30, 'Evaluación de Taller de Danza Folklórica', 'Opinión de los participantes sobre el taller.', 0, 'identified', '2025-04-15 06:00:00', '2025-05-01 05:59:59', 58, 26, 2, NULL, 2, 1, 8, '2026-08-31 01:22:00', '2026-08-31 01:22:00', NULL),
(31, 'Encuesta de Impacto del Programa de Becas Artísticas', 'Medición del impacto de las becas en los beneficiarios.', 0, 'identified', '2025-09-01 06:00:00', '2025-10-01 05:59:59', 60, 1, 1, NULL, 1, 1, 8, '2026-08-31 01:22:00', '2026-10-08 22:08:01', NULL),
(32, 'Encuesta de Clima Laboral en Bibliotecas', 'Evaluación interna para bibliotecas públicas.', 1, 'identified', NULL, NULL, 62, 22, 3, NULL, 3, 2, 1, '2026-08-31 01:22:00', '2026-08-31 01:22:00', NULL),
(33, 'Evaluación del Servicio de Cafetería en Teatros', 'Satisfacción con el servicio de cafetería en los teatros.', 0, 'identified', '2025-08-01 06:00:00', '2026-01-01 05:59:59', 64, 27, 4, NULL, 1, 1, 8, '2026-08-31 01:22:00', '2026-10-08 22:08:01', NULL),
(34, 'Encuesta de Percepción de la Programación Cultural', 'Opinión sobre la oferta cultural del ministerio.', 0, 'identified', '2025-05-01 06:00:00', '2025-09-01 05:59:59', 66, 1, 1, NULL, 4, 1, 7, '2026-08-31 01:22:00', '2026-08-31 01:22:00', NULL),
(35, 'Encuesta de Satisfacción de Visitantes del Palacio Nacional', 'Evaluación de la visita guiada al Palacio Nacional.', 1, 'identified', '2025-01-01 06:00:00', '2025-04-01 05:59:59', 68, 54, 2, NULL, 1, 1, 9, '2026-08-31 01:22:00', '2026-08-31 01:22:00', NULL),
(36, 'Encuesta de Evaluación de la Orquesta Sinfónica', 'Opinión sobre los conciertos de la orquesta.', 0, 'identified', '2025-06-01 06:00:00', '2025-08-01 05:59:59', 70, 36, 4, NULL, 2, 1, 8, '2026-08-31 01:22:00', '2026-08-31 01:22:00', NULL),
(37, 'Encuesta de Opinión sobre la Reforma Cultural', 'Consulta pública sobre propuestas de reforma.', 0, 'identified', '2025-10-01 06:00:00', '2025-10-16 05:59:59', 72, 1, 1, NULL, 4, 1, 2, '2026-08-31 01:22:00', '2026-08-31 01:22:00', NULL),
(38, 'Encuesta de Ambiente Laboral en la Dirección de Teatros', 'Clima organizacional en la Dirección de Teatros.', 1, 'identified', '2025-09-01 06:00:00', '2025-10-01 05:59:59', 74, 27, 4, NULL, 3, 2, 8, '2026-08-31 01:22:00', '2026-10-08 22:08:01', NULL),
(39, 'Encuesta de Satisfacción del Servicio de Archivo General', 'Evaluación de los servicios del Archivo General de la Nación.', 1, 'identified', '2025-02-01 06:00:00', '2025-03-01 05:59:59', 76, 25, 3, NULL, 1, 1, 8, '2026-08-31 01:22:00', '2026-08-31 01:22:00', NULL),
(40, 'Encuesta de Evaluación de la Escuela Nacional de Música', 'Opinión de estudiantes sobre la formación recibida.', 1, 'identified', '2025-11-01 06:00:00', '2025-11-16 05:59:59', 78, 38, 4, NULL, 2, 2, 4, '2026-08-31 01:22:00', '2026-08-31 01:22:00', NULL),
(41, 'Encuesta de Impacto de los Centros Culturales', 'Medición del impacto comunitario de los centros culturales.', 0, 'identified', '2025-07-01 06:00:00', '2025-11-01 05:59:59', 80, 53, 2, NULL, 4, 1, 8, '2026-08-31 01:22:00', '2026-10-08 22:08:01', NULL),
(42, 'Encuesta de Satisfacción de Usuarios de la Biblioteca Digital', 'Evaluación de la plataforma digital de la biblioteca.', 1, 'identified', '2025-08-01 06:00:00', '2026-01-01 05:59:59', 82, 22, 3, NULL, 1, 1, 8, '2026-08-31 01:22:00', '2026-10-08 22:08:01', NULL),
(43, 'Encuesta de Evaluación del Programa de Formación Artística', 'Opinión de los participantes en los cursos de formación.', 1, 'identified', '2025-10-01 06:00:00', '2025-10-21 05:59:59', 84, 37, 4, NULL, 3, 2, 3, '2026-08-31 01:22:00', '2026-08-31 01:22:00', NULL),
(44, 'Encuesta de Evaluación de Servicios Culturales en Línea', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 'identified', '2025-01-01 06:00:00', '2026-01-01 05:59:59', 86, 1, 1, NULL, 1, 1, 8, '2026-08-31 01:26:24', '2026-10-08 22:08:01', NULL),
(45, 'Encuesta de Clima Organizacional Ampliada', 'Diagnóstico profundo del ambiente laboral, comunicación y satisfacción del personal.', 1, 'identified', NULL, NULL, 91, 1, 1, NULL, 3, 2, 2, '2026-08-31 01:26:24', '2026-08-31 01:26:24', NULL),
(46, 'Encuesta de Impacto del Programa de Formación Artística', 'Evaluación del impacto de los cursos y talleres de formación artística en los beneficiarios.', 1, 'identified', '2025-06-01 06:00:00', '2025-09-01 05:59:59', 96, 37, 4, NULL, 3, 2, 8, '2026-08-31 01:26:24', '2026-10-08 22:08:01', NULL),
(47, 'Encuesta de Satisfacción de Visitantes de Museos', 'Medición detallada de la experiencia de los visitantes en los diferentes museos del ministerio.', 0, 'identified', '2025-02-01 06:00:00', '2025-12-01 05:59:59', 101, 45, 2, NULL, 1, 1, 8, '2026-08-31 01:26:24', '2026-10-08 22:08:01', NULL),
(48, 'Encuesta de Evaluación de Eventos Culturales Masivos', 'Evaluación de la organización, logística y contenido de eventos culturales de gran afluencia.', 0, 'identified', '2025-03-01 06:00:00', '2025-06-01 05:59:59', 106, 2, 2, NULL, 2, 1, 8, '2026-08-31 01:26:24', '2026-08-31 01:26:24', NULL),
(49, 'Horas Sociales Sociales por Encuesta', 'El objetivo de este cuestionario es conocer tu experiencia y evaluar el impacto de las actividades realizadas durante tus horas sociales. Tus respuestas son fundamentales para identificar áreas de mejora, optimizar el apoyo logístico y garantizar que futuros proyectos generen un valor real tanto para la comunidad como para tu formación profesional.', 0, 'identified', NULL, '2026-09-30 06:00:00', 112, 22, 1, NULL, 1, 2, 8, '2026-09-29 03:08:42', '2026-10-08 22:08:01', NULL),
(50, 'Esta es una nueva encuesta', 'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG', 0, 'optional', '2026-10-06 06:00:00', '2026-10-09 06:00:00', 116, 22, 1, NULL, 1, 1, 8, '2026-10-08 03:16:32', '2026-10-10 00:41:22', NULL),
(51, 'Capacitación', 'Evaluación de cursos y talleres de capacitación.', 0, 'identified', '2026-10-08 06:00:00', '2026-10-10 06:00:00', 119, 25, 1, NULL, 1, 1, 1, '2026-10-08 16:10:19', '2026-10-08 16:10:19', NULL),
(52, 'Evaluación Festival Nacional de las Artes 2026', 'Encuesta de satisfacción general del festival.', 0, 'identified', '2026-10-10 06:00:00', NULL, 120, 34, 1, NULL, 1, 1, 1, '2026-10-08 16:11:29', '2026-10-08 16:11:29', NULL),
(53, 'Encuesta Nueva', 'Evaluación de la organización, logística y contenido de eventos culturales de gran afluencia.', 0, 'identified', '2026-10-10 06:00:00', NULL, 122, 25, 1, NULL, 1, 1, 6, '2026-10-08 16:12:29', '2026-10-08 22:24:07', NULL),
(54, 'Encuesta Nueva', 'Evaluación de la organización, logística y contenido de eventos culturales de gran afluencia.', 0, 'identified', '2026-10-09 06:00:00', '2026-10-09 06:00:00', 126, 25, 1, NULL, 1, 1, 8, '2026-10-08 22:15:36', '2026-10-08 22:22:30', '2026-10-08 22:22:30'),
(55, 'Encuesta Nueva', 'Evaluación de la organización, logística y contenido de eventos culturales de gran afluencia.', 1, 'identified', '2026-10-08 22:30:00', '2026-10-08 22:33:00', 130, 25, 1, NULL, 1, 1, 8, '2026-10-08 22:28:18', '2026-10-08 22:33:01', NULL),
(56, 'Nueva encuesta de prueba', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 0, 'identified', '2026-10-10 00:28:00', '2026-10-10 00:30:00', 134, 25, 1, NULL, 1, 1, 8, '2026-10-10 00:24:01', '2026-10-10 00:41:22', NULL),
(57, 'Nueva encuesta para probar', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 0, 'optional', '2026-10-10 15:19:00', '2026-10-10 15:22:00', 138, 25, 1, NULL, 1, 1, 8, '2026-10-10 15:12:29', '2026-10-10 15:22:27', NULL),
(58, 'Nueva encuesta de prueba', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 0, 'optional', '2026-10-10 15:54:00', '2026-10-10 15:58:00', 142, 25, 1, NULL, 1, 1, 8, '2026-10-10 15:52:03', '2026-10-10 15:58:27', NULL),
(59, 'Nueva encuesta con daniel', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 'optional', '2026-10-10 16:05:00', '2026-10-10 16:07:00', 146, 25, 1, NULL, 1, 1, 8, '2026-10-10 16:02:32', '2026-10-10 16:07:35', NULL),
(60, 'Nueva encuesta de prueba', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 0, 'optional', '2026-10-12 15:22:00', '2026-10-12 15:25:00', 150, 40, 2, NULL, 1, 1, 8, '2026-10-12 15:19:14', '2026-10-12 15:25:06', NULL),
(61, 'Encuesta de día lunes', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 'optional', '2026-10-12 15:45:00', '2026-10-12 15:50:00', 154, 2, 2, NULL, 1, 1, 8, '2026-10-12 15:40:09', '2026-10-12 15:53:25', NULL),
(62, 'Nueva encuesta de prueba para el día de hoy', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 'anonymous', '2026-10-12 20:00:00', '2026-10-12 20:05:00', 158, 2, 2, NULL, 1, 1, 8, '2026-10-12 19:54:03', '2026-10-12 20:05:51', NULL),
(63, 'Diagnóstico de bibliotecas', 'Evaluación de servicios bibliotecarios municipales.', 0, 'identified', '2026-10-12 06:00:00', '2026-10-12 06:00:00', 162, 40, 1, NULL, 1, 1, 1, '2026-10-12 21:42:11', '2026-10-12 21:42:11', NULL),
(64, 'Encuesta Nueva', 'Evaluación de la organización, logística y contenido de eventos culturales de gran afluencia.', 0, 'optional', '2026-10-12 13:00:00', '2026-10-13 18:00:00', 163, 2, 2, NULL, 1, 1, 2, '2026-10-12 21:54:51', '2026-10-12 21:59:45', NULL),
(65, 'Nueva encuesta de prueba', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 0, 'identified', '2026-10-12 06:00:00', '2026-10-12 06:00:00', 167, 34, 1, NULL, 1, 1, 1, '2026-10-12 21:56:33', '2026-10-12 21:56:33', NULL),
(66, 'Nueva encuesta de prueba', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 0, 'identified', '2026-10-12 06:00:00', '2026-10-12 06:00:00', 171, 25, 1, NULL, 1, 1, 1, '2026-10-12 22:36:08', '2026-10-12 22:36:08', NULL),
(67, 'HOLA ESTA ES UNA ENCUESTA', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 'optional', NULL, '2026-10-12 22:47:00', 175, 2, 2, NULL, 1, 1, 8, '2026-10-12 22:37:22', '2026-10-13 03:14:13', NULL),
(68, 'Hola esta es una encuesta en la noche', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 'optional', '2026-10-13 03:04:00', '2026-10-13 03:06:00', 179, 2, 2, NULL, 1, 1, 2, '2026-10-13 03:02:03', '2026-10-13 03:07:47', NULL),
(69, 'Nueva encuesta de prueba', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 0, 'identified', '2026-10-12 06:00:00', '2026-10-12 06:00:00', 181, 2, 2, NULL, 2, 1, 8, '2026-10-13 03:14:59', '2026-10-13 03:19:11', NULL),
(70, 'Encuesta 2 ---2026 --noche', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 'optional', '2026-10-13 03:30:00', '2026-10-13 03:33:00', 185, 2, 2, NULL, 1, 1, 8, '2026-10-13 03:22:58', '2026-10-13 03:33:02', NULL),
(71, 'Encuesta de prueba  -- de noche', 'Plantilla para evaluar eventos culturales y festivales.', 0, 'identified', '2026-10-15 02:45:00', '2026-10-15 02:48:00', 189, 25, 1, NULL, 1, 1, 2, '2026-10-15 02:40:05', '2026-10-15 02:44:42', NULL),
(72, 'Clima organizacional-hola', 'Evaluación del ambiente laboral y satisfacción interna.', 0, 'identified', '2026-10-14 06:00:00', '2026-10-14 06:00:00', 190, 25, 1, NULL, 1, 1, 2, '2026-10-15 02:45:05', '2026-10-15 02:45:24', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `survey_categories`
--

CREATE TABLE `survey_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `survey_categories`
--

INSERT INTO `survey_categories` (`id`, `name`, `status`, `description`, `deleted_at`) VALUES
(1, 'Satisfacción', 1, 'Encuestas sobre calidad del servicio', NULL),
(2, 'Evaluación de Evento', 1, 'Medición de impacto de eventos', NULL),
(3, 'Institucional', 1, 'Temas internos de la institución', NULL),
(4, 'Culturales', 1, 'En cuestas de cultura', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `survey_notifications`
--

CREATE TABLE `survey_notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `survey_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text DEFAULT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `survey_notifications`
--

INSERT INTO `survey_notifications` (`id`, `user_id`, `survey_id`, `type`, `title`, `message`, `read_at`, `created_at`, `updated_at`) VALUES
(1, 1, 64, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Encuesta Nueva» a revisión.', '2026-10-12 22:00:04', '2026-10-12 21:59:45', '2026-10-12 22:00:04'),
(2, 8, 64, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Encuesta Nueva» a revisión.', NULL, '2026-10-12 21:59:45', '2026-10-12 21:59:45'),
(3, 1, 67, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «HOLA ESTA ES UNA ENCUESTA» a revisión.', '2026-10-12 22:39:14', '2026-10-12 22:39:02', '2026-10-12 22:39:14'),
(4, 8, 67, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «HOLA ESTA ES UNA ENCUESTA» a revisión.', NULL, '2026-10-12 22:39:02', '2026-10-12 22:39:02'),
(5, 1, 67, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «HOLA ESTA ES UNA ENCUESTA» a revisión.', '2026-10-12 22:42:13', '2026-10-12 22:41:02', '2026-10-12 22:42:13'),
(6, 8, 67, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «HOLA ESTA ES UNA ENCUESTA» a revisión.', NULL, '2026-10-12 22:41:02', '2026-10-12 22:41:02'),
(7, 1, 68, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Hola esta es una encuesta en la noche» a revisión.', '2026-10-13 03:03:26', '2026-10-13 03:03:11', '2026-10-13 03:03:26'),
(8, 8, 68, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Hola esta es una encuesta en la noche» a revisión.', NULL, '2026-10-13 03:03:11', '2026-10-13 03:03:11'),
(9, 1, 68, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Hola esta es una encuesta en la noche» a revisión.', NULL, '2026-10-13 03:07:47', '2026-10-13 03:07:47'),
(10, 8, 68, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Hola esta es una encuesta en la noche» a revisión.', NULL, '2026-10-13 03:07:47', '2026-10-13 03:07:47'),
(11, 1, 69, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Nueva encuesta de prueba» a revisión.', '2026-10-13 03:17:13', '2026-10-13 03:16:57', '2026-10-13 03:17:13'),
(12, 8, 69, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Nueva encuesta de prueba» a revisión.', NULL, '2026-10-13 03:16:57', '2026-10-13 03:16:57'),
(13, 1, 69, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Nueva encuesta de prueba» a revisión.', NULL, '2026-10-13 03:18:35', '2026-10-13 03:18:35'),
(14, 8, 69, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Nueva encuesta de prueba» a revisión.', NULL, '2026-10-13 03:18:35', '2026-10-13 03:18:35'),
(15, 1, 70, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Nueva encuesta de prueba» a revisión.', '2026-10-13 03:25:10', '2026-10-13 03:24:50', '2026-10-13 03:25:10'),
(16, 8, 70, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Nueva encuesta de prueba» a revisión.', NULL, '2026-10-13 03:24:50', '2026-10-13 03:24:50'),
(17, 1, 70, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Encuesta 2 ---2026 --noche» a revisión.', NULL, '2026-10-13 03:26:49', '2026-10-13 03:26:49'),
(18, 8, 70, 'review_requested', 'Encuesta pendiente de revisión', 'Ana Ramírez envió «Encuesta 2 ---2026 --noche» a revisión.', NULL, '2026-10-13 03:26:49', '2026-10-13 03:26:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `survey_roles`
--

CREATE TABLE `survey_roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `survey_roles`
--

INSERT INTO `survey_roles` (`id`, `name`, `description`, `permissions`, `deleted_at`) VALUES
(1, 'Administrador', 'Acceso total al sistema de encuestas, todas las dependencias', '[\"admin.access\",\"surveys.create\",\"surveys.delete\",\"surveys.viewAll\",\"status.moderate\",\"status.submitForReview\",\"status.publish\",\"surveys.respond\",\"changelogs.view\",\"catalogs.manage\"]', NULL),
(2, 'Encuestador', 'Creación de encuestas de su dependencia; envía a revisión y publica una vez aprobadas', '[\"admin.access\",\"surveys.create\",\"status.submitForReview\",\"status.publish\",\"surveys.respond\",\"changelogs.view\"]', NULL),
(3, 'Encuestado', 'Solo puede responder encuestas públicas o por invitación', '[\"surveys.respond\"]', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `survey_users`
--

CREATE TABLE `survey_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `external_id` varchar(255) NOT NULL COMMENT 'ID del sistema institucional externo (login-mc)',
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `role_id` bigint(20) UNSIGNED DEFAULT NULL,
  `dependency_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `survey_users`
--

INSERT INTO `survey_users` (`id`, `external_id`, `name`, `email`, `is_active`, `role_id`, `dependency_id`, `created_at`, `updated_at`) VALUES
(1, '1', 'Carlos Méndez', 'carlos.mendez@cultura.gob.sv', 1, 1, 1, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(2, '2', 'Ana Ramírez', 'ana.ramirez@cultura.gob.sv', 1, 2, 2, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(3, '3', 'Jorge Alas', 'jorge.alas@cultura.gob.sv', 1, 2, 22, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(4, '4', 'Karla Núñez', 'karla.nunez@cultura.gob.sv', 1, 2, 26, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(5, '5', 'Luis Portillo', 'luis.portillo@cultura.gob.sv', 1, 3, NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(6, '6', 'Mario Cruz', 'mario.cruz@cultura.gob.sv', 1, 3, NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(7, '7', 'Diana Flores', 'diana.flores@cultura.gob.sv', 1, 3, NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(8, 'ext-001', 'Carlos Méndez', 'admin@cultura.gob.sv', 1, 1, 1, '2026-08-24 23:56:01', '2026-08-24 23:56:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `templates`
--

CREATE TABLE `templates` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `dependency_id` bigint(20) UNSIGNED DEFAULT NULL,
  `survey_category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `templates`
--

INSERT INTO `templates` (`id`, `name`, `description`, `is_public`, `user_id`, `dependency_id`, `survey_category_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Evaluación de eventos', 'Plantilla para evaluar eventos culturales y festivales.', 1, 8, 1, NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01', NULL),
(2, 'Clima organizacional', 'Evaluación del ambiente laboral y satisfacción interna.', 1, 8, 1, NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01', NULL),
(3, 'Satisfacción ciudadana', 'Medición de calidad en atención al ciudadano.', 1, 8, 1, NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01', NULL),
(4, 'Diagnóstico de bibliotecas', 'Evaluación de servicios bibliotecarios municipales.', 1, 8, 1, NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01', NULL),
(5, 'Capacitación', 'Evaluación de cursos y talleres de capacitación.', 1, 8, 1, NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01', NULL),
(6, 'Evaluación Festival Nacional de las Artes 2026', 'Encuesta de satisfacción general del festival.', 1, 1, 1, NULL, '2026-10-08 16:09:37', '2026-10-08 16:09:37', NULL),
(7, 'Evaluación de Exposición Temporal', 'Encuesta sobre la exposición de arte moderno', 1, 1, 1, NULL, '2026-10-08 16:09:59', '2026-10-08 16:09:59', NULL),
(8, 'Encuesta de Evaluación de Servicios Culturales en Línea', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 1, 1, NULL, '2026-10-08 16:10:39', '2026-10-08 16:10:39', NULL),
(9, 'Encuesta Nueva', 'Evaluación de la organización, logística y contenido de eventos culturales de gran afluencia.', 1, 1, 1, NULL, '2026-10-08 16:12:12', '2026-10-08 16:12:12', NULL),
(10, 'Nueva encuesta de prueba', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 1, 1, NULL, '2026-10-10 00:23:30', '2026-10-10 00:23:30', NULL),
(11, 'encuestas 2', 'jsjjsjsjss', 1, 1, 2, 1, '2026-10-12 22:18:06', '2026-10-12 22:18:06', NULL),
(12, 'HOLA ESTA ES UNA ENCUESTA', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 2, 2, 1, '2026-10-12 22:41:50', '2026-10-12 22:41:50', NULL),
(13, 'Encuesta 2 ---2026 --noche', 'Evaluación integral de los servicios culturales ofrecidos a través de plataformas digitales y presenciales.', 1, 2, 2, 3, '2026-10-13 03:34:49', '2026-10-13 03:34:49', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `type`
--

CREATE TABLE `type` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `types`
--

CREATE TABLE `types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `types`
--

INSERT INTO `types` (`id`, `name`, `description`, `deleted_at`) VALUES
(1, 'Pública', 'Acceso por enlace/QR libre', NULL),
(2, 'Privada', 'Solo para invitados en grupos específicos', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubication`
--

CREATE TABLE `ubication` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `role_id`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Carlos Méndez', 'carlos.mendez@cultura.gob.sv', 1, NULL, '$2y$10$JzXLd8Y/TsstdHE/ZaU0Bemwp4H3K2WqJlUz5x0ElV09WmgZg9ejy', NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(2, 'Ana Ramírez', 'ana.ramirez@cultura.gob.sv', 1, NULL, '$2y$10$6X1UnYAtPMI9chPN1VxpWOct98.dxVvY8RHZv0dyDVPCQ23wGo5Pe', NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(3, 'Jorge Alas', 'jorge.alas@cultura.gob.sv', 1, NULL, '$2y$10$BbDVnfPeWNKSUi3S0E3Ft.P6QKU2S5qkLACDBl.iK/1j/QR9fRYvm', NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(4, 'Karla Núñez', 'karla.nunez@cultura.gob.sv', 1, NULL, '$2y$10$h0h5H477QeZMHE26EY3vUOtxGaCXpwUGU4MD7soDIgAMv07FjLN/a', NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(5, 'Luis Portillo', 'luis.portillo@cultura.gob.sv', 1, NULL, '$2y$10$3Ook9NITuUIHdvMl0b9jFedcA/nSHYWPaLAWqEGj7gI87bS7vwbYK', NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(6, 'Mario Cruz', 'mario.cruz@cultura.gob.sv', 1, NULL, '$2y$10$QZMAmeqED29HNh3E3qlehOXxi1mb9VrTDY8c7LydLsovOzZvBPp3i', NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01'),
(7, 'Diana Flores', 'diana.flores@cultura.gob.sv', 1, NULL, '$2y$10$5nzVBdQ6a71XLeKxWxRYuu7LjMHcFZpqXERFuTMqKrWR0pf4veHA6', NULL, '2026-08-24 23:56:01', '2026-08-24 23:56:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `verifications`
--

CREATE TABLE `verifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('pendiente','usado','expirado') NOT NULL DEFAULT 'pendiente',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `brand`
--
ALTER TABLE `brand`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indices de la tabla `change_logs`
--
ALTER TABLE `change_logs`
  ADD PRIMARY KEY (`action_id`),
  ADD KEY `change_logs_user_id_foreign` (`user_id`),
  ADD KEY `change_logs_survey_id_foreign` (`survey_id`);

--
-- Indices de la tabla `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `email_notifications`
--
ALTER TABLE `email_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email_notifications_survey_id_foreign` (`survey_id`),
  ADD KEY `email_notifications_participant_id_foreign` (`participant_id`);

--
-- Indices de la tabla `extend`
--
ALTER TABLE `extend`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  ADD KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`);

--
-- Indices de la tabla `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`group_id`),
  ADD KEY `groups_created_by_foreign` (`created_by`),
  ADD KEY `groups_dependency_id_foreign` (`dependency_id`);

--
-- Indices de la tabla `group_participants`
--
ALTER TABLE `group_participants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_participants_group_id_foreign` (`group_id`),
  ADD KEY `group_participants_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indices de la tabla `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `material`
--
ALTER TABLE `material`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `model`
--
ALTER TABLE `model`
  ADD PRIMARY KEY (`id`),
  ADD KEY `model_brand_id_foreign` (`brand_id`);

--
-- Indices de la tabla `movement`
--
ALTER TABLE `movement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movement_supplier_id_foreign` (`supplier_id`),
  ADD KEY `movement_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `movement_detail`
--
ALTER TABLE `movement_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movement_detail_resource_id_foreign` (`resource_id`),
  ADD KEY `movement_detail_movement_id_foreign` (`movement_id`);

--
-- Indices de la tabla `multiple_choise_responses`
--
ALTER TABLE `multiple_choise_responses`
  ADD PRIMARY KEY (`response_id`,`question_option_id`),
  ADD KEY `multiple_choise_responses_question_option_id_foreign` (`question_option_id`);

--
-- Indices de la tabla `organizational_units`
--
ALTER TABLE `organizational_units`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `organizational_units_code_unique` (`code`),
  ADD KEY `organizational_units_parent_id_foreign` (`parent_id`);

--
-- Indices de la tabla `participants`
--
ALTER TABLE `participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `participants_access_token_unique` (`access_token`),
  ADD KEY `idx_participants_survey_email` (`survey_id`,`email`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indices de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indices de la tabla `qr_codes`
--
ALTER TABLE `qr_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `qr_codes_survey_id_foreign` (`survey_id`);

--
-- Indices de la tabla `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `questions_section_id_foreign` (`section_id`),
  ADD KEY `questions_template_id_foreign` (`template_id`);

--
-- Indices de la tabla `question_options`
--
ALTER TABLE `question_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_options_question_id_foreign` (`question_id`);

--
-- Indices de la tabla `resource`
--
ALTER TABLE `resource`
  ADD PRIMARY KEY (`id`),
  ADD KEY `resource_brand_id_foreign` (`brand_id`),
  ADD KEY `resource_ubication_id_foreign` (`ubication_id`),
  ADD KEY `resource_type_id_foreign` (`type_id`),
  ADD KEY `resource_extend_id_foreign` (`extend_id`),
  ADD KEY `resource_material_id_foreign` (`material_id`);

--
-- Indices de la tabla `responses`
--
ALTER TABLE `responses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `responses_question_id_foreign` (`question_id`),
  ADD KEY `responses_participant_id_foreign` (`participant_id`),
  ADD KEY `idx_responses_survey_question` (`survey_id`,`question_id`),
  ADD KEY `idx_responses_survey_participant` (`survey_id`,`participant_id`),
  ADD KEY `idx_responses_survey_anon` (`survey_id`,`anonymous_identifier`);

--
-- Indices de la tabla `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sections_survey_id_foreign` (`survey_id`);

--
-- Indices de la tabla `section_comments`
--
ALTER TABLE `section_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `section_comments_section_id_foreign` (`section_id`),
  ADD KEY `section_comments_survey_id_foreign` (`survey_id`),
  ADD KEY `section_comments_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `session_logs`
--
ALTER TABLE `session_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `session_logs_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `statuses`
--
ALTER TABLE `statuses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `statuses_slug_unique` (`slug`);

--
-- Indices de la tabla `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `surveys`
--
ALTER TABLE `surveys`
  ADD PRIMARY KEY (`id`),
  ADD KEY `surveys_user_id_foreign` (`user_id`),
  ADD KEY `surveys_template_id_foreign` (`template_id`),
  ADD KEY `surveys_survey_category_id_foreign` (`survey_category_id`),
  ADD KEY `surveys_type_id_foreign` (`type_id`),
  ADD KEY `surveys_status_id_foreign` (`status_id`),
  ADD KEY `surveys_section_id_foreign` (`section_id`),
  ADD KEY `idx_surveys_dependency_status` (`dependency_id`,`status_id`);

--
-- Indices de la tabla `survey_categories`
--
ALTER TABLE `survey_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `survey_notifications`
--
ALTER TABLE `survey_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `survey_notifications_survey_id_foreign` (`survey_id`),
  ADD KEY `survey_notifications_user_id_read_at_index` (`user_id`,`read_at`);

--
-- Indices de la tabla `survey_roles`
--
ALTER TABLE `survey_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `survey_roles_name_unique` (`name`);

--
-- Indices de la tabla `survey_users`
--
ALTER TABLE `survey_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `survey_users_external_id_unique` (`external_id`),
  ADD UNIQUE KEY `survey_users_email_unique` (`email`),
  ADD KEY `survey_users_role_id_foreign` (`role_id`),
  ADD KEY `survey_users_dependency_id_foreign` (`dependency_id`);

--
-- Indices de la tabla `templates`
--
ALTER TABLE `templates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `templates_user_id_foreign` (`user_id`),
  ADD KEY `templates_dependency_id_foreign` (`dependency_id`),
  ADD KEY `templates_survey_category_id_foreign` (`survey_category_id`);

--
-- Indices de la tabla `type`
--
ALTER TABLE `type`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `types`
--
ALTER TABLE `types`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ubication`
--
ALTER TABLE `ubication`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_role_id_foreign` (`role_id`);

--
-- Indices de la tabla `verifications`
--
ALTER TABLE `verifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `verifications_user_id_foreign` (`user_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `brand`
--
ALTER TABLE `brand`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `change_logs`
--
ALTER TABLE `change_logs`
  MODIFY `action_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=532;

--
-- AUTO_INCREMENT de la tabla `department`
--
ALTER TABLE `department`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `email_notifications`
--
ALTER TABLE `email_notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `extend`
--
ALTER TABLE `extend`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `groups`
--
ALTER TABLE `groups`
  MODIFY `group_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `group_participants`
--
ALTER TABLE `group_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `material`
--
ALTER TABLE `material`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de la tabla `model`
--
ALTER TABLE `model`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `movement`
--
ALTER TABLE `movement`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `movement_detail`
--
ALTER TABLE `movement_detail`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `organizational_units`
--
ALTER TABLE `organizational_units`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT de la tabla `participants`
--
ALTER TABLE `participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `qr_codes`
--
ALTER TABLE `qr_codes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `questions`
--
ALTER TABLE `questions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=691;

--
-- AUTO_INCREMENT de la tabla `question_options`
--
ALTER TABLE `question_options`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=787;

--
-- AUTO_INCREMENT de la tabla `resource`
--
ALTER TABLE `resource`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `responses`
--
ALTER TABLE `responses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=481;

--
-- AUTO_INCREMENT de la tabla `role`
--
ALTER TABLE `role`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `sections`
--
ALTER TABLE `sections`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=191;

--
-- AUTO_INCREMENT de la tabla `section_comments`
--
ALTER TABLE `section_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `session_logs`
--
ALTER TABLE `session_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `statuses`
--
ALTER TABLE `statuses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `surveys`
--
ALTER TABLE `surveys`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT de la tabla `survey_categories`
--
ALTER TABLE `survey_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `survey_notifications`
--
ALTER TABLE `survey_notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `survey_roles`
--
ALTER TABLE `survey_roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `survey_users`
--
ALTER TABLE `survey_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `templates`
--
ALTER TABLE `templates`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `type`
--
ALTER TABLE `type`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `types`
--
ALTER TABLE `types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ubication`
--
ALTER TABLE `ubication`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `verifications`
--
ALTER TABLE `verifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `change_logs`
--
ALTER TABLE `change_logs`
  ADD CONSTRAINT `change_logs_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `change_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `survey_users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `email_notifications`
--
ALTER TABLE `email_notifications`
  ADD CONSTRAINT `email_notifications_participant_id_foreign` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `email_notifications_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `groups_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `survey_users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `groups_dependency_id_foreign` FOREIGN KEY (`dependency_id`) REFERENCES `organizational_units` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `group_participants`
--
ALTER TABLE `group_participants`
  ADD CONSTRAINT `group_participants_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`group_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `group_participants_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `model`
--
ALTER TABLE `model`
  ADD CONSTRAINT `model_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`);

--
-- Filtros para la tabla `movement`
--
ALTER TABLE `movement`
  ADD CONSTRAINT `movement_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`id`),
  ADD CONSTRAINT `movement_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `movement_detail`
--
ALTER TABLE `movement_detail`
  ADD CONSTRAINT `movement_detail_movement_id_foreign` FOREIGN KEY (`movement_id`) REFERENCES `movement` (`id`),
  ADD CONSTRAINT `movement_detail_resource_id_foreign` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`);

--
-- Filtros para la tabla `multiple_choise_responses`
--
ALTER TABLE `multiple_choise_responses`
  ADD CONSTRAINT `multiple_choise_responses_question_option_id_foreign` FOREIGN KEY (`question_option_id`) REFERENCES `question_options` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `multiple_choise_responses_response_id_foreign` FOREIGN KEY (`response_id`) REFERENCES `responses` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `organizational_units`
--
ALTER TABLE `organizational_units`
  ADD CONSTRAINT `organizational_units_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `organizational_units` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `participants`
--
ALTER TABLE `participants`
  ADD CONSTRAINT `participants_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `qr_codes`
--
ALTER TABLE `qr_codes`
  ADD CONSTRAINT `qr_codes_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_section_id_foreign` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `questions_template_id_foreign` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `question_options`
--
ALTER TABLE `question_options`
  ADD CONSTRAINT `question_options_question_id_foreign` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `resource`
--
ALTER TABLE `resource`
  ADD CONSTRAINT `resource_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`),
  ADD CONSTRAINT `resource_extend_id_foreign` FOREIGN KEY (`extend_id`) REFERENCES `extend` (`id`),
  ADD CONSTRAINT `resource_material_id_foreign` FOREIGN KEY (`material_id`) REFERENCES `material` (`id`),
  ADD CONSTRAINT `resource_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `type` (`id`),
  ADD CONSTRAINT `resource_ubication_id_foreign` FOREIGN KEY (`ubication_id`) REFERENCES `ubication` (`id`);

--
-- Filtros para la tabla `responses`
--
ALTER TABLE `responses`
  ADD CONSTRAINT `responses_participant_id_foreign` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `responses_question_id_foreign` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `responses_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `section_comments`
--
ALTER TABLE `section_comments`
  ADD CONSTRAINT `section_comments_section_id_foreign` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `section_comments_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `section_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `survey_users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `session_logs`
--
ALTER TABLE `session_logs`
  ADD CONSTRAINT `session_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `survey_users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `surveys`
--
ALTER TABLE `surveys`
  ADD CONSTRAINT `surveys_dependency_id_foreign` FOREIGN KEY (`dependency_id`) REFERENCES `organizational_units` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `surveys_section_id_foreign` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `surveys_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`),
  ADD CONSTRAINT `surveys_survey_category_id_foreign` FOREIGN KEY (`survey_category_id`) REFERENCES `survey_categories` (`id`),
  ADD CONSTRAINT `surveys_template_id_foreign` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `surveys_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `types` (`id`),
  ADD CONSTRAINT `surveys_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `survey_users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `survey_notifications`
--
ALTER TABLE `survey_notifications`
  ADD CONSTRAINT `survey_notifications_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `survey_notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `survey_users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `survey_users`
--
ALTER TABLE `survey_users`
  ADD CONSTRAINT `survey_users_dependency_id_foreign` FOREIGN KEY (`dependency_id`) REFERENCES `organizational_units` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `survey_users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `survey_roles` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `templates`
--
ALTER TABLE `templates`
  ADD CONSTRAINT `templates_dependency_id_foreign` FOREIGN KEY (`dependency_id`) REFERENCES `organizational_units` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `templates_survey_category_id_foreign` FOREIGN KEY (`survey_category_id`) REFERENCES `survey_categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `templates_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `survey_users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`);

--
-- Filtros para la tabla `verifications`
--
ALTER TABLE `verifications`
  ADD CONSTRAINT `verifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
