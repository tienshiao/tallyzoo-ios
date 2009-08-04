create table items (
id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT, -- limited to a shorter number of characters
    default_note TEXT, -- limited to some short number of characters
    default_tags TEXT, -- delimited string
    initial_value REAL, -- starting value
    goal REAL,
    default_step REAL, -- how much to increment by (1.0, 60, etc)
    color TEXT, -- TODO exact format and storage is undetermined
    count_updown INTEGER,  -- -1 or +1
    display_total INTEGER,  -- display number badge on button
    screen INTEGER,  -- which screen, -1 for never been assigned
    position INTEGER,  -- position in matrix (0-8),
    deleted INTEGER, -- 1 = deleted
    created_on TEXT,  -- datetime stored in localtime
    created_tz TEXT,
    modified_on TEXT, -- datetime stored in localtime
    modified_tz TEXT
);

create table counts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id INTEGER,
    note TEXT,
    tags TEXT,
    amount REAL,
    latitude REAL,
    longitude REAL,
    created_on TEXT, -- datetime stored in localtime
    created_tz TEXT,
    modified_on TEXT, -- datetime stored in localtime
    modified_tz TEXT
);

