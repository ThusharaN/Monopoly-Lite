CREATE DEFINER=`root`@`localhost` PROCEDURE `update_player_pos`(IN p_name VARCHAR(30), 
																IN rolled_num INT,
                                                                IN round_num INT)
BEGIN
	DECLARE p_id INT;
	DECLARE curr_loc INT;
	DECLARE curr_loc_name VARCHAR (30);
    DECLARE is_bonus BOOLEAN;
    DECLARE next_pos INT;
    DECLARE last_played INT;
    DECLARE continue_flow BOOLEAN;
    DECLARE player_bonus INT;
    
    SET continue_flow = TRUE;
    
    -- Helper procedure to get the current location details of the player
    CALL get_location_details(p_name, p_id, curr_loc, curr_loc_name);
    
    -- Get the previous state of the player from Audit table
    SELECT MAX(ID) INTO last_played FROM AUDIT_TRAIL WHERE player_id = p_id;
    IF curr_loc_name = "Jail" THEN
		-- How to proceed if a person is in jail
		CALL continue_if_in_jail(last_played, p_id, rolled_num, continue_flow);
	ELSE
		-- Update audit trial with the rolled number
		UPDATE AUDIT_TRAIL SET curr_rolled = rolled_num WHERE ID = last_played;
    END IF;
    
	IF continue_flow THEN
		SET next_pos = curr_loc + rolled_num;
        
        -- If the Player passes GO, update the bank balance by 200 and bonus by 1 
        -- indicating the player has received a bonus during this gameplay
        SELECT bonus INTO player_bonus FROM PLAYER WHERE ID = p_id;
        IF player_bonus IS NULL THEN
			IF next_pos > 17 THEN
				UPDATE PLAYER 
				SET bank_bal = bank_bal + 200, bonus = 1
				WHERE name = p_name;
			END IF;
		END IF;
        
        -- Update current state and Audit trail for the new position of the player
        IF next_pos > 16 THEN
			SET next_pos = next_pos%16;
		END IF;
		UPDATE CURRENT_STATE SET loc_id = next_pos WHERE player_id = p_id;
        INSERT INTO AUDIT_TRAIL(player_id, loc_id, bank_bal, game_round) 
        VALUES (p_id, next_pos, (SELECT bank_bal FROM PLAYER WHERE ID = p_id), round_num);
        
        -- If rolled number is 6, only the position changes
        -- Bonus or property related actions to be done only on the next roll
        IF rolled_num != 6 THEN
			SELECT isBonus INTO is_bonus FROM LOCATION WHERE ID = next_pos;
            SELECT bonus INTO player_bonus FROM PLAYER WHERE ID = p_id;
			IF is_bonus THEN
				IF player_bonus IS NULL THEN
					CALL do_bonus_task(p_id, next_pos, round_num);
				END IF;
			ELSE
				CALL own_or_rent_property(p_id, next_pos);
			END IF;
            -- make bonus null because this gameplay has ended; player can collect another bonus in the next gameplay
            UPDATE PLAYER SET bonus = NULL WHERE name = p_name;
		END IF;			
	END IF;

END