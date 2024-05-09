DROP SCHEMA IF EXISTS simplon_mcq;
CREATE SCHEMA simplon_mcq;
USE simplon_mcq;

-- Table Users
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_login VARCHAR(255) NOT NULL,
    user_pass VARCHAR(255) NOT NULL,
    role ENUM('admin', 'trainer', 'candidat') NOT NULL
);

-- Table Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(30) NOT NULL UNIQUE
);

-- Table Formations
CREATE TABLE Formations (
    formation_id INT PRIMARY KEY AUTO_INCREMENT,
    formation_name VARCHAR(30) NOT NULL UNIQUE
);

-- Table Questions
CREATE TABLE Questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    weight INT DEFAULT 1,
    content TEXT NOT NULL,
    hidden BOOLEAN DEFAULT FALSE,
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE NO ACTION
);

-- Table Answers
CREATE TABLE Answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT,
    content TEXT,
    is_correct BOOLEAN,
    FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE NO ACTION
);

-- Table MediasDiagrams
CREATE TABLE MediasDiagrams (
    media_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT,
    media_content TEXT NOT NULL,
    FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE NO ACTION
);

-- Table Sessions
CREATE TABLE Sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    session_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    formation_id INT,
    FOREIGN KEY (formation_id) REFERENCES Formations(formation_id) ON DELETE NO ACTION
);

-- Table SessionUser
CREATE TABLE SessionUser (
    session_user_id INT PRIMARY KEY AUTO_INCREMENT,
    session_id INT,
    user_id INT,
    FOREIGN KEY (session_id) REFERENCES Sessions(session_id) ON DELETE NO ACTION,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE NO ACTION
);

-- Table Results
CREATE TABLE Results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    session_id INT,
    question_id INT,
    answer_id INT,
    user_id INT,
    time_spent INT,
    FOREIGN KEY (session_id) REFERENCES Sessions(session_id) ON DELETE NO ACTION,
    FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE NO ACTION,
    FOREIGN KEY (answer_id) REFERENCES Answers(answer_id) ON DELETE NO ACTION,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE NO ACTION
);


-- Table QuestionCategory
CREATE TABLE QuestionCategory (
    question_category_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT,
    category_id INT,
    FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE NO ACTION,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE NO ACTION
);

-- Table QuestionFormation
CREATE TABLE QuestionFormation (
    question_formation_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT,
    formation_id INT,
    FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE NO ACTION,
    FOREIGN KEY (formation_id) REFERENCES Formations(formation_id) ON DELETE NO ACTION
);
