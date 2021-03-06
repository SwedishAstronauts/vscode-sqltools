CREATE KEYSPACE personal_data
  WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE personal_data.contacts (
  first_name text,
  last_name text,
  city_id uuid,
  age int,
  emails set<text>,
  PRIMARY KEY ((first_name, last_name), city_id));

BEGIN BATCH
  INSERT INTO personal_data.contacts (first_name, last_name, city_id, emails)
    VALUES ('John', 'Lennon', 87ec1bfc-58d6-484e-a4a2-20747b96d86f, {'lennon.john@example.com'});

  INSERT INTO personal_data.contacts (first_name, last_name, city_id, age)
    VALUES ('Paul', 'McCartney', 637b67f3-d176-4dab-a9dc-5db8b4e2510a, 77);
APPLY BATCH;

CREATE OR REPLACE FUNCTION personal_data.avgState ( state tuple<int,bigint>, val int )
  CALLED ON NULL INPUT RETURNS tuple<int,bigint> LANGUAGE java
  AS 'if (val !=null) { state.setInt(0, state.getInt(0)+1);
  state.setLong(1, state.getLong(1)+val.intValue()); }
  return state;';
