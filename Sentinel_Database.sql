----------------------------------------------
-- NOMES E RMS

-- NOME: Alissa Silva Cezero RM:553954
-- NOME: Melissa Barbosa de Souza RM: 552535
-- NOME: Nicolas Paiffer do Carmo RM: 554145  
----------------------------------------------

-------------------------------------------
-- CRIAÇÃO DAS TABELAS - PROJETO SENTINEL
-------------------------------------------

-- Tabela ADDRESS
CREATE TABLE T_GS_ADDRESS (
    id_address INTEGER PRIMARY KEY NOT NULL,
    street_address VARCHAR2(85) NOT NULL,
    number_address INTEGER NOT NULL,
    city_address VARCHAR2(80) NOT NULL,
    state_address VARCHAR2(30) NOT NULL,
    country_address VARCHAR2(35) NOT NULL,
    cep_address INTEGER
);

-- Tabela T_GS_CONTACT
CREATE TABLE T_GS_CONTACT (
    id_contact INTEGER PRIMARY KEY NOT NULL,
    email_contact VARCHAR2(100) NOT NULL,
    contact_number VARCHAR2(15) NOT NULL
);

-- Tabela T_GS_USER
CREATE TABLE T_GS_USER (
    id_user INTEGER PRIMARY KEY NOT NULL,
    email_user VARCHAR2(100) NOT NULL,
    password_user VARCHAR2(300) NOT NULL,
    role_user VARCHAR2(50) NOT NULL
);

-- Tabela T_GS_SHELTERS
CREATE TABLE T_GS_SHELTERS (
    id_shelters INTEGER PRIMARY KEY NOT NULL,
    name_shelters VARCHAR2(100) NOT NULL,
    total_capacity INTEGER NOT NULL,
    current_capacity INTEGER NOT NULL,
    available_resources VARCHAR2(150) NOT NULL,
    status_shelters VARCHAR2(50) NOT NULL,
    update_date_shelters DATE NOT NULL,
    id_address INTEGER,
    id_contact INTEGER,
    id_user INTEGER,
    
    -- Definição das Foreign Keys
    CONSTRAINT FK_SHELTERS_ADDRESS FOREIGN KEY (id_address) 
        REFERENCES ADDRESS (id_address),
        
    CONSTRAINT FK_SHELTERS_CONTACT FOREIGN KEY (id_contact) 
        REFERENCES T_GS_CONTACT (id_contact),
        
    CONSTRAINT FK_SHELTERS_USER FOREIGN KEY (id_user) 
        REFERENCES T_GS_USER (id_user)
);


------------
-- INSERTS  
------------

-- Endereços
INSERT INTO T_GS_ADDRESS VALUES (1, 'Rua Oscar Freire', 100, 'São Paulo', 'São Paulo', 'Brasil', 12345678);
INSERT INTO T_GS_ADDRESS VALUES (2, 'Rua da Consolação', 200, 'Rio de Janeiro', 'Rio de Janeiro', 'Brasil', 87654321);
INSERT INTO T_GS_ADDRESS VALUES (3, 'Av Central', 300, 'Curitiba', 'Paraná', 'Brasil', 45678912);
INSERT INTO T_GS_ADDRESS VALUES (4, 'Rua das Flores', 400, 'Salvador', 'Bahia', 'Brasil', 78912345);
INSERT INTO T_GS_ADDRESS VALUES (5, 'Av Paulista', 500, 'São Paulo', 'São Paulo', 'Brasil', 32165498);

-- Contatos
INSERT INTO T_GS_CONTACT VALUES (1, 'abrigoesperanca@email.com', '11999990001');
INSERT INTO T_GS_CONTACT VALUES (2, 'vidaabrigo@email.com', '11999990002');
INSERT INTO T_GS_CONTACT VALUES (3, 'abrigoluz@email.com', '11999990003');
INSERT INTO T_GS_CONTACT VALUES (4, 'abrigorenovar@email.com', '11999990004');
INSERT INTO T_GS_CONTACT VALUES (5, 'abrigouniao@email.com', '11999990005');

-- Usuários
INSERT INTO T_GS_USER VALUES (1, 'ana@email.com', 'senha123', 'ADMIN');
INSERT INTO T_GS_USER VALUES (2, 'joao@email.com', 'senha234', 'USER');
INSERT INTO T_GS_USER VALUES (3, 'alissa@email.com', 'senha345', 'USER');
INSERT INTO T_GS_USER VALUES (4, 'nicolas@email.com', 'senha456', 'VOLUNTEER');
INSERT INTO T_GS_USER VALUES (5, 'melissa@email.com', 'senha567', 'VOLUNTEER');

