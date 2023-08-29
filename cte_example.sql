/*Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.

Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

Notes:

Calculate the following percentages:
time spent sending / (Time spent sending + Time spent opening)
Time spent opening / (Time spent sending + Time spent opening)
To avoid integer division in percentages, multiply by 100.0 and not 100.

Strategy: create a cte for sending time and opening time, use these values for the main statement calculations.
*/





WITH sending as 
(SELECT user_id, activity_type, sum(time_spent) as time_sending
 FROM activities
 WHERE activity_type = 'send'
 GROUP BY user_id, activity_type),
 
 opening as 
(SELECT user_id, activity_type, sum(time_spent) as time_opening
 FROM activities
 WHERE activity_type = 'open'
 GROUP BY user_id, activity_type)
 
SELECT bd.age_bucket, 
     ROUND(sending.time_sending/(sending.time_sending+opening.time_opening)*100,2) as send_perc, 
     ROUND(opening.time_opening/(sending.time_sending+opening.time_opening)*100,2) as open_perc
FROM age_breakdown as bd JOIN sending 
    ON bd.user_id = sending.user_id
    JOIN opening 
    ON bd.user_id = opening.user_id
GROUP BY bd.age_bucket, sending.time_sending, opening.time_opening
