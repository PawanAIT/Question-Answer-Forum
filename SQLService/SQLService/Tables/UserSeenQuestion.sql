CREATE TABLE [dbo].[user_seen_question]
(
	[user_id] BIGINT NOT NULL , 
    [seen_question_id] BIGINT NOT NULL, 
    PRIMARY KEY ([user_id], [seen_question_id]),
    FOREIGN KEY (user_id) REFERENCES [dbo].[users] (user_id)
)
