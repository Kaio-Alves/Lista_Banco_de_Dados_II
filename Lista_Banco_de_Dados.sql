-- Criação das Tabelas
CREATE TABLE PROFESSOR (
    ID_PROFESSOR NUMBER PRIMARY KEY,
    NOME VARCHAR2(100) NOT NULL,
    TITULACAO VARCHAR2(50)
);

CREATE TABLE ALUNO (
    ID_ALUNO NUMBER PRIMARY KEY,
    NOME VARCHAR2(100) NOT NULL,
    DATA_NASCIMENTO DATE,
    ID_CURSO NUMBER
);

CREATE TABLE DISCIPLINA (
    ID_DISCIPLINA NUMBER PRIMARY KEY,
    NOME_DISCIPLINA VARCHAR2(100) NOT NULL,
    CARGA_HORARIA NUMBER,
    ID_PROFESSOR NUMBER,
    FOREIGN KEY (ID_PROFESSOR) REFERENCES PROFESSOR(ID_PROFESSOR)
);

CREATE TABLE MATRICULA (
    ID_MATRICULA NUMBER PRIMARY KEY,
    ID_ALUNO NUMBER,
    ID_DISCIPLINA NUMBER,
    FOREIGN KEY (ID_ALUNO) REFERENCES ALUNO(ID_ALUNO),
    FOREIGN KEY (ID_DISCIPLINA) REFERENCES DISCIPLINA(ID_DISCIPLINA)
);

-- Criação da Sequência para DISCIPLINA
CREATE SEQUENCE DISCIPLINA_SEQ
START WITH 4  -- Ajuste para o valor mais alto já existente
INCREMENT BY 1;

-- Inserção de dados nas tabelas

-- Inserção de dados na tabela PROFESSOR
INSERT INTO PROFESSOR (ID_PROFESSOR, NOME, TITULACAO) VALUES (1, 'Dr. Roberto Lima', 'Doutor');
INSERT INTO PROFESSOR (ID_PROFESSOR, NOME, TITULACAO) VALUES (2, 'Profa. Letícia Costa', 'Mestre');

-- Inserção de dados na tabela ALUNO
INSERT INTO ALUNO (ID_ALUNO, NOME, DATA_NASCIMENTO, ID_CURSO) VALUES (1, 'João Silva', TO_DATE('2005-05-12', 'YYYY-MM-DD'), 101);
INSERT INTO ALUNO (ID_ALUNO, NOME, DATA_NASCIMENTO, ID_CURSO) VALUES (2, 'Maria Oliveira', TO_DATE('1998-08-23', 'YYYY-MM-DD'), 102);
INSERT INTO ALUNO (ID_ALUNO, NOME, DATA_NASCIMENTO, ID_CURSO) VALUES (3, 'Carlos Souza', TO_DATE('2003-10-15', 'YYYY-MM-DD'), 103);
INSERT INTO ALUNO (ID_ALUNO, NOME, DATA_NASCIMENTO, ID_CURSO) VALUES (4, 'Ana Santos', TO_DATE('1995-12-05', 'YYYY-MM-DD'), 104);

-- Inserção de dados na tabela DISCIPLINA
INSERT INTO DISCIPLINA (ID_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA, ID_PROFESSOR) 
VALUES (DISCIPLINA_SEQ.NEXTVAL, 'Matemática', 60, 1); -- Dr. Roberto Lima
INSERT INTO DISCIPLINA (ID_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA, ID_PROFESSOR) 
VALUES (DISCIPLINA_SEQ.NEXTVAL, 'Física', 80, 2); -- Profa. Letícia Costa
INSERT INTO DISCIPLINA (ID_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA, ID_PROFESSOR) 
VALUES (DISCIPLINA_SEQ.NEXTVAL, 'Química', 70, 2); -- Profa. Letícia Costa

-- Inserção de dados na tabela MATRICULA
INSERT INTO MATRICULA (ID_MATRICULA, ID_ALUNO, ID_DISCIPLINA) VALUES (1, 1, 1); -- João em Matemática
INSERT INTO MATRICULA (ID_MATRICULA, ID_ALUNO, ID_DISCIPLINA) VALUES (2, 1, 2); -- João em Física
INSERT INTO MATRICULA (ID_MATRICULA, ID_ALUNO, ID_DISCIPLINA) VALUES (3, 2, 1); -- Maria em Matemática
INSERT INTO MATRICULA (ID_MATRICULA, ID_ALUNO, ID_DISCIPLINA) VALUES (4, 3, 2); -- Carlos em Física
INSERT INTO MATRICULA (ID_MATRICULA, ID_ALUNO, ID_DISCIPLINA) VALUES (5, 3, 3); -- Carlos em Química

-- Criação do pacote PKG_ALUNO
CREATE OR REPLACE PACKAGE PKG_ALUNO AS
    -- Procedure para excluir um aluno
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER);

    -- Cursor para listar alunos maiores de 18 anos
    CURSOR c_alunos_maiores_18 IS
        SELECT nome, data_nascimento
        FROM aluno
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;

    -- Cursor para listar alunos por curso
    CURSOR c_alunos_por_curso(p_id_curso IN NUMBER) IS
        SELECT nome
        FROM aluno
        WHERE id_curso = p_id_curso;
