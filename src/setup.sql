CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
    ('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
    ('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
    ('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

    -- Service project categories
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);
 
INSERT INTO category (name)
VALUES
    ('Environmental'),
    ('Educational'),
    ('Community Service'),
    ('Health and Wellness');
 
-- Junction table associating projects with categories (many-to-many)
CREATE TABLE project_category (
    project_id INTEGER NOT NULL REFERENCES project(project_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES category(category_id) ON DELETE CASCADE,
    PRIMARY KEY (project_id, category_id)
);
 
INSERT INTO project_category (project_id, category_id)
VALUES
    ((SELECT project_id FROM project WHERE title = 'Park Cleanup'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT project_id FROM project WHERE title = 'Food Drive'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT project_id FROM project WHERE title = 'Food Drive'), (SELECT category_id FROM category WHERE name = 'Health and Wellness')),
    ((SELECT project_id FROM project WHERE title = 'Community Tutoring'), (SELECT category_id FROM category WHERE name = 'Educational'));