/****** Object:  StoredProcedure [dbo].[ReorderFrameworkCompetency]    Script Date: 15/10/2021 08:31:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Kevin Whittaker
-- Create date: 15/10/2021
-- Description:	Reorders the CompetencyAssessmentQuestions - moving the given competency question up or down.
-- =============================================
CREATE OR ALTER   PROCEDURE [dbo].[ReorderCompetencyAssessmentQuestion]
	-- Add the parameters for the stored procedure here
	@CompetencyID int,
	@AssessmentQuestionID int,
	@Direction nvarchar(4) = '',
	@SingleStep bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @CurrentPos INT
	Declare @MaxPos INT
	SELECT @CurrentPos = Ordering FROM CompetencyAssessmentQuestions WHERE CompetencyID = @CompetencyID AND AssessmentQuestionID = @AssessmentQuestionID
	SELECT @MaxPos = MAX(Ordering) FROM CompetencyAssessmentQuestions WHERE CompetencyID = @CompetencyID
	IF @Direction = 'UP' AND @CurrentPos > 1 AND @SingleStep = 1
BEGIN
UPDATE CompetencyAssessmentQuestions SET Ordering = @CurrentPos WHERE (CompetencyID = @CompetencyID) AND (Ordering = @CurrentPos -1)
UPDATE CompetencyAssessmentQuestions SET Ordering = @CurrentPos - 1 WHERE CompetencyID = @CompetencyID AND (AssessmentQuestionID = @AssessmentQuestionID)
END

IF @Direction = 'DOWN' AND @CurrentPos < @MaxPos AND @SingleStep = 1
BEGIN
UPDATE CompetencyAssessmentQuestions SET Ordering = @CurrentPos WHERE (CompetencyID = @CompetencyID) AND (Ordering = @CurrentPos +1)
UPDATE CompetencyAssessmentQuestions SET Ordering = @CurrentPos + 1 WHERE CompetencyID = @CompetencyID AND (AssessmentQuestionID = @AssessmentQuestionID)
END

IF @Direction = 'UP' AND @CurrentPos > 1 AND @SingleStep = 0
BEGIN
UPDATE CompetencyAssessmentQuestions SET Ordering = Ordering + 1 WHERE (CompetencyID = @CompetencyID) AND (Ordering < @CurrentPos)
UPDATE CompetencyAssessmentQuestions SET Ordering = 1 WHERE CompetencyID = @CompetencyID AND (AssessmentQuestionID = @AssessmentQuestionID)
END

IF @Direction = 'DOWN' AND @CurrentPos < @MaxPos AND @SingleStep = 0
BEGIN
UPDATE CompetencyAssessmentQuestions SET Ordering = Ordering - 1 WHERE (CompetencyID = @CompetencyID) AND (Ordering > @CurrentPos)
UPDATE CompetencyAssessmentQuestions SET Ordering = @MaxPos WHERE CompetencyID = @CompetencyID AND (AssessmentQuestionID = @AssessmentQuestionID)
END
END