-- Abrigos
INSERT INTO T_GS_SHELTERS VALUES (1, 'Abrigo Esperança', 100, 70, 'Água, Comida', 'Ativo', SYSDATE, 1, 1, 1);
INSERT INTO T_GS_SHELTERS VALUES (2, 'Abrigo Vida', 200, 190, 'Água, Comida, Roupas', 'Ativo', SYSDATE, 2, 2, 2);
INSERT INTO T_GS_SHELTERS VALUES (3, 'Abrigo Luz', 150, 100, 'Água', 'Manutenção', SYSDATE, 3, 3, 3);
INSERT INTO T_GS_SHELTERS VALUES (4, 'Abrigo Renovar', 120, 80, 'Comida, Cobertores', 'Ativo', SYSDATE, 4, 4, 4);
INSERT INTO T_GS_SHELTERS VALUES (5, 'Abrigo União', 300, 290, 'Água, Comida, Medicamentos', 'Lotado', SYSDATE, 5, 5, 5);


-------------------------------------------------------------------
-- PACKAGE COM PROCEDURES, FUNCTIONS, CURSORES, TRIGGERS  
-------------------------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_SHELTERS AS
    
    CREATE SEQUENCE SEQ_SHELTERS START WITH 6 INCREMENT BY 1;

-- Procedures CRUD
PROCEDURE inserir_shelter(p_name VARCHAR2, p_total_capacity INTEGER, p_current_capacity INTEGER,
                            p_resources VARCHAR2, p_status VARCHAR2, p_id_address INTEGER,
                            p_id_contact INTEGER, p_id_user INTEGER);
                            
PROCEDURE atualizar_shelter(p_id INTEGER, p_status VARCHAR2, p_current_capacity INTEGER);

PROCEDURE excluir_shelter(p_id INTEGER);

-- Funções
FUNCTION calcular_ocupacao(p_id INTEGER) RETURN NUMBER;

FUNCTION risco_shelter(p_id INTEGER) RETURN VARCHAR2;

FUNCTION ranking_ocupacao RETURN SYS_REFCURSOR;

-- Relatórios
PROCEDURE relatorio_shelters(p_cursor OUT SYS_REFCURSOR);

END PKG_SHELTERS;
/

CREATE OR REPLACE PACKAGE BODY PKG_SHELTERS AS

-- Inserção
PROCEDURE inserir_shelter(p_name VARCHAR2, p_total_capacity INTEGER, p_current_capacity INTEGER,
                            p_resources VARCHAR2, p_status VARCHAR2, p_id_address INTEGER,
                            p_id_contact INTEGER, p_id_user INTEGER) AS
BEGIN
    INSERT INTO T_GS_SHELTERS (id_shelters, name_shelters, total_capacity, current_capacity,
                                available_resources, status_shelters, update_date_shelters,
                                id_address, id_contact, id_user)
    VALUES (SEQ_SHELTERS.NEXTVAL, p_name, p_total_capacity, p_current_capacity,
            p_resources, p_status, SYSDATE, p_id_address, p_id_contact, p_id_user);
END inserir_shelter;

-- Atualização
PROCEDURE atualizar_shelter(p_id INTEGER, p_status VARCHAR2, p_current_capacity INTEGER) AS
BEGIN
    UPDATE T_GS_SHELTERS
    SET status_shelters = p_status,
        current_capacity = p_current_capacity,
        update_date_shelters = SYSDATE
    WHERE id_shelters = p_id;
END atualizar_shelter;

-- Exclusão
PROCEDURE excluir_shelter(p_id INTEGER) AS
BEGIN
    DELETE FROM T_GS_SHELTERS WHERE id_shelters = p_id;
END excluir_shelter;

-- Função de ocupação (%)
FUNCTION calcular_ocupacao(p_id INTEGER) RETURN NUMBER AS
    v_ocupacao NUMBER;
BEGIN
    SELECT (current_capacity / total_capacity) * 100.0
    INTO v_ocupacao
    FROM T_GS_SHELTERS
    WHERE id_shelters = p_id;
    RETURN v_ocupacao;
END calcular_ocupacao;

-- Função de risco (alto, médio, baixo)
FUNCTION risco_shelter(p_id INTEGER) RETURN VARCHAR2 AS
    v_ocupacao NUMBER;
BEGIN
    v_ocupacao := calcular_ocupacao(p_id);
    IF v_ocupacao >= 90 THEN
    RETURN 'ALTO';
    ELSIF v_ocupacao >= 70 THEN
    RETURN 'MÉDIO';
    ELSE
    RETURN 'BAIXO';
    END IF;
END risco_shelter;

-- Função de ranking
FUNCTION ranking_ocupacao RETURN SYS_REFCURSOR AS
    c_ranking SYS_REFCURSOR;
