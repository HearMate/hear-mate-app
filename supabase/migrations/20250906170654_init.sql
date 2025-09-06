create table headphones (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    grade integer not null,
    hz_125_correction real not null,
    hz_250_correction real not null,
    hz_500_correction real not null,
    hz_1000_correction real not null,
    hz_2000_correction real not null,
    hz_4000_correction real not null,
    hz_8000_correction real not null,
    created_at timestamp default now()
);