-- Active: 1764013759001@@127.0.0.1@1433@model
-- Connect to ms1-pub:1433

-- NOT IDEMPOTENT.

USE model;
GO
EXEC sp_replicationdboption 
    @dbname = N'model',
    @optname = N'publish',
    @value = N'true';
GO

EXEC sp_addpublication 
    @publication = N'Model_Snapshot_Pub',
    @description = N'Snapshot publication from ms1-pub to ms1-sub via ms1-dist',
    @sync_method = N'native',
    @retention = 336,
    @allow_push = N'true',
    @allow_pull = N'false',
    @allow_anonymous = N'false',
    @repl_freq = N'snapshot',
    @status = N'active',
    @independent_agent = N'true',
    @immediate_sync = N'true',
    @replicate_ddl = 1;
GO

EXEC sp_addpublication_snapshot 
    @publication = N'Model_Snapshot_Pub',
    @frequency_type = 1,
    @publisher_security_mode = 0,  -- SQL auth (critical!)
    @publisher_login = N'sa',
    @publisher_password = N'I''m2tired',
    @job_login = NULL,  -- Not used for SQL auth
    @job_password = NULL;
GO

# not executed yet
EXEC sp_addarticle @publication = N'Model_Snapshot_Pub', @article = N'user', @source_owner = N'dbo', @source_object = N'user', @type = N'logbased', @pre_creation_cmd = N'drop', @schema_option = 0x00000000000000F5, @identityrangemanagementoption = N'manual', @destination_table = N'user', @destination_owner = N'dbo';
EXEC sp_addarticle @publication = N'Model_Snapshot_Pub', @article = N'user_education', @source_owner = N'dbo', @source_object = N'user_education', @type = N'logbased', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'user_education', @destination_owner = N'dbo';
EXEC sp_addarticle @publication = N'Model_Snapshot_Pub', @article = N'user_primary_position', @source_owner = N'dbo', @source_object = N'user_primary_position', @type = N'logbased', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual',@destination_table = N'user_primary_position', @destination_owner = N'dbo';
EXEC sp_addarticle @publication = N'Model_Snapshot_Pub', @article = N'user_skills', @source_owner = N'dbo', @source_object = N'user_skills', @type = N'logbased', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'user_skills', @destination_owner = N'dbo';
GO


EXEC sp_addsubscription 
    @publication = N'Model_Snapshot_Pub',
    @subscriber = N'ms1-sub',
    @destination_db = N'model_subscriber',
    @subscription_type = N'Push',  -- Push from distributor
    @sync_type = N'automatic';
GO

EXEC sp_addpushsubscription_agent 
    @publication = N'Model_Snapshot_Pub',
    @subscriber = N'ms1-sub',
    @subscriber_db = N'model_subscriber',
    @subscriber_security_mode = 0,
    @subscriber_login = N'sa',
    @subscriber_password = N'I''m2tired',
    @frequency_type = 64,  -- *** RUN AUTOMATICALLY after snapshot ***
    @active_start_date = 0,
    @active_end_date = 0;
GO

