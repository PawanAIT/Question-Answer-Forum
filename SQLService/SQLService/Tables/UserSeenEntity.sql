CREATE TABLE [dbo].[user_seen_answers]
(
	[user_id] BIGINT NOT NULL , 
    [seen_entity_id] BIGINT NOT NULL, 
    PRIMARY KEY ([user_id], [seen_entity_id])
)
