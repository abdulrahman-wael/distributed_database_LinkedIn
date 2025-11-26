-- Active: 1764013895985@@127.0.0.1@1435@master
-- Create Subscriber Database (Idempotent)
USE master;
GO

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'model_subscriber')
BEGIN
    CREATE DATABASE model_subscriber;
    PRINT '✓ Subscriber database created.';
END
ELSE
BEGIN
    PRINT '⚠ Subscriber database already exists. Skipping.';
END
GO

-- Set database sizes (always safe to re-run)
USE model_subscriber;
GO
ALTER DATABASE model_subscriber MODIFY FILE (NAME='model_subscriber', SIZE=100MB);
ALTER DATABASE model_subscriber MODIFY FILE (NAME='model_subscriber_log', SIZE=50MB);
GO

PRINT 'Subscriber database configured.';