PRINT 'Verifying subscriber data...';
USE model_subscriber;
GO
SELECT 'user' AS table_name, COUNT(*) AS row_count FROM dbo.[user]
UNION ALL
SELECT 'user_education', COUNT(*) FROM dbo.user_education
UNION ALL
SELECT 'user_primary_position', COUNT(*) FROM dbo.user_primary_position
UNION ALL
SELECT 'user_skills', COUNT(*) FROM dbo.user_skills;
GO

PRINT 'Replication process complete.';