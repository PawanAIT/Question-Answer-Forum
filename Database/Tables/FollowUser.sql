CREATE TABLE [dbo].[follow_user]
(
    followed_user_id BIGINT,
    follower_user_id BIGINT,
    PRIMARY KEY (followed_user_id, follower_user_id),
    FOREIGN KEY (followed_user_id) REFERENCES [dbo].[users] (user_id),
    FOREIGN KEY (follower_user_id) REFERENCES [dbo].[users] (user_id)
);