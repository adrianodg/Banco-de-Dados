-- Criaçao do Banco de Dados
CREATE SCHEMA Empresa;

use Empresa;

CREATE TABLE Departamento (
    idDepto    INT           NOT NULL auto_increment,
    nomeDepto  VARCHAR(30)   NOT NULL,
    idGerente  INT           NOT NULL,
    CONSTRAINT pk_depto PRIMARY KEY (idDepto),
    CONSTRAINT uk_nome UNIQUE (nomeDepto)
);

CREATE TABLE Funcionario (
    idFunc     INT           NOT NULL auto_increment,
    nomeFunc   VARCHAR(50)   NOT NULL,
    endereco   VARCHAR(80)   NOT NULL,
    dataNasc   DATE          NOT NULL,
    sexo       CHAR(1)       NOT NULL,
    salario    DECIMAL(8,2)  NOT NULL,
    idSuperv   INT               NULL,
    idDepto    INT           NOT NULL,
    CONSTRAINT pk_func PRIMARY KEY (idFunc),
    CONSTRAINT ck_sexo CHECK (sexo='M' or sexo='F')
);

CREATE TABLE Projeto (
    idProj       INT          NOT NULL auto_increment,
    nomeProj     VARCHAR(30)  NOT NULL,
    localizacao  VARCHAR(30)      NULL,
    idDepto      INT          NOT NULL,
    CONSTRAINT pk_proj PRIMARY KEY (idProj),
    CONSTRAINT fk_proj_depto FOREIGN KEY (idDepto)
       REFERENCES Departamento (idDepto),
    CONSTRAINT uk_nomeProj UNIQUE (nomeProj)
);

CREATE TABLE Dependente (
    idDep       INT          NOT NULL auto_increment,
    idFunc      INT          NOT NULL,
    nomeDep     VARCHAR(50)  NOT NULL,
    dataNasc    DATE         NOT NULL,
    sexo        CHAR(1)      NOT NULL,
    parentesco  VARCHAR(15)      NULL,
    CONSTRAINT pk_depend PRIMARY KEY (idDep),
    CONSTRAINT fk_dep_func FOREIGN KEY (idFunc)
       REFERENCES Funcionario (idFunc)
       ON DELETE CASCADE,
    CONSTRAINT ck_sexo_dep CHECK (sexo='M' or sexo='F')
);

CREATE TABLE Trabalha (
    idFunc    INT           NOT NULL,
    idProj    INT           NOT NULL,
    numHoras  DECIMAL(6,1)      NULL,
    CONSTRAINT pk_trab PRIMARY KEY (idFunc,idProj),
    CONSTRAINT fk_trab_func FOREIGN KEY (idFunc)
       REFERENCES Funcionario (idFunc)
       ON DELETE CASCADE,
    CONSTRAINT fk_trab_proj FOREIGN KEY (idProj)
       REFERENCES Projeto (idProj)
       ON DELETE CASCADE
);

INSERT INTO Funcionario
VALUES (1,'João B. Silva','R. Guaicui, 175','1955/02/01','M',500,2,1);
INSERT INTO Funcionario
VALUES (2,'Frank T. Santos','R. Gentios, 22','1966/02/02','M',1000,8,1);
INSERT INTO Funcionario
VALUES (3,'Alice N. Pereira','R. Curitiba, 11','1970/05/15','F',700,4,3);
INSERT INTO Funcionario
VALUES (4,'Júnia B. Mendes','R. E. Santos, 123','1976/07/06','F',1200,8,3);
INSERT INTO Funcionario
VALUES (5,'José S. Tavares','R. Iraí, 153','1975/10/12','M',1500,2,1);
INSERT INTO Funcionario
VALUES (6,'Luciana S. Santos','R. Iraí, 175','1960/10/10','F',600,2,1);
INSERT INTO Funcionario
VALUES (7,'Maria P. Ramos','R. C. Linhares, 10','1965/11/05','F',1000,4,3);
INSERT INTO Funcionario
VALUES (8,'Jaime A. Mendes','R. Bahia, 111','1960/11/25','M',2000,NULL,2);

INSERT INTO Departamento
VALUES (1,'Pesquisa',2);
INSERT INTO Departamento
VALUES (2,'Administração',8);
INSERT INTO Departamento
VALUES (3,'Construção',4);

ALTER TABLE Funcionario
ADD CONSTRAINT fk_func_depto FOREIGN KEY (idDepto)
       REFERENCES Departamento (idDepto);

ALTER TABLE Funcionario
ADD CONSTRAINT fk_func_superv FOREIGN KEY (idSuperv)
       REFERENCES Funcionario (idFunc)
       ON DELETE SET NULL;

