CREATE DEFINER=`root`@`localhost` PROCEDURE `own_or_rent_property`(IN player_id INT,
																   IN curr_loc INT)
BEGIN

    DECLARE property_id INT;
    DECLARE curr_owner INT;
    DECLARE property_color VARCHAR(30);
    DECLARE cost INT;
    DECLARE number_of_owners INT;
    DECLARE deduction INT;
    DECLARE latest_id INT;
    
    DECLARE own_id INT;
    DECLARE own_loc_id INT;
    DECLARE own_loc_name VARCHAR(30);
    
    -- Get property details
    SELECT ID, owner_id, color, pur_cost INTO property_id, curr_owner, property_color, cost FROM PROPERTY WHERE ID = curr_loc;
    SET deduction = cost;
    
    -- Helper procedure to get the current location details of the player
    CALL get_location_details((SELECT name FROM PLAYER WHERE ID = curr_owner), own_id, own_loc_id, own_loc_name);
    
    -- Get ID of the latest state; to be used for updations at a later stage
    SELECT MAX(ID) INTO latest_id FROM AUDIT_TRAIL WHERE player_id = player_id;
    
    -- Check if the property is owned by anyone
    IF curr_owner IS NOT NULL THEN
		-- Check that current player is not the owner
		IF curr_owner != player_id THEN
			-- Check if the owner owns all other properties of the same color
			SELECT COUNT(DISTINCT COALESCE(owner_id,'dummy_for_null')) INTO number_of_owners
			FROM PROPERTY 
			WHERE color = property_color;
			
            -- Paying double rent if all the properties of the same color 
            -- are owned by the same owner
			IF number_of_owners = 1 THEN
				SET deduction = 2*cost;
            END IF;
            
			-- Update the bank balances of both the owner and 
            -- the player who has landed
			UPDATE PLAYER SET bank_bal = bank_bal - deduction WHERE ID = player_id;
            UPDATE PLAYER SET bank_bal = bank_bal + deduction WHERE ID = curr_owner;
                        
			-- Update bank balance for the latest state of the player
            UPDATE AUDIT_TRAIL SET bank_bal = bank_bal - deduction WHERE ID = latest_id;
                        
		END IF;
	ELSE
		-- Buy the property if it does not have an owner
		UPDATE PLAYER SET bank_bal = bank_bal - deduction WHERE ID = player_id;
		UPDATE PROPERTY SET owner_id = player_id WHERE ID = property_id;
        
        -- Update bank balance For the latest state of the player
        UPDATE AUDIT_TRAIL SET bank_bal = bank_bal - deduction WHERE ID = latest_id;
                    
	END IF;
END