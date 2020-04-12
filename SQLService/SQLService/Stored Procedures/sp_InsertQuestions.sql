CREATE PROCEDURE [dbo].[sp_InsertQuestions]      
(      
    @question_title NVARCHAR (1000),
    @question_details NVARCHAR (4000),
    @question_poster_id BIGINT,
    @question_topic_id BIGINT  
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            INSERT INTO [dbo].[questions] ([question_title] ,[question_details], [question_poster_id], [question_topic_id])
            VALUES(@question_title,@question_details, @question_poster_id,@question_topic_id);
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END