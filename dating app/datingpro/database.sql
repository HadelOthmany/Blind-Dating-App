CREATE TABLE user (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `gender` VARCHAR(15),   
    `password` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,                   
    `email` VARCHAR(255) NOT NULL UNIQUE,           
    `phone_no` VARCHAR(15),                        
    `city` VARCHAR(100),
    `country` VARCHAR(100),                  
    `profile_heading` VARCHAR(255),               
    `looking_for_partner` TEXT,                  
    `height` VARCHAR(10),                          
    `weight` VARCHAR(10),                          
    `body_type` VARCHAR(50),                     
    `profession` VARCHAR(100),                    
    `living_situation` VARCHAR(255), 
     
    `willing_to_relocate` TINYINT(1) DEFAULT 0, 
    `relationship_looking_for` VARCHAR(100),       
    `nationality` VARCHAR(100),                     
    `education` VARCHAR(100),                       
    `languages_spoken` VARCHAR(255),                
    `religion` VARCHAR(100),                       
    `ethnicity` VARCHAR(100),                       
    `birthdate` DATE,                              
    `drinks` TINYINT(1) DEFAULT 0,                 
    `smokes` TINYINT(1) DEFAULT 0,                 
    `have_children` TINYINT(1) DEFAULT 0,
    `no_of_children` VARCHAR(10),
    `employment_status` VARCHAR(50),
    `income` VARCHAR(50)
   
);      
CREATE TABLE favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,         
    favorite_user_id INT NOT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (favorite_user_id) REFERENCES user(id),
    UNIQUE (user_id, favorite_user_id) 
);

CREATE TABLE likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,          
    like_user_id INT NOT NULL,  
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id),
     FOREIGN KEY (like_user_id) REFERENCES user(id),
    UNIQUE (user_id, like_user_id)
);
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,          
    receiver_id INT NOT NULL,         
    message TEXT NOT NULL,            
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES user(id),
    FOREIGN KEY (receiver_id) REFERENCES user(id)
);

CREATE TABLE blocked_users (
    id INT AUTO_INCREMENT PRIMARY KEY,    
    user_id INT NOT NULL, 
     email VARCHAR(255) NOT NULL,  
    report_reason TEXT, 
    block_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_id) REFERENCES user(id)  
);

CREATE TABLE reported_users (
  report_id INT AUTO_INCREMENT PRIMARY KEY,       
  reported_user_id INT NOT NULL,                   
  reporting_user_id INT NOT NULL,                  
  report_reason TEXT,                              
  report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reported_user_id) REFERENCES user(id) ON DELETE CASCADE, 
  FOREIGN KEY (reporting_user_id) REFERENCES user(id) ON DELETE CASCADE  
);
