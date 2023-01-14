-- Initial population of the DBs
CREATE TABLE TOKEN (
    ID INT AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    PRIMARY KEY (ID)
);
INSERT INTO TOKEN(name)
VALUES ("dog"),
    ("car"),
    ("battleship"),
    ("top hat"),
    ("thimble"),
    ("boot");

    
CREATE TABLE PLAYER (
    ID INT AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    token INT NOT NULL,
    bank_bal INT DEFAULT 0,
    bonus INT,
    PRIMARY KEY (ID),
    FOREIGN KEY (token) REFERENCES TOKEN(ID),
    FOREIGN KEY (bonus) REFERENCES BONUS(ID)
);
INSERT INTO PLAYER(name, token, bank_bal)
VALUES (
        "Mary",
        (
            SELECT ID
            FROM TOKEN
            WHERE name = "Battleship"
        ),
        190
    ),
    (
        "Bill",
        (
            SELECT ID
            FROM TOKEN
            WHERE name = "Dog"
        ),
        500
    ),
    (
        "Jane",
        (
            SELECT ID
            FROM TOKEN
            WHERE name = "Car"
        ),
        150
    ),
    (
        "Norman",
        (
            SELECT ID
            FROM TOKEN
            WHERE name = "Thimble"
        ),
        250
    );


CREATE TABLE LOCATION (
    ID INT AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    isBonus BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (ID)
);
INSERT INTO LOCATION(name, isBonus)
VALUES ("GO", TRUE),
    ("Kilburn", FALSE),
    ("Chance 1", TRUE),
    ("Uni Place", FALSE),
    ("Jail", TRUE),
    ("Victoria", FALSE),
    ("Community Chest 1", TRUE),
    ("Piccadilly", FALSE),
    ("Free Parking", TRUE),
    ("Oak House", FALSE),
    ("Chance 2", TRUE),
    ("Owens Park", FALSE),
    ("Go to Jail", TRUE),
    ("AMBS", FALSE),
    ("Community Chest 2", TRUE),
    ("Co-Op", FALSE);


CREATE TABLE BONUS (
    ID INT,
    description VARCHAR(200) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES Location(ID)
);
INSERT INTO BONUS
VALUES (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "GO"
        ),
        "Collect £200"
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Chance 1"
        ),
        "Pay each of the other players £50"
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Jail"
        ),
        "In Jail"
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Community Chest 1"
        ),
        "For winning a Beauty Contest, you win £100"
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Free Parking"
        ),
        "No action"
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Chance 2"
        ),
        "Move forward 3 spaces"
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Go to Jail"
        ),
        "Go to Jail, do not pass GO, do not collect £200"
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Community Chest 2"
        ),
        "Your library books are overdue. Pay a fine of £30"
    );


CREATE TABLE PROPERTY (
    ID INT,
    owner_id INT,
    color VARCHAR(30) NOT NULL,
    pur_cost INT DEFAULT 0,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES Location(ID),
    FOREIGN KEY (owner_id) REFERENCES PLAYER(ID)
);
INSERT INTO PROPERTY
VALUES (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Kilburn"
        ),
        NULL,
        "Yellow",
        120
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Uni Place"
        ),
        (
            SELECT ID
            FROM PLAYER
            WHERE name = "Mary"
        ),
        "Yellow",
        100
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Victoria"
        ),
        (
            SELECT ID
            FROM PLAYER
            WHERE name = "Bill"
        ),
        "Green",
        75
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Piccadilly"
        ),
        NULL,
        "Green",
        35
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Oak House"
        ),
        (
            SELECT ID
            FROM PLAYER
            WHERE name = "Norman"
        ),
        "Orange",
        100
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Owens Park"
        ),
        (
            SELECT ID
            FROM PLAYER
            WHERE name = "Norman"
        ),
        "Orange",
        30
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "AMBS"
        ),
        NULL,
        "Blue",
        400
    ),
    (
        (
            SELECT ID
            FROM LOCATION
            WHERE name = "Co-Op"
        ),
        (
            SELECT ID
            FROM PLAYER
            WHERE name = "Jane"
        ),
        "Blue",
        30
    );


CREATE TABLE CURRENT_STATE (
    player_id INT,
    loc_id INT DEFAULT 1,
    PRIMARY KEY (player_id, loc_id),
    FOREIGN KEY (player_id) REFERENCES PLAYER(ID),
    FOREIGN KEY (loc_id) REFERENCES LOCATION(ID)
);
INSERT INTO CURRENT_STATE
VALUES (
        (
            SELECT ID
            FROM PLAYER
            WHERE name = "Mary"
        ),
        (
            SELECT ID
            FROM Location
            WHERE name = "Free Parking"
        )
    ),
    (
        (
            SELECT ID
            FROM PLAYER
            WHERE name = "Bill"
        ),
        (
            SELECT ID
            FROM Location
            WHERE name = "Owens Park"
        )
    ),
    (
        (
            SELECT ID
            FROM PLAYER
            WHERE name = "Jane"
        ),
        (
            SELECT ID
            FROM Location
            WHERE name = "AMBS"
        )
    ),
    (
        (
            SELECT ID
            FROM PLAYER
            WHERE name = "Norman"
        ),
        (
            SELECT ID
            FROM Location
            WHERE name = "Kilburn"
        )
    );


CREATE TABLE AUDIT_TRAIL (
    ID INT AUTO_INCREMENT,
    player_id INT NOT NULL,
    loc_id INT NOT NULL,
    bank_bal INT DEFAULT 0,
    curr_rolled INT,
    game_round INT NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (player_id) REFERENCES PLAYER(ID),
    FOREIGN KEY (loc_id) REFERENCES LOCATION(ID)
);
INSERT INTO AUDIT_TRAIL(player_id, loc_id, bank_bal)
VALUES (
        1,
        (
            SELECT loc_id
            FROM CURRENT_STATE
            WHERE player_id = 1
        ),
        (
            SELECT bank_bal
            FROM PLAYER
            WHERE ID = 1
        ),
        0
    ),
    (
        2,
        (
            SELECT loc_id
            FROM CURRENT_STATE
            WHERE player_id = 2
        ),
        (
            SELECT bank_bal
            FROM PLAYER
            WHERE ID = 2
        ),
        0
    ),
    (
        3,
        (
            SELECT loc_id
            FROM CURRENT_STATE
            WHERE player_id = 3
        ),
        (
            SELECT bank_bal
            FROM PLAYER
            WHERE ID = 3
        ),
        0
    ),
    (
        4,
        (
            SELECT loc_id
            FROM CURRENT_STATE
            WHERE player_id = 4
        ),
        (
            SELECT bank_bal
            FROM PLAYER
            WHERE ID = 4
        ),
        0
    );