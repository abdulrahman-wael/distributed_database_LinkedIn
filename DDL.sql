-- Active: 1761334024323@@127.0.0.1@1433@model
-- how to work with mssql using one command: 

-- sudo docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=I'm2tired" \
--    -e "MSSQL_PID=Developer" \
--    -p 1433:1433 --name ms1 --hostname ms1 \
--    -v sqlvolume:/var/opt/mssql \
--    -d \
--    mcr.microsoft.com/mssql/server:2022-latest

USE model;

CREATE TABLE [user] (
    ID INT PRIMARY KEY IDENTITY(1,1),
    First_name NVARCHAR(100),
    Last_name NVARCHAR(100),
    Additional_name NVARCHAR(100),
    name_pronunciation NVARCHAR(200),
    Industry NVARCHAR(100),
    Country_Region NVARCHAR(100),
    City NVARCHAR(100),
    Profile_URL NVARCHAR(500),
    Email NVARCHAR(255),
    Phone_number NVARCHAR(50),
    Birthdate DATE,
    Website NVARCHAR(500),
    Instant_messaging NVARCHAR(100),
    open_to NVARCHAR(MAX)
);


CREATE TABLE user_education (
    Education NVARCHAR(200),
    ID INT,
    PRIMARY KEY (Education, ID),
    FOREIGN KEY (ID) REFERENCES [user](ID)
);

CREATE TABLE user_primary_position (
    Primary_position NVARCHAR(200),
    ID INT,
    PRIMARY KEY (Primary_position, ID),
    FOREIGN KEY (ID) REFERENCES [user](ID)
);

CREATE TABLE user_skills (
    Skill NVARCHAR(50),
    ID INT,
    PRIMARY KEY (Skill, ID),
    FOREIGN KEY (ID) REFERENCES [user](ID)
);

CREATE TABLE [event] (
    Event_ID INT PRIMARY KEY IDENTITY(1,1),
    Picture_URL NVARCHAR(100),
    end_datetime DATETIME2,
    start_datetime DATETIME2,
    external_event_link NVARCHAR(100),
    timezone NVARCHAR(100),
    Title NVARCHAR(255),
    About NVARCHAR(MAX),
    [Type] NVARCHAR(100),
    creatorID INT,
    FOREIGN KEY (creatorID) REFERENCES [user](ID)
);

CREATE TABLE attends (
    ID INT,
    Event_ID INT,
    PRIMARY KEY (ID, Event_ID),
    FOREIGN KEY (ID) REFERENCES [user](ID),
    FOREIGN KEY (Event_ID) REFERENCES [event](Event_ID)
);

CREATE TABLE speaks_on (
    ID INT,
    Event_ID INT,
    PRIMARY KEY (ID, Event_ID),
    FOREIGN KEY (ID) REFERENCES [user](ID),
    FOREIGN KEY (Event_ID) REFERENCES [event](Event_ID)
);

CREATE TABLE post (
    postID INT PRIMARY KEY IDENTITY(1,1),
    publisher NVARCHAR(255),
    media NVARCHAR(500),
    scheduled_time DATETIME2,
    targeted_audience NVARCHAR(255),
    comments_control NVARCHAR(100)
);

CREATE TABLE comments (
    commentID INT,
    postID INT,
    Event_ID INT,
    publisher NVARCHAR(255),
    [text] NVARCHAR(MAX),
    media NVARCHAR(500),
    media_type NVARCHAR(100),
    PRIMARY KEY (commentID, postID, Event_ID),
    FOREIGN KEY (postID) REFERENCES Post(postID),
    FOREIGN KEY (Event_ID) REFERENCES [event](Event_ID)
);

CREATE TABLE reaction (
    reactionID INT,
    postID INT,
    Event_ID INT,
    publisher NVARCHAR(255),
    content NVARCHAR(MAX),
    PRIMARY KEY (reactionID, postID, Event_ID),
    FOREIGN KEY (postID) REFERENCES Post(postID),
    FOREIGN KEY (Event_ID) REFERENCES [event](Event_ID)
);
