CREATE TABLE [dbo].[user_gave_kudos]
(
	[user_id] BIGINT NOT NULL , 
    [kudos_answer_id] BIGINT NOT NULL, 
    [kudos_question_id] BIGINT NOT NULL,
    PRIMARY KEY ([user_id]),
    FOREIGN KEY (user_id) REFERENCES [dbo].[users] (user_id)
)
