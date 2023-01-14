CREATE DEFINER=`root`@`localhost` PROCEDURE `do_bonus_task`(IN player INT,
							 IN curr_loc INT,
                             IN round_num INT)
BEGIN
	DECLARE num_ids INT;
    DECLARE last_id INT;
    
	CASE curr_loc
		WHEN 1 THEN 
			UPDATE PLAYER SET bank_bal = bank_bal + 200 WHERE ID = player;
            SELECT MAX(ID) INTO last_id FROM AUDIT_TRAIL WHERE player_id = player;
            UPDATE AUDIT_TRAIL SET bank_bal = bank_bal + 200 WHERE ID = last_id;
		WHEN 3 THEN 
			SELECT COUNT(ID) INTO num_ids FROM PLAYER WHERE ID != player;
			UPDATE PLAYER SET bank_bal = bank_bal + 50 WHERE ID != player;
            UPDATE PLAYER SET bank_bal = bank_bal - 50*num_ids WHERE ID = player;
            SELECT MAX(ID) INTO last_id FROM AUDIT_TRAIL WHERE player_id = player;
            UPDATE AUDIT_TRAIL SET bank_bal = bank_bal - 50*num_ids WHERE ID = last_id;
		WHEN 7 THEN
			UPDATE PLAYER SET bank_bal = bank_bal + 100 WHERE ID = player;
            SELECT MAX(ID) INTO last_id FROM AUDIT_TRAIL WHERE player_id = player;
            UPDATE AUDIT_TRAIL SET bank_bal = bank_bal + 100 WHERE ID = last_id;
		WHEN 11 THEN
			-- If we move 3 spaces from Chance 2, we land at AMBS
            UPDATE CURRENT_STATE SET loc_id = 14 WHERE player_id = player;
			INSERT INTO AUDIT_TRAIL(player_id, loc_id, bank_bal, game_round) 
				VALUES (player, 14, (SELECT bank_bal FROM PLAYER WHERE ID = player), round_num);
            CALL own_or_rent_property(player, 14);
		WHEN 13 THEN
			UPDATE CURRENT_STATE SET loc_id = 5 WHERE player_id = player;
            INSERT INTO AUDIT_TRAIL(player_id, loc_id, bank_bal, game_round) 
				VALUES (player, 5, (SELECT bank_bal FROM PLAYER WHERE ID = player), round_num);
		WHEN 15 THEN
			UPDATE PLAYER SET bank_bal = bank_bal - 30 WHERE ID = player;
            SELECT MAX(ID) INTO last_id FROM AUDIT_TRAIL WHERE player_id = player;
            UPDATE AUDIT_TRAIL SET bank_bal = bank_bal - 30 WHERE ID = last_id;
		ELSE 
			-- Do Nothing
			SELECT '';
	END CASE;
END