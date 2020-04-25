﻿CREATE PROCEDURE [dbo].[sp_Follow_Topic]      
(      
    @followed_topic_id BIGINT,
	@follower_user_id BIGINT
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            INSERT INTO [dbo].[follow_topic] (follower_user_id, followed_topic_id) values (@follower_user_id,@followed_topic_id);
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END