ALTER TABLE Departamento
ADD CONSTRAINT fk_depto_func FOREIGN KEY (idGerente)
        REFERENCES Funcionario (idFunc);

INSERT INTO Dependente
VALUES (1,2,'Luciana','1990/11/05','F','Filha');
INSERT INTO Dependente
VALUES (2,2,'Paulo','1992/11/11','M','Filho');
INSERT INTO Dependente
VALUES (3,2,'Sandra','1996/12/14','F','Filha');
INSERT INTO Dependente
VALUES (4,4,'Mike','1997/11/05','M','Filho');
INSERT INTO Dependente
VALUES (5,1,'Max','1979/05/11','M','Filho');
INSERT INTO Dependente
VALUES (6,1,'Rita','1985/11/07','F','Filha');
INSERT INTO Dependente
VALUES (7,1,'Bety','1960/12/17','F','Esposa');

INSERT INTO Projeto
VALUES (1,'ProdX','Savassi',1);
INSERT INTO Projeto
VALUES (2,'ProdY','Luxemburgo',1);
INSERT INTO Projeto
VALUES (3,'ProdZ','Centro',1);
INSERT INTO Projeto
VALUES (10,'Computação','C. Nova',3);
INSERT INTO Projeto
VALUES (20,'Organização','Luxemburgo',2);
INSERT INTO Projeto
VALUES (30,'N. Benefícios','C. Nova',3);

INSERT INTO Trabalha
VALUES (1,1,32.5);
INSERT INTO Trabalha
VALUES (1,2,7.5);
INSERT INTO Trabalha
VALUES (5,3,40.0);
INSERT INTO Trabalha
VALUES (6,1,20.0);
INSERT INTO Trabalha
VALUES (6,2,20.0);
INSERT INTO Trabalha
VALUES (2,2,10.0);
INSERT INTO Trabalha
VALUES (2,3,10.0);
INSERT INTO Trabalha
VALUES (2,10,10.0);
INSERT INTO Trabalha
VALUES (2,20,10.0);
INSERT INTO Trabalha
VALUES (3,30,30.0);
INSERT INTO Trabalha
VALUES (3,10,10.0);
INSERT INTO Trabalha
VALUES (7,10,35.0);
INSERT INTO Trabalha
VALUES (7,30,5.0);
INSERT INTO Trabalha
VALUES (4,20,15.0);
INSERT INTO Trabalha
VALUES (8,20,NULL);

commit;


-- 1. Selecione o endereço e o salario do funcionário de nome ‘Luciana S. Santos’.
select endereco, salario
from Funcionario
where nomeFunc='Luciana S. Santos';

-- 2. Selecione o nome e o salário dos funcionários que nasceram entre os anos de 1960 e 1969, inclusive, do sexo feminino e que ganham menos de 1000.
select nomeFunc, salario
from Funcionario
where dataNasc between '1960-01-01' and '1969-12-31' and sexo = 'F' and salario < 1000;

-- 3. Selecione o nome dos dependentes do funcionário de nome ‘João B. Silva’.
select nomeDep
from Funcionario F join Dependente D on F.idFunc=D.idFunc
where nomeFunc='João B. Silva';

-- 4. Selecione o nome dos projetos que o funcionário de nome ‘Frank T. Santos’ trabalha.
select nomeProj
from Funcionario F, Trabalha T, Projeto P 
where nomeFunc='Frank T. Santos' and F.idFunc=T.idFunc and T.idProj=P.idProj;

-- 5. Selecione o nome dos funcionários que trabalham em projetos controlados pelo departamento de nome ‘Construção’.
select nomeFunc
from Funcionario F, Trabalha T, Projeto P, Departamento D
where nomeDepto='Construção' and D.idDepto=P.idDepto and T.idProj=P.idProj and F.idFunc=T.idFunc;

-- 6. Selecione o nome dos funcionários supervisionados pelo funcionário de nome ‘Frank T. Santos’.
select S.nomeFunc
from Funcionario F, Funcionario S
where F.nomeFunc='Frank T. Santos' and F.idFunc=S.idSuperv;

-- 7. Selecione o nome e endereço dos funcionários que não tem nenhum dependente.
select nomeFunc, endereco
from Funcionario
where idFunc not in (select idFunc
		     from Dependente);
                     
-- 8. Selecione o nome dos funcionários que trabalham no departamento de nome ‘Pesquisa’ ou que trabalham no projeto de nome ‘N. Benefícios’.
select nomeFunc
from Funcionario natural join Departamento
where nomeDepto='Pesquisa'
union
select nomeFunc
from Funcionario F, Trabalha T, Projeto P 
where nomeProj='N. Benefícios' and F.idFunc=T.idFunc and T.idProj=P.idProj;

