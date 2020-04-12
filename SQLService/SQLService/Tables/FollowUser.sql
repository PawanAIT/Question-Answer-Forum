CREATE TABLE [dbo].[follow_user]
(
    follower_user_id BIGINT,
    followed_user_id BIGINT,
    PRIMARY KEY (follower_user_id, followed_user_id),
    FOREIGN KEY (followed_user_id) REFERENCES [dbo].[users] (user_id),
    FOREIGN KEY (follower_user_id) REFERENCES [dbo].[users] (user_id)
);