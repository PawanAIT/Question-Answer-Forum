CREATE TABLE [dbo].[user_seen_answers]
(
	[user_id] BIGINT NOT NULL , 
    [seen_answer_id] BIGINT NOT NULL, 
    PRIMARY KEY ([user_id], [seen_answer_id]),
    FOREIGN KEY (user_id) REFERENCES [dbo].[users] (user_id)
)
