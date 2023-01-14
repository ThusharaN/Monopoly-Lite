CREATE DEFINER = `root` @`localhost` PROCEDURE `continue_if_in_jail`(
    IN latest_play INT,
    IN player INT,
    IN rolled_num INT,
    OUT continue_flow BOOLEAN
) BEGIN
DECLARE prev_pos_name VARCHAR(30);
DECLARE prev_rolled INT;
SET continue_flow = FALSE;
-- Getting the location name of the player before they landed in Jail
SELECT name into prev_pos_name
FROM LOCATION
WHERE ID = (
        SELECT loc_id
        FROM AUDIT_TRAIL
        WHERE ID = (
                SELECT MAX(ID)
                FROM AUDIT_TRAIL
                WHERE ID != latest_play
                    AND player_id = player
            )
    );
-- Check if the player landed 'In Jail' due to the 'Go To Jail' bonus
IF prev_pos_name != "Go to Jail" THEN
SET continue_flow = TRUE;
ELSE -- Check if the player had previously rolled a 6
SELECT curr_rolled INTO prev_rolled
FROM AUDIT_TRAIL
WHERE ID = latest_play;
-- If the player had previously rolled a six, they can get out of jail
IF prev_rolled = 6 THEN
SET continue_flow = TRUE;
END IF;
END IF;
UPDATE AUDIT_TRAIL
SET curr_rolled = rolled_num
WHERE ID = latest_play;
END