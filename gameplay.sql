SET @@sql_mode =(
        SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY,', '')
    );

SET SQL_SAFE_UPDATES = 0;
-- First Round begins
CALL update_player_pos('Jane', 3, 1);
CALL update_player_pos('Norman', 1, 1);
CALL update_player_pos('Mary', 4, 1);
CALL update_player_pos('Bill', 2, 1);
-- First Round ends

SELECT * FROM game_view;

-- Second Round begins
FROM new_view;
CALL update_player_pos('Jane', 5, 2);
CALL update_player_pos('Norman', 4, 2);
CALL update_player_pos('Mary', 6, 2);
CALL update_player_pos('Mary', 5, 2);
CALL update_player_pos('Bill', 6, 2);
CALL update_player_pos('Bill', 3, 2);
-- Second Round ends

SET SQL_SAFE_UPDATES = 1;