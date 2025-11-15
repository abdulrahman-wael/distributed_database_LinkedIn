-- vertical fragmentation
SELECT ID, First_name, Last_name, Birthdate, City, Country_Region, Industry INTO user_personal_fragment FROM [user];

SELECT ID, Industry, open_to, Website, Profile_URL INTO user_professional_fragment FROM [user];

-- horizontal fragmentation
SELECT * INTO industry_tech_users FROM [user] WHERE Industry = 'Technology';

SELECT * INTO industry_finance_users FROM [user] WHERE Industry = 'Finance';

SELECT * INTO industry_healthcare_users FROM [user] WHERE Industry = 'Healthcare';

-- hybrid fragmentation
SELECT ID, First_name, Last_name, Website, Instant_messaging, Profile_URL INTO active_networkers_fragment FROM [user] WHERE Website IS NOT NULL AND Instant_messaging IS NOT NULL;

SELECT ID, First_name, Last_name, Industry, open_to INTO job_seekers_fragment FROM [user] WHERE open_to IS NOT NULL;

SELECT Event_ID, Title, start_datetime, end_datetime INTO local_events_fragment FROM [event] WHERE external_event_link IS NULL;

SELECT Event_ID, Title, external_event_link, timezone INTO virtual_events_fragment FROM [event] WHERE external_event_link IS NOT NULL;

SELECT Event_ID, Title, start_datetime, end_datetime INTO event_venues_fragment FROM [event] WHERE external_event_link IS NULL;

SELECT Event_ID, Title, external_event_link, timezone INTO online_events_fragment FROM [event] WHERE external_event_link IS NOT NULL;

SELECT postID, publisher, scheduled_time, targeted_audience INTO scheduled_posts_fragment FROM post WHERE scheduled_time IS NOT NULL;

SELECT postID, publisher, targeted_audience, comments_control INTO audience_targeted_posts_fragment FROM post WHERE targeted_audience IS NOT NULL;

SELECT reactionID, postID, publisher, content INTO post_engagements_fragment FROM reaction WHERE postID IN (SELECT postID FROM post WHERE scheduled_time IS NOT NULL);

SELECT commentID, postID, publisher, text, media INTO comment_engagements_fragment FROM comments WHERE media IS NOT NULL;