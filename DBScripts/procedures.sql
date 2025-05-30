CREATE OR REPLACE PROCEDURE creer_embarcation_permis(
    p_permis VARCHAR,
    p_description VARCHAR,
    p_marque VARCHAR(255),
    p_longueur INT,
    p_photo VARCHAR(255),
    in_display_name VARCHAR,
    in_sub VARCHAR
)
AS $$
BEGIN
    -- Insert a new entry into Embarcation
    INSERT INTO Embarcation(id_embarcation, description, marque, longueur, photo)
    VALUES (p_permis, p_description, p_marque, p_longueur, p_photo);

    INSERT INTO EmbarcationUtilisateur (id_embarcation, nom, sub, id_embarcation_utilisateur)
    VALUES (p_permis, in_display_name, in_sub, creer_pne_id('serial_embarcation_utilisateur'));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE creer_embarcation(
    p_description VARCHAR,
    p_marque VARCHAR(255),
    p_longueur INT,
    in_nom VARCHAR,
    in_sub VARCHAR,
    p_photo VARCHAR
)
AS $$
DECLARE
    v_id_embarcation VARCHAR;
BEGIN
    -- Insert a new entry into Embarcation
    INSERT INTO Embarcation(id_embarcation, description, marque, longueur, photo)
    VALUES (creer_pne_id('serial_embarcation') , p_description, p_marque, p_longueur, p_photo)
    RETURNING id_embarcation INTO v_id_embarcation;

    -- Add the Embarcation to EmbarcationUtilisateur
    CALL ajouter_embarcation_utilisateur(in_sub, v_id_embarcation, in_nom);
END;
$$ LANGUAGE plpgsql;

-- CREATE OR REPLACE PROCEDURE creer_embarcation_permis(
--     p_permis VARCHAR,
--     p_description VARCHAR,
--     p_marque VARCHAR(255),
--     p_longueur INT,
--     in_nom VARCHAR,
--     in_sub VARCHAR,
--     p_photo VARCHAR
-- )
-- AS $$
-- BEGIN
--     -- Insert a new entry into Embarcation
--     INSERT INTO Embarcation(id_embarcation, description, marque, longueur, photo)
--     VALUES (p_permis, p_description, p_marque, p_longueur, p_photo);
--
--     INSERT INTO EmbarcationUtilisateur (id_embarcation, nom, sub, id_embarcation_utilisateur)
--     VALUES (p_permis, in_nom, in_sub, creer_pne_id('serial_embarcation_utilisateur'));
-- END;
-- $$ LANGUAGE plpgsql;


-- CREATE OR REPLACE PROCEDURE creer_embarcation(
--     p_description VARCHAR,
--     p_marque VARCHAR(255),
--     p_longueur INT,
--     p_photo VARCHAR(255),
--     in_nom VARCHAR,
--     in_sub VARCHAR
-- )
-- AS $$
-- DECLARE
--     v_id_embarcation VARCHAR;
-- BEGIN
--     -- Insert a new entry into Embarcation
--     INSERT INTO Embarcation(id_embarcation, description, marque, longueur, photo)
--     VALUES (creer_pne_id('serial_embarcation') , p_description, p_marque, p_longueur, p_photo)
--     RETURNING id_embarcation INTO v_id_embarcation;
--
--     -- Add the Embarcation to EmbarcationUtilisateur
--     CALL ajouter_embarcation_utilisateur(v_id_embarcation, in_nom, in_sub);
-- END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE ajouter_embarcation_utilisateur(
    IN in_sub VARCHAR,
    IN in_id_embarcation embarcation_id,
    IN in_nom VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert a new row into EmbarcationUtilisateur table
    INSERT INTO EmbarcationUtilisateur (id_embarcation, nom, sub, id_embarcation_utilisateur)
    VALUES (in_id_embarcation, in_nom, in_sub, creer_pne_id('serial_embarcation_utilisateur'));
END;
$$;


CREATE OR REPLACE PROCEDURE ajouter_lavage(
    in_id_embarcation VARCHAR,
    in_type_lavage VARCHAR,
    in_self_serve BOOLEAN
) AS $$
BEGIN
    -- Insert a new record into Lavage
    INSERT INTO Lavage (id_embarcation, type_lavage, date, self_serve, id_lavage)
    VALUES (in_id_embarcation, in_type_lavage::type_lavage, NOW() - INTERVAL '4 hours', in_self_serve,  creer_pne_id('serial_lavage'));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE creer_plan_eau(
    in_niveau_couleur VARCHAR,
    in_emplacement GEOMETRY(Point, 4326), -- Assuming WGS 84 coordinate system
    in_nom VARCHAR
) AS $$
BEGIN
    -- Insert a new record into PlanEau
    INSERT INTO PlanEau (niveau_couleur, emplacement, id_plan_eau, nom)
    VALUES (in_niveau_couleur::niveau, in_emplacement, creer_pne_id('serial_plan_eau'), in_nom);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE creer_note(
    in_id_embarcation_utilisateur VARCHAR,
    in_id_plan_eau VARCHAR,
    in_note VARCHAR
) AS $$
BEGIN
    -- Insert a new record into NoteDossier
    INSERT INTO NoteDossier (id_embarcation_utilisateur, id_plan_eau, date, note, idNote)
    VALUES (in_id_embarcation_utilisateur, in_id_plan_eau, NOW() - INTERVAL '4 hours', in_note, creer_pne_id('serial_note'));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE ajouter_code_unique(
    in_id_plan_eau VARCHAR,
    in_code_unique_list VARCHAR[]
) AS $$
DECLARE
    code_val VARCHAR;
BEGIN
    -- Iterate through the code_unique_list and insert each code into the table
    FOREACH code_val IN ARRAY in_code_unique_list
    LOOP
        -- Insert a new record into CodeUnique
        INSERT INTO CodeUnique (code_unique, id_plan_eau)
        VALUES (code_val, in_id_plan_eau);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE creer_certification(
    in_code_certification VARCHAR,
    in_nom_formation VARCHAR
) AS $$
BEGIN
    -- Insert a new record into Certification
    INSERT INTO Certification (code_certification, nom_formation)
    VALUES (in_code_certification, in_nom_formation);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE ajouter_certification_utilisateur(
    in_code_certification VARCHAR,
    in_sub VARCHAR
) AS $$
BEGIN
    -- Insert a new record into EmployeCertification
    INSERT INTO EmployeCertification (code_certification, sub)
    VALUES (in_code_certification, in_sub);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE creer_role(
    in_nom_role VARCHAR,
    in_description VARCHAR
) AS $$
BEGIN
    -- Insert a new record into Role
    INSERT INTO Role (nom_role, description)
    VALUES (in_nom_role, in_description);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE ajouter_role_utilisateur(
    in_nom_role VARCHAR,
    in_sub VARCHAR
) AS $$
BEGIN
    -- Insert a new record into UtilisateurRole
    INSERT INTO UtilisateurRole (nom_role, sub)
    VALUES (in_nom_role, in_sub);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE mise_eau(
    in_id_plan_eau VARCHAR, -- Assuming pne_id is a VARCHAR type
    in_id_embarcation_utilisateur VARCHAR -- Assuming pne_id is a VARCHAR type
) AS $$
BEGIN
    -- Insert a new record into MiseAEau
    INSERT INTO MiseAEau(id_mise_eau, date, id_plan_eau, id_embarcation_utilisateur)
    VALUES (creer_pne_id('serial_mise_eau'), NOW() - INTERVAL '4 hours', in_id_plan_eau, in_id_embarcation_utilisateur);
END;
$$ LANGUAGE plpgsql;