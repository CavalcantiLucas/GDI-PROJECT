CREATE TABLE Endereco (

    cep VARCHAR2(8) NOT NULL,
    rua VARCHAR2(100),
    
    CONSTRAINT endereco_pkey PRIMARY KEY (cep)
);

CREATE TABLE Pessoa (

    cpf VARCHAR2(11) NOT NULL,
    nome VARCHAR2(255) NOT NULL,
    sexo VARCHAR2(1),
    idade NUMBER(2) NOT NULL,
    cep_endereco VARCHAR2(8) NOT NULL,
    complemento VARCHAR2(10),
    numero NUMBER(5),

    CONSTRAINT pessoa_pkey PRIMARY KEY (cpf),
    CONSTRAINT pessoa_sex CHECK (sexo = 'M' OR sexo = 'F'),
    CONSTRAINT pessoa_fkey FOREIGN KEY (cep_endereco) REFERENCES Endereco (cep)

);

CREATE TABLE Jogador (

    cpf_jogador VARCHAR2(11) NOT NULL, 
    carteira NUMBER, -- definir tipo de carteira
    
    CONSTRAINT jogador_pkey PRIMARY KEY (cpf_jogador),
    CONSTRAINT jogador_fkey FOREIGN KEY (cpf_jogador) REFERENCES Pessoa (cpf)
);

CREATE TABLE Casa (

    cnpj VARCHAR2(14) NOT NULL,
    nome VARCHAR2(255) NOT NULL,
    saldo NUMBER, -- definir modelo de saldo

    CONSTRAINT casa_pkey PRIMARY KEY (cnpj)
);

CREATE TABLE Emprego (

    cargo VARCHAR2(30) NOT NULL,
    cnpj_casa VARCHAR2(14) NOT NULL,
    salario NUMBER NOT NULL, -- definir salario base

    CONSTRAINT emprego_pkey PRIMARY KEY (cargo, cnpj_casa),
    CONSTRAINT emprego_fkey FOREIGN KEY (cnpj_casa) REFERENCES Casa (cnpj)

);

CREATE TABLE Funcionario (

    cpf_funcionario VARCHAR2(11) NOT NULL,
    cargo_funcionario VARCHAR2(30) NOT NULL,
    cnpj_casa VARCHAR2(14) NOT NULL,
    cpf_supervisor VARCHAR2(11) NOT NULL,

    CONSTRAINT funcionario_pkey PRIMARY KEY (cpf_funcionario),
    CONSTRAINT funcionario_fkey FOREIGN KEY (cpf_funcionario) REFERENCES Pessoa (cpf),

    CONSTRAINT funcionario_fkey2 FOREIGN KEY (cpf_supervisor) REFERENCES Funcionario (cpf_funcionario),
    CONSTRAINT funcionario_fkey3 FOREIGN KEY (cnpj_casa) REFERENCES Casa (cnpj),
    CONSTRAINT funcionario_fkey4 FOREIGN KEY (cargo_funcionario) REFERENCES Emprego (cargo, cnpj_casa)
);

CREATE TABLE Jogo (

    nome VARCHAR2(255) NOT NULL,
    custo NUMBER,

    CONSTRAINT jogo_pkey PRIMARY KEY (nome)
);

CREATE TABLE Ficha_casa (

    cnpj_casa VARCHAR2(14) NOT NULL,
    cor VARCHAR2(20) NOT NULL,
    valor NUMBER,

    CONSTRAINT fichacasa_pkey PRIMARY KEY (cnpj_casa, cor),
    CONSTRAINT fichacasa_fkey FOREIGN KEY (cnpj_casa) REFERENCES Casa (cnpj)
);

CREATE TABLE Joga (

    cpf_jogador VARCHAR2(11) NOT NULL,
    nome_jogo VARCHAR2(255) NOT NULL,
    datahora TIMESTAMP NOT NULL,

    CONSTRAINT joga_pkey PRIMARY KEY (cpf_jogador, nome_jogo, datahora),
    CONSTRAINT joga_fkey FOREIGN KEY (cpf_jogador) REFERENCES Jogador (cpf_jogador),
    CONSTRAINT joga_fkey2 FOREIGN KEY (nome_jogo) REFERENCES Jogo (nome)
);

CREATE TABLE Contem (

    cnpj_casa VARCHAR2(14) NOT NULL,
    nome_jogo VARCHAR2(255) NOT NULL,

    CONSTRAINT contem_pkey PRIMARY KEY (cnpj_casa, nome_jogo),

    CONSTRAINT contem_fkey FOREIGN KEY (cnpj_casa) REFERENCES Casa (cnpj),
    CONSTRAINT contem_fkey2 FOREIGN KEY (nome_jogo) REFERENCES Jogo (nome)
);

CREATE TABLE Numero_Telefone (

    cpf_pessoa VARCHAR2(11) NOT NULL,
    telefone VARCHAR2(13) NOT NULL, -- modelo - (81)8888-8888

    CONSTRAINT telefone_pkey PRIMARY KEY (cpf_pessoa, telefone),
    CONSTRAINT telefone_fkey FOREIGN KEY (cpf_pessoa) REFERENCES Pessoa (cpf)
);

CREATE TABLE Compra (

    cpf_jogador VARCHAR2(11) NOT NULL,
    cpf_funcionario VARCHAR2(11) NOT NULL,
    cor_ficha VARCHAR2(20) NOT NULL,
    cnpj_casa VARCHAR2(14) NOT NULL,
    datahora TIMESTAMP NOT NULL,

    valor_compra NUMBER,

    CONSTRAINT compra_pkey PRIMARY KEY (cpf_jogador, cpf_funcionario, cnpj_casa, cor_ficha, datahora),

    CONSTRAINT compra_fkey FOREIGN KEY (cpf_jogador) REFERENCES Jogador (cpf_jogador),
    CONSTRAINT compra_fkey2 FOREIGN KEY (cpf_funcionario) REFERENCES Funcionario (cpf_funcionario),
    CONSTRAINT compra_fkey3 FOREIGN KEY (cnpj_casa, cor_ficha) REFERENCES Ficha_casa (cnpj_casa, cor)

);