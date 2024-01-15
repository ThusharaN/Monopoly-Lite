# Monopoly lite using MySQL

## <u>About the project</u>
We model the gameplay of a simplified version of Monopoly by automating actions using MySQL, utilizing multiple stored procedures and views to streamline different steps within the gameplay.


## <u>Monopoly: Modelling the gameplay</u>
### Entity Relationship Diagram
We identify the different entities that make up the gameplay and establish relationships to extract an accurate Relational Database schema that will aid in implementing the said schema.   
<div align="center"><img width="700" alt="image" src="https://github.com/ThusharaN/Monopoly-Lite/assets/85170859/641e18f0-ade4-402f-bb68-cc51d623c331"></div>

### Entity Relationship Diagram – Design Choices
There are strong and weak entities identified for the ER model. The strong entities are as follows: 
- `Token`: This entity identifies the token used by each player. Every player needs to have a distinct token while playing the game. 
- `Player`: This entity represents the players participating in the game. Since every player must have one token, there is a mandatory **one-and-only-one** relationship with the token. On the other hand, a token can either be owned by zero (if there are fewer players than tokens) or one player at most, which establishes a **zero-or-many** relation for the token with the player. 
- `Location`: Every spot on the Monopoly board is represented by the **Location** entity. To have a better separation of concerns, additional information regarding each spot is provided as part of the **Bonus** or **Property** entities since every spot on the board is either a bonus or a property.
- `Bonus`: The  **Bonus**  entity  represents  those  locations  on  the  board  that  are  either  Chances,  Corners  or Community Chests. Since every player can have at most one bonus at any given time in the game, there is a **zero-or-one** relation with the **Bonus** entity, but the same bonus can be used by multiple players throughout the game which makes the relationship **zero-or-many**.  
- `Property`: Every property can have one owner at most, making the relationship **zero-or-one**. Every player can own zero or multiple properties throughout the game making its relationship with **Property** of the **zero-or-many** type.

`Current State` and `Audit Trial` are **weak entities** because they cease to exist without the **Player** and **Location** entities since only when a player participates, will there exist a state for that player. Their relations are described further as follows: 

- `Current state`: This entity represents the current state that a player is in. Since every player has one state and every state is unique to a player, the relation is **one-and-only-one** on both ends. A location can be part of multiple states for different players, but every state can have only one location since a player can only be present at one location at any given time which makes the relationship between Location and Current State **one-to-many**. 
- `Audit trail`: The **Audit trail** entity resembles the **Current State** entity, the difference being every state of every player throughout the game is recorded as part of this entity. A player will have at least one state as the game progresses however one record from **Audit trial** cannot have multiple players since it represents the state of a player at any given time in the game. Hence the relations established are **one- and-only-one** and **one-or-many** on either of the two sides, respectively. A location might or might not be occupied by multiple players as the game progresses however, at any point in the game, a state will be associated with only one player and their corresponding location. This makes the relationship between Location and Audit Trail of the **one-to-many** type.  


### Relational Database Schema 
The Relational Database schema for the above ER diagram can be represented as follows: 
<div align="center"><img width="650" alt="image" src="https://github.com/ThusharaN/Monopoly-Lite/assets/85170859/db72f9c6-781f-4183-af0c-91afc2a873a0"></div>


## <u>Liberties</u>
Some assumptions have been made to facilitate the modelling of the gameplay. These assumptions have been put into place to combat the ambiguity of some requirements in the description. 
- If a player crosses ‘GO’ by rolling a 6, we assume that the player gets a 200￡ bonus even though the final position of the player is decided only after the immediate next roll. After the immediate next roll, if the player lands on another bonus, it has no effect since the player already collected a bonus (200 ￡ collected early). 
- If a player lands on the ‘In Jail’ location due to dice rolling **i.e.,** the player was not sent to jail due to the ‘Go to Jail’ bonus, the player does not need a 6 to get out. Only in cases where the player was sent to jail from the ‘Go to Jail’ corner, the player needs a 6 to get out. 
- We  assume  when  a  game  starts,  the  CURRENT\_STATE  and  AUDIT\_TRIAL  tables  have  been populated with the player's first state, i.e., the player at location ‘GO’. 
- While auditing, any changes in other players’ bank balances caused due to a bonus or a property being used by the current player, are not reflected in the AUDIT\_TRIAL table right away. This gets reflected when the other players take their turn. This helps maintain the truth and actual order of events while Auditing. 

> _**Note**_: _The entire project report is documented in `11078927_Databases.pdf`_
