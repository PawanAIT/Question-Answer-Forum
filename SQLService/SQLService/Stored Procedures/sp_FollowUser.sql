CREATE PROCEDURE [dbo].[sp_FollowUser]      
(   
	@follower_user_id BIGINT,
    @followed_user_id BIGINT
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            INSERT INTO [dbo].[follow_user] (followed_user_id, follower_user_id) values (@followed_user_id,@follower_user_id);
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END