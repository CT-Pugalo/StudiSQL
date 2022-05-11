--
-- Hôte : 127.0.0.1
-- Généré le : lun. 09 mai 2022 à 11:59
-- Version du serveur : 10.6.5-MariaDB

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `studisql`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `AjouterCine` (IN `nom` VARCHAR(255) CHARSET utf8mb3)   INSERT INTO `cinema` (`nom`)
VALUES (nom)$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `AjouterEmploye` (IN `nom` VARCHAR(255), IN `prenom` VARCHAR(255), IN `salaire` INT, IN `cine` INT)   INSERT INTO `employe` (`nom`, `prenom`, `identifiant`, `motDePasse`, `salaire`, `cinema_id`) 
SELECT nom, prenom, LOWER(CONCAT(SUBSTRING(nom, 1, 2), "",SUBSTRING(prenom, 1, 1) )) , PASSWORD(CONCAT(SUBSTRING(nom, 1, 4), "",SUBSTRING(prenom, 1, 3))), salaire, cine$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `AjouterProgrammateur` (IN `programmateur` INT, IN `cine` INT)   UPDATE `ciname`
SET `programmateur`=programmateur
WHERE `id`=cine$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `AjouterSalle` (IN `nbPlace` INT, IN `cinema` INT)   INSERT INTO `salle` (`nbPlace`, `cinema_id`)
VALUES (nbPlace, cinema)$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `AjouterSceance` (IN `nomFilm` VARCHAR(255), IN `horraire` DATETIME, IN `salle` INT)   INSERT INTO sceance (nomFilm, horraire, salle) 
VALUES (nomFilm, horraire, salle)$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `NombreDePlaceRestantePourUneSceance` (IN `sceance` INT)   SELECT nbPlace-SUM(
	reservation.nbPersonneAutre +
	reservation.nbPersonneEnfant +
	reservation.nbPersonneEtudiant
) as place_restante
FROM salle, reservation, sceance
WHERE
sceance.id=sceance_id AND salle.id=sceance.salle AND reservation.sceance_id=sceance$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `PrixReservation` (IN `reserv` INT)   SELECT SUM(nbPersonneEtudiant*7.60 + nbPersonneEnfant*5.90 + nbPersonneAutre*9.20) as prixTTC
FROM reservation WHERE reservation.id=reserv$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `TouteLesInfoDeToutLesCine` ()   SELECT DISTINCT cinema.nom as cinema_id, employe.id as employe_id, salle.id as salle_id FROM cinema
LEFT JOIN employe ON employe.cinema_id=cinema.id
LEFT JOIN salle ON salle.cinema_id=cinema.id
ORDER BY cinema.id$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `TouteLesInfosDUnCine` (IN `id_cine` INT)   SELECT DISTINCT cinema.nom as cinema_id, employe.id as employe_id, salle.id as salle_id FROM cinema
LEFT JOIN employe ON employe.cinema_id=cinema.id
LEFT JOIN salle ON salle.cinema_id=cinema.id
WHERE cinema.id=id_cine
ORDER BY cinema.id$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `TouteLesSallesDeToutLesCinema` ()   BEGIN
SELECT DISTINCT cinema.nom, salle.id FROM salle
RIGHT JOIN cinema on salle.cinema_id=cinema.id
ORDER BY salle.cinema_id;
END$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `TouteLesSallesDUnCinema` (IN `id_cine` INT)   SELECT DISTINCT cinema.nom, salle.nbPlace FROM salle
RIGHT JOIN cinema on salle.cinema_id=cinema.id
WHERE cinema.id=id_cine
ORDER BY salle.cinema_id$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `ToutLePersonelleDeToutLesCine` ()   SELECT DISTINCT cinema.nom, employe.prenom FROM employe
RIGHT JOIN cinema on employe.cinema_id=cinema.id
ORDER BY employe.cinema_id$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `ToutLePersonelleDUnCine` (IN `id_cine` INT)   SELECT DISTINCT cinema.nom, employe.prenom FROM employe
RIGHT JOIN cinema on employe.cinema_id=cinema.id
WHERE cinema.id=id_cine
ORDER BY employe.cinema_id$$

