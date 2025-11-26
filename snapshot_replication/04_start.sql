-- Active: 1764013861714@@127.0.0.1@1434@master
-- Start Replication and Monitor Progress

-- 1. Start Snapshot Agent
USE msdb;
GO
DECLARE @job_name NVARCHAR(100);
SELECT @job_name = name FROM dbo.sysjobs WHERE name LIKE '%Model_Snapshot_Pub%' AND name NOT LIKE '%ms1-sub%';

IF @job_name IS NOT NULL
BEGIN
    EXEC dbo.sp_start_job @job_name = @job_name;
    PRINT '✓ Snapshot agent started: ' + @job_name;
END
ELSE
BEGIN
    PRINT '⚠ ERROR: Snapshot agent job not found!';
END
GO

-- 2. Monitor Snapshot Progress
PRINT 'Monitoring snapshot agent...';
USE distribution;
GO
DECLARE @snapshot_status INT;
DECLARE @attempts INT = 0;

WHILE @attempts < 30  -- Wait up to 5 minutes
BEGIN
    SELECT TOP 1 @snapshot_status = h.runstatus
    FROM MSsnapshot_history h
    INNER JOIN MSsnapshot_agents a ON h.agent_id = a.id
    WHERE a.publication = 'Model_Snapshot_Pub'
    ORDER BY h.time DESC;

    IF @snapshot_status = 2
    BEGIN
        PRINT '✓ Snapshot completed successfully!';
        BREAK;
    END
    ELSE IF @snapshot_status = 6
    BEGIN
        PRINT '✗ Snapshot FAILED. Last message:';
        SELECT TOP 1 h.comments FROM MSsnapshot_history h
        INNER JOIN MSsnapshot_agents a ON h.agent_id = a.id
        WHERE a.publication = 'Model_Snapshot_Pub'
        ORDER BY h.time DESC;
        BREAK;
    END
    
    WAITFOR DELAY '00:00:10';
    SET @attempts = @attempts + 1;
    PRINT 'Still processing... (attempt ' + CAST(@attempts AS NVARCHAR) + ')';
END

-- 3. Monitor Distribution Progress
PRINT 'Monitoring distribution agent...';
DECLARE @dist_status INT;
DECLARE @attempts INT;

SET @attempts = 0;

WHILE @attempts < 30
BEGIN
    SELECT TOP 1 @dist_status = h.runstatus
    FROM MSdistribution_history h
    INNER JOIN MSdistribution_agents a ON h.agent_id = a.id
    WHERE a.subscriber_db = 'model_subscriber'
    ORDER BY h.time DESC;

    IF @dist_status = 2
    BEGIN
        PRINT '✓ Distribution completed successfully!';
        BREAK;
    END
    ELSE IF @dist_status = 6
    BEGIN
        PRINT '✗ Distribution FAILED. Last message:';
        SELECT TOP 1 h.comments FROM MSdistribution_history h
        INNER JOIN MSdistribution_agents a ON h.agent_id = a.id
        WHERE a.subscriber_db = 'model_subscriber'
        ORDER BY h.time DESC;
        BREAK;
    END
    
    WAITFOR DELAY '00:00:10';
    SET @attempts = @attempts + 1;
END
PRINT 'Replication process complete.';

