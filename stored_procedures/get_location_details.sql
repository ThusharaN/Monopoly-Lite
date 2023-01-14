CREATE DEFINER=`root`@`localhost` PROCEDURE `get_location_details`(IN p_name VARCHAR(30), 
										 OUT p_id INT,
                                         OUT location_id INT,
										 OUT location_name VARCHAR(30))
BEGIN
	SELECT ID INTO p_id FROM PLAYER WHERE name = p_name ;		
	SELECT loc_id INTO location_id FROM CURRENT_STATE WHERE player_id = p_id;
	SELECT name INTO location_name FROM LOCATION WHERE ID = location_id;
END