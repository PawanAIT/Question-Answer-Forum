CREATE PROCEDURE [dbo].[sp_InsertUserDetails]      
(      
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100),
    @bio NVARCHAR(256),
    @profile_picture NVARCHAR (500)  
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            INSERT INTO [dbo].[users] (first_name, last_name, email, bio, profile_picture)
            VALUES(@first_name,@last_name, @email, @bio, @profile_picture);
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END