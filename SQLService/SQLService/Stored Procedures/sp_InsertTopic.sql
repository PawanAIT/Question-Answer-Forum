CREATE PROCEDURE [dbo].[sp_Insert_Topic]      
(      
    @topic_name NVARCHAR (50)
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            INSERT INTO [dbo].[topics] (topic_name) values ( @topic_name);
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END