-- Active: 1764013861714@@127.0.0.1@1434@master
-- On DISTRIBUTOR (ms1-dist)
-- Configure Distributor (Idempotent)
USE master;
GO

-- Drop existing distributor configuration completely
IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'ms1-dist' AND is_distributor = 1)
BEGIN
    EXEC sp_dropdistributor @no_checks = 1, @ignore_distributor = 1;
    PRINT '✓ Dropped existing distributor configuration.';
END
ELSE
BEGIN
    PRINT '✓ No distributor found. Proceeding with clean setup.';
END
GO

-- Create distributor metadata
EXEC sp_adddistributor 
    @distributor = N'ms1-dist',
    @password = N'I''m2tired';
GO

-- Create distribution database (if not exists)
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'distribution')
BEGIN
    EXEC sp_adddistributiondb 
        @database = N'distribution',
        @data_folder = N'/var/opt/mssql/data',
        @log_folder = N'/var/opt/mssql/data',
        @log_file_size = 10,
        @min_distretention = 0,
        @max_distretention = 72,
        @history_retention = 48,
        @security_mode = 0,
        @login = N'sa',
        @password = N'I''m2tired';
    PRINT '✓ Distribution database created.';
END
ELSE
BEGIN
    PRINT '⚠ Distribution database already exists. Skipping creation.';
END
GO

-- Register Publisher (idempotent - can be re-run)
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.MSdistpublishers WHERE name = 'ms1-pub')
BEGIN
    EXEC sp_adddistpublisher 
        @publisher = N'ms1-pub',
        @distribution_db = N'distribution',
        @working_directory = N'/var/opt/mssql/ReplData',
        @security_mode = 0,
        @login = N'sa',
        @password = N'I''m2tired';
    PRINT '✓ Publisher registered.';
END
ELSE
BEGIN
    PRINT '⚠ Publisher already registered. Skipping.';
END
GO

PRINT 'Distributor configuration complete.';