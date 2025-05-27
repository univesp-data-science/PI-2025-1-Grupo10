/*
/Users/Shared/DBngin/mysql/8.0.33/bin/mysql -u root -p -h 127.0.0.1 pi202501_010 < /Users/fabiotnt/Downloads/radacct_bi.sql

Usuários / Dia
Dados / Dia
Tempo Médio / Dia
Total de Conexões do Dia

Usuários / Hora
Dados / Hora
Tempo Médio / Hora
Total de Conexões do Hora
*/

INSERT INTO `wifimaxx_access_by_hour`(`username`, `acctsessiontime`, `acctinputoctets`, `acctoutputoctets`, `hour`) 

SELECT
  `username`,
  SUM(`acctsessiontime`) AS total_session_time,
  SUM(`acctinputoctets`) AS total_input_octets,
  SUM(`acctoutputoctets`) AS total_output_octets,
  DATE_FORMAT(`created_date`, '%Y-%m-%d %H:00:00') AS computed_hour
FROM
  `radacct_bi`
GROUP BY
  `username`,
  computed_hour
ORDER BY
  computed_hour ASC, `username` ASC;

15144

SELECT COUNT(`username`) FROM `radacct_bi` WHERE `created_date` LIKE '2025-05-20%' GROUP BY `username`;

9519

SELECT * FROM `wifimaxx_access_by_hour` WHERE `hour` BETWEEN '2025-05-23' AND '2025-05-24';

--- Refazer query para contar direito

INSERT INTO `wifimaxx_access_by_day`(`users`, `acctsessiontime`, `acctinputoctets`, `acctoutputoctets`, `computed_day`)
SELECT
  COUNT(DISTINCT username) AS total_users,
  SUM(acctsessiontime) AS total_session_time,
  SUM(acctinputoctets) AS total_input_octets,
  SUM(acctoutputoctets) AS total_output_octets,
  DATE_FORMAT(created_date, '%Y-%m-%d') AS computed_day,
FROM
  `radacct_bi`
GROUP BY
  computed_day
ORDER BY
  computed_day ASC;

--- Refazer query para contar direito

INSERT INTO `wifimaxx_total_access_by_hour`(`users`, `acctsessiontime`, `acctinputoctets`, `acctoutputoctets`, `hour`)
SELECT
  COUNT(DISTINCT username) AS total_users,
  SUM(acctsessiontime) AS total_session_time,
  SUM(acctinputoctets) AS total_input_octets,
  SUM(acctoutputoctets) AS total_output_octets,
  DATE_FORMAT(`created_date`, '%Y-%m-%d %H:00:00') AS computed_hour
FROM
  `radacct_bi`
GROUP BY
  computed_hour
ORDER BY
  computed_hour ASC;

--- Refazer query para contar direito

INSERT INTO `wifimaxx_total_access_by_month`(`users`, `acctsessiontime`, `acctinputoctets`, `acctoutputoctets`, `computed_month`)
SELECT
  COUNT(DISTINCT username) AS total_users,
  SUM(acctsessiontime) AS total_session_time,
  SUM(acctinputoctets) AS total_input_octets,
  SUM(acctoutputoctets) AS total_output_octets,
  DATE_FORMAT(`created_date`, '%Y-%m-01') AS computed_month
FROM
  `radacct_bi`
GROUP BY
  computed_month
ORDER BY
  computed_month ASC;

----

SELECT
  HOUR(`hour`) AS hora,
  SUM(users) AS total_users,
  SUM(acctsessiontime) AS total_session_time,
  SUM(acctinputoctets) AS total_input_octets,
  SUM(acctoutputoctets) AS total_output_octets
FROM
  wifimaxx_total_access_by_hour
GROUP BY
  hora
ORDER BY hora;