CREATE PROCEDURE [dbo].[sp_Unfollow_User]      
(   
	@unfollower_user_id BIGINT,
    @unfollowed_user_id BIGINT
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            DELETE FROM [dbo].[follow_user] where follower_user_id = @unfollower_user_id and followed_user_id = @unfollowed_user_id;
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END