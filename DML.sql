INSERT INTO [user] (First_name, Last_name, Additional_name, name_pronunciation, Industry, Country_Region, City, Profile_URL, Email, Phone_number, Birthdate, Website, Instant_messaging, open_to)
VALUES 
('John', 'Doe', 'Michael', 'jon-doh', 'Technology', 'USA', 'New York', 'linkedin.com/johndoe', 'john.doe@email.com', '+1234567890', '1990-05-15', 'johndoe.com', 'johndoe123', 'Job opportunities'),
('Jane', 'Smith', NULL, 'jayn-smith', 'Marketing', 'UK', 'London', 'linkedin.com/janesmith', 'jane.smith@email.com', '+4412345678', '1985-08-22', 'janesmith.com', 'janesmith456', 'Consulting'),
('Ahmed', 'Ali', 'Hassan', 'ah-med-ah-lee', 'Finance', 'Egypt', 'Cairo', 'linkedin.com/ahmedali', 'ahmed.ali@email.com', '+201234567890', '1992-03-10', NULL, 'ahmed_ali', 'Networking');

INSERT INTO user_education (Education, ID)
VALUES 
('MIT - Computer Science', 1),
('Harvard - MBA', 2),
('Cairo University - Business Administration', 3);

INSERT INTO user_primary_position (Primary_position, ID)
VALUES 
('Software Engineer at Google', 1),
('Marketing Director at Meta', 2),
('Financial Analyst at Bank of Egypt', 3);

INSERT INTO user_skills (Skill, ID)
VALUES 
('Python', 1),
('JavaScript', 1),
('Digital Marketing', 2),
('SEO', 2),
('Financial Analysis', 3),
('Risk Management', 3);

INSERT INTO [event] (Picture_URL, end_datetime, start_datetime, external_event_link, timezone, Title, About, [Type], creatorID)
VALUES 
('event1.jpg', '2025-11-01 18:00:00', '2025-11-01 14:00:00', 'techconf2025.com', 'EST', 'Tech Conference 2025', 'Annual technology conference covering AI and Cloud', 'Conference', 1),
('event2.jpg', '2025-12-15 20:00:00', '2025-12-15 19:00:00', 'marketingwebinar.com', 'GMT', 'Marketing Trends Webinar', 'Online webinar about digital marketing trends', 'Webinar', 2),
('event3.jpg', '2025-10-30 17:00:00', '2025-10-30 15:00:00', 'financesummit.com', 'EET', 'Finance Summit Cairo', 'Regional finance and investment summit', 'Summit', 3);

INSERT INTO attends (ID, Event_ID)
VALUES 
(1, 1),
(2, 1),
(2, 2),
(3, 3),
(1, 3);

INSERT INTO speaks_on (ID, Event_ID)
VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO post (publisher, media, scheduled_time, targeted_audience, comments_control)
VALUES 
('John Doe', 'image1.jpg', '2025-10-26 10:00:00', 'Tech professionals', 'Everyone'),
('Jane Smith', 'video1.mp4', '2025-10-27 14:00:00', 'Marketing professionals', 'Connections only'),
('Ahmed Ali', NULL, '2025-10-28 09:00:00', 'Finance sector', 'Everyone');

INSERT INTO comments (commentID, postID, Event_ID, publisher, [text], media, media_type)
VALUES 
(1, 1, 1, 'Jane Smith', 'Great post! Looking forward to the conference', NULL, NULL),
(2, 1, 1, 'Ahmed Ali', 'Very informative', NULL, NULL),
(3, 2, 2, 'John Doe', 'Excellent insights on marketing trends', NULL, NULL);

INSERT INTO reaction (reactionID, postID, Event_ID, publisher, content)
VALUES 
(1, 1, 1, 'Jane Smith', 'Like'),
(2, 1, 1, 'Ahmed Ali', 'Love'),
(3, 2, 2, 'John Doe', 'Insightful'),
(4, 3, 3, 'Jane Smith', 'Like');


UPDATE [user]
SET Email = 'john.doe.new@email.com', City = 'San Francisco'
WHERE ID = 1;

UPDATE [event]
SET Title = 'Global Tech Conference 2025'
WHERE Event_ID = 1;

UPDATE post
SET scheduled_time = '2025-10-26 12:00:00'
WHERE postID = 1;

DELETE FROM reaction
WHERE reactionID = 4 AND postID = 3 AND Event_ID = 3;

DELETE FROM attends
WHERE ID = 1 AND Event_ID = 3;

DELETE FROM user_skills
WHERE ID = 2 AND Skill = 'SEO';