CREATE DEFINER=`admin`@`127.0.0.1` PROCEDURE `ToutLesProgrammateurDeToutLesCine` ()   SELECT DISTINCT employe.nom, cinema.nom FROM cinema RIGHT JOIN employe on employe.id=cinema.programmateur WHERE cinema.nom IS NOT NULL ORDER BY cinema.id$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `administrateur`
--

CREATE TABLE `administrateur` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employe_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `administrateur`
--

INSERT INTO `administrateur` (`id`, `employe_id`) VALUES
(1, 1),
(5, 2),
(2, 3),
(3, 4),
(4, 6);

-- --------------------------------------------------------

--
-- Structure de la table `cinema`
--

CREATE TABLE `cinema` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `programmateur` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `cinema`
--

INSERT INTO `cinema` (`id`, `nom`, `programmateur`) VALUES
(1, 'CineLion', 6),
(2, 'CineTroyes', 7),
(3, 'CineReims', 8),
(4, 'CineParis', 9),
(5, 'CineMarseille', 10);

-- --------------------------------------------------------

--
-- Structure de la table `employe`
--

CREATE TABLE `employe` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `prenom` varchar(255) DEFAULT NULL,
  `identifiant` varchar(255) DEFAULT NULL,
  `motDePasse` varchar(255) DEFAULT NULL,
  `salaire` int(11) DEFAULT NULL,
  `cinema_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `employe`
--

INSERT INTO `employe` (`id`, `nom`, `prenom`, `identifiant`, `motDePasse`, `salaire`, `cinema_id`) VALUES
(1, 'Dutroux', 'Jaque', 'duj', '*0CF663632735EF0B84DF0A6E995C1625504976F5', 1400, 1),
(2, 'Dupond', 'Xavier', 'dux', '*0A1DFA72338EAA61FDDD4697AE1F5C40FD6D9BBF', 1400, 2),
(3, 'Scorses', 'Mahilde', 'scm', '*B856A9661F8BD35B9805EF545486B4CE3EFC4534', 1400, 3),
(4, 'Dubrovnik', 'Zlatan', 'duz', '*B9E8E7007FFC4F2DC82B467E814A304E193BF46B', 1400, 4),
(5, 'Henry', 'Paul', 'hep', '*66A0540671A9AB39DF876749C6052690223268E2', 1400, 5),
(6, 'Tatcher', 'Margaret', 'tam', '*C5E1DE7C5677DBAF06E9490EFBC50FE03F6C33EC', 1400, 1),
(7, 'Lebreton', 'Loic', 'lel', '*ADCA22898FFBD7D9BBBFC1434B3E1CB409E0CCF8', 1400, 2),
(8, 'Lefrancais', 'Emillie', 'lee', '*4C4AE811E0FC1EEB5BA93F972440F56F1C611C1D', 1400, 3),
(9, 'McFaren', 'Linus', 'mcl', '*117E2C6041178D6E13EDD4A284042A617CD30235', 1400, 4),
(10, 'Lange', 'Michael', 'lam', '*4BBADA7333E60785E3620687EF59695173BF0C9E', 1400, 5),
(11, 'Ratzmann', 'Olivier', 'rao', '*0B0A1C1741929C5A3AC9563E036DEB7346558FAA', 1400, 1),
(12, 'Bogdanovic', 'Hugo', 'boh', '*CCBED6D245B7D53AF676ABF07D4D1C60AFE15B27', 1500, 3);

-- --------------------------------------------------------

--
-- Structure de la table `reservation`
--

CREATE TABLE `reservation` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sceance_id` bigint(20) UNSIGNED DEFAULT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `nbPersonneEtudiant` int(11) DEFAULT NULL,
  `nbPersonneEnfant` int(11) DEFAULT NULL,
  `nbPersonneAutre` int(11) DEFAULT NULL,
  `paye` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `reservation`
--

