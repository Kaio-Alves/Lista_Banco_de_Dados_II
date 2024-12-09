# Lista_Banco_de_Dados_II


Este repositório contém um script SQL para criar um sistema de gerenciamento de professores, alunos, disciplinas e matrículas no Oracle Database. O script também define pacotes PL/SQL para facilitar operações e consultas relacionadas a essas entidades.

## Como Executar o Script no Oracle

1. **Conexão com o Banco de Dados:**
   - Abra o *SQL* (SQL*Plus, Oracle SQL Developer ou outra ferramenta de sua preferência).
   - Conecte-se ao banco de dados Oracle utilizando um usuário com privilégios suficientes para criar tabelas e pacotes.

2. **Executando o Script:**
   - Copie todo o conteúdo do script SQL.
   - Cole e execute no seu ambiente Oracle conectado.
   - O script cria as tabelas `PROFESSOR`, `ALUNO`, `DISCIPLINA`, `MATRICULA`, a sequência `DISCIPLINA_SEQ`, e os pacotes PL/SQL `PKG_ALUNO`, `PKG_DISCIPLINA` e `PKG_PROFESSOR`.

3. **Inserção de Dados:**
   - O script também insere dados iniciais nas tabelas, incluindo dois professores, quatro alunos, três disciplinas e as matrículas de alunos nas disciplinas correspondentes.

## Descrição dos Pacotes PL/SQL

### 1. **PKG_ALUNO**

O pacote `PKG_ALUNO` é responsável pela gestão de operações relacionadas aos alunos.

- **Procedure `excluir_aluno`:**
  - Exclui um aluno, removendo todas as matrículas associadas a ele antes de excluir o aluno da tabela `ALUNO`.

- **Cursor `c_alunos_maiores_18`:**
  - Lista os alunos com mais de 18 anos. Calcula a idade a partir da data de nascimento do aluno e a compara com a data atual.

- **Cursor `c_alunos_por_curso`:**
  - Lista todos os alunos de um curso específico, dado o `ID_CURSO`.

### 2. **PKG_DISCIPLINA**

O pacote `PKG_DISCIPLINA` gerencia operações relacionadas às disciplinas e matrículas de alunos.

- **Procedure `CadastrarDisciplina`:**
  - Cadastra uma nova disciplina na tabela `DISCIPLINA`, com nome e carga horária, utilizando a sequência `DISCIPLINA_SEQ` para gerar o `ID_DISCIPLINA`.

- **Procedure `ListarAlunosDisciplina`:**
  - Lista todos os alunos matriculados em uma disciplina específica, dada a `ID_DISCIPLINA`.

- **Função `MediaIdadeDisciplina`:**
  - Calcula e retorna a média de idade dos alunos matriculados em uma disciplina específica. A idade é calculada com base na data de nascimento dos alunos e a data atual.

### 3. **PKG_PROFESSOR**

O pacote `PKG_PROFESSOR` é responsável por operações relacionadas aos professores e suas disciplinas.

- **Cursor `c_total_turmas_por_professor`:**
  - Lista os professores que lecionam mais de uma disciplina, mostrando o nome do professor e o total de turmas que ele leciona.

- **Função `total_turmas_professor`:**
  - Retorna o total de disciplinas que um professor leciona, dado o `ID_PROFESSOR`.

- **Função `professor_de_disciplina`:**
  - Retorna o nome do professor que leciona uma disciplina específica, dado o `ID_DISCIPLINA`.

## Considerações Finais

- O script deve ser executado em um banco de dados Oracle.
- Para testar as funções e procedimentos dos pacotes, utilize o SQL Developer ou outra ferramenta para executar consultas e comandos `EXEC`.
- Certifique-se de que o ambiente do banco de dados está configurado corretamente para suportar o script (ex.: permissões adequadas para criação de objetos).
- Caso queira utilize um ambiente online : https://onecompiler.com/oracle/

## Exemplo de Execução

- Para listar todos os alunos de uma disciplina, você pode executar a seguinte chamada no Oracle:

```sql
EXEC PKG_DISCIPLINA.ListarAlunosDisciplina(1);  -- Exemplo com ID_DISCIPLINA = 1
