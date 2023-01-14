CREATE ALGORITHM = UNDEFINED DEFINER = `root` @`localhost` SQL SECURITY DEFINER VIEW `new_view` AS
SELECT `pj`.`Player` AS `Player`,
    `pj`.`Token` AS `Token`,
    `pj`.`Balance` AS `Balance`,
    `pj`.`LOCATION` AS `Current_location`,
    GROUP_CONCAT(`Loc`.`name` SEPARATOR ',') AS `Properties owned`
FROM (
        (
            SELECT `P`.`name` AS `Player`,
                `T`.`name` AS `Token`,
                `P`.`bank_bal` AS `Balance`,
                `L`.`name` AS `LOCATION`,
                `PP`.`ID` AS `Property`
            FROM (
                    (
                        (
                            (
                                `player_dummy` `P`
                                JOIN `token` `T`
                            )
                            JOIN `location` `L`
                        )
                        JOIN `current_state_dummy` `CSD`
                    )
                    JOIN `property_dummy` `PP`
                )
            WHERE (
                    (`P`.`token` = `T`.`ID`)
                    AND (`P`.`ID` = `CSD`.`player_id`)
                    AND (`L`.`ID` = `CSD`.`loc_id`)
                    AND (`PP`.`owner_id` = `P`.`ID`)
                )
        ) `PJ`
        LEFT JOIN `location` `Loc` ON ((`pj`.`Property` = `Loc`.`ID`))
    )
GROUP BY `pj`.`Player`