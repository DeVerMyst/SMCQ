USE simplon_mcq;

-- Insérer un utilisateur
INSERT INTO Users (user_login, user_pass, role) VALUES ('john_doe', 'password123', 'trainer');

-- Insérer une catégorie si elle n'existe pas déjà
INSERT INTO Categories (category_name)
SELECT 'Programming'
WHERE NOT EXISTS (
    SELECT 1 FROM Categories WHERE category_name = 'Programming'
);

INSERT INTO Categories (category_name)
SELECT 'Géographie'
WHERE NOT EXISTS (
    SELECT 1 FROM Categories WHERE category_name = 'Géographie'
);

-- Lire toutes les catégories
SELECT * FROM Categories;

-- Lire une catégorie
SELECT * FROM Categories WHERE category_name='Programming';

-- Insérer une formation si elle n'existe pas déjà
INSERT INTO Formations (formation_name)
SELECT 'Web Development'
WHERE NOT EXISTS (
    SELECT 1 FROM Formations WHERE formation_name = 'Web Development'
);

-- Créer une question
INSERT INTO Questions (user_id, content) VALUES (1, 'Quelle est la capitale de la France ?');

-- Récupérer l'ID de la catégorie 'Géographie'
SET @category_id = (SELECT category_id FROM Categories WHERE category_name = 'Géographie');

-- Insérer l'association dans la table QuestionCategory
INSERT INTO QuestionCategory (question_id, category_id) 
VALUES ((SELECT question_id FROM Questions WHERE content = 'Quelle est la capitale de la France ?'), @category_id);
-- ou tout simplement si on connait l'id de la question et l'id de la catégorie
-- INSERT INTO QuestionCategory (question_id, category_id) VALUES (1,1);

-- Créer un media/diagram
INSERT INTO MediasDiagrams (question_id, media_content) 
VALUES (1, 'https://example.com/image.jpg');

-- Récupérer l'ID de la question nouvellement insérée
SET @question_id = LAST_INSERT_ID();

-- Insérer les réponses associées à la question
INSERT INTO Answers (question_id, content, is_correct) 
VALUES 
(@question_id, 'Paris', 1),
(@question_id, 'Londres', 0),
(@question_id, 'Berlin', 0),
(@question_id, 'Madrid', 0);

-- lire les réponses d'une question
SELECT q.question_id, q.content AS question_content, a.answer_id, a.content AS answer_content, a.is_correct
FROM Questions q
LEFT JOIN Answers a ON q.question_id = a.question_id
WHERE q.question_id = 1;

-- connaitre l'id de la bonne réponse pour une question donnée
SELECT answer_id
FROM Answers
WHERE question_id = 1 -- Remplacez 1 par l'ID de la question donnée
  AND is_correct = 1;

-- récupérer toutes les questions liées à une catégorie
SELECT q.*
FROM Questions q
INNER JOIN QuestionCategory qc ON q.question_id = qc.question_id
INNER JOIN Categories c ON qc.category_id = c.category_id
WHERE c.category_name = 'Géographie';

-- avoir toutes les questions d’un user
SELECT *
FROM Questions
WHERE user_id = 1; -- Remplacez 1 par l'ID de l'utilisateur spécifique

-- une requete qui donne toutes les questions de tous les users en donnant leur 
-- nom, leur id, la bonne réponse, le texte de la bonne réponse, la question et le texte de la question
SELECT u.user_id, u.user_login,
       q.question_id, q.content AS question_text,
       a.answer_id, a.content AS answer_text
FROM Questions q
JOIN Users u ON q.user_id = u.user_id
LEFT JOIN Answers a ON q.question_id = a.question_id AND a.is_correct = 1;
