CREATE TABLE [dbo].[follow_question]
(
    followed_question_id BIGINT,
    follower_user_id BIGINT,
    PRIMARY KEY (followed_question_id, follower_user_id),
    FOREIGN KEY (followed_question_id) REFERENCES [dbo].[questions] (question_id),
    FOREIGN KEY (follower_user_id) REFERENCES [dbo].[users] (user_id)
);