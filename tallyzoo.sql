create table activities (
id INTEGER PRIMARY KEY AUTOINCREMENT,
    guid TEXT,
    name TEXT, -- limited to a shorter number of characters
    default_note TEXT, -- limited to some short number of characters
    default_tags TEXT, -- delimited string
    initial_value REAL, -- starting value
    init_sig INTEGER, -- significant digits for initial_value
--    goal REAL,
    default_step REAL, -- how much to increment by (1.0, 60, etc)
    step_sig INTEGER, -- significant digits for default_step
    color TEXT, -- TODO exact format and storage is undetermined
    count_updown INTEGER,  -- -1 or +1
    display_total INTEGER,  -- display number badge on button
    screen INTEGER,  -- which screen, -1 for never been assigned
    position INTEGER,  -- position in matrix (0-8),
    graph_type INTEGER, -- graph type on iPhone
    deleted INTEGER, -- 1 = deleted
    created_on TEXT,  -- datetime stored in localtime
    created_on_UTC TEXT,
    modified_on TEXT, -- datetime stored in localtime
    modified_on_UTC TEXT
);

create table counts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    guid TEXT,
    activity_id INTEGER,
    note TEXT,
    tags TEXT,
    amount REAL,
    amount_sig INTEGER, -- significant digits for amount
    latitude REAL,
    longitude REAL,
    deleted INTEGER,
    local INTEGER,
    created_on TEXT, -- datetime stored in localtime
    created_on_UTC TEXT,
    modified_on TEXT, -- datetime stored in localtime
    modified_on_UTC TEXT
);

create table groups_activities (
    group_id INTEGER,
    activity_id INTEGER,
    CONSTRAINT group_activity UNIQUE(group_id, activity_id)
);

create table groups (
    id INTEGER PRIMARY KEY,
    name TEXT
);

INSERT INTO groups (id, name) VALUES (0, 'Public');