-- 9. Selecione o nome dos funcionários que trabalham em algum projeto controlado pelo departamento cujo gerente é o funcionário de nome ‘Júnia B. Mendes’.
select distinct F.nomeFunc
from Funcionario G, Departamento D, Projeto P, Trabalha T, Funcionario F
where G.nomeFunc='Júnia B. Mendes' and G.idFunc=D.idGerente and D.idDepto=P.idDepto and P.idProj=T.idProj and T.idFunc=F.idFunc;

-- 10. Selecione o nome dos funcionários que trabalham em todos os projetos controlados pelo departamento cujo gerente é o funcionário de nome ‘Júnia B. Mendes’.
select Func.nomeFunc
from Funcionario Func
where not exists (select P.idProj
	          from Projeto P, Departamento D, Funcionario F
                  where F.nomeFunc='Júnia B. Mendes' and F.idFunc=D.idGerente and D.idDepto=P.idDepto and
                        P.idProj not in (select T.idProj
                                         from Trabalha T
                                         where T.idFunc=Func.idFunc));

/* é o mesmo que:                             
select Func.nomeFunc
from Funcionario Func
where not exists (select P.idProj
	          from Projeto P, Departamento D, Funcionario F
                  where F.nomeFunc='Júnia B. Mendes' and F.idFunc=D.idGerente and D.idDepto=P.idDepto)
                  MINUS
                 (select T.idProj
                  from Trabalha T
                  where T.idFunc=Func.idFunc));
 */

-- 11. Selecione o nome dos funcionários e o nome de seus dependentes. Deve incluir o nome dos funcionários sem dependentes.
select nomeFunc, nomeDep
from Funcionario F left outer join Dependente D on F.idFunc=D.idFunc;
 
-- 12. Selecione a quantidade de funcionários que trabalham no departamento que controla o projeto de nome ‘ProdZ’.
select count(*)
from Funcionario natural join Projeto
where nomeProj = 'ProdZ';

-- 13. Selecione o nome dos funcionários e a quantidade de projetos que cada um trabalha mais de 10 horas.
select idFunc, nomeFunc, count(*)
from Funcionario natural join Trabalha
where numHoras > 10
group by idFunc, nomeFunc;

-- 14. Selecione o nome dos funcionários e a quantidade de projetos que cada um trabalha. Selecione apenas os funcionários que trabalham em mais de um projeto.
select idFunc, nomeFunc, count(*)
from Funcionario natural join Trabalha
group by idFunc, nomeFunc
having count(*) > 1;

-- 15. Selecione a soma dos salários dos funcionários que trabalham em departamentos que controlam mais de um projeto. O resultado deve vir agrupado por departamento.
select nomeDepto, sum(salario)
from Funcionario natural join Departamento D
where D.idDepto in (select idDepto
                    from Projeto
	            group by idDepto
                    having count(*) > 1)
group by nomeDepto;

-- 16. Selecione o nome dos funcionários que ganham mais que o maior salário dos funcionários do departamento de nome ‘Construção’. O resultado deve vir ordenado alfabeticamente pelo nome.
select nomeFunc
from Funcionario
where salario > (select max(salario)
		 from Funcionario natural join Departamento
                 where nomeDepto = 'Construção')
order by nomeFunc;

-- 17. Selecione o nome do funcionário e o nome do seu supervisor para todos os funcionários que não são supervisionados pelo funcionario de nome 'Frank T. Santos'.
select F.nomeFunc, S.nomeFunc
from Funcionario F left outer join Funcionario S on S.idFunc = F.idSuperv
where S.nomeFunc != 'Frank T. Santos' or F.idSuperv is null;

-- 18. Aumente em 10% o salários de todos os funcionários que trabalham em mais de um projeto.
update Funcionario
set salario = salario * 1.10
where idFunc in (select idFunc
		 from Trabalha
                 group by idFunc
                 having count(*) > 1);

-- 19. Exclua todos os projetos que não têm funcionários trabalhando neles.
delete from Projeto
where idProj not in (select idProj
		     from Trabalha);

-- 20. Crie uma visão que selecione, para cada departamento, sua identificação, seu nome, mais o nome e o salário de seu gerente. Mostre também um exemplo de como usar a visão criada.
create view DeptoGerente as
select D.idDepto, nomeDepto, nomeFunc, salario
from Departamento D join Funcionario F on D.idGerente = F.idFunc;

select * from DeptoGerente;

select nomeDepto, nomeFunc, nomeProj
from DeptoGerente natural join Projeto;