END PKG_ALUNO;
/ 

-- Criação do corpo do pacote PKG_ALUNO
CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS
    -- Procedure para excluir um aluno
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER) IS
    BEGIN
        -- Excluindo as matrículas associadas ao aluno
        DELETE FROM matricula WHERE id_aluno = p_id_aluno;

        -- Excluindo o aluno
        DELETE FROM aluno WHERE id_aluno = p_id_aluno;

        COMMIT; -- Confirmar as mudanças após a exclusão
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK; -- Reverter as mudanças caso ocorra erro
            RAISE; -- Levantar o erro novamente
    END excluir_aluno;

END PKG_ALUNO;
/ 

-- Criação do pacote PKG_DISCIPLINA
CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
    -- Procedure para cadastrar uma disciplina
    PROCEDURE CadastrarDisciplina(p_nome_disciplina IN VARCHAR2, p_carga_horaria IN NUMBER);

    -- Procedure para listar todos os alunos de uma disciplina
    PROCEDURE ListarAlunosDisciplina(p_id_disciplina IN NUMBER);

    -- Função para calcular a média de idade dos alunos matriculados em uma disciplina
    FUNCTION MediaIdadeDisciplina(p_id_disciplina IN NUMBER) RETURN NUMBER;
END PKG_DISCIPLINA;
/ 

-- Criação do corpo do pacote PKG_DISCIPLINA
CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS
    -- Procedure para cadastrar uma disciplina
    PROCEDURE CadastrarDisciplina(p_nome_disciplina IN VARCHAR2, p_carga_horaria IN NUMBER) IS
    BEGIN
        INSERT INTO DISCIPLINA (ID_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA)
        VALUES (DISCIPLINA_SEQ.NEXTVAL, p_nome_disciplina, p_carga_horaria);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END CadastrarDisciplina;

    -- Procedure para listar todos os alunos de uma disciplina
    PROCEDURE ListarAlunosDisciplina(p_id_disciplina IN NUMBER) IS
        CURSOR c_alunos IS
            SELECT a.NOME
            FROM ALUNO a
            JOIN MATRICULA m ON a.ID_ALUNO = m.ID_ALUNO
            WHERE m.ID_DISCIPLINA = p_id_disciplina;
    BEGIN
        FOR aluno IN c_alunos LOOP
            DBMS_OUTPUT.PUT_LINE('Aluno: ' || aluno.NOME);
        END LOOP;
    END ListarAlunosDisciplina;

    -- Função para calcular a média de idade dos alunos matriculados em uma disciplina
    FUNCTION MediaIdadeDisciplina(p_id_disciplina IN NUMBER) RETURN NUMBER IS
        v_media NUMBER;
    BEGIN
        SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.DATA_NASCIMENTO) / 12))
        INTO v_media
        FROM ALUNO a
        JOIN MATRICULA m ON a.ID_ALUNO = m.ID_ALUNO
        WHERE m.ID_DISCIPLINA = p_id_disciplina;
        RETURN v_media;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END MediaIdadeDisciplina;

END PKG_DISCIPLINA;
/ 

-- Criação do pacote PKG_PROFESSOR
CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS
    -- Cursor para total de turmas por professor (professores com mais de uma turma)
    CURSOR c_total_turmas_por_professor IS
        SELECT p.NOME, COUNT(d.ID_DISCIPLINA) AS total_turmas
        FROM PROFESSOR p
        JOIN DISCIPLINA d ON d.ID_PROFESSOR = p.ID_PROFESSOR
        GROUP BY p.NOME
        HAVING COUNT(d.ID_DISCIPLINA) > 1;

    -- Function para total de turmas de um professor
    FUNCTION total_turmas_professor(p_id_professor IN NUMBER) RETURN NUMBER;

    -- Function para professor de uma disciplina
    FUNCTION professor_de_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2;

END PKG_PROFESSOR;
/ 

-- Criação do corpo do pacote PKG_PROFESSOR
CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS
    -- Function para total de turmas de um professor
    FUNCTION total_turmas_professor(p_id_professor IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        -- Contar o total de turmas que o professor leciona
        SELECT COUNT(d.ID_DISCIPLINA)
        INTO v_total
        FROM DISCIPLINA d
        WHERE d.ID_PROFESSOR = p_id_professor;
        
        RETURN v_total;
    EXCEPTION
        WHEN OTHERS THEN
            -- Caso haja erro, retornar 0
            RETURN 0;
    END total_turmas_professor;

    -- Function para professor de uma disciplina
    FUNCTION professor_de_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2 IS
        v_nome_professor VARCHAR2(100);
    BEGIN
        -- Buscar o nome do professor da disciplina
        SELECT p.NOME
        INTO v_nome_professor
        FROM PROFESSOR p
        JOIN DISCIPLINA d ON d.ID_PROFESSOR = p.ID_PROFESSOR
        WHERE d.ID_DISCIPLINA = p_id_disciplina;

        RETURN v_nome_professor;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Desconhecido';
    END professor_de_disciplina;

END PKG_PROFESSOR;