INSERT INTO `reservation` (`id`, `sceance_id`, `nom`, `nbPersonneEtudiant`, `nbPersonneEnfant`, `nbPersonneAutre`, `paye`) VALUES
(1, 1, 'Dupond', 0, 0, 2, NULL),
(2, 3, 'Haddoc', 0, 0, 1, NULL),
(3, 5, 'Tintin', 0, 1, 1, NULL),
(4, 7, 'Tournesol', 0, 0, 1, NULL),
(5, 9, 'Nestor', 1, 1, 2, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `salle`
--

CREATE TABLE `salle` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nbPlace` int(11) DEFAULT NULL,
  `cinema_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `salle`
--

INSERT INTO `salle` (`id`, `nbPlace`, `cinema_id`) VALUES
(1, 15, 1),
(2, 15, 1),
(3, 30, 1),
(4, 20, 2),
(5, 30, 2),
(6, 40, 3),
(7, 90, 3),
(8, 100, 4),
(9, 50, 5);

-- --------------------------------------------------------

--
-- Structure de la table `sceance`
--

CREATE TABLE `sceance` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nomFilm` varchar(255) DEFAULT NULL,
  `horraire` datetime DEFAULT NULL,
  `salle` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `sceance`
--

INSERT INTO `sceance` (`id`, `nomFilm`, `horraire`, `salle`) VALUES
(1, 'Doctor Strange', '2022-04-05 19:20:00', 2),
(2, 'Doctor Strange', '2022-04-05 19:20:00', 3),
(3, 'Doctor Strange', '2022-04-05 19:20:00', 8),
(4, 'Doctor Strange', '2022-04-05 19:20:00', 9),
(5, 'Bianca', '2022-04-06 14:20:00', 1),
(6, 'Mobidick', '2022-04-05 17:00:00', 4),
(7, 'Thales', '2022-04-05 16:00:00', 5),
(8, 'Eiffel', '2022-04-05 17:20:00', 6),
(9, 'DeGaulle', '2022-04-05 20:00:00', 7);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `administrateur`
--
ALTER TABLE `administrateur`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oto_employe-admin` (`employe_id`);

--
-- Index pour la table `cinema`
--
ALTER TABLE `cinema`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oto_cinema-programmateur` (`programmateur`);

--
-- Index pour la table `employe`
--
ALTER TABLE `employe`
  ADD PRIMARY KEY (`id`),
  ADD KEY `otm_cinema-employe` (`cinema_id`);

--
-- Index pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oto_reservation-sallesceance` (`sceance_id`);

--
-- Index pour la table `salle`
--
ALTER TABLE `salle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `otm_cinema-salle` (`cinema_id`);

--
-- Index pour la table `sceance`
--
ALTER TABLE `sceance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oto_sceance-salle` (`salle`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `administrateur`
--
ALTER TABLE `administrateur`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `cinema`
--
ALTER TABLE `cinema`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `employe`
--
ALTER TABLE `employe`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `salle`
--
ALTER TABLE `salle`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `sceance`
--
ALTER TABLE `sceance`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `administrateur`
--
ALTER TABLE `administrateur`
  ADD CONSTRAINT `oto_employe-admin` FOREIGN KEY (`employe_id`) REFERENCES `employe` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `cinema`
--
ALTER TABLE `cinema`
  ADD CONSTRAINT `oto_cinema-programmateur` FOREIGN KEY (`programmateur`) REFERENCES `employe` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `employe`
--
ALTER TABLE `employe`
  ADD CONSTRAINT `otm_cinema-employe` FOREIGN KEY (`cinema_id`) REFERENCES `cinema` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `oto_reservation-sallesceance` FOREIGN KEY (`sceance_id`) REFERENCES `sceance` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `salle`
--
ALTER TABLE `salle`
  ADD CONSTRAINT `otm_cinema-salle` FOREIGN KEY (`cinema_id`) REFERENCES `cinema` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `sceance`
--
ALTER TABLE `sceance`
  ADD CONSTRAINT `oto_sceance-salle` FOREIGN KEY (`salle`) REFERENCES `salle` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
