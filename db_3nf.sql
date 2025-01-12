-- Таблица граждан
CREATE TABLE Citizen (
    citizen_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    passport_number VARCHAR(50) UNIQUE NOT NULL
);

-- Таблица водительских прав
CREATE TABLE DriverLicense (
    license_id SERIAL PRIMARY KEY,
    citizen_id INT NOT NULL UNIQUE REFERENCES Citizen(citizen_id) ON DELETE CASCADE,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    category VARCHAR(10) NOT NULL,
    issued_date DATE NOT NULL,
    expiry_date DATE NOT NULL
);

-- Таблица этапов процесса получения прав
CREATE TABLE ProcessStep (
    step_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    estimated_duration INTERVAL
);

-- Таблица зависимостей этапов (порядок выполнения)
CREATE TABLE StepDependency (
    step_id INT NOT NULL REFERENCES ProcessStep(step_id) ON DELETE CASCADE,
    depends_on_step_id INT NOT NULL REFERENCES ProcessStep(step_id) ON DELETE CASCADE,
    PRIMARY KEY (step_id, depends_on_step_id)
);

-- Таблица прогресса выполнения этапов
CREATE TABLE Progress (
    progress_id SERIAL PRIMARY KEY,
    citizen_id INT NOT NULL REFERENCES Citizen(citizen_id) ON DELETE CASCADE,
    step_id INT NOT NULL REFERENCES ProcessStep(step_id) ON DELETE CASCADE,
    status VARCHAR(50) NOT NULL CHECK (status IN ('not started', 'in progress', 'completed')),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
