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
    ('Health and Wellness'),
    ('Youth Development');

-- Service projects, each belonging to one partner organization
CREATE TABLE project (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL REFERENCES organization(organization_id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(150),
    date DATE NOT NULL
);

INSERT INTO project (organization_id, title, description, location, date)
VALUES
    -- BrightFuture Builders (5 projects)
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Park Cleanup', 'Join us to clean up local parks and make them beautiful!', 'Riverside Park', '2026-08-15'),
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Playground Build', 'Help construct a new playground for neighborhood kids.', 'Maple Street Park', '2026-10-10'),
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Road Repair Initiative', 'Assist with patching and repairing damaged residential roads.', 'Elmwood District', '2026-10-24'),
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Community Center Renovation', 'Volunteer to help paint and repair the local community center.', 'Downtown Community Center', '2026-11-07'),
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Sidewalk Accessibility Project', 'Build wheelchair ramps and repair uneven sidewalks.', 'Oak Avenue', '2026-11-21'),

    -- GreenHarvest Growers (5 projects)
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Food Drive', 'Help collect and distribute food to those in need.', 'Community Center', '2026-08-22'),
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Community Garden Planting', 'Plant vegetables and herbs in the shared neighborhood garden.', 'Sunnyside Community Garden', '2026-10-03'),
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Farmers Market Setup', 'Help set up and run a weekend farmers market for local growers.', 'Town Square', '2026-10-17'),
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Composting Workshop', 'Teach residents how to compost food waste at home.', 'GreenHarvest Education Center', '2026-10-31'),
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Seed Bank Drive', 'Collect and organize donated seeds for next season''s planting.', 'GreenHarvest Warehouse', '2026-11-14'),

    -- UnityServe Volunteers (5 projects)
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Community Tutoring', 'Volunteer to tutor students in various subjects.', 'Public Library', '2026-09-05'),
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Senior Center Visit', 'Spend time with residents at the local senior center.', 'Golden Years Senior Center', '2026-10-05'),
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Clothing Donation Drive', 'Sort and distribute donated clothing to families in need.', 'UnityServe Office', '2026-10-19'),
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Blood Donation Drive', 'Help organize and staff a community blood drive.', 'Memorial Hospital', '2026-11-02'),
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Neighborhood Cleanup', 'Pick up litter and beautify shared neighborhood spaces.', 'Willow Creek Neighborhood', '2026-11-16');

-- Junction table associating projects with categories (many-to-many)
CREATE TABLE project_category (
    project_id INTEGER NOT NULL REFERENCES project(project_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES category(category_id) ON DELETE CASCADE,
    PRIMARY KEY (project_id, category_id)
);

INSERT INTO project_category (project_id, category_id)
VALUES
    ((SELECT project_id FROM project WHERE title = 'Park Cleanup'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT project_id FROM project WHERE title = 'Playground Build'), (SELECT category_id FROM category WHERE name = 'Youth Development')),
    ((SELECT project_id FROM project WHERE title = 'Road Repair Initiative'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT project_id FROM project WHERE title = 'Community Center Renovation'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT project_id FROM project WHERE title = 'Sidewalk Accessibility Project'), (SELECT category_id FROM category WHERE name = 'Health and Wellness')),

    ((SELECT project_id FROM project WHERE title = 'Food Drive'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT project_id FROM project WHERE title = 'Food Drive'), (SELECT category_id FROM category WHERE name = 'Health and Wellness')),
    ((SELECT project_id FROM project WHERE title = 'Community Garden Planting'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT project_id FROM project WHERE title = 'Farmers Market Setup'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT project_id FROM project WHERE title = 'Composting Workshop'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT project_id FROM project WHERE title = 'Seed Bank Drive'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT project_id FROM project WHERE title = 'Seed Bank Drive'), (SELECT category_id FROM category WHERE name = 'Educational')),

    ((SELECT project_id FROM project WHERE title = 'Community Tutoring'), (SELECT category_id FROM category WHERE name = 'Educational')),
    ((SELECT project_id FROM project WHERE title = 'Senior Center Visit'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT project_id FROM project WHERE title = 'Clothing Donation Drive'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT project_id FROM project WHERE title = 'Blood Donation Drive'), (SELECT category_id FROM category WHERE name = 'Health and Wellness')),
    ((SELECT project_id FROM project WHERE title = 'Neighborhood Cleanup'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT project_id FROM project WHERE title = 'Neighborhood Cleanup'), (SELECT category_id FROM category WHERE name = 'Youth Development'));

-- Roles for role-based access control (RBAC)
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT
);

INSERT INTO roles (role_name, role_description) VALUES
    ('user', 'Standard user with basic access'),
    ('admin', 'Administrator with full system access');

-- User accounts, each assigned one role
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Junction table tracking which users volunteered for which projects (many-to-many)
CREATE TABLE project_volunteer (
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    project_id INTEGER NOT NULL REFERENCES project(project_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, project_id)
);