BEGIN
    OPEN c_ranking FOR
    SELECT id_shelters, name_shelters,
            (current_capacity/total_capacity)*100 AS ocupacao_percentual
    FROM T_GS_SHELTERS
    ORDER BY ocupacao_percentual DESC;
    RETURN c_ranking;
END ranking_ocupacao;

-- Relatório geral
PROCEDURE relatorio_shelters(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
    OPEN p_cursor FOR
    SELECT s.name_shelters, s.status_shelters, s.total_capacity, s.current_capacity,
            (s.current_capacity/s.total_capacity)*100 AS ocupacao_percentual,
            a.city_address, a.state_address,
            c.email_contact, c.contact_number,
            u.email_user
    FROM T_GS_SHELTERS s
    JOIN ADDRESS a ON s.id_address = a.id_address
    JOIN T_GS_CONTACT c ON s.id_contact = c.id_contact
    JOIN T_GS_USER u ON s.id_user = u.id_user
    ORDER BY ocupacao_percentual DESC;
END relatorio_shelters;

---------------------------------------------------------------------------------
-- TRIGGER DE VALIDAÇÃO: NÃO PERMITE QUE A OCUPAÇÃO SEJA MAIOR QUE A CAPACIDADE  
---------------------------------------------------------------------------------

    CREATE OR REPLACE TRIGGER TRG_VALIDA_CAPACIDADE
        BEFORE INSERT OR UPDATE ON T_GS_SHELTERS
        FOR EACH ROW
        BEGIN
        IF :NEW.current_capacity > :NEW.total_capacity THEN
            RAISE_APPLICATION_ERROR(-20001, 'A capacidade atual não pode exceder a capacidade total.');
        END IF;
    END;
    /

--------------------------------------------------------
-- CURSOR COM LOOP: FAZ A LISTAGEM DE TODOS OS ABRIGOS  
--------------------------------------------------------

    DECLARE
    CURSOR c_shelters IS
        SELECT id_shelters, name_shelters, total_capacity, current_capacity
        FROM T_GS_SHELTERS;
    v_nome VARCHAR2(100);
    v_total INTEGER;
    v_atual INTEGER;
    BEGIN
    FOR r IN c_shelters LOOP
        v_nome := r.name_shelters;
        v_total := r.total_capacity;
        v_atual := r.current_capacity;
        DBMS_OUTPUT.PUT_LINE('Abrigo: ' || v_nome || 
                            ' - Ocupação: ' || v_atual || '/' || v_total);
    END LOOP;
    END;
    /


-----------------------------------------------------------
-- BLOCO ANÔNIMO DE TESTE COM IF/ELSE E CONTROLE DE FLUXO  
-----------------------------------------------------------

    DECLARE
    v_ocupacao NUMBER;
    BEGIN
    v_ocupacao := PKG_SHELTERS.calcular_ocupacao(1);

    IF v_ocupacao >= 90 THEN
        DBMS_OUTPUT.PUT_LINE('Abrigo com risco ALTO!');
    ELSIF v_ocupacao >= 70 THEN
        DBMS_OUTPUT.PUT_LINE('Abrigo com risco MÉDIO!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Abrigo com risco BAIXO!');
    END IF;
    END;
    /

END PKG_SHELTERS;
/

-----------------------------------------------------------
-- RELATÓRIO COMPLEXO (com JOINs e Agregações)
-----------------------------------------------------------

SELECT a.city_address, COUNT(s.id_shelters) AS total_abrigos,
    SUM(s.current_capacity) AS total_ocupados,
    SUM(s.total_capacity) AS capacidade_total,
    ROUND((SUM(s.current_capacity) / SUM(s.total_capacity)) * 100, 2) AS percentual_ocupacao
FROM T_GS_SHELTERS s
JOIN ADDRESS a ON s.id_address = a.id_address
GROUP BY a.city_address
ORDER BY percentual_ocupacao DESC;

-------------------------------------------------
-- AGRUPAMENTOS E FILTROS COM FUNÇÕES AGREGADAS
-------------------------------------------------

--  Relatório de ocupação dos abrigos:

SELECT 
    s.name_shelter,
    s.total_capacity,
    s.current_capacity,
    ROUND((s.current_capacity / s.total_capacity) * 100, 2) AS ocupacao_percentual
FROM 
    T_SHELTER s
WHERE 
    s.status = 'ABERTO'
ORDER BY 
    ocupacao_percentual DESC;

-- Relatório de abrigos quase lotados (ex.: mais de 80% ocupado):

SELECT 
    s.name_shelter,
    s.current_capacity,
    s.total_capacity,
    ROUND((s.current_capacity / s.total_capacity) * 100, 2) AS ocupacao_percentual
FROM 
    T_SHELTER s
WHERE 
    (s.current_capacity / s.total_capacity) >= 0.